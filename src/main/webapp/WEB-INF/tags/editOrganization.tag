<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="organization" required="false"
              type="edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isFirstRequired" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="cardText" required="true"
              type="java.lang.String" %>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${organization}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isFirstRequired="${isFirstRequired}"
                                 cardText="${cardText}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.organization.name" var="namePlaceHolder" />
<myTags:editNonZeroLengthString label="Name"
                                placeholder="${namePlaceHolder}"
                                string="${organization.name}"
                                isRequired="true"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                isInputGroup="${true}"
                                updateCardTabTitleText="${true}"
                                path="${path}.name">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.organization.abbreviation" var="abbreviationPlaceHolder" />
<myTags:editNonZeroLengthString label="Abbreviation"
                                placeholder="${abbreviationPlaceHolder}"
                                specifier="${specifier}-abbreviation"
                                id="${specifier}-abbreviation"
                                isRequired="${true}"
                                path="${path}.abbreviation"
                                isInputGroup="${true}"
                                string="${organization.abbreviation}">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier specifier="${specifier}-identifier"
                       label="Identifier"
                       id="${specifier}-identifier"
                       path="${path}.identifier"
                       singleIdentifier="${organization.identifier}"
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
                            listItems="${organization.alternateIdentifiers}">
</myTags:editMasterUnbounded>
<myTags:editPlace place="${organization.location}"
                  path="${path}.location"
                  specifier="${specifier}-location"
                  tagName="place"
                  id="${specifier}-location"
                  isUnboundedList="${false}"
                  label="Location">
</myTags:editPlace>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${organization}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isFirstRequired="${isFirstRequired}"
                                 cardText="${cardText}"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>


