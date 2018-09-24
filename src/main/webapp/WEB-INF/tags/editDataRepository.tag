<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@attribute name="dataRepository" required="false"
             type="edu.pitt.isg.mdc.dats2_2.DataRepository" %>

<fmt:message key="dataset.dataRepository" var="dataRepositoryPlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataRepository}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${false}"
                                 cardText="${dataRepositoryPlaceHolder}"
                                 cardIcon="fas fa-database"
                                 tagName="dataRepository"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.dataRepository.name" var="namePlaceHolder" />
<myTags:editNonZeroLengthString placeholder="${namePlaceHolder}"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                label="Name"
                                string="${dataRepository.name}"
                                path="${path}.name"
                                isInputGroup="${true}"
                                isRequired="${true}">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.dataRepository.description" var="descriptionPlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.description"
                                string="${dataRepository.description}"
                                specifier="${specifier}-description"
                                id="${specifier}-description"
                                isTextArea="${true}"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                placeholder="${descriptionPlaceHolder}"
                                label="Description">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.dataRepository.version" var="versionPlaceHolder" />
<myTags:editNonZeroLengthString label="Version"
                                placeholder="${versionPlaceHolder}"
                                specifier="${specifier}-version"
                                id="${specifier}-version"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                string="${dataRepository.version}"
                                path="${path}.version">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier path="${path}.identifier"
                       singleIdentifier="${dataRepository.identifier}"
                       id="${specifier}-identifier"
                       specifier="${specifier}-identifier"
                       isUnboundedList="${false}"
                       label="Identifier">
</myTags:editIdentifier>

<fmt:message key="dataset.alternateIdentifier" var="alternateIdentifierCardText" />
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            addButtonLabel="Alternate Identifier"
                            path="${path}.alternateIdentifiers"
                            cardText="${alternateIdentifierCardText}"
                            cardIcon="fa fa-id-card"
                            tagName="identifier"
                            listItems="${dataRepository.alternateIdentifiers}">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.dataRepository.scopes" var="scopesPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.scopes"
                            specifier="${specifier}-scopes"
                            listItems="${dataRepository.scopes}"
                            cardText="${scopesPlaceHolder}"
                            cardIcon="far fa-eye"
                            tagName="annotation"
                            addButtonLabel="Scope"
                            label="Scopes">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.dataRepository.types" var="typesPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.types"
                            specifier="${specifier}-types"
                            listItems="${dataRepository.types}"
                            cardText="${typesPlaceHolder}"
                            cardIcon="fas fa-shapes"
                            tagName="annotation"
                            addButtonLabel="Type"
                            label="Types">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.dataRepository.licenses" var="licensesPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.licenses"
                            listItems="${dataRepository.licenses}"
                            label="Licenses"
                            addButtonLabel="License"
                            cardText="${licensesPlaceHolder}"
                            cardIcon="fab fa-creative-commons"
                            tagName="license"
                            specifier="${specifier}-licenses">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.publishers" var="publishersPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.publishers"
                            specifier="${specifier}-publishers"
                            label="Publishers"
                            addButtonLabel="Publisher"
                            listItems="${dataRepository.publishers}"
                            isFirstRequired="false"
                            createPersonOrganizationTags="true"
                            cardText="${publishersPlaceHolder}"
                            cardIcon="fas fa-book-open"
                            tagName="personComprisedEntity"
                            showAddPersonButton="true"
                            showAddOrganizationButton="true">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.dataRepository.access" var="accessPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.access"
                            specifier="${specifier}-access"
                            listItems="${dataRepository.access}"
                            cardText="${accessPlaceHolder}"
                            cardIcon="fa fa-unlock"
                            tagName="access"
                            isRequired="${false}"
                            addButtonLabel="Access"
                            label="Access">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataRepository}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${false}"
                                 cardText="${dataRepositoryPlaceHolder}"
                                 showCardFooter="${true}"
                                 tagName="dataRepository"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
