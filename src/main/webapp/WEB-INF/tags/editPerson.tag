<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="person" required="false"
              type="edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isFirstRequired" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="cardText" required="true"
              type="java.lang.String" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${person}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isFirstRequired="${isFirstRequired}"
                                 cardText="${cardText}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString label="Full Name"
                                placeholder=" The first name, any middle names, and surname of a person."
                                string="${person.fullName}"
                                isRequired="true"
                                specifier="${specifier}-fullname"
                                id="${specifier}-fullname"
                                isInputGroup="${true}"
                                path="${path}.fullName">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString label="First Name"
                                placeholder=" The given name of the person."
                                string="${person.firstName}"
                                specifier="${specifier}-firstName"
                                id="${specifier}-firstName"
                                isRequired="true"
                                isInputGroup="${true}"
                                path="${path}.firstName">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString label="Middle Initial"
                                placeholder=" The first letter of the person's middle name."
                                string="${person.middleInitial}"
                                specifier="${specifier}-middleInitial"
                                id="${specifier}-middleInitial"
                                isRequired="true"
                                isInputGroup="${true}"
                                path="${path}.middleInitial">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString label="Last Name"
                                placeholder=" The person's family name."
                                string="${person.lastName}"
                                specifier="${specifier}-lastName"
                                id="${specifier}-lastName"
                                isRequired="true"
                                isInputGroup="${true}"
                                path="${path}.lastName">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString label="Email"
                                placeholder=" An electronic mail address for the person."
                                string="${person.email}"
                                specifier="${specifier}-email"
                                id="${specifier}-email"
                                isRequired="true"
                                isInputGroup="${true}"
                                path="${path}.email">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier specifier="${specifier}-identifier"
                       label="Identifier"
                       path="${path}.identifier"
                       id="${specifier}-identifier"
                       singleIdentifier="${person.identifier}"
                       isUnboundedList="${false}">
</myTags:editIdentifier>
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            addButtonLabel="Alternate Identifier"
                            path="${path}.alternateIdentifiers"
                            cardText="Information about an alternate identifier (other than the primary)."
                            tagName="identifier"
                            listItems="${person.alternateIdentifiers}">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.affiliations"
                                  specifier="${specifier}-affiliations"
                                  label="Affiliations"
                            addButtonLabel="Affiliation"
                                  listItems="${person.affiliations}"
                                  isFirstRequired="false"
                                  createPersonOrganizationTags="false"
                            tagName="personComprisedEntity"
                            cardText="The organizations to which the person is associated with."
                                  showAddPersonButton="false"
                                  showAddOrganizationButton="true">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.roles"
                            specifier="${specifier}-roles"
                            listItems="${person.roles}"
                            cardText="The roles assumed by a person, ideally from a controlled vocabulary/ontology."
                            tagName="annotation"
                            addButtonLabel="Role"
                            label="Roles">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${person}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isFirstRequired="${isFirstRequired}"
                                 cardText="${cardText}"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>



