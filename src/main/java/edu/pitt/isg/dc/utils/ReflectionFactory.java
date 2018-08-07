package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.mdc.dats2_2.IsAbout;
import edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity;
import org.springframework.util.AutoPopulatingList;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ReflectionFactory {

    private static Class getGenericTypeOfList(Method method, Class clazz) throws ClassNotFoundException {
        String field = method.getName().substring(3, method.getName().length());
        field = field.substring(0, 1).toLowerCase() + field.substring(1, method.getName().length() - 3);
        String name = ReflectionFactory.getGenericTypeOfDeclaredField(field, clazz);
        name = name.substring(name.indexOf("<") + 1, name.indexOf(">"));
        Class listClazz = Class.forName(name);
        return listClazz;
    }

    private static String getGenericTypeOfDeclaredField(String field, Class clazz) {
        try {
            return clazz.getDeclaredField(field).getGenericType().getTypeName();
        } catch (NoSuchFieldException e) {
            if (clazz.getSuperclass().getName().equals("java.lang.Object"))
                return null;
            else
                return getGenericTypeOfDeclaredField(field, clazz.getSuperclass());
        }
    }

    private static <T> List<T> getGenericList(List<T> list, Class<T> type, Class clazz) throws Exception {
        if (list == null) {
            list = new ArrayList<>();
            Object newInstance = ReflectionFactory.create(clazz);
            list.add((T) newInstance);
        }

        if (list.size() == 0) {
            list.add((T) create(clazz));
        }

        ReflectionFactoryHelper reflectionFactoryHelper = new ReflectionFactoryHelper();

        for (int i = 0; i < list.size(); i++) {
            if (list.get(i) != null)
                list.set(i, (T) ReflectionFactory.create(clazz, list.get(i)));
            if (clazz.getName().endsWith("IsAbout"))
                list.set(i, (T) ReflectionFactory.create(IsAboutItems.class, reflectionFactoryHelper.mapIsAboutToIsAboutItems((IsAbout) list.get(i))));
            if (clazz.getName().endsWith("PersonComprisedEntity"))
                list.set(i, (T) ReflectionFactory.create(PersonComprisedEntity.class, reflectionFactoryHelper.mapPersonComprisedEntityToPersonOrganization((PersonComprisedEntity) list.get(i))));
        }
        if (list instanceof AutoPopulatingList) {
            return list;
        } else {
            return new AutoPopulatingList(list, new ReflectionFactoryElementFactory<T>(clazz));
        }
    }

    private static <Type> List<Type> getGenericList(Class<Type> type, Class clazz) throws Exception {
        return getGenericList(null, type, clazz);
    }

    private static List<Method> gatherMethods(Object object, List<Method> methods) throws Exception {
        if (methods == null) {
            methods = new ArrayList<>();
        }
        methods.addAll(Arrays.asList(object.getClass().getMethods()));
        if (object.getClass().getSuperclass().getName().equals("java.lang.Object"))
            return methods;
        else
            return gatherMethods(object.getClass().getSuperclass().newInstance(), methods);
    }

    public static Object create(Class<?> clazz) throws Exception {
        return create(clazz, null);
    }

//TODO: throw exception if no getters/setters are found
    public static Object create(Class<?> clazz, Object instance) throws Exception {
        if (clazz.getName().endsWith("PersonComprisedEntity")) {
            clazz = Class.forName("edu.pitt.isg.dc.entry.classes.PersonOrganization");
        }
        if (clazz.getName().endsWith("IsAbout")) {
            clazz = Class.forName("edu.pitt.isg.dc.entry.classes.IsAboutItems");
        }
        if (instance == null)
            instance = clazz.newInstance();
        for (Method getter : ReflectionFactory.gatherMethods(instance, null)) {
            if (getter.getName().startsWith("get") && getter.getParameterTypes().length == 0) {
                if (!getter.getReturnType().getName().startsWith("java.lang")) {
                    String possibleSetter = "s" + getter.getName().substring(1, getter.getName().length());
                    try {
                        Method setter = instance.getClass().getMethod(possibleSetter, getter.getReturnType());
                        if (getter.getReturnType().equals(List.class)) {
                            Class listClazz = getGenericTypeOfList(getter, clazz);
                            //invoke getter
                            List list = (List) getter.invoke(instance);
                            if (list == null) {
                                setter.invoke(instance, getGenericList(listClazz.getClass(), listClazz));
                            } else {
                                setter.invoke(instance, getGenericList(list, listClazz.getClass(), listClazz));
                            }
                        } else {
                            if (!setter.getName().endsWith("Geometry")) {
                                Object object = getter.invoke(instance);
                                if (object == null) {
                                    setter.invoke(instance, ReflectionFactory.create(getter.getReturnType()));
                                } else {
                                    setter.invoke(instance, ReflectionFactory.create(getter.getReturnType(), object));
                                }
                            }
                        }
                    } catch (NoSuchMethodException e) {
                        //this is fine I think...
                    }
                }
            }
        }
        return instance;
    }
}
