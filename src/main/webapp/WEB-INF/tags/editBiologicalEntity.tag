<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="entity" required="false"
              type="edu.pitt.isg.mdc.dats2_2.IsAbout" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>

<fmt:message key="dataset.biologicalEntity" var="biologicalEntityPlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${entity}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${biologicalEntityPlaceHolder}"
                                 tagName="biological-entity"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.biologicalEntity.name" var="namePlaceHolder" />
<myTags:editNonZeroLengthString placeholder="${namePlaceHolder}"
                                label="Name"
                                isRequired="true"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                string="${entity.name}"
                                isInputGroup="${true}"
                                updateCardTabTitleText="${true}"
                                path="${path}.name">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.biologicalEntity.description" var="descriptionPlaceHolder" />
<myTags:editNonZeroLengthString string="${entity.description}"
                                path="${path}.description"
                                label="Description"
                                placeholder="${descriptionPlaceHolder}"
                                isTextArea="true"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                id="${specifier}-description"
                                specifier="${specifier}-description">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier singleIdentifier="${entity.identifier}"
                       path="${path}.identifier"
                       specifier="${specifier}-identifier"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       label="Identifier">
</myTags:editIdentifier>

<fmt:message key="dataset.biologicalEntity.alternateIdentifiers" var="alternateIdentifiersPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.alternateIdentifiers"
                            specifier="${specifier}-alternateIdentifiers"
                            listItems="${entity.alternateIdentifiers}"
                            cardText="${alternateIdentifiersPlaceHolder}"
                            cardIcon="fa fa-id-card"
                            tagName="identifier"
                            addButtonLabel="Alternate Identifier"
                            label="Alternate Identifiers">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${entity}"
                                 label="${label}"
                                 id="${specifier}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${biologicalEntityPlaceHolder}"
                                 showCardFooter="${true}"
                                 tagName="biological-entity"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

