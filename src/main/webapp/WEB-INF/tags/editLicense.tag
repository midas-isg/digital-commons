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
<%@ attribute name="license" required="false"
              type="edu.pitt.isg.mdc.dats2_2.License" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>

<fmt:message key="dataset.license" var="licensePlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${license}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${licensePlaceHolder}"
                                 cardIcon="fab fa-creative-commons"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.license.name" var="namePlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.name"
                                placeholder="${namePlaceHolder}"
                                string="${license.name}"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                isUnboundedList="${false}"
                                updateCardTabTitleText="${true}"
                                label="Name">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.license.version" var="versionPlaceHolder" />
<myTags:editNonZeroLengthString label="Version"
                                placeholder="${versionPlaceHolder}"
                                specifier="${specifier}-version"
                                id="${specifier}-version"
                                string="${license.version}"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                isUnboundedList="${false}"
                                path="${path}.version">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier label="Identifier"
                       path="${path}.identifier"
                       isUnboundedList="${false}"
                       id="${specifier}-identifier"
                       singleIdentifier="${license.identifier}"
                       specifier="${specifier}-identifier">
</myTags:editIdentifier>

<fmt:message key="dataset.license.creators" var="creatorsPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.creators"
                            specifier="${specifier}-creators"
                            label="Creators"
                            addButtonLabel="Creator"
                            createPersonOrganizationTags="${true}"
                            listItems="${license.creators}"
                            isFirstRequired="false"
                            showAddPersonButton="true"
                            cardText="${creatorsPlaceHolder}"
                            cardIcon="fas fa-users"
                            tagName="personComprisedEntity"
                            showAddOrganizationButton="true">
</myTags:editMasterUnbounded>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${license}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${licensePlaceHolder}"
                                 cardIcon="fab fa-creative-commons"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

