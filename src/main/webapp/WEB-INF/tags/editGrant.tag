<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="grant" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Grant" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>

<fmt:message key="dataset.grant" var="grantPlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${grant}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${grantPlaceHolder}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.grant.name" var="namePlaceHolder" />
<myTags:editNonZeroLengthString placeholder="${namePlaceHolder}"
                                label="Name"
                                string="${grant.name}"
                                isUnboundedList="${false}"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                updateCardTabTitleText="${true}"
                                path="${path}.name">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.grant.funders" var="fundersPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.funders"
                            specifier="${specifier}-funders"
                            label="Funders"
                            addButtonLabel="Funder"
                            listItems="${grant.funders}"
                            createPersonOrganizationTags="${true}"
                            tagName="personComprisedEntity"
                            cardText="${fundersPlaceHolder}"
                            cardIcon="fas fa-users"
                            isFirstRequired="true"
                            showAddPersonButton="true"
                            showAddOrganizationButton="true">
</myTags:editMasterUnbounded>
<myTags:editIdentifier path="${path}.identifier"
                       singleIdentifier="${grant.identifier}"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       specifier="${specifier}-identifier"
                       label="Identifier">
</myTags:editIdentifier>

<fmt:message key="dataset.alternateIdentifier" var="alternateIdentifierPlaceHolder" />
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            addButtonLabel="Alternate Identifier"
                            path="${path}.alternateIdentifiers"
                            cardText="${alternateIdentifierPlaceHolder}"
                            cardIcon="fa fa-id-card"
                            tagName="identifier"
                            listItems="${grant.alternateIdentifiers}">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.grant.awardees" var="awardeesPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.awardees"
                            specifier="${specifier}-awardees"
                            label="Awardees"
                            addButtonLabel="Awardee"
                            listItems="${grant.awardees}"
                            createPersonOrganizationTags="${true}"
                            cardText="${awardeesPlaceHolder}"
                            cardIcon="fas fa-award"
                            tagName="personComprisedEntity"
                            isFirstRequired="false"
                            showAddPersonButton="true"
                            showAddOrganizationButton="true">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${grant}"
                                 label="${label}"
                                 id="${id}"
                                 cardText="${grantPlaceHolder}"
                                 showCardFooter="${true}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>


