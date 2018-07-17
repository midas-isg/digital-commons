package edu.pitt.isg.dc.utils;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class TagUtil {
    public static boolean isObjectEmpty(Object bean) {
        boolean isObjectEmpty = false;
        Method[] methods = bean.getClass().getDeclaredMethods();
        for(Method method : methods){
            if(isGetter(method)){
                try {
                    Object obj = method.invoke(bean);
                    if(obj == null) {
                        isObjectEmpty = true;
                    } else {
                        return false;
                    }
                    System.out.println("Invoking "+ method.getName() + " Returned Value - " + obj);
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
}
