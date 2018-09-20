package edu.pitt.isg.dc.validator;

import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.dc.utils.TagUtil;
import edu.pitt.isg.mdc.dats2_2.*;
import org.apache.commons.beanutils.BeanUtils;
import org.springframework.security.access.method.P;
import org.springframework.util.AutoPopulatingList;

import javax.persistence.criteria.CriteriaBuilder;
import javax.xml.bind.annotation.XmlElement;
import java.io.ObjectOutput;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.ListIterator;

import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.convertIsAboutItems;
import static edu.pitt.isg.dc.validator.ValidatorHelperMethods.convertPersonOrganization;

public class ReflectionValidator {

    private boolean isList(Object object) {
        return (List.class.isAssignableFrom(object.getClass()));
    }

    private String capFirstLetter(String string) {
        return string.substring(0, 1).toUpperCase() + string.substring(1);
    }

    private String getGetterNameFromFieldName(Field field) {
        return "get" + capFirstLetter(field.getName());
    }

    private Object getValue(Field field, Object object) throws FatalReflectionValidatorException {
        Method method;
        try {
            if(field.getType().getName().equals("boolean")) {
                String getterNameFromField = field.getName();
                if(!getterNameFromField.startsWith("is")) {
                    getterNameFromField = "is" + getterNameFromField.substring(0,1).toUpperCase() + getterNameFromField.substring(1);
                }
                method = object.getClass().getMethod(getterNameFromField);
            } else {
                method = object.getClass().getMethod(getGetterNameFromFieldName(field));
            }
            return method.invoke(object);
        } catch (Exception e) {
            throw new FatalReflectionValidatorException(e.getMessage());
        }
    }

    private void setValue(Field field, Object object, Object value) throws FatalReflectionValidatorException {
        try {
            BeanUtils.setProperty(object, field.getName(), value);
        } catch (Exception e) {
            throw new FatalReflectionValidatorException(e.getMessage());
        }
    }

    @SuppressWarnings("unchecked")
    private <T> List<? extends T> convertItemsToSubclass(List<? extends T> list) throws FatalReflectionValidatorException {
        List<T> newList = new ArrayList<>(list);

        for (int i = 0; i < newList.size(); i++) {
            T item = newList.get(i);
            Class clazz = item.getClass();
            //IsAboutItems and PersonOrganization are illegal types because the DATS converter doesn't know how to handle these classes
            if (IsAboutItems.class.isAssignableFrom(clazz))
                newList.set(i, (T) convertIsAboutItems((IsAboutItems) item));
            else if (PersonOrganization.class.isAssignableFrom(clazz))
                newList.set(i, (T) convertPersonOrganization((PersonOrganization) item));
            else if (Organization.class.isAssignableFrom(clazz))
                newList.set(i, item);
            else if (Person.class.isAssignableFrom(clazz))
                newList.set(i, item);
            else if (BiologicalEntity.class.isAssignableFrom(clazz))
                newList.set(i, item);
            else if (Annotation.class.isAssignableFrom(clazz))
                newList.set(i, item);
            else
                throw new FatalReflectionValidatorException("Unsupported class:" + clazz.getName());
        }
        return newList;
    }

    private List<Field> getRequiredFields(Class clazz) {
        List<Field> declaredFields = getAllPublicDeclaredFields(clazz);
        List<Field> requiredFields = new ArrayList<>();

        for (Field field : declaredFields) {
            if (field.isAnnotationPresent(XmlElement.class)) {
                XmlElement annotation = field.getAnnotation(XmlElement.class);
                if (annotation.required()) {
                    requiredFields.add(field);
                }
            }
        }

        return requiredFields;
    }

    private List<Field> getNonEmptyNonRequiredFields(Class clazz, Object object) throws FatalReflectionValidatorException {
        List<Field> declaredFields = getAllPublicDeclaredFields(clazz);
        List<Field> nonEmptyNonRequiredFields = new ArrayList<>();

        for (Field field : declaredFields) {
            boolean nonEmptyNonRequiredField = true;
            if (field.isAnnotationPresent(XmlElement.class)) {
                XmlElement annotation = field.getAnnotation(XmlElement.class);
                if (annotation.required()) {
                    nonEmptyNonRequiredField = false;
                }
            }
            if (nonEmptyNonRequiredField) {
                Object value = getValue(field, object);
                if (value != null) {
                    if (isList(value)) {
                        if (!isListEmtpy((List) value))
                            nonEmptyNonRequiredFields.add(field);
                    } else {
                        if (!isObjectEmpty(value)) {
                            nonEmptyNonRequiredFields.add(field);
                        }
                    }
                }
            }
        }
        return nonEmptyNonRequiredFields;

    }

