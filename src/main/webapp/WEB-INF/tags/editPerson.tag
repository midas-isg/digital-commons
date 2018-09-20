<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

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

<fmt:message key="dataset.person.fullName" var="fullNamePlaceHolder" />
<myTags:editNonZeroLengthString label="Full Name"
                                placeholder="${fullNamePlaceHolder}"
                                string="${person.fullName}"
                                isRequired="true"
                                specifier="${specifier}-fullname"
                                id="${specifier}-fullname"
                                isInputGroup="${true}"
                                path="${path}.fullName">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.person.firstName" var="firstNamePlaceHolder" />
<myTags:editNonZeroLengthString label="First Name"
                                placeholder="${firstNamePlaceHolder}"
                                string="${person.firstName}"
                                specifier="${specifier}-firstName"
                                id="${specifier}-firstName"
                                isRequired="true"
                                isInputGroup="${true}"
                                path="${path}.firstName">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.person.middleInitial" var="middleInitialPlaceHolder" />
<myTags:editNonZeroLengthString label="Middle Initial"
                                placeholder="${middleInitialPlaceHolder}"
                                string="${person.middleInitial}"
                                specifier="${specifier}-middleInitial"
                                id="${specifier}-middleInitial"
                                isRequired="true"
                                isInputGroup="${true}"
                                path="${path}.middleInitial">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.person.lastName" var="lastNamePlaceHolder" />
<myTags:editNonZeroLengthString label="Last Name"
                                placeholder="${lastNamePlaceHolder}"
                                string="${person.lastName}"
                                specifier="${specifier}-lastName"
                                id="${specifier}-lastName"
                                isRequired="true"
                                isInputGroup="${true}"
                                path="${path}.lastName">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.person.email" var="emailPlaceHolder" />
<myTags:editNonZeroLengthString label="Email"
                                placeholder="${emailPlaceHolder}"
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

<fmt:message key="dataset.alternateIdentifier" var="alternateIdentifierPlaceHolder" />
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            addButtonLabel="Alternate Identifier"
                            path="${path}.alternateIdentifiers"
                            cardText="${alternateIdentifierPlaceHolder}"
                            cardIcon="fa fa-id-card"
                            tagName="identifier"
                            listItems="${person.alternateIdentifiers}">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.person.affiliations" var="affiliationsPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.affiliations"
                            specifier="${specifier}-affiliations"
                            label="Affiliations"
                            addButtonLabel="Affiliation"
                            listItems="${person.affiliations}"
                            isFirstRequired="false"
                            createPersonOrganizationTags="false"
                            tagName="personComprisedEntity"
                            cardText="${affiliationsPlaceHolder}"
                            cardIcon="fas fa-users"
                            showAddPersonButton="false"
                            showAddOrganizationButton="true">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.person.roles" var="rolesPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.roles"
                            specifier="${specifier}-roles"
                            listItems="${person.roles}"
                            cardText="${rolesPlaceHolder}"
                            cardIcon="fas fa-user-tie"
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



