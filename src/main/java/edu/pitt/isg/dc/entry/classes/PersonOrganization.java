package edu.pitt.isg.dc.entry.classes;

import edu.pitt.isg.mdc.dats2_2.*;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class PersonOrganization extends PersonComprisedEntity implements Serializable {
    protected String firstName;
    protected String lastName;
    protected String email;
    protected String fullName;
    protected String middleInitial;
    protected List<Organization> affiliations;
    protected List<Annotation> roles;
    protected String name;
    protected String abbreviation;
    protected Place location;

    public Identifier getIdentifier() {
        return identifier;
    }

    public void setIdentifier(Identifier identifier) {
        this.identifier = identifier;
    }

    public List<Identifier> getAlternateIdentifiers() {
        return alternateIdentifiers;
    }

    public void setAlternateIdentifiers(List<Identifier> alternateIdentifiers) {
        this.alternateIdentifiers = alternateIdentifiers;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getMiddleInitial() {
        return middleInitial;
    }

    public void setMiddleInitial(String middleInitial) {
        this.middleInitial = middleInitial;
    }

    public List<Organization> getAffiliations() {
        if (affiliations == null) {
            affiliations = new ArrayList<Organization>();
        }
        return this.affiliations;
    }

    public List<Annotation> getRoles() {
        if (roles == null) {
            roles = new ArrayList<Annotation>();
        }
        return this.roles;
    }

    public void setRoles(List<Annotation> roles) {
        this.roles = roles;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAbbreviation() {
        return abbreviation;
    }

    public void setAbbreviation(String abbreviation) {
        this.abbreviation = abbreviation;
    }

    public Place getLocation() {
        return location;
    }

    public void setLocation(Place location) {
        this.location = location;
    }
}
