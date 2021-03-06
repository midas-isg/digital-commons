<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="annotation" required="false"
              type="edu.pitt.isg.mdc.dats2_2.IsAbout" %>
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
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="cardText" required="true"
              type="java.lang.String" %>
<%@ attribute name="cardIcon" required="false"
              type="java.lang.String" %>
<%@ attribute name="updateCardTabTitleText" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="updateCardTabTitleTextType" required="false"
              type="java.lang.Boolean" %>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${annotation}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="annotation"
                                 isRequired="${isRequired}"
                                 cardText="${cardText}"
                                 cardIcon="${cardIcon}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.annotation.value" var="valuePlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.value"
                                specifier="${specifier}-value"
                                id="${specifier}-value"
                                placeholder="${valuePlaceHolder}"
                                isRequired="${true}"
                                label="${valuePlaceHolder}"
                                isInputGroup="${true}"
                                updateCardTabTitleText="${isUnboundedList or updateCardTabTitleText}"
                                updateCardTabTitleTextType="${updateCardTabTitleTextType}"
                                string="${annotation.value}">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.annotation.valueIRI" var="valueIRIPlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.valueIRI"
                                specifier="${specifier}-valueIRI"
                                id="${specifier}-valueIRI"
                                placeholder="${valueIRIPlaceHolder}"
                                isRequired="${true}"
                                label="Value IRI"
                                isInputGroup="${true}"
                                string="${annotation.valueIRI}">
</myTags:editNonZeroLengthString>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${annotation}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="annotation"
                                 isRequired="${isRequired}"
                                 cardText="${cardText}"
                                 cardIcon="${cardIcon}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

