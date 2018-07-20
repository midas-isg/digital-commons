package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.mdc.dats2_2.*;
import org.springframework.util.AutoPopulatingList;

import java.util.ArrayList;
import java.util.List;

public class DatasetFactory {

    private static final Integer TOTAL_ITERATIONS = 1;

    public static Dataset createDatasetForWebFlow(Dataset dataset) {
        //create an instance of every member of Dataset
        //every member of every member must be instantiated
        //every list must contain at least one entry for every type the list can take (e.g. Person/Organization)
//        Dataset dataset = new Dataset();
        if(dataset == null){
            dataset = new Dataset();
        }

        if(dataset.getIdentifier() == null){
            dataset.setIdentifier(new Identifier());
        }
        if(dataset.getDates().isEmpty()){
            dataset.setDates(wrapListWithAutoPopulatingList(createDateList(null), Date.class));
        } else dataset.setDates(wrapListWithAutoPopulatingList(createDateList(dataset.getDates()), Date.class));
        if(dataset.getStoredIn() == null){
            dataset.setStoredIn(createDataRepository(null));
        } else  dataset.setStoredIn(createDataRepository(dataset.getStoredIn()));
        if(dataset.getSpatialCoverage().isEmpty()){
            dataset.setSpatialCoverage(wrapListWithAutoPopulatingList(createPlaceList(null), Place.class));
        } else dataset.setSpatialCoverage(wrapListWithAutoPopulatingList(createPlaceList(dataset.getSpatialCoverage()), Place.class));
        dataset.setTypes(wrapListWithAutoPopulatingList(createTypeList(dataset.getTypes()), Type.class));
//        if(dataset.getTypes() == null || dataset.getTypes().size() == 0){
//            dataset.setTypes(wrapListWithAutoPopulatingList(createTypeList(dataset.getTypes()), Type.class));
//        }
        if(dataset.getDistributions().isEmpty()){
            dataset.setDistributions(wrapListWithAutoPopulatingList(createDistributionList(null), Distribution.class));
        } else dataset.setDistributions(wrapListWithAutoPopulatingList(createDistributionList(dataset.getDistributions()), Distribution.class));
        if(dataset.getPrimaryPublications().isEmpty()){
            dataset.setPrimaryPublications(wrapListWithAutoPopulatingList(createPublicationList(null), Publication.class));
        } else dataset.setPrimaryPublications(wrapListWithAutoPopulatingList(createPublicationList(dataset.getPrimaryPublications()), Publication.class));
        if(dataset.getCitations().isEmpty()){
            dataset.setCitations(wrapListWithAutoPopulatingList(createPublicationList(null), Publication.class));
        } else dataset.setCitations(wrapListWithAutoPopulatingList(createPublicationList(dataset.getCitations()), Publication.class));
        if(dataset.getProducedBy() == null){
            dataset.setProducedBy(createStudy(null));
        } else dataset.setProducedBy(createStudy(dataset.getProducedBy()));
        if(dataset.getCreators().isEmpty()){
            dataset.setCreators(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(null), PersonComprisedEntity.class));
        } else dataset.setCreators(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(dataset.getCreators()), PersonComprisedEntity.class));
        if(dataset.getLicenses().isEmpty()){
            dataset.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(null), License.class));
        } else dataset.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(dataset.getLicenses()), License.class));
        if(dataset.getIsAbout().isEmpty()){
            dataset.setIsAbout(wrapListWithAutoPopulatingList(createIsAboutList(null), IsAbout.class));
        } dataset.setIsAbout(wrapListWithAutoPopulatingList(createIsAboutList(dataset.getIsAbout()), IsAbout.class));
        if(dataset.getAcknowledges().isEmpty()){
            dataset.setAcknowledges(wrapListWithAutoPopulatingList(createGrantList(null), Grant.class));
        } else dataset.setAcknowledges(wrapListWithAutoPopulatingList(createGrantList(dataset.getAcknowledges()), Grant.class));
        if(dataset.getExtraProperties().isEmpty()){
            dataset.setExtraProperties(wrapListWithAutoPopulatingList(createCategoryValuePairList(null), CategoryValuePair.class));
        } else dataset.setExtraProperties(wrapListWithAutoPopulatingList(createCategoryValuePairList(dataset.getExtraProperties()), CategoryValuePair.class));

        return dataset;
    }

    public static <T> List<T> wrapListWithAutoPopulatingList(List<T> list, Class<?> pojoClazz)  {

        List<T> apl = new AutoPopulatingList(list, pojoClazz ) ;
        return apl;
    }

    public static List<Distribution> createDistributionList(List<Distribution> distributionList){
//        List<Distribution> distributionList = new ArrayList<Distribution>();
        if(distributionList == null || distributionList.isEmpty()){
            distributionList = new ArrayList<Distribution>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (distributionList.size() - 1)){
                distributionList.add(createDistribution(null));
            } else distributionList.set(i, createDistribution(distributionList.get(i)));
        } //end for loop

        return distributionList;
    }

    public static Distribution createDistribution(Distribution distribution){
//        Distribution distribution = new Distribution();
        if(distribution == null){
            distribution = new Distribution();
        }
        if(distribution.getIdentifier() == null){
            distribution.setIdentifier(new Identifier());
        }
        if(distribution.getAlternateIdentifiers().isEmpty()){
            distribution.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else distribution.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(distribution.getAlternateIdentifiers()), Identifier.class));
        if(distribution.getStoredIn() == null){
            distribution.setStoredIn(createDataRepository(null));
        } else distribution.setStoredIn(createDataRepository(distribution.getStoredIn()));
        if(distribution.getDates().isEmpty()){
            distribution.setDates(wrapListWithAutoPopulatingList(createDateList(null), Date.class));
        } else distribution.setDates(wrapListWithAutoPopulatingList(createDateList(distribution.getDates()), Date.class));
        if(distribution.getLicenses().isEmpty()){
            distribution.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(null), License.class));
        } else distribution.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(distribution.getLicenses()), License.class));
        if(distribution.getAccess() == null){
            distribution.setAccess(createAccess(null));
        } else distribution.setAccess(createAccess(distribution.getAccess()));
        if(distribution.getConformsTo().isEmpty()){
            distribution.setConformsTo(wrapListWithAutoPopulatingList(createDataStandardList(null), DataStandard.class));
        } else distribution.setConformsTo(wrapListWithAutoPopulatingList(createDataStandardList(distribution.getConformsTo()), DataStandard.class));
        if(distribution.getQualifiers().isEmpty()){
            distribution.setQualifiers(wrapListWithAutoPopulatingList(createAnnotationList(null), Annotation.class));
        } else distribution.setQualifiers(wrapListWithAutoPopulatingList(createAnnotationList(distribution.getQualifiers()), Annotation.class));
        if(distribution.getUnit() == null){
            distribution.setUnit(new Annotation());
        }

        return distribution;
    }

    public static List<Identifier> createIdentifierList(List<Identifier> identifierList){
//        List<Identifier> identifierList = new ArrayList<Identifier>();
        if(identifierList == null || identifierList.isEmpty()){
            identifierList = new ArrayList<Identifier>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (identifierList.size() - 1)){
                identifierList.add(new Identifier());
            }
        } //end for loop

        return identifierList;
    }

    public static List<Annotation> createAnnotationList(List<Annotation> annotationList){
//        List<Annotation> annotationList = new ArrayList<Annotation>();
        if(annotationList == null || annotationList.isEmpty()){
            annotationList = new ArrayList<Annotation>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (annotationList.size() - 1)){
                annotationList.add(new Annotation());
            }
        } //end for loop

        return annotationList;
    }

    public static List<Type> createTypeList(List<Type> typeList){
        if(typeList == null || typeList.isEmpty()){
            typeList = new ArrayList<Type>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (typeList.size() - 1)){
                typeList.add(createType(null));
            } else typeList.set(i, createType(typeList.get(i)));
        } //end for loop

        return typeList;
    }

    public static edu.pitt.isg.mdc.dats2_2.Type createType(Type type){
//        edu.pitt.isg.mdc.dats2_2.Type type = new edu.pitt.isg.mdc.dats2_2.Type();
        if(type == null){
            type = new edu.pitt.isg.mdc.dats2_2.Type();
        }
        if(type.getInformation() == null){
            type.setInformation(new Annotation());
        }
        if(type.getMethod() == null){
            type.setMethod(new Annotation());
        }
        if(type.getPlatform() == null){
            type.setPlatform(new Annotation());
        }

        return type;
    }

    public static List<DataStandard> createDataStandardList(List<DataStandard> dataStandardList){
//        List<DataStandard> dataStandardList = new ArrayList<DataStandard>();
        if(dataStandardList == null || dataStandardList.isEmpty()){
            dataStandardList = new ArrayList<DataStandard>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (dataStandardList.size() - 1)){
                dataStandardList.add(createDataStandard(null));
            } else dataStandardList.set(i, createDataStandard(dataStandardList.get(i)));
        } //end for loop

        return dataStandardList;
    }

    public static DataStandard createDataStandard(DataStandard dataStandard){
//        DataStandard dataStandard = new DataStandard();
        if(dataStandard == null){
            dataStandard = new DataStandard();
        }
        if(dataStandard.getIdentifier() == null){
            dataStandard.setIdentifier(new Identifier());
        }
        if(dataStandard.getAlternateIdentifiers().isEmpty()){
            dataStandard.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else dataStandard.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(dataStandard.getAlternateIdentifiers()), Identifier.class));
        if(dataStandard.getType() == null){
            dataStandard.setType(new Annotation());
        }
        if(dataStandard.getLicenses().isEmpty()){
            dataStandard.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(null), License.class));
        } else dataStandard.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(dataStandard.getLicenses()), License.class));
        if(dataStandard.getExtraProperties().isEmpty()){
            dataStandard.setExtraProperties(wrapListWithAutoPopulatingList(createCategoryValuePairList(null), CategoryValuePair.class));
        } else dataStandard.setExtraProperties(wrapListWithAutoPopulatingList(createCategoryValuePairList(dataStandard.getExtraProperties()), CategoryValuePair.class));

        return dataStandard;
    }

    public static DataRepository createDataRepository(DataRepository dataRepository){
//        DataRepository dataRepository = new DataRepository();
        if(dataRepository == null){
            dataRepository = new DataRepository();
        }
        if(dataRepository.getIdentifier() == null){
            dataRepository.setIdentifier(new Identifier());
        }
        if(dataRepository.getAlternateIdentifiers().isEmpty()){
            dataRepository.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else dataRepository.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(dataRepository.getAlternateIdentifiers()), Identifier.class));
        if(dataRepository.getScopes().isEmpty()){
            dataRepository.setScopes(wrapListWithAutoPopulatingList(createAnnotationList(null), Annotation.class));
        } else dataRepository.setScopes(wrapListWithAutoPopulatingList(createAnnotationList(dataRepository.getScopes()), Annotation.class));
        if(dataRepository.getTypes().isEmpty()){
            dataRepository.setTypes(wrapListWithAutoPopulatingList(createAnnotationList(null), Annotation.class));
        } else dataRepository.setTypes(wrapListWithAutoPopulatingList(createAnnotationList(dataRepository.getTypes()), Annotation.class));
        if(dataRepository.getLicenses().isEmpty()){
            dataRepository.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(null), License.class));
        } else dataRepository.setLicenses(wrapListWithAutoPopulatingList(createLicenseList(dataRepository.getLicenses()), License.class));
        if(dataRepository.getPublishers().isEmpty()){
            dataRepository.setPublishers(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(null), PersonComprisedEntity.class));
        } else dataRepository.setPublishers(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(dataRepository.getPublishers()), PersonComprisedEntity.class));
        if(dataRepository.getAccess().isEmpty()){
            dataRepository.setAccess(wrapListWithAutoPopulatingList(createAccessList(null), Access.class));
        } else dataRepository.setAccess(wrapListWithAutoPopulatingList(createAccessList(dataRepository.getAccess()), Access.class));

        return dataRepository;
    }

    public static List<IsAbout> createIsAboutList(List<IsAbout> isAboutList){
//        List<IsAbout> isAboutItemsList = new ArrayList<IsAbout>();
        if(isAboutList == null || isAboutList.isEmpty()){
            isAboutList = new ArrayList<IsAbout>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (isAboutList.size() - 1)){
                isAboutList.add(createIsAbout(null));
            } else isAboutList.set(i, createIsAbout(isAboutList.get(i)));
        } //end for loop

        return isAboutList;
    }

    public static IsAboutItems createIsAboutItems(IsAboutItems isAboutItems){
//        IsAboutItems isAboutItems = new IsAboutItems();
        if(isAboutItems == null){
            isAboutItems = new IsAboutItems();
        }
        if(isAboutItems.getIdentifier() == null){
            isAboutItems.setIdentifier(new Identifier());
        }
        if(isAboutItems.getAlternateIdentifiers().isEmpty()){
            isAboutItems.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else isAboutItems.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(isAboutItems.getAlternateIdentifiers()), Identifier.class));

        return isAboutItems;
    }

    public static IsAbout createIsAbout(IsAbout isAbout){
//        IsAbout isAbout = createIsAboutItems();
        if(isAbout == null){
            isAbout = createIsAboutItems(null);
        } else {
            IsAboutItems isAboutItems = new IsAboutItems();
            if(isAbout.getClass().isAssignableFrom(Annotation.class)){
                Annotation annotation = (Annotation) isAbout;
                isAboutItems.setValue(annotation.getValue());
                isAboutItems.setValueIRI(annotation.getValueIRI());
            }
            if(isAbout.getClass().isAssignableFrom(BiologicalEntity.class)){
                BiologicalEntity biologicalEntity = (BiologicalEntity) isAbout;
                isAboutItems.setIdentifier(biologicalEntity.getIdentifier());
                isAboutItems.setAlternateIdentifiers(biologicalEntity.getAlternateIdentifiers());
                isAboutItems.setName(biologicalEntity.getName());
                isAboutItems.setDescription(biologicalEntity.getDescription());
            }
            isAbout = createIsAboutItems(isAboutItems);
        }

        return isAbout;
    }

    public static BiologicalEntity createBiologicalEntity(BiologicalEntity biologicalEntity){
//        BiologicalEntity biologicalEntity = new BiologicalEntity();
        if(biologicalEntity == null){
            biologicalEntity = new BiologicalEntity();
        }
        if(biologicalEntity.getIdentifier() == null){
            biologicalEntity.setIdentifier(new Identifier());
        }
        if(biologicalEntity.getAlternateIdentifiers().isEmpty()){
            biologicalEntity.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else biologicalEntity.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(biologicalEntity.getAlternateIdentifiers()), Identifier.class));

        return biologicalEntity;
    }

    public static Study createStudy(Study study){
//        Study study = new Study();
        if(study == null){
            study = new Study();
        }
        if(study.getStartDate() == null){
            study.setStartDate(createDate());
        }
        if(study.getEndDate() == null){
            study.setEndDate(createDate());
        }
        if(study.getLocation() == null){
            study.setLocation(createPlace(null));
        } else study.setLocation(createPlace(study.getLocation()));

        return study;
    }

    public static List<License> createLicenseList(List<License> licenseList){
//        List<License> licenseList = new ArrayList<License>();
        if(licenseList == null || licenseList.isEmpty()){
            licenseList = new ArrayList<License>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (licenseList.size() - 1)){
                licenseList.add(createLicense(null));
            } else licenseList.set(i, createLicense(licenseList.get(i)));
        } //end for loop

        return licenseList;
    }

    public static License createLicense(License license){
//        License license = new License();
        if(license == null){
            license = new License();
        }
        if(license.getIdentifier() == null){
            license.setIdentifier(new Identifier());
        }
        if(license.getCreators().isEmpty()){
            license.setCreators(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(null), PersonComprisedEntity.class));
        } else license.setCreators(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(license.getCreators()), PersonComprisedEntity.class));

        return license;
    }

    public static List<Publication> createPublicationList(List<Publication> publicationList){
//        List<Publication> publicationList = new ArrayList<Publication>();
        if(publicationList == null || publicationList.isEmpty()){
            publicationList = new ArrayList<Publication>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (publicationList.size() - 1)){
                publicationList.add(createPublication(null));
            } else publicationList.set(i, createPublication(publicationList.get(i)));
        } //end for loop

        return publicationList;
    }

    public static Publication createPublication(Publication publication){
//        Publication publication = new Publication();
        if(publication == null){
            publication = new Publication();
        }
        if(publication.getIdentifier() == null){
            publication.setIdentifier(new Identifier());
        }
        if(publication.getAlternateIdentifiers().isEmpty()){
            publication.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else publication.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(publication.getAlternateIdentifiers()), Identifier.class));
        if(publication.getType() == null){
            publication.setType(new Annotation());
        }
        if(publication.getDates().isEmpty()){
            publication.setDates(wrapListWithAutoPopulatingList(createDateList(null), Date.class));
        } else publication.setDates(wrapListWithAutoPopulatingList(createDateList(publication.getDates()), Date.class));
        if(publication.getAuthors().isEmpty()){
            publication.setAuthors(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(null), PersonComprisedEntity.class));
        } else publication.setAuthors(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(publication.getAuthors()), PersonComprisedEntity.class));
        if(publication.getAcknowledges().isEmpty()){
            publication.setAcknowledges(wrapListWithAutoPopulatingList(createGrantList(null), Grant.class));
        } else publication.setAcknowledges(wrapListWithAutoPopulatingList(createGrantList(publication.getAcknowledges()), Grant.class));

        return publication;
    }

    public static List<Grant> createGrantList(List<Grant> grantList){
//        List<Grant> grantList = new ArrayList<Grant>();
        if(grantList == null || grantList.isEmpty()){
            grantList = new ArrayList<Grant>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (grantList.size() - 1)){
                grantList.add(createGrant(null));
            } else grantList.set(i, createGrant(grantList.get(i)));
        } //end for loop

        return grantList;
    }

    public static Grant createGrant(Grant grant){
//        Grant grant = new Grant();
        if(grant == null){
            grant = new Grant();
        }
        if(grant.getIdentifier() == null){
            grant.setIdentifier(new Identifier());
        }
        if(grant.getAlternateIdentifiers().isEmpty()){
            grant.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else grant.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(grant.getAlternateIdentifiers()), Identifier.class));
        if(grant.getFunders().isEmpty()){
            grant.setFunders(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(null), PersonComprisedEntity.class));
        } else grant.setFunders(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(grant.getFunders()), PersonComprisedEntity.class));
        if(grant.getAwardees().isEmpty()){
            grant.setAwardees(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(null), PersonComprisedEntity.class));
        } else grant.setAwardees(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(grant.getAwardees()), PersonComprisedEntity.class));


        return grant;
    }

    public static List<Access> createAccessList(List<Access> accessList){
//        List<Access> accessList = new ArrayList<Access>();
        if(accessList == null || accessList.isEmpty()){
            accessList = new ArrayList<Access>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (accessList.size() - 1)){
                accessList.add(createAccess(null));
            } else accessList.set(i, createAccess(accessList.get(i)));
        } //end for loop

        return accessList;
    }

    public static Access createAccess(Access access){
//        Access access = new Access();
        if(access == null){
            access = new Access();
        }
        if(access.getIdentifier() == null){
            access.setIdentifier(new Identifier());
        }
        if(access.getAlternateIdentifiers().isEmpty()){
            access.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else access.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(access.getAlternateIdentifiers()), Identifier.class));
        if(access.getTypes().isEmpty()){
            access.setTypes(wrapListWithAutoPopulatingList(createAnnotationList(null), Annotation.class));
        } else access.setTypes(wrapListWithAutoPopulatingList(createAnnotationList(access.getTypes()), Annotation.class));
        if(access.getAuthorizations().isEmpty()){
            access.setAuthorizations(wrapListWithAutoPopulatingList(createAnnotationList(null), Annotation.class));
        } else access.setAuthorizations(wrapListWithAutoPopulatingList(createAnnotationList(access.getAuthorizations()), Annotation.class));
        if(access.getAuthentications().isEmpty()){
            access.setAuthentications(wrapListWithAutoPopulatingList(createAnnotationList(null), Annotation.class));
        } else access.setAuthentications(wrapListWithAutoPopulatingList(createAnnotationList(access.getAuthentications()), Annotation.class));

        return access;
    }

    public static PersonOrganization createPersonOrganization(PersonOrganization personOrganization){
//        PersonOrganization personOrganization = new PersonOrganization();
        if(personOrganization == null){
            personOrganization = new PersonOrganization();
        }
        if(personOrganization.getIdentifier() == null){
            personOrganization.setIdentifier(new Identifier());
        }
        if(personOrganization.getAlternateIdentifiers() == null || personOrganization.getAlternateIdentifiers().isEmpty()){
            personOrganization.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else personOrganization.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(personOrganization.getAlternateIdentifiers()), Identifier.class));
        personOrganization.setAffiliations(wrapListWithAutoPopulatingList(createOrganizationList(personOrganization.getAffiliations()), Organization.class));
