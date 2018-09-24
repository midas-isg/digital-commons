package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.dc.validator.ReflectionValidator;
import edu.pitt.isg.mdc.dats2_2.*;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;

public class TagUtil {
    public static boolean isObjectEmpty(Object bean) {
        ReflectionValidator validator = new ReflectionValidator();
        try {
            return validator.isObjectEmpty(bean);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
//        if (bean == null || bean.equals("")) {
//            return true;
//        }
//
//        boolean objectEmpty = false;
//
//        if (bean instanceof List) {
//            List myList = (List) bean;
//            if (myList.size() == 0)
//                return true;
//            else {
//                for (int i = 0; i < myList.size(); i++) {
//                    objectEmpty = isObjectEmpty(myList.get(i));
//                }
//            }
//        } else {
//            Method[] methods = bean.getClass().getDeclaredMethods();
//            for (Method method : methods) {
//                if (isGetter(method)) {
//                    try {
//                        Object obj = method.invoke(bean);
//                        if (obj == null || obj.equals("")) {
//                            objectEmpty = true;
//                        } else {
//                            if (obj.getClass().isPrimitive()) {
//                                return false;
//                            } else {
//                                if (isObjectEmpty(obj)) {
//                                    objectEmpty = true;
//                                } else
//                                    return false;
//                            }
//                        }
//                    } catch (IllegalAccessException e) {
//                        e.printStackTrace();
//                    } catch (IllegalArgumentException e) {
//                        e.printStackTrace();
//                    } catch (InvocationTargetException e) {
//                        e.printStackTrace();
//                    }
//                }
//            }
//        }
//        return objectEmpty;
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

    public static String getCardTabTitle(Object listItem){
        String cardTabTitle = null;

        switch (listItem.getClass().getSimpleName()) {
            case "String":
                cardTabTitle = listItem.toString();
                break;
            case "Annotation":
                cardTabTitle = ((Annotation) listItem).getValue();
                break;
            case "BiologicalEntity":
                cardTabTitle = ((BiologicalEntity) listItem).getName();
                break;
            case "IsAboutItems":
                if(isBiologicalEntity((IsAboutItems) listItem)){
                    cardTabTitle = ((IsAboutItems) listItem).getName();
                } else cardTabTitle = ((IsAboutItems) listItem).getValue();
                break;
            case "DataStandard":
                cardTabTitle = ((DataStandard) listItem).getName();
                break;
            case "DataRepository":
                cardTabTitle = ((DataRepository) listItem).getName();
                break;
            case "Date":
                cardTabTitle = ((Date) listItem).getType().getValue();
                break;
            case "Identifier":
                cardTabTitle = ((Identifier) listItem).getIdentifier();
                break;
            case "Person":
                if (isObjectEmpty(((Person) listItem).getFullName())) {
                    cardTabTitle = ((Person) listItem).getFirstName() + " " + ((Person) listItem).getLastName();
                } else cardTabTitle = ((Person) listItem).getFullName();
                break;
            case "Organization":
                cardTabTitle = ((Organization) listItem).getName();
                break;
            case "PersonOrganization":
                if (isPerson((PersonOrganization) listItem)) {
                    cardTabTitle = ((PersonOrganization) listItem).getFirstName() + " " + ((PersonOrganization) listItem).getLastName();
                } else cardTabTitle = ((PersonOrganization) listItem).getName();
                break;
            case "Study":
                cardTabTitle = ((Study) listItem).getName();
                break;
            case "License":
                cardTabTitle = ((License) listItem).getName();
                break;
            case "Publication":
                if (isObjectEmpty(((Publication) listItem).getTitle())) {
                    cardTabTitle = "Publication";
                } else cardTabTitle = ((Publication) listItem).getTitle();
                break;
            case "Grant":
                cardTabTitle = ((Grant) listItem).getName();
                break;
            case "Access":
                if (isObjectEmpty(((Access) listItem).getLandingPage())) {
                    cardTabTitle = "Access";
                } else cardTabTitle = ((Access) listItem).getLandingPage();
                break;
            case "Distribution":
                if (isObjectEmpty(((Distribution) listItem).getTitle())) {
                    cardTabTitle = "Distribution";
                } else cardTabTitle = ((Distribution) listItem).getTitle();
                break;
            case "Place":
                cardTabTitle = ((Place) listItem).getName();
                break;
            case "Type":
                if (!isObjectEmpty(((Type) listItem).getInformation().getValue())) {
                    cardTabTitle = ((Type) listItem).getInformation().getValue();
                } else if (!isObjectEmpty(((Type) listItem).getMethod().getValue())) {
                    cardTabTitle = ((Type) listItem).getMethod().getValue();
                } else if (!isObjectEmpty(((Type) listItem).getPlatform().getValue())) {
                    cardTabTitle = ((Type) listItem).getPlatform().getValue();
                } else cardTabTitle = "Type";
                break;
            case "CategoryValuePair":
                if (isObjectEmpty(((CategoryValuePair) listItem).getCategory())) {
                    cardTabTitle = "Category";
                } else cardTabTitle = ((CategoryValuePair) listItem).getCategory();
                break;
        }

        return cardTabTitle;
    }

    public static boolean isFirstInstance(String specifier) {
        if(specifier.endsWith("-0")){
            return true;
        } else return false;
    }
}
