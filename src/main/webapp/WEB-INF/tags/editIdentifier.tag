<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="singleIdentifier" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Identifier" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>

<fmt:message key="dataset.identifier" var="cardText" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${singleIdentifier}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${cardText}"
                                 cardIcon="fa fa-id-card-o"
                                 tagName="identifier"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.identifier.identifier" var="identifierPlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.identifier"
                                specifier="${specifier}-identifier"
                                id="${specifier}-identifier"
                                placeholder="${identifierPlaceHolder}"
                                isRequired="${true}"
                                label="Identifier"
                                isInputGroup="${true}"
                                string="${singleIdentifier.identifier}">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.identifier.identifierSource" var="identifierSourcePlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.identifierSource"
                                specifier="${specifier}-identifierSource"
                                id="${specifier}-identifierSource"
                                placeholder="${identifierSourcePlaceHolder}"
                                isRequired="${true}"
                                label="Identifier Source"
                                isInputGroup="${true}"
                                string="${singleIdentifier.identifierSource}">
</myTags:editNonZeroLengthString>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${singleIdentifier}"
                                 label="${label}"
                                 id="${id}"
                                 cardText="${cardText}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="identifier"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

