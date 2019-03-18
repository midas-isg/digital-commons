<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText"/>

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="dataInputs" required="false"
              type="edu.pitt.isg.mdc.v1_0.DataInputs" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>

<fmt:message key="software.dataInputs" var="dataInputsPlaceHolder"/>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataInputs}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${dataInputsPlaceHolder}"
                                 cardIcon="fas fa-sign-in-alt"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<myTags:editPositiveBigInteger number="${dataInputs.inputNumber}"
                               path="${path}.inputNumber"
                               specifier="${specifier}-inputNumber"
                               label="Input Number"
                               placeholder="Input Number"
                               id="${specifier}-inputNumber"
                               isRequired="${true}">
</myTags:editPositiveBigInteger>

<fmt:message key="software.dataInputs.description" var="descriptionPlaceHolder"/>
<myTags:editNonZeroLengthString label="Description"
                                placeholder="${descriptionPlaceHolder}"
                                specifier="${specifier}-description"
                                id="${specifier}-description"
                                string="${dataInputs.description}"
                                isTextArea="${true}"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                isUnboundedList="${false}"
                                updateCardTabTitleText="${true}"
                                path="${path}.description">
</myTags:editNonZeroLengthString>

<fmt:message key="software.dataInputs.dataFormats" var="dataFormatsPlaceHolder"/>
<myTags:editSelect path="${path}.dataFormats"
                   specifier="${specifier}-dataFormats"
                   label="Data Formats"
                   id="${specifier}-dataFormats"
                   tagName="select"
                   isRequired="${true}"
                   isMulti="${true}"
                   enumDataMap="${dataFormatsEnums}"
                   enumDataList="${dataInputs.dataFormats}"
                   cardText="${dataFormatsPlaceHolder}">
</myTags:editSelect>

<%--
<fmt:message key="software.dataInputs.dataFormats" var="dataFormatsPlaceHolder"/>
<myTags:editMasterUnbounded path="${path}.dataFormats"
                            specifier="${specifier}-dataFormats"
                            label="Data Formats"
                            addButtonLabel="Data Format"
                            listItems="${dataInputs.dataFormats}"
                            isFirstRequired="${false}"
                            cardText="${dataFormatsPlaceHolder}"
                            cardIcon=""
                            tagName="string">
</myTags:editMasterUnbounded>
--%>

<myTags:editYesNoUnknownEnum path="${path}.isListOfDataFormatsComplete"
                   specifier="${specifier}-isListOfDataFormatsComplete"
                   label="Is List Of Data Formats Complete"
                   yesNoUnknown="${dataInputs.isListOfDataFormatsComplete}"
                   tagName="dataInputs"
                   id="${specifier}-isListOfDataFormatsComplete">
</myTags:editYesNoUnknownEnum>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataInputs}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${dataInputsPlaceHolder}"
                                 cardIcon="fas fa-sign-in-alt"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

