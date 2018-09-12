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

        if (softwareCategory.equals("DataFormatConverters") || softwareCategory.equals("MetagenomicAnalysis") || softwareCategory.equals("ModelingPlatforms") || softwareCategory.equals("PhylogeneticTreeConstructors") || softwareCategory.equals("SyntheticEcosystemConstructors")) {
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

    public static String getCardTabTitle(Object listItem) {
        String cardTabTitle = getCardTabToolTip(listItem);

        if (cardTabTitle.length() > 40) {
            if (cardTabTitle.contains(" ")) {
                String[] cardTabTitleWords = cardTabTitle.split("\\s+");
                int size = cardTabTitleWords.length;
                if (size > 6) {
                    cardTabTitle = cardTabTitle.substring(0, cardTabTitle.indexOf(cardTabTitleWords[3]) - 1) + "..." + cardTabTitle.substring(cardTabTitle.indexOf(cardTabTitleWords[size - 2]));
                }
            } else
                cardTabTitle = cardTabTitle.substring(0, 15) + "..." + cardTabTitle.substring(cardTabTitle.length() - 15);
        }

        return cardTabTitle;

    }

    public static String getCardTabToolTip(Object listItem) {
        String cardTabToolTip = null;

        switch (listItem.getClass().getSimpleName()) {
            case "String":
                cardTabToolTip = listItem.toString();
                break;
            case "Annotation":
                cardTabToolTip = ((Annotation) listItem).getValue();
                break;
            case "BiologicalEntity":
                cardTabToolTip = ((BiologicalEntity) listItem).getName();
                break;
            case "IsAboutItems":
                if (isBiologicalEntity((IsAboutItems) listItem)) {
                    cardTabToolTip = ((IsAboutItems) listItem).getName();
                } else cardTabToolTip = ((IsAboutItems) listItem).getValue();
                break;
            case "DataStandard":
                cardTabToolTip = ((DataStandard) listItem).getName();
                break;
            case "DataRepository":
                cardTabToolTip = ((DataRepository) listItem).getName();
                break;
            case "Date":
                cardTabToolTip = ((Date) listItem).getType().getValue();
                break;
            case "Identifier":
                cardTabToolTip = ((Identifier) listItem).getIdentifier();
                break;
            case "Person":
                if (isObjectEmpty(((Person) listItem).getFullName())) {
                    cardTabToolTip = ((Person) listItem).getFirstName() + " " + ((Person) listItem).getLastName();
                } else cardTabToolTip = ((Person) listItem).getFullName();
                break;
            case "Organization":
                cardTabToolTip = ((Organization) listItem).getName();
                break;
            case "PersonOrganization":
                if (isPerson((PersonOrganization) listItem)) {
                    cardTabToolTip = ((PersonOrganization) listItem).getFirstName() + " " + ((PersonOrganization) listItem).getLastName();
                } else cardTabToolTip = ((PersonOrganization) listItem).getName();
                break;
            case "Study":
                cardTabToolTip = ((Study) listItem).getName();
                break;
            case "License":
                cardTabToolTip = ((License) listItem).getName();
                break;
            case "Publication":
                if (isObjectEmpty(((Publication) listItem).getTitle())) {
                    cardTabToolTip = "Publication";
                } else cardTabToolTip = ((Publication) listItem).getTitle();
                break;
            case "Grant":
                cardTabToolTip = ((Grant) listItem).getName();
                break;
            case "Access":
                if (isObjectEmpty(((Access) listItem).getLandingPage())) {
                    cardTabToolTip = "Access";
                } else cardTabToolTip = ((Access) listItem).getLandingPage();
                break;
            case "Distribution":
                if (isObjectEmpty(((Distribution) listItem).getTitle())) {
                    cardTabToolTip = "Distribution";
                } else cardTabToolTip = ((Distribution) listItem).getTitle();
                break;
            case "Place":
                cardTabToolTip = ((Place) listItem).getName();
                break;
            case "Type":
                if (!isObjectEmpty(((Type) listItem).getInformation().getValue())) {
                    cardTabToolTip = ((Type) listItem).getInformation().getValue();
                } else if (!isObjectEmpty(((Type) listItem).getMethod().getValue())) {
                    cardTabToolTip = ((Type) listItem).getMethod().getValue();
                } else if (!isObjectEmpty(((Type) listItem).getPlatform().getValue())) {
                    cardTabToolTip = ((Type) listItem).getPlatform().getValue();
                } else cardTabToolTip = "Type";
                break;
            case "CategoryValuePair":
                if (isObjectEmpty(((CategoryValuePair) listItem).getCategory())) {
                    cardTabToolTip = "Category";
                } else cardTabToolTip = ((CategoryValuePair) listItem).getCategory();
                break;
        }

        return cardTabToolTip;
    }

    public static boolean isFirstInstance(String specifier) {
        if (specifier.endsWith("-0")) {
            return true;
        } else return false;
    }
}
