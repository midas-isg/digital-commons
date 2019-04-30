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
<myTags:editSelect path="${path}.dataFormats"
                   specifier="${specifier}-dataFormats"
                   label="Data Formats"
                   id="${specifier}-dataFormats"
                   tagName="select"
                   isRequired="${true}"
                   isMulti="${true}"
                   enumDataMap="${dataFormatsEnums}"
                   enumDataList="${dataOutputs.dataFormats}"
                   cardText="${dataFormatsPlaceHolder}">
</myTags:editSelect>

<myTags:editYesNoUnknownEnum path="${path}.isOptional"
                             specifier="${specifier}-isOptional"
                             label="Is Output Optional"
                             yesNoUnknown="${dataOutputs.isOptional}"
                             tagName="dataOutputs"
                             id="${specifier}-isOptional">
</myTags:editYesNoUnknownEnum>

<myTags:editYesNoUnknownEnum path="${path}.isListOfDataFormatsComplete"
                             specifier="${specifier}-isListOfDataFormatsComplete"
                             label="Is List Of Data Formats Complete"
                             yesNoUnknown="${dataOutputs.isListOfDataFormatsComplete}"
                             tagName="dataOutputs"
                             id="${specifier}-isListOfDataFormatsComplete">
</myTags:editYesNoUnknownEnum>

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

