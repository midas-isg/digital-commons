package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity;
import edu.pitt.isg.mdc.dats2_2.Organization;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;

public class TagUtil {
    public static boolean isObjectEmpty(Object bean) {
        if(bean == null || bean.equals("")) {
            return true;
        }

        boolean objectEmpty = false;

        if(bean instanceof List) {
            List myList = (List) bean;
            if(myList.size() == 0)
                return true;
            else {
                for (int i = 0; i < myList.size(); i++) {
                    objectEmpty = isObjectEmpty(myList.get(i));
                }
            }
        } else {
            Method[] methods = bean.getClass().getDeclaredMethods();
            for (Method method : methods) {
                if (isGetter(method)) {
                    try {
                        Object obj = method.invoke(bean);
                        if (obj == null || obj.equals("")) {
                            objectEmpty = true;
                        } else {
                            if (obj.getClass().isPrimitive()) {
                                return false;
                            } else {
                                if (isObjectEmpty(obj)) {
                                    objectEmpty = true;
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
        }
        return  objectEmpty;
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
            if(personComprisedEntity instanceof Organization) {
                return false;
            }
            else if(isObjectEmpty(((PersonOrganization) personComprisedEntity).getName()) && isObjectEmpty(((PersonOrganization) personComprisedEntity).getAbbreviation()) && isObjectEmpty(((PersonOrganization) personComprisedEntity).getLocation())) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            return true;
        }
    }
}
