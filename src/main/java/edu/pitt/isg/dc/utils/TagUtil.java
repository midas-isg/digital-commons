package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;

public class TagUtil {
    public static boolean isObjectEmpty(Object bean) {
        if(bean == null || bean.equals("")) {
            return true;
        }

        boolean isObjectEmpty = false;

        if(bean instanceof List) {
            List myList = (List) bean;
            if(myList.size() == 0)
                return true;

            bean =  myList.get(0);
        }
        Method[] methods = bean.getClass().getDeclaredMethods();
        for(Method method : methods){
            if(isGetter(method)){
                try {
                    Object obj = method.invoke(bean);
                    if(obj == null || obj.equals("")) {
                        isObjectEmpty = true;
                    } else {
                        if(obj.getClass().isPrimitive()) {
                            return false;
                        } else {
                            if(isObjectEmpty(obj)) {
                                isObjectEmpty = true;
                            } else
                                return false;
                        }
                    }
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (IllegalArgumentException e) {
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                }
            }
        }
        return  isObjectEmpty;
    }

    private static boolean isGetter(Method method){
        // identify get methods
        if((method.getName().startsWith("get") || method.getName().startsWith("is"))
                && method.getParameterCount() == 0 && !method.getReturnType().equals(void.class)){
            return true;
        }
        return false;
    }

    public static boolean isPerson(PersonComprisedEntity personComprisedEntity) {
        try {
            if(isObjectEmpty(((PersonOrganization) personComprisedEntity).getName()) && isObjectEmpty(((PersonOrganization) personComprisedEntity).getAbbreviation()) && isObjectEmpty(((PersonOrganization) personComprisedEntity).getLocation())) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            return true;
        }
    }
}
