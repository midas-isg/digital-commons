<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

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

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${annotation}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="annotation"
                                 isRequired="${isRequired}"
                                 cardText="${cardText}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString path="${path}.value"
                                specifier="${specifier}-value"
                                id="${specifier}-value"
                                placeholder="Value"
                                isRequired="${true}"
                                label="Value"
                                isInputGroup="${true}"
                                string="${annotation.value}">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.valueIRI"
                                specifier="${specifier}-valueIRI"
                                id="${specifier}-valueIRI"
                                placeholder="Value IRI"
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
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

