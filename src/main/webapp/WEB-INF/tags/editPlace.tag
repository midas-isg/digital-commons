<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="place" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Place" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>

<fmt:message key="dataset.place" var="placePlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${place}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${placePlaceHolder}"
                                 cardIcon="fas fa-map-marker-alt"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.place.name" var="namePlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.name"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                placeholder="${namePlaceHolder}"
                                string="${place.name}"
                                isRequired="true"
                                isInputGroup="${true}"
                                updateCardTabTitleText="${true}"
                                label=" Name">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.place.description" var="descriptionPlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.description"
                                specifier="${specifier}-description"
                                id="${specifier}-description"
                                string="${place.description}"
                                isTextArea="true"
                                isRequired="true"
                                isInputGroup="${true}"
                                placeholder="${descriptionPlaceHolder}"
                                label="Description">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.place.postalAddress" var="postalAddressPlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.postalAddress"
                                specifier="${specifier}-postalAddress"
                                id="${specifier}-postalAddress"
                                string="${place.postalAddress}"
                                isRequired="true"
                                isInputGroup="${true}"
                                placeholder="${postalAddressPlaceHolder}"
                                label="Postal Address">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.place.geometry" var="geometryPlaceHolder" />
<myTags:editSelect path="${path}.geometry"
                   specifier="${specifier}-geometry"
                   label="Geometry"
                   enumData="${place.geometry}"
                   enumList="${geometryEnums}"
                   cardText="${geometryPlaceHolder}"
                   isRequired="true"
                   tagName="geometry"
                   id="${specifier}-geometry">
</myTags:editSelect>
<myTags:editIdentifier specifier="${specifier}-identifier"
                       label="Identifier"
                       path="${path}.identifier"
                       id="${specifier}-identifier"
                       singleIdentifier="${place.identifier}"
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
                            listItems="${place.alternateIdentifiers}">
</myTags:editMasterUnbounded>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${place}"
                                 label="${label}"
                                 id="${id}"
                                 cardText="${placePlaceHolder}"
                                 cardIcon="fas fa-map-marker-alt"
                                 showCardFooter="${true}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