    private List<Field> getAllPublicDeclaredFields(Class clazz) {
        return getAllPublicDeclaredFields(clazz, null);
    }

    private List<Field> getAllPublicDeclaredFields(Class clazz, List<Field> declaredFields) {
        if (declaredFields == null)
            declaredFields = new ArrayList<>();

        List<Field> publicFields = Arrays.asList(clazz.getDeclaredFields());
        for (Field field : publicFields) {
            if (Modifier.isProtected(field.getModifiers())) {
                declaredFields.add(field);
            }
        }
        if (clazz.getSuperclass().getName().equals("java.lang.Object")) {
            return declaredFields;
        } else {
            return getAllPublicDeclaredFields(clazz.getSuperclass(), declaredFields);
        }
    }

    private boolean isListEmtpy(List list) throws FatalReflectionValidatorException {
        for (Object item : list) {
            if (!isObjectEmpty(item)) return false;
        }
        return true;
    }

    public boolean isObjectEmpty(Object objectOrList) throws FatalReflectionValidatorException {
        if (objectOrList == null || objectOrList.equals("")) {
            return true;
        }

        if (isList(objectOrList)) {
            return isListEmtpy((List) objectOrList);
        } else {
            List<Field> allFields = getAllPublicDeclaredFields(objectOrList.getClass());
            for (Field field : allFields) {
                Object value = getValue(field, objectOrList);
                if (value == null)
                    continue;
                if (isList(value)) {
                    if (!isListEmtpy((List) value)) return false;
                } else {
                    if (!value.equals("")) {
                        //at least one field has a value
                        if (value.getClass().getName().startsWith("java.lang"))
                            return false;
                        else {
                            boolean subObjectIsEmpty = isObjectEmpty(value);
                            if (!subObjectIsEmpty)
                                return false;

                        }
                    }
                }
            }
        }
        if (objectOrList.getClass().getName().endsWith("String")) {
            if (((String) objectOrList).isEmpty()) {
                return true;
            } else return false;
        }
        if (objectOrList.getClass().isEnum()) {
            if (objectOrList == null) {
                return true;
            } else return false;
        }
        return true;
    }

    public <T> void validateList(List<T> list, boolean listIsAllowedToBeEmpty, String
            breadcrumb, Field field, List<ValidatorError> errors) throws FatalReflectionValidatorException {

        if (field != null) {
            breadcrumb += "->" + field.getName();
        }

        boolean listIsEmpty = true;
        int index = 0;
        for (T item : list)
            if (!isObjectEmpty(item)) {
                listIsEmpty = false;
                //root is false as we don't need every item to exist...just one
                validate(item.getClass(), item, false, breadcrumb + "->" + index, field, errors);
                index++;
            }

        if (!listIsAllowedToBeEmpty && listIsEmpty) {
            try {
                errors.add(new ValidatorError(ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD, breadcrumb, Class.forName(field.getType().getName())));
            } catch (ClassNotFoundException e) {
                throw new FatalReflectionValidatorException(e.getMessage());
            }
        }
    }

