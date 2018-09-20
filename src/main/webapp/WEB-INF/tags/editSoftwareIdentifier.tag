<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="identifier" required="false"
              type="edu.pitt.isg.mdc.v1_0.Identifier" %>
<%--
<%@ attribute name="identifiers" required="false"
              type="java.util.List" %>
--%>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="tagName" required="false"
              type="java.lang.String" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>


<fmt:message key="software.identifier" var="cardText" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${identifier}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isRequired="${isRequired}"
                                 cardText="${cardText}"
                                 cardIcon="fa fa-id-card-o"
                                 tagName="softwareIdentifier"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="software.identifier.identifier" var="identifierPlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.identifier"
                                specifier="${specifier}-identifier"
                                id="${specifier}-identifier"
                                placeholder="A code uniquely identifying an entity locally to a system or globally."
                                cardText="${identifierPlaceHolder}"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                label="Identifier"
                                string="${identifier.identifier}">
</myTags:editNonZeroLengthString>

<fmt:message key="software.identifier.identifierSource" var="identifierSourcePlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.identifierSource"
                                specifier="${specifier}-identifierSource"
                                id="${specifier}-identifierSource"
                                placeholder="${identifierSourcePlaceHolder}"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                label="Identifier Source"
                                string="${identifier.identifierSource}">
</myTags:editNonZeroLengthString>

<fmt:message key="software.identifier.description" var="descriptionPlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.identifierDescription"
                                specifier="${specifier}-identifierDescription"
                                id="${specifier}-identifierDescription"
                                placeholder="${descriptionPlaceHolder}"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                label="Identifier Description"
                                string="${identifier.identifierDescription}">
</myTags:editNonZeroLengthString>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${identifier}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${cardText}"
                                 isRequired="${isRequired}"
                                 tagName="softwareIdentifier"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>


