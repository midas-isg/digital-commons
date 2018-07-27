package edu.pitt.isg.dc.validator;

import edu.pitt.isg.dc.utils.ReflectionFactory;
import edu.pitt.isg.mdc.dats2_2.*;

import javax.xml.bind.annotation.XmlElement;
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

    private static String capFirst(String string) {
        return string.substring(0, 1).toUpperCase() + string.substring(1);
    }

    private static Object getValue(Field field, Object object) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        Method method = object.getClass().getMethod("get" + capFirst(field.getName()));
        return method.invoke(object);
    }

    private static List<PersonComprisedEntity> convertPersonComprisedEntityList(List<PersonComprisedEntity> personComprisedEntities) {
        List<PersonComprisedEntity> newPersonComprisedEntityList = new ArrayList<>();
        ListIterator<PersonComprisedEntity> personComprisedEntityListIterator = personComprisedEntities.listIterator();
        while (personComprisedEntityListIterator.hasNext()) {
            newPersonComprisedEntityList.add(convertPersonOrganization(personComprisedEntityListIterator.next()));
        }
        return newPersonComprisedEntityList;
    }

    private static List<IsAbout> convertIsAboutList(List<IsAbout> isAboutList) {
        List<IsAbout> newIsAboutList =  new ArrayList<>();
        ListIterator<IsAbout> isAboutListIterator = isAboutList.listIterator();
        while(isAboutListIterator.hasNext()) {
            newIsAboutList.add(convertIsAboutItems(isAboutListIterator.next()));
        }
        return newIsAboutList;
    }

    private static List<Method> getPublicMethods(Object object, List<Method> publicMethods) throws Exception {
        if (publicMethods == null) {
            publicMethods = new ArrayList<>();
        }
        List<Method> allMethods = Arrays.asList(object.getClass().getMethods());
        for (Method method : allMethods) {
            if (Modifier.isPublic(method.getModifiers())) {
                publicMethods.add(method);
            }
        }

        if (object.getClass().getSuperclass().getName().equals("java.lang.Object"))
            return publicMethods;
        else
            return getPublicMethods(object.getClass().getSuperclass().newInstance(), publicMethods);
    }

    private static boolean isList(Object object) {
        return (List.class.isAssignableFrom(object.getClass()));
    }

    private static List<Field> getRequiredFields(Class clazz) throws Exception {
        List<Field> declaredFields = ReflectionValidator.getAllPublicDeclaredFields(clazz, null);
        List<Field> requiredFields = new ArrayList<>();

        for (Field field : declaredFields) {
            if (field.isAnnotationPresent(XmlElement.class)) {
                XmlElement annotation = (XmlElement) field.getAnnotation(XmlElement.class);
                if (annotation.required()) {
                    requiredFields.add(field);
                }
            }
        }

        return requiredFields;
    }

    private static List<Field> getNonEmptyNonRequiredFields(Class clazz, Object object) throws Exception {
        List<Field> declaredFields = ReflectionValidator.getAllPublicDeclaredFields(clazz, null);
        List<Field> nonEmptyNonRequiredFields = new ArrayList<>();

        for (Field field : declaredFields) {
            boolean nonEmptyNonRequiredField = true;
            if (field.isAnnotationPresent(XmlElement.class)) {
                XmlElement annotation = (XmlElement) field.getAnnotation(XmlElement.class);
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

    private static List<Field> getAllPublicDeclaredFields(Class clazz, List<Field> declaredFields) throws
            Exception {
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

    /*private static boolean isGetter(Method method){
        // identify get methods
        if((method.getName().startsWith("get") || method.getName().startsWith("is"))
                && method.getParameterCount() == 0 && !method.getReturnType().equals(void.class)){
            return true;
        }
        return false;
    }
*/

    private static boolean isListEmtpy(List list) throws Exception {
        for (Object item : list) {
            if (!isObjectEmpty(item)) return false;
        }
        return true;
    }

    private static boolean isObjectEmpty(Object object) throws Exception {
        if (List.class.isAssignableFrom(object.getClass())) {
            if (!isListEmtpy((List) object)) return false;
        } else {
            List<Field> allFields = getAllPublicDeclaredFields(object.getClass(), null);
            for (Field field : allFields) {
                Object value = getValue(field, object);
                if (value == null)
                    continue;
                if (List.class.isAssignableFrom(value.getClass())) {
                    if (!isListEmtpy((List) value)) return false;
                } else {
                    if (value != null && !value.equals("")) {
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
        return true;
    }

    //
    private static <T> void validateRequiredList(Class<T> clazz, List<T> list, String
            breadcrumb, Field field, List<ValidatorError> errors) throws Exception {
        breadcrumb += "->" + field.getName();
        boolean foundNonEmpty = false;
        for (T item : list) {
            //if its totally empty, hmmm
            if (!isObjectEmpty(item)) {
                foundNonEmpty = true;
                //root is false as we don't need every item to exist...just one
                validate(item.getClass(), item, false, breadcrumb, field, errors);
            }
        }
        if (foundNonEmpty) {
            //ok!
        } else
            errors.add(new ValidatorError(ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD, breadcrumb, Class.forName(field.getType().getName())));

    }

    public static void validate(Class<?> clazz, Object object, boolean rootIsRequired, String
            breadcrumb, Field rootField, List<ValidatorError> errors) throws Exception {
        if (rootField == null) {
            breadcrumb += "(root)";
        }

        if (rootIsRequired)
            if (isObjectEmpty(object)) {
                errors.add(new ValidatorError(ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD, breadcrumb, object.getClass()));
                return;
            }

        List<Field> requiredFields = getRequiredFields(clazz);
        List<Field> nonEmptyNonRequiredFields = getNonEmptyNonRequiredFields(clazz, object);

        List<Field> fieldsToValidate = new ArrayList<>();
        fieldsToValidate.addAll(requiredFields);
        fieldsToValidate.addAll(nonEmptyNonRequiredFields);

        for (Field field : fieldsToValidate) {
            Object value = getValue(field, object);
            if (value == null || (value.getClass().getName().startsWith("java.lang") && value.equals(""))) {
                errors.add(new ValidatorError(ValidatorErrorType.NULL_VALUE_IN_REQUIRED_FIELD, breadcrumb + "->" + field.getName(), Class.forName(field.getType().getName())));
            } else if (value.getClass().getName().startsWith("java.lang")) {
                //seems okay, there is a value
            } else if ((List.class.isAssignableFrom(value.getClass()))) {
/*              //Check for alternate ID's
                if(field.getName().contains("alternateIdentifiers")){
                    System.out.println(breadcrumb + "->" + field.getName());
                }
*/
                List<Field> publicDeclaredFields = getAllPublicDeclaredFields(object.getClass(), null);
                Boolean foundField = false;
                for(int i = 0; i < publicDeclaredFields.size(); i++){
                    if(publicDeclaredFields.get(i).getName().equals(field.getName())){
                        String name = publicDeclaredFields.get(i).getGenericType().getTypeName();
                        name = name.substring(name.indexOf("<") + 1, name.indexOf(">"));

                        if(name.contains("PersonComprisedEntity")) {
                            List<PersonComprisedEntity> entityList = convertPersonComprisedEntityList((List) value);
                            validateRequiredList(Class.forName(name), (List) entityList, breadcrumb, field, errors);
                        } else if(name.contains("IsAbout")) {
                            List<IsAbout> isAboutList = convertIsAboutList((List) value);
                            validateRequiredList(Class.forName(name), (List)isAboutList, breadcrumb, field, errors);
                        } else {
                            validateRequiredList(Class.forName(name), (List) value, breadcrumb, field, errors);
                        }

                        foundField = true;
                    }
                }
                if(!foundField){
                    throw new Exception("We didn't find the field!!!");
                }

                //so this is a list of <name>, we need to make sure there is at least one value in the list
            } else {
                validate(value.getClass(), value, true, breadcrumb + "->" + field.getName(), field, errors);
                //System.out.println(value);
            }
            //System.out.println(value);
        }
    }

/*
    public static void main(String[] args) throws Exception {
        Dataset d = (Dataset) ReflectionFactory.create(Dataset.class);
        d.setTitle("John's Test");
        Type t = new Type();
        Annotation a = new Annotation();
        a.setValue("hello");
        t.setInformation(a);
        d.getTypes().add(t);
        License license = new License();
        license.setVersion("1.0");
        d.getLicenses().add(license);
        Organization organization = new Organization();
        // organization.setName("John");
        d.getCreators().add(organization);
        isObjectEmpty(d.getTypes());
        List<ValidatorError> errors = new ArrayList<>();
        String breadcrumb = "";
        ReflectionValidator.validate(Dataset.class, d, true, breadcrumb, null, errors);
        if (errors.size() > 0) {

            System.out.println("Validation failed with the following errors:");
            for (ValidatorError error : errors) {
                System.out.println("\t" + error);
            }
        }
    }
*/
}