    public void validate(Class<?> clazz, Object object, boolean rootIsRequired, String
            breadcrumb, Field rootField, List<ValidatorError> errors) throws FatalReflectionValidatorException {
        if (rootField == null) {
            breadcrumb += "(root)";
        }
        if(breadcrumb.equals("")) {
            breadcrumb += rootField.getName();
        }
        if (rootIsRequired) {
            if (isObjectEmpty(object)) {
                errors.add(new ValidatorError(ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD, breadcrumb, object.getClass()));
                return;
            }
        } else {
            if(isObjectEmpty(object)) {
                return;
            }
        }

        List<Field> requiredFields = getRequiredFields(clazz);
        List<Field> nonEmptyNonRequiredFields = getNonEmptyNonRequiredFields(clazz, object);

        List<Field> fieldsToValidate = new ArrayList<>();
        fieldsToValidate.addAll(requiredFields);
        fieldsToValidate.addAll(nonEmptyNonRequiredFields);

        for (Field field : fieldsToValidate) {
            Object value = getValue(field, object);
            if (value == null || (value.getClass().getName().startsWith("java.lang") && value.equals(""))) {
                try {
                    if(!field.getName().endsWith("coordinates")){
                        errors.add(new ValidatorError(ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD, breadcrumb + "->" + field.getName(), Class.forName(field.getType().getName())));
                    }
                } catch (ClassNotFoundException e) {
                    throw new FatalReflectionValidatorException(e.getMessage());
                }
            } else if (value.getClass().getName().startsWith("java.lang")) {
                //seems okay, there is a value
            } else if (isList(value)) {
                List<Field> publicDeclaredFields = getAllPublicDeclaredFields(object.getClass());
                Boolean foundField = false;
                for (Field publicDeclaredField : publicDeclaredFields) {
                    if (publicDeclaredField.getName().equals(field.getName())) {
                        String name = publicDeclaredField.getGenericType().getTypeName();
                        name = name.substring(name.indexOf("<") + 1, name.indexOf(">"));
                        if (name.contains("PersonComprisedEntity")) {
                            List<PersonComprisedEntity> entityList = convertItemsToSubclass((List) value);
                            validateList(entityList, false, breadcrumb, field, errors);
                        } else if (name.contains("IsAbout")) {
                            List<IsAbout> isAboutList = convertItemsToSubclass((List) value);
                            validateList(isAboutList, false,  breadcrumb, field, errors);
                        } else {
                            validateList((List) value, false, breadcrumb, field, errors);
                        }
                        foundField = true;
                    }
                }
                if (!foundField) {
                    throw new FatalReflectionValidatorException("Unable to find getter for the list: " + field.getName());
                }
                //so this is a list of <name>, we need to make sure there is at least one value in the list
            } else {
                validate(value.getClass(), value, true, breadcrumb + "->" + field.getName(), field, errors);
            }
        }
    }

    public <T> List cleanseList(List<T> list, boolean setEmptyToNull) throws FatalReflectionValidatorException {
        ListIterator iterator = list.listIterator();
        while(iterator.hasNext()) {
            Object listObject = iterator.next();
            if(isObjectEmpty(listObject)) {
                iterator.remove();
            } else {
                cleanse(listObject.getClass(), listObject, setEmptyToNull);
            }
        }
        if(list.size() == 0) {
            return null;
        }
        return list;
    }

    public Object cleanse(Class<?> clazz, Object object, boolean setEmptyToNull) throws FatalReflectionValidatorException {
        if(setEmptyToNull) {
            if (isObjectEmpty(object)) {
                return null;
            }
        }

        List<Field> fields = getAllPublicDeclaredFields(object.getClass());

        for(Field field : fields) {
            Object value = getValue(field, object);
            if (value == null && (field.getType().isAssignableFrom(Float.class) || field.getType().isAssignableFrom(Integer.class))) {
                continue; // setValue will change the null value to 0.0 or 0 as appropriate for numeric Types -- in doing so, the field will be populated in the json
            }
            if (value == null || (value.getClass().getName().startsWith("java.lang") && value.equals(""))) {
                setValue(field, object, null);
            } else if(isList(value)) {
                List<Field> publicDeclaredFields = getAllPublicDeclaredFields(object.getClass());
                Boolean foundField = false;
                for (Field publicDeclaredField : publicDeclaredFields) {
                    if (publicDeclaredField.getName().equals(field.getName())) {
                        String name = publicDeclaredField.getGenericType().getTypeName();
                        name = name.substring(name.indexOf("<") + 1, name.indexOf(">"));
                        if (name.contains("PersonComprisedEntity")) {
                            List<PersonComprisedEntity> entityList = cleanseList(convertItemsToSubclass((List) value), setEmptyToNull);
                            setValue(field, object, entityList);
                        } else if (name.contains("IsAbout")) {
                            List<IsAbout> isAboutList = cleanseList(convertItemsToSubclass((List) value), setEmptyToNull);
                            setValue(field, object, isAboutList);
                        } else {
                            List newList = new ArrayList();
                            List<?> cleanedList = cleanseList((List) value, setEmptyToNull);
                            if(cleanedList instanceof AutoPopulatingList) {
                                for(Object listItem : cleanedList) {
                                    newList.add(listItem);
                                }
                                setValue(field, object, newList);
                            } else
                                setValue(field, object, cleanedList);
                        }
                        foundField = true;
                    }
                }
                if (!foundField) {
                    throw new FatalReflectionValidatorException("Unable to find getter for the list: " + field.getName());
                }
            } else {
                Object cleanedObject = cleanse(value.getClass(), value, setEmptyToNull);
                setValue(field, object, cleanedObject);
            }
        }
        return object;
    }

}
