package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.mdc.dats2_2.*;

import java.util.ArrayList;
import java.util.List;

public class DatasetFactory {
    public static Dataset createDatasetForWebFlow() {
        //create an instance of every member of Dataset
        //every member of every member must be instantiated
        //every list must contain at least one entry for every type the list can take (e.g. Person/Organization)
        Dataset dataset = new Dataset();
        dataset.setIdentifier(new Identifier());
        dataset.getDates().add(createDate());
        dataset.setStoredIn(createDataRepository());
        dataset.getSpatialCoverage().add(createPlace());
        dataset.getTypes().add(createType());
        dataset.getDistributions().add(createDistribution());
        dataset.getPrimaryPublications().add(createPublication());
        dataset.getCitations().add(createPublication());
        dataset.setProducedBy(createStudy());
        dataset.getCreators().add(createPersonComprisedEntity());
        dataset.getLicenses().add(createLicense());
        dataset.getIsAbout().add(createIsAbout());
        dataset.getAcknowledges().add(createGrant());
        dataset.getExtraProperties().add(createCategoryValuePair());

        return dataset;
    }


    public static Distribution createDistribution(){
        Distribution distribution = new Distribution();
        distribution.setIdentifier(new Identifier());
        distribution.getAlternateIdentifiers().add(new Identifier());
        distribution.setStoredIn(createDataRepository());
        distribution.getDates().add(createDate());
        distribution.getLicenses().add(createLicense());
        distribution.setAccess(createAccess());
        distribution.getConformsTo().add(createDataStandard());
        distribution.getQualifiers().add(new Annotation());
        distribution.setUnit(new Annotation());

        return distribution;
    }

    public static DataStandard createDataStandard(){
        DataStandard dataStandard = new DataStandard();
        dataStandard.setIdentifier(new Identifier());
        dataStandard.getAlternateIdentifiers().add(new Identifier());
        dataStandard.setType(new Annotation());
        dataStandard.getLicenses().add(createLicense());
        dataStandard.getExtraProperties().add(createCategoryValuePair());

        return dataStandard;
    }

    public static DataRepository createDataRepository(){
        DataRepository dataRepository = new DataRepository();
        dataRepository.setIdentifier(new Identifier());
        dataRepository.getAlternateIdentifiers().add(new Identifier());
        dataRepository.getScopes().add(new Annotation());
        dataRepository.getTypes().add(new Annotation());
        dataRepository.getLicenses().add(createLicense());
        dataRepository.getPublishers().add(createPersonComprisedEntity());
        dataRepository.getAccess().add(createAccess());

        return dataRepository;
    }

    public static IsAboutItems createIsAboutItems(){
        IsAboutItems isAboutItems = new IsAboutItems();
        isAboutItems.setIdentifier(new Identifier());
        isAboutItems.getAlternateIdentifiers().add(new Identifier());

        return isAboutItems;
    }

    public static IsAbout createIsAbout(){
        IsAbout isAbout = createIsAboutItems();

        return isAbout;
    }

    public static BiologicalEntity createBiologicalEntity(){
        BiologicalEntity biologicalEntity = new BiologicalEntity();
        biologicalEntity.setIdentifier(new Identifier());
        biologicalEntity.getAlternateIdentifiers().add(new Identifier());

        return biologicalEntity;
    }

    public static Study createStudy(){
        Study study = new Study();
        study.setStartDate(createDate());
        study.setEndDate(createDate());
        study.setLocation(createPlace());

        return study;
    }

    public static License createLicense(){
        License license = new License();
        license.setIdentifier(new Identifier());
        license.getCreators().add(createPersonComprisedEntity());

        return license;
    }

    public static Publication createPublication(){
        Publication publication = new Publication();
        publication.setIdentifier(new Identifier());
        publication.getAlternateIdentifiers().add(new Identifier());
        publication.setType(new Annotation());
        publication.getDates().add(createDate());
        publication.getAuthors().add(createPersonComprisedEntity());
        publication.getAcknowledges().add(createGrant());

        return publication;
    }

    public static Grant createGrant(){
        Grant grant = new Grant();
        grant.setIdentifier(new Identifier());
        grant.getAlternateIdentifiers().add(new Identifier());
        grant.getFunders().add(createPersonComprisedEntity());
        grant.getAwardees().add(createPersonComprisedEntity());

        return grant;
    }

    public static Access createAccess(){
        Access access = new Access();
        access.setIdentifier(new Identifier());
        access.getAlternateIdentifiers().add(new Identifier());
        access.getTypes().add(new Annotation());
        access.getAuthorizations().add(new Annotation());
        access.getAuthentications().add(new Annotation());

        return access;
    }

    public static PersonOrganization createPersonOrganization(){
        PersonOrganization personOrganization = new PersonOrganization();
        List<Identifier> alternateIdentifiers = new ArrayList<>();
        for(int j=1; j>0; j--) {
            alternateIdentifiers.add(new Identifier());
        }
//        personOrganization.getAlternateIdentifiers().add(new Identifier());
        personOrganization.setAlternateIdentifiers(alternateIdentifiers);
        personOrganization.getAffiliations().add(createOrganization());
        personOrganization.getRoles().add(new Annotation());
        personOrganization.setIdentifier(new Identifier());
        personOrganization.setLocation(createPlace());

        return personOrganization;
    }

    public static PersonComprisedEntity createPersonComprisedEntity(){
        PersonComprisedEntity personComprisedEntity = createPersonOrganization();

        return personComprisedEntity;
    }

    public static Person createPerson(){
        Person person = new Person();
        person.setIdentifier(new Identifier());
        person.getAlternateIdentifiers().add(new Identifier());
        person.getAffiliations().add(createOrganization());
        person.getRoles().add(new Annotation());

        return person;
    }

    public static Organization createOrganization(){
        Organization organization = new Organization();
        organization.setIdentifier(new Identifier());
        organization.getAlternateIdentifiers().add(new Identifier());
        organization.setLocation(createPlace());

        return organization;
    }

    public static Position createPosition(){
        return new Position();
    }

    public static Place createPlace(){
        Place place = new Place();
        place.setIdentifier(new Identifier());
        place.getAlternateIdentifiers().add(new Identifier());

        return place;
    }

    public static edu.pitt.isg.mdc.dats2_2.Type createType(){
        edu.pitt.isg.mdc.dats2_2.Type type = new edu.pitt.isg.mdc.dats2_2.Type();
        type.setInformation(new Annotation());
        type.setMethod(new Annotation());
        type.setPlatform(new Annotation());

        return type;
    }

    public static edu.pitt.isg.mdc.dats2_2.Date createDate(){
        edu.pitt.isg.mdc.dats2_2.Date date = new edu.pitt.isg.mdc.dats2_2.Date();
        date.setType(new Annotation());

        return date;
    }

    public static CategoryValuePair createCategoryValuePair(){
        CategoryValuePair categoryValuePair = new CategoryValuePair();
        categoryValuePair.getValues().add(new Annotation());

        return categoryValuePair;
    }
}
