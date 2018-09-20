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
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="dataStandard" required="false"
              type="edu.pitt.isg.mdc.dats2_2.DataStandard" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>

<fmt:message key="dataset.dataStandard" var="dataStandardPlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataStandard}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${dataStandardPlaceHolder}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.dataStandard.name" var="namePlaceHolder" />
<myTags:editNonZeroLengthString placeholder="${namePlaceHolder}"
                                label="Name"
                                string="${dataStandard.name}"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                isUnboundedList="${false}"
                                updateCardTabTitleText="${true}"
                                path="${path}.name">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.dataStandard.description" var="descriptionPlaceHolder" />
<myTags:editNonZeroLengthString specifier="${specifier}-description"
                                id="${specifier}-description"
                                string="${dataStandard.description}"
                                path="${path}.description"
                                label="Description"
                                isTextArea="${true}"
                                isInputGroup="${true}"
                                isRequired="${true}"
                                placeholder="${descriptionPlaceHolder}">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.dataStandard.version" var="versionPlaceHolder" />
<myTags:editNonZeroLengthString label="Version"
                                placeholder="${versionPlaceHolder}"
                                specifier="${specifier}-version"
                                id="${specifier}-version"
                                string="${dataStandard.version}"
                                isUnboundedList="${false}"
                                isInputGroup="${true}"
                                isRequired="${true}"
                                path="${path}.version">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.dataStandard.type" var="typePlaceHolder" />
<myTags:editAnnotation annotation="${dataStandard.type}"
                       isRequired="${true}"
                       path="${path}.type"
                       specifier="${specifier}-type"
                       id="${specifier}-type"
                       cardText="${typePlaceHolder}"
                       isUnboundedList="${false}"
                       label="Type">
</myTags:editAnnotation>
<myTags:editIdentifier singleIdentifier="${dataStandard.identifier}"
                       label="Identifier"
                       specifier="${specifier}-identifier"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       path="${path}.identifier">
</myTags:editIdentifier>

<fmt:message key="dataset.dataStandard.alternateIdentifier" var="alternateIdentifierPlaceHolder" />
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            addButtonLabel="Alternate Identifier"
                            path="${path}.alternateIdentifiers"
                            listItems="${dataStandard.alternateIdentifiers}"
                            isRequired="${false}"
                            cardText="${alternateIdentifierPlaceHolder}"
                            cardIcon="fa fa-id-card"
                            tagName="identifier">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.dataStandard.licenses" var="licensesPlaceHolder" />
<myTags:editMasterUnbounded listItems="${dataStandard.licenses}"
                            tagName="license"
                            specifier="${specifier}-licenses"
                            isRequired="${false}"
                            label="Licenses"
                            addButtonLabel="License"
                            cardText="${licensesPlaceHolder}"
                            cardIcon="fab fa-creative-commons"
                            path="${path}.licenses">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.dataStandard.extraProperties" var="extraPropertiesPlaceHolder" />
<myTags:editMasterUnbounded listItems="${dataStandard.extraProperties}"
                            tagName="categoryValuePair"
                            isRequired="${false}"
                            specifier="${specifier}-extraProperties"
                            cardText="${extraPropertiesPlaceHolder}"
                            path="${path}.extraProperties"
                            addButtonLabel="Extra Property"
                            cardIcon="fas fa-plus"
                            label="Extra Properties">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataStandard}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${dataStandardPlaceHolder}"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

