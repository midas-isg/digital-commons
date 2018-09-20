<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="access" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Access" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isAccessRequired" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>

<fmt:message key="dataset.access" var="accessPlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${access}"
                                 label="Access"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isRequired="${isAccessRequired}"
                                 tagName="access"
                                 cardText="${accessPlaceHolder}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.access.landingPage" var="landingPagePlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.landingPage"
                                placeholder="${landingPagePlaceHolder}"
                                string="${access.landingPage}"
                                isRequired="true"
                                isUnboundedList="false"
                                specifier="${specifier}-landingPage"
                                id="${specifier}-landingPage"
                                isInputGroup="${true}"
                                updateCardTabTitleText="${true}"
                                label="Landing Page">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.access.url" var="urlPlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.accessURL"
                                specifier="${specifier}-accessURL"
                                placeholder="${urlPlaceHolder}"
                                string="${access.accessURL}"
                                isRequired="${true}"
                                id="${specifier}-accessURL"
                                isInputGroup="${true}"
                                label="Access URL">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier label="Identifier"
                       specifier="${specifier}-identifier"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       path="${path}.identifier"
                       singleIdentifier="${access.identifier}">
</myTags:editIdentifier>

<fmt:message key="dataset.alternateIdentifier" var="alternateIdentifierPlaceHolder" />
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            addButtonLabel="Alternate Identifier"
                            label="Alternate Identifiers"
                            path="${path}.alternateIdentifiers"
                            cardText="${alternateIdentifierPlaceHolder}"
                            cardIcon="fa fa-id-card"
                            tagName="identifier"
                            listItems="${access.alternateIdentifiers}">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.access.types" var="typesPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.types"
                            specifier="${specifier}-types"
                            listItems="${access.types}"
                            cardText="${typesPlaceHolder}"
                            cardIcon="fas fa-info-circle"
                            tagName="annotation"
                            addButtonLabel="Type"
                            label="Types">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.access.authorizations" var="authorizationsPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.authorizations"
                            specifier="${specifier}-authorizations"
                            cardText="${authorizationsPlaceHolder}"
                            cardIcon="fas fa-key"
                            tagName="annotation"
                            listItems="${access.authorizations}"
                            addButtonLabel="Authorization"
                            label="Authorizations">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.access.authentications" var="authenticationsPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.authentications"
                            specifier="${specifier}-authentications"
                            cardText="${authenticationsPlaceHolder}"
                            cardIcon="fa fa-check-circle"
                            tagName="annotation"
                            listItems="${access.authentications}"
                            addButtonLabel="Authentication"
                            label="Authentications">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${access}"
                                 label="Access"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isRequired="${isAccessRequired}"
                                 cardText="${accessPlaceHolder}"
                                 showCardFooter="${true}"
                                 tagName="access"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

