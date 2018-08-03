package edu.pitt.isg.dc.utils;

import edu.pitt.isg.dc.entry.classes.IsAboutItems;
import edu.pitt.isg.dc.entry.classes.PersonOrganization;
import edu.pitt.isg.dc.utils.AutoPopulatedWrapper.AutoPopulatedOrganizationWrapper;
import edu.pitt.isg.mdc.dats2_2.*;

import java.util.ArrayList;
import java.util.List;

public class ReflectionFactoryHelper {

   public IsAbout mapIsAboutToIsAboutItems(IsAbout isAbout) {
        if (isAbout == null) {
            isAbout = new IsAboutItems();
        } else {
            IsAboutItems isAboutItems = new IsAboutItems();
            if (isAbout.getClass().isAssignableFrom(Annotation.class)) {
                Annotation annotation = (Annotation) isAbout;
                isAboutItems.setValue(annotation.getValue());
                isAboutItems.setValueIRI(annotation.getValueIRI());
            }
            if (isAbout.getClass().isAssignableFrom(BiologicalEntity.class)) {
                BiologicalEntity biologicalEntity = (BiologicalEntity) isAbout;
                isAboutItems.setIdentifier(biologicalEntity.getIdentifier());
                isAboutItems.setAlternateIdentifiers(biologicalEntity.getAlternateIdentifiers());
                isAboutItems.setName(biologicalEntity.getName());
                isAboutItems.setDescription(biologicalEntity.getDescription());
            }
            return isAboutItems;
            //isAbout = createIsAboutItems(isAboutItems);
        }

        return isAbout;
    }

    public PersonComprisedEntity mapPersonComprisedEntityToPersonOrganization(PersonComprisedEntity personComprisedEntity) {
        if (personComprisedEntity == null) {
            personComprisedEntity = new PersonOrganization();
        } else {
            PersonOrganization personOrganization = new PersonOrganization();
            if (personComprisedEntity.getClass().isAssignableFrom(Organization.class)) {
                Organization organization = (Organization) personComprisedEntity;
                personOrganization.setIdentifier(organization.getIdentifier());
                personOrganization.setAlternateIdentifiers(organization.getAlternateIdentifiers());
                personOrganization.setLocation(organization.getLocation());
                personOrganization.setName(organization.getName());
                personOrganization.setAbbreviation(organization.getAbbreviation());
            }
            if (personComprisedEntity.getClass().isAssignableFrom(Person.class)) {
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
            personComprisedEntity = personOrganization;
        }
        return personComprisedEntity;
    }


}
