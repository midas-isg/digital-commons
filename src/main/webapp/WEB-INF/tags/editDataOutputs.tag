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
<%@ attribute name="dataOutputs" required="false"
              type="edu.pitt.isg.mdc.v1_0.DataOutputs" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>

<fmt:message key="software.dataOutputs" var="dataOutputsPlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataOutputs}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${dataOutputsPlaceHolder}"
                                 cardIcon="fas fa-sign-out-alt"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<myTags:editPositiveBigInteger number="${dataOutputs.outputNumber}"
                                    path="${path}.outputNumber"
                                    specifier="${specifier}-outputNumber"
                                    label="Output Number"
                                    placeholder="Output Number"
                                    id="${specifier}-outputNumber"
                                    isRequired="${true}">
</myTags:editPositiveBigInteger>

<fmt:message key="software.dataOutputs.description" var="descriptionPlaceHolder" />
<myTags:editNonZeroLengthString label="Description"
                                placeholder="${descriptionPlaceHolder}"
                                specifier="${specifier}-description"
                                id="${specifier}-description"
                                string="${dataOutputs.description}"
                                isTextArea="${true}"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                isUnboundedList="${false}"
                                updateCardTabTitleText="${true}"
                                path="${path}.description">
</myTags:editNonZeroLengthString>

<fmt:message key="software.dataOutputs.dataFormats" var="dataFormatsPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.dataFormats"
                            specifier="${specifier}-dataFormats"
                            label="Data Formats"
                            addButtonLabel="Data Format"
                            listItems="${dataOutputs.dataFormats}"
                            isFirstRequired="${false}"
                            cardText="${dataFormatsPlaceHolder}"
                            cardIcon=""
                            tagName="string">
</myTags:editMasterUnbounded>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataOutputs}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${dataOutputsPlaceHolder}"
                                 cardIcon="fas fa-sign-out-alt"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