//        personOrganization.setAffiliations(wrapListWithAutoPopulatingList(createPersonComprisedEntityList(personOrganization.getAffiliations()), PersonComprisedEntity.class));
        if(personOrganization.getRoles().isEmpty()){
            personOrganization.setRoles(wrapListWithAutoPopulatingList(createAnnotationList(null), Annotation.class));
        } else personOrganization.setRoles(wrapListWithAutoPopulatingList(createAnnotationList(personOrganization.getRoles()), Annotation.class));
        if(personOrganization.getLocation() == null){
            personOrganization.setLocation(createPlace(null));
        } else personOrganization.setLocation(createPlace(personOrganization.getLocation()));


        return personOrganization;
    }

    public static List<PersonComprisedEntity> createPersonComprisedEntityList(List<PersonComprisedEntity> personComprisedEntityList){
//        List<PersonComprisedEntity> personComprisedEntityList = wrapListWithAutoPopulatingList(new ArrayList<PersonComprisedEntity>(),PersonComprisedEntity.class);
        if(personComprisedEntityList == null || personComprisedEntityList.isEmpty()){
            personComprisedEntityList = wrapListWithAutoPopulatingList(new ArrayList<PersonComprisedEntity>(),PersonComprisedEntity.class);
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (personComprisedEntityList.size() - 1)){
                personComprisedEntityList.add(createPersonComprisedEntity(null));
            } else {
                personComprisedEntityList.set(i,createPersonComprisedEntity(personComprisedEntityList.get(i)));
            }
        } //end for loop

        return personComprisedEntityList;
    }


    public static PersonComprisedEntity createPersonComprisedEntity(PersonComprisedEntity personComprisedEntity){
//        PersonComprisedEntity personComprisedEntity = createPersonOrganization(null);
        if(personComprisedEntity == null){
            personComprisedEntity = createPersonOrganization(null);
        } else {
            PersonOrganization personOrganization = new PersonOrganization();
            if(personComprisedEntity.getClass().isAssignableFrom(Organization.class)){
//                personComprisedEntity = createPersonOrganization((PersonOrganization) personComprisedEntity);
                Organization organization = (Organization) personComprisedEntity;
                personOrganization.setIdentifier(organization.getIdentifier());
                personOrganization.setAlternateIdentifiers(organization.getAlternateIdentifiers());
                personOrganization.setLocation(organization.getLocation());
                personOrganization.setName(organization.getName());
                personOrganization.setAbbreviation(organization.getAbbreviation());
            }
            if(personComprisedEntity.getClass().isAssignableFrom(Person.class)){
                Person person = (Person) personComprisedEntity;
                personOrganization.setIdentifier(person.getIdentifier());
                personOrganization.setAlternateIdentifiers(person.getAlternateIdentifiers());
                personOrganization.setRoles(person.getRoles());
                personOrganization.setAffiliations(person.getAffiliations());
                personOrganization.setFullName(person.getFullName());
                personOrganization.setFirstName(person.getFirstName());
                personOrganization.setMiddleInitial(person.getMiddleInitial());
                personOrganization.setLastName(person.getLastName());
                personOrganization.setEmail(person.getEmail());
            }
            personComprisedEntity = createPersonOrganization(personOrganization);
        }

            personComprisedEntity = createPersonOrganization((PersonOrganization) personComprisedEntity);

        return personComprisedEntity;
    }

    public static Person createPerson(Person person){
//        Person person = new Person();
        if(person == null){
            person = new Person();
        }
        if(person.getIdentifier() == null){
            person.setIdentifier(new Identifier());
        }
        if(person.getAlternateIdentifiers().isEmpty()){
            person.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else person.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(person.getAlternateIdentifiers()), Identifier.class));
        if(person.getAffiliations().isEmpty()){
            person.setAffiliations(wrapListWithAutoPopulatingList(createOrganizationList(null), PersonComprisedEntity.class));
        } else person.setAffiliations(wrapListWithAutoPopulatingList(createOrganizationList(person.getAffiliations()), Organization.class));
        if(person.getRoles().isEmpty()){
            person.setRoles(wrapListWithAutoPopulatingList(createAnnotationList(null), Annotation.class));
        } else person.setRoles(wrapListWithAutoPopulatingList(createAnnotationList(person.getRoles()), Annotation.class));

        return person;
    }
