package edu.pitt.isg.dc.utils;

import edu.pitt.isg.mdc.dats2_2.Dataset;
import org.springframework.util.AutoPopulatingList;

import java.lang.reflect.Method;
import java.util.*;

public class ReflectionFactory {

    private static String getGenericTypeOfDeclaredField(String field, Class clazz) {
        if (field.equals("alternateIdentifiers") && clazz.getName().contains("About")) {
            System.out.println("hmm");
        }
        try {
            return clazz.getDeclaredField(field).getGenericType().getTypeName();
        } catch (NoSuchFieldException e) {
            if (clazz.getSuperclass().getName().equals("java.lang.Object"))
                return null;
            else
                return getGenericTypeOfDeclaredField(field, clazz.getSuperclass());
        }
    }

    private static <Type> List<Type> getGenericList(Class<Type> type, Class clazz) throws Exception {
        List<Type> l = new ArrayList<Type>();
        Object newInstance = ReflectionFactory.create(clazz);
        l.add((Type) newInstance);
        return new AutoPopulatingList(l, new ReflectionFactoryElementFactory<Type>(clazz));
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
        if (clazz.getName().endsWith("PersonComprisedEntity")) {
            clazz = Class.forName("edu.pitt.isg.dc.entry.classes.PersonOrganization");
        }
        if (clazz.getName().endsWith("IsAbout")) {
            clazz = Class.forName("edu.pitt.isg.dc.entry.classes.IsAboutItems");
        }
        Object instance = clazz.newInstance();
        for (Method m : ReflectionFactory.gatherMethods(instance, null)) {
            if (m.getName().startsWith("get") && m.getParameterTypes().length == 0) {
                final Object r = m.invoke(instance);
                if (!m.getReturnType().getName().startsWith("java.lang")) {
                    String possibleSetter = "s" + m.getName().substring(1, m.getName().length());
                    try {
                        Method setter = instance.getClass().getMethod(possibleSetter, m.getReturnType());
                        System.out.println("Setting " + possibleSetter);

                        if (m.getReturnType().equals(List.class)) {
                            System.out.println(m.getTypeParameters());
                            String field = m.getName().substring(3, m.getName().length());
                            field = field.substring(0, 1).toLowerCase() + field.substring(1, m.getName().length() - 3);
                            String name = ReflectionFactory.getGenericTypeOfDeclaredField(field, clazz);

                            name = name.substring(name.indexOf("<") + 1, name.indexOf(">"));
                            Class listClazz = Class.forName(name);

                            setter.invoke(instance, getGenericList(listClazz.getClass(), listClazz));
                        } else {
                            if (!setter.getName().endsWith("Geometry"))
                                setter.invoke(instance, ReflectionFactory.create(m.getReturnType()));
                        }
                    } catch (NoSuchMethodException e) {
                        //this is fine I think...
                    }
                }
            }
        }
        return instance;
    }

    public static void main(String[] args) throws Exception {
        Dataset d = (Dataset) ReflectionFactory.create(Dataset.class);
        d.getLicenses().get(2);
        System.out.println(d);
    }

}
