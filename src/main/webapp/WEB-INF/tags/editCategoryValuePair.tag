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
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="categoryValuePair" required="false"
              type="edu.pitt.isg.mdc.dats2_2.CategoryValuePair" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="cardText" required="false"
              type="java.lang.String" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${categoryValuePair}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${cardText}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.categoryValuePair.category" var="categoryPlaceHolder" />
<myTags:editNonZeroLengthString label="Category"
                                placeholder="${categoryPlaceHolder}"
                                specifier="${specifier}-category"
                                id="${specifier}-category"
                                isRequired="${true}"
                                path="${path}.category"
                                isInputGroup="${true}"
                                string="${categoryValuePair.category}">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.categoryValuePair.categoryIRI" var="categoryIRIPlaceHolder" />
<myTags:editNonZeroLengthString label="CategoryIRI"
                                placeholder="${categoryIRIPlaceHolder}"
                                specifier="${specifier}-categoryIRI"
                                id="${specifier}-categoryIRI"
                                isRequired="${true}"
                                path="${path}.categoryIRI"
                                isInputGroup="${true}"
                                string="${categoryValuePair.categoryIRI}">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.categoryValuePair.values" var="valuesPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.values"
                            specifier="${specifier}-values"
                            label="Values"
                            addButtonLabel="Value"
                            cardText="${valuesPlaceHolder}"
                            cardIcon="fas fa-tags"
                            tagName="annotation"
                            listItems="${categoryValuePair.values}">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${categoryValuePair}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${cardText}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

