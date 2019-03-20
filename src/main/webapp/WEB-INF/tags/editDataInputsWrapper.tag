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
<%@ attribute name="digitalObject" required="false"
              type="java.lang.Object" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>

<fmt:message key="software.dataInputs" var="dataInputsPlaceHolder"/>
<myTags:editMasterElementWrapper path="${path}.wrapper"
                                 specifier="${specifier}-wrapper"
                                 object="${digitalObject}"
                                 label="${label}"
                                 id="${id}-wrapper"
                                 isUnboundedList="false"
                                 cardText="${dataInputsPlaceHolder}"
                                 cardIcon="fas fa-sign-in-alt"
                                 tagName="${tagName}"
                                 isRequired="${true}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<myTags:editYesNoUnknownEnum path="isListOfInputsComplete"
                             specifier="isListOfInputsComplete"
                             label="Is List Of Inputs Complete"
                             yesNoUnknown="${digitalObject.isListOfInputsComplete}"
                             tagName="yesNoUnknownEnum"
                             id="isListOfInputsComplete">
</myTags:editYesNoUnknownEnum>
<fmt:message key="software.dataInputFormats" var="dataInputFormatsPlaceHolder" />
<myTags:editMasterUnbounded label="Inputs"
                            addButtonLabel="Input"
                            placeholder="${dataInputFormatsPlaceHolder}"
                            path="inputs"
                            specifier="inputs"
                            isRequired="${false}"
                            cardIcon="fas fa-sign-in-alt"
                            cardText="${dataInputFormatsPlaceHolder}"
                            listItems="${digitalObject.inputs}"
                            tagName="dataInputs">
</myTags:editMasterUnbounded>

<myTags:editMasterElementWrapper path="${path}.wrapper"
                                 specifier="${specifier}-wrapper"
                                 object="${digitalObject}"
                                 label="${label}"
                                 id="${id}-wrapper"
                                 isRequired="${true}"
                                 isUnboundedList="${false}"
                                 cardText="${dataInputsPlaceHolder}"
                                 cardIcon="fas fa-sign-in-alt"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

