package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.mdc.dats2_2.*;
import org.springframework.util.AutoPopulatingList;

import java.util.ArrayList;
import java.util.List;

public class DatasetFactory {
    public static Dataset createDatasetForWebFlow() {
        //create an instance of every member of Dataset
        //every member of every member must be instantiated
        //every list must contain at least one entry for every type the list can take (e.g. Person/Organization)
        Dataset dataset = new Dataset();
        dataset.setIdentifier(new Identifier());

        dataset.setDates(wrapListWithAutoPopulatingList(createDateList(), Date.class));
        dataset.setStoredIn(createDataRepository());
        dataset.setSpatialCoverage(wrapListWithAutoPopulatingList(createPlaceList(), Place.class));
        dataset.setTypes(wrapListWithAutoPopulatingList(createTypeList(), Type.class));
        dataset.setDistributions(wrapListWithAutoPopulatingList(createDistributionList(), Distribution.class));
        dataset.setPrimaryPublications(wrapListWithAutoPopulatingList(createPublicationList(), Publication.class));
        dataset.setCitations(wrapListWithAutoPopulatingList(createPublicationList(), Publication.class));
        dataset.setProducedBy(createStudy());
        dataset.setCreators(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(), PersonComprisedEntity.class));
        dataset.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(), License.class));
        dataset.setIsAbout(wrapListWithAutoPopulatingList(createIsAboutItemsList(), IsAbout.class));
        dataset.setAcknowledges(wrapListWithAutoPopulatingList(createGrantList(), Grant.class));
        dataset.setExtraProperties(wrapListWithAutoPopulatingList(createCategoryValuePairList(), CategoryValuePair.class));

        return dataset;
    }

    public static <T> List<T> wrapListWithAutoPopulatingList(List<T> list, Class<?> pojoClazz)  {

        List<T> apl = new AutoPopulatingList(list, pojoClazz ) ;
        return apl;
    }

    public static List<Distribution> createDistributionList(){
        List<Distribution> distributionList = new ArrayList<Distribution>();
        distributionList.add(createDistribution());

        return distributionList;
    }

    public static Distribution createDistribution(){
        Distribution distribution = new Distribution();
        distribution.setIdentifier(new Identifier());
        distribution.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));
        distribution.setStoredIn(createDataRepository());
        distribution.setDates(wrapListWithAutoPopulatingList(createDateList(), Date.class));
        distribution.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(), License.class));
        distribution.setAccess(createAccess());
        distribution.setConformsTo(wrapListWithAutoPopulatingList(createDataStandardList(), DataStandard.class));
        distribution.setQualifiers(wrapListWithAutoPopulatingList(createAnnotationList(), Annotation.class));
        distribution.setUnit(new Annotation());

        return distribution;
    }

    public static List<Identifier> createIdentifierList(){
        List<Identifier> identifierList = new ArrayList<Identifier>();
        identifierList.add(new Identifier());

        return identifierList;
    }

    public static List<Annotation> createAnnotationList(){
        List<Annotation> annotationList = new ArrayList<Annotation>();
        annotationList.add(new Annotation());

        return annotationList;
    }

    public static List<Type> createTypeList(){
        List<Type> typeList = new ArrayList<Type>();
        Type type = new Type();
        type.setInformation(new Annotation());
        type.setMethod(new Annotation());
        type.setPlatform(new Annotation());

        typeList.add(type);

        return typeList;
    }

    public static List<DataStandard> createDataStandardList(){
        List<DataStandard> dataStandardList = new ArrayList<DataStandard>();
        dataStandardList.add(createDataStandard());

        return dataStandardList;
    }

    public static DataStandard createDataStandard(){
        DataStandard dataStandard = new DataStandard();
        dataStandard.setIdentifier(new Identifier());
        dataStandard.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));
        dataStandard.setType(new Annotation());
        dataStandard.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(), License.class));
        dataStandard.setExtraProperties(wrapListWithAutoPopulatingList(createCategoryValuePairList(), CategoryValuePair.class));

        return dataStandard;
    }

    public static DataRepository createDataRepository(){
        DataRepository dataRepository = new DataRepository();
        dataRepository.setIdentifier(new Identifier());
        dataRepository.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));
        dataRepository.setScopes(wrapListWithAutoPopulatingList(createAnnotationList(), Annotation.class));
        dataRepository.setTypes(wrapListWithAutoPopulatingList(createAnnotationList(), Annotation.class));
        dataRepository.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(), License.class));
        dataRepository.setPublishers(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(), PersonComprisedEntity.class));
        dataRepository.setAccess(wrapListWithAutoPopulatingList(createAccessList(), Access.class));

        return dataRepository;
    }

    public static List<IsAbout> createIsAboutItemsList(){
        List<IsAbout> isAboutItemsList = new ArrayList<IsAbout>();
        isAboutItemsList.add(createIsAboutItems());

        return isAboutItemsList;
    }

    public static IsAboutItems createIsAboutItems(){
        IsAboutItems isAboutItems = new IsAboutItems();
        isAboutItems.setIdentifier(new Identifier());
        isAboutItems.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));

        return isAboutItems;
    }

    public static IsAbout createIsAbout(){
        IsAbout isAbout = createIsAboutItems();

        return isAbout;
    }

    public static BiologicalEntity createBiologicalEntity(){
        BiologicalEntity biologicalEntity = new BiologicalEntity();
        biologicalEntity.setIdentifier(new Identifier());
        biologicalEntity.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));

        return biologicalEntity;
    }

    public static Study createStudy(){
        Study study = new Study();
        study.setStartDate(createDate());
        study.setEndDate(createDate());
        study.setLocation(createPlace());

        return study;
    }

    public static List<License> createLicenseList(){
        List<License> licenseList = new ArrayList<License>();
        licenseList.add(createLicense());

        return licenseList;
    }

    public static License createLicense(){
        License license = new License();
        license.setIdentifier(new Identifier());
        license.setCreators(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(), PersonComprisedEntity.class));

        return license;
    }

    public static List<Publication> createPublicationList(){
        List<Publication> publicationList = new ArrayList<Publication>();
        publicationList.add(createPublication());

        return publicationList;
    }

    public static Publication createPublication(){
        Publication publication = new Publication();
        publication.setIdentifier(new Identifier());
        publication.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));
        publication.setType(new Annotation());
        publication.setDates(wrapListWithAutoPopulatingList(createDateList(), Date.class));
        publication.setAuthors(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(), PersonComprisedEntity.class));
        publication.setAcknowledges(wrapListWithAutoPopulatingList(createGrantList(), Grant.class));

        return publication;
    }

    public static List<Grant> createGrantList(){
        List<Grant> grantList = new ArrayList<Grant>();
        grantList.add(createGrant());

        return grantList;
    }

    public static Grant createGrant(){
        Grant grant = new Grant();
        grant.setIdentifier(new Identifier());
        grant.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));
        grant.setFunders(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(), PersonComprisedEntity.class));
        grant.setAwardees(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(), PersonComprisedEntity.class));

        return grant;
    }

    public static List<Access> createAccessList(){
        List<Access> accessList = new ArrayList<Access>();
        accessList.add(createAccess());

        return accessList;
    }

    public static Access createAccess(){
        Access access = new Access();
        access.setIdentifier(new Identifier());
        access.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));
        access.setTypes(wrapListWithAutoPopulatingList(createAnnotationList(), Annotation.class));
        access.setAuthorizations(wrapListWithAutoPopulatingList(createAnnotationList(), Annotation.class));
        access.setAuthentications(wrapListWithAutoPopulatingList(createAnnotationList(), Annotation.class));

        return access;
    }

    public static PersonOrganization createPersonOrganization(){
        PersonOrganization personOrganization = new PersonOrganization();
        personOrganization.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));
        personOrganization.setAffiliations(wrapListWithAutoPopulatingList(createOrganizationList(), Organization.class));
        personOrganization.setRoles(wrapListWithAutoPopulatingList(createAnnotationList(), Annotation.class));
        personOrganization.setIdentifier(new Identifier());
        personOrganization.setLocation(createPlace());

        return personOrganization;
    }

    public static List<PersonComprisedEntity> createPersonComprisedEntityList(){
        List<PersonComprisedEntity> personComprisedEntityList = new ArrayList<PersonComprisedEntity>();
        personComprisedEntityList.add(createPersonComprisedEntity());

        return personComprisedEntityList;
    }


    public static PersonComprisedEntity createPersonComprisedEntity(){
        PersonComprisedEntity personComprisedEntity = createPersonOrganization();

        return personComprisedEntity;
    }

    public static Person createPerson(){
        Person person = new Person();
        person.setIdentifier(new Identifier());
        person.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));
        person.setAffiliations(wrapListWithAutoPopulatingList(createOrganizationList(), Organization.class));
        person.setRoles(wrapListWithAutoPopulatingList(createAnnotationList(), Annotation.class));

        return person;
    }

    public static List<Organization> createOrganizationList(){
        List<Organization> organizationList = new ArrayList<Organization>();
        organizationList.add(createOrganization());

        return organizationList;
    }

    public static Organization createOrganization(){
        Organization organization = new Organization();
        organization.setIdentifier(new Identifier());
        organization.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));
        organization.setLocation(createPlace());

        return organization;
    }

    public static Position createPosition(){
        return new Position();
    }

    public static List<Place> createPlaceList(){
        List<Place> placeList = new ArrayList<Place>();
        placeList.add(createPlace());

        return placeList;
    }

    public static Place createPlace(){
        Place place = new Place();
        place.setIdentifier(new Identifier());
        place.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(), Identifier.class));

        return place;
    }

    public static edu.pitt.isg.mdc.dats2_2.Type createType(){
        edu.pitt.isg.mdc.dats2_2.Type type = new edu.pitt.isg.mdc.dats2_2.Type();
        type.setInformation(new Annotation());
        type.setMethod(new Annotation());
        type.setPlatform(new Annotation());

        return type;
    }

    public static List<edu.pitt.isg.mdc.dats2_2.Date> createDateList(){
        List<edu.pitt.isg.mdc.dats2_2.Date> dateList = new ArrayList<edu.pitt.isg.mdc.dats2_2.Date>();
        dateList.add(createDate());

        return dateList;
    }

    public static edu.pitt.isg.mdc.dats2_2.Date createDate(){
        edu.pitt.isg.mdc.dats2_2.Date date = new edu.pitt.isg.mdc.dats2_2.Date();
        date.setType(new Annotation());

        return date;
    }

    public static List<CategoryValuePair> createCategoryValuePairList(){
        List<CategoryValuePair> categoryValuePairList = new ArrayList<CategoryValuePair>();
        categoryValuePairList.add(createCategoryValuePair());

        return categoryValuePairList;
    }

    public static CategoryValuePair createCategoryValuePair(){
        CategoryValuePair categoryValuePair = new CategoryValuePair();
        categoryValuePair.setValues(wrapListWithAutoPopulatingList(createAnnotationList(), Annotation.class));

        return categoryValuePair;
    }
}
