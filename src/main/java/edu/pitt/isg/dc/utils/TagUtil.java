package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.mdc.dats2_2.Annotation;
import edu.pitt.isg.mdc.dats2_2.IsAbout;
import edu.pitt.isg.mdc.dats2_2.Organization;
import edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;

public class TagUtil {
    public static boolean isObjectEmpty(Object bean) {
        if (bean == null || bean.equals("")) {
            return true;
        }

        boolean objectEmpty = false;

        if (bean instanceof List) {
            List myList = (List) bean;
            if (myList.size() == 0)
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
        return objectEmpty;
    }

    private static boolean isGetter(Method method) {
        // identify get methods
        if ((method.getName().startsWith("get") || method.getName().startsWith("is"))
                && method.getParameterCount() == 0 && !method.getReturnType().equals(void.class)) {
            return true;
        }
        return false;
    }

    public static boolean isPerson(PersonComprisedEntity personComprisedEntity) {
        try {
            if (personComprisedEntity instanceof Organization) {
                return false;
            } else if (isObjectEmpty(((PersonOrganization) personComprisedEntity).getName()) && isObjectEmpty(((PersonOrganization) personComprisedEntity).getAbbreviation()) && isObjectEmpty(((PersonOrganization) personComprisedEntity).getLocation())) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            return true;
        }
    }

    public static boolean isBiologicalEntity(IsAbout isAbout) {
        try {
            if (isAbout instanceof Annotation) {
                return false;
            } else if (isObjectEmpty(((IsAboutItems) isAbout).getValue()) && isObjectEmpty(((IsAboutItems) isAbout).getValueIRI())) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            return true;
        }
    }

    public static boolean onlyContainsSoftwareElements(Object software) {
        String softwareCategory = software.getClass().getTypeName().substring(software.getClass().getTypeName().lastIndexOf(".") + 1);

        if(softwareCategory.equals("DataFormatConverters") || softwareCategory.equals("MetagenomicAnalysis") || softwareCategory.equals("ModelingPlatforms") || softwareCategory.equals("PhylogeneticTreeConstructors") || softwareCategory.equals("SyntheticEcosystemConstructors")){
            return true;
        } else return false;
/*
        switch (softwareCategory) {
            case "DataFormatConverters":
                return true;
            case "MetagenomicAnalysis":
                return true;
            case "ModelingPlatforms":
                return true;
            case "PhylogeneticTreeConstructors":
                return true;
            case "SyntheticEcosystemConstructors":
                return true;
            default: return false;
        }
*/
    }

}