/*

    public static List<PersonComprisedEntity> createOrganizationList(List<Organization> organizationList){
//        List<Organization> organizationList = new ArrayList<Organization>();
        List<PersonComprisedEntity> personComprisedEntityList = new ArrayList<PersonComprisedEntity>();
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            personComprisedEntityList.set(i, organizationList.get(i));
            if(i > (organizationList.size() - 1)){
                personComprisedEntityList.add(createPersonComprisedEntity(null));
            } else {
                if(organizationList.get(i).getIdentifier() == null){
                    organizationList.get(i).setIdentifier(new Identifier());
                }
                if(organizationList.get(i).getAlternateIdentifiers().isEmpty()){
                    organizationList.get(i).setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
                } else organizationList.get(i).setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(organizationList.get(i).getAlternateIdentifiers()), Identifier.class));
                if(organizationList.get(i).getLocation() == null){
                    organizationList.get(i).setLocation(createPlace(null));
                } else organizationList.get(i).setLocation(organizationList.get(i).getLocation());
            }
        } //end for loop

        return personComprisedEntityList;
    }
*/

    public static List<Organization> createOrganizationList(List<Organization> organizationList){
//        List<Organization> organizationList = new ArrayList<Organization>();
        if(organizationList == null || organizationList.isEmpty()){
            organizationList = new ArrayList<Organization>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (organizationList.size() - 1)){
                organizationList.add(createOrganization(null));
            } else {
                if(organizationList.get(i).getIdentifier() == null){
                    organizationList.get(i).setIdentifier(new Identifier());
                }
                if(organizationList.get(i).getAlternateIdentifiers().isEmpty()){
                    organizationList.get(i).setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
                } else organizationList.get(i).setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(organizationList.get(i).getAlternateIdentifiers()), Identifier.class));
                if(organizationList.get(i).getLocation() == null){
                    organizationList.get(i).setLocation(createPlace(null));
                } else organizationList.get(i).setLocation(organizationList.get(i).getLocation());
            }
        } //end for loop

        return organizationList;
    }

    public static Organization createOrganization(Organization organization){
//        Organization organization = new Organization();
        if(organization == null){
            organization = new Organization();
        }
        if(organization.getIdentifier() == null){
            organization.setIdentifier(new Identifier());
        }
        if(organization.getAlternateIdentifiers().isEmpty()){
            organization.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else organization.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(organization.getAlternateIdentifiers()), Identifier.class));
        if(organization.getLocation() == null){
            organization.setLocation(createPlace(null));
        } else organization.setLocation(createPlace(organization.getLocation()));

        return organization;
    }

    public static Position createPosition(){
        return new Position();
    }

    public static List<Place> createPlaceList(List<Place> placeList){
//        List<Place> placeList = new ArrayList<Place>();
        if(placeList == null || placeList.isEmpty()){
            placeList = new ArrayList<Place>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (placeList.size() - 1)){
                placeList.add(createPlace(null));
            } else placeList.set(i, createPlace(placeList.get(i)));
        } //end for loop

        return placeList;
    }

    public static Place createPlace(Place place){
//        Place place = new Place();
        if(place == null){
            place = new Place();
        }
        if(place.getIdentifier() == null){
            place.setIdentifier(new Identifier());
        }
        if(place.getAlternateIdentifiers().isEmpty()){
            place.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(null), Identifier.class));
        } else place.setAlternateIdentifiers(wrapListWithAutoPopulatingList(createIdentifierList(place.getAlternateIdentifiers()), Identifier.class));

        return place;
    }

    public static List<edu.pitt.isg.mdc.dats2_2.Date> createDateList(List<edu.pitt.isg.mdc.dats2_2.Date> dateList){
//        List<edu.pitt.isg.mdc.dats2_2.Date> dateList = new ArrayList<edu.pitt.isg.mdc.dats2_2.Date>();
        if(dateList == null || dateList.isEmpty()){
            dateList = new ArrayList<edu.pitt.isg.mdc.dats2_2.Date>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (dateList.size() - 1)){
                dateList.add(createDate());
            } else {
                if(dateList.get(i).getType() == null){
                    dateList.get(i).setType(new Annotation());
                }
            }
        } //end for loop

        return dateList;
    }

    public static edu.pitt.isg.mdc.dats2_2.Date createDate(){
        edu.pitt.isg.mdc.dats2_2.Date date = new edu.pitt.isg.mdc.dats2_2.Date();
        date.setType(new Annotation());

        return date;
    }

    public static List<CategoryValuePair> createCategoryValuePairList(List<CategoryValuePair> categoryValuePairList){
//        List<CategoryValuePair> categoryValuePairList = new ArrayList<CategoryValuePair>();
        if(categoryValuePairList == null || categoryValuePairList.isEmpty()){
            categoryValuePairList = new ArrayList<CategoryValuePair>();
        }
        for(int i = 0; i < TOTAL_ITERATIONS; i++){
            if(i > (categoryValuePairList.size() - 1)){
                categoryValuePairList.add(createCategoryValuePair());
            } else {
                if(categoryValuePairList.get(i).getValues() == null){
                    categoryValuePairList.get(i).setValues(wrapListWithAutoPopulatingList(createAnnotationList(null), Annotation.class));
                } else categoryValuePairList.get(i).setValues(wrapListWithAutoPopulatingList(createAnnotationList(categoryValuePairList.get(i).getValues()), Annotation.class));
            }
        } //end for loop

        return categoryValuePairList;
    }

    public static CategoryValuePair createCategoryValuePair(){
        CategoryValuePair categoryValuePair = new CategoryValuePair();
        categoryValuePair.setValues(wrapListWithAutoPopulatingList(createAnnotationList(null), Annotation.class));

        return categoryValuePair;
    }
}
