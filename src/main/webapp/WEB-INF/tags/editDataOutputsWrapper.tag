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

<fmt:message key="software.dataOutputs" var="dataOutputsPlaceHolder" />
<myTags:editMasterElementWrapper path="${path}.wrapper"
                                 specifier="${specifier}-wrapper"
                                 object="${digitalObject}"
                                 label="${label}"
                                 id="${id}-wrapper"
                                 isUnboundedList="false"
                                 cardText="${dataOutputsPlaceHolder}"
                                 cardIcon="fas fa-sign-in-alt"
                                 tagName="${tagName}"
                                 isRequired="${true}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<myTags:editYesNoUnknownEnum path="isListOfOutputsComplete"
                             specifier="isListOfOutputsComplete"
                             label="Is List Of Outputs Complete"
                             yesNoUnknown="${digitalObject.isListOfOutputsComplete}"
                             tagName="yesNoUnknownEnum"
                             id="isListOfOutputsComplete">
</myTags:editYesNoUnknownEnum>
<fmt:message key="software.dataOutputFormats" var="dataOutputFormatsPlaceHolder" />
<myTags:editMasterUnbounded label="Outputs"
                            addButtonLabel="Output"
                            placeholder="${dataOutputFormatsPlaceHolder}"
                            path="outputs"
                            specifier="outputs"
                            isRequired="${false}"
                            cardIcon="fas fa-sign-in-alt"
                            cardText="${dataOutputFormatsPlaceHolder}"
                            listItems="${digitalObject.outputs}"
                            tagName="dataOutputs">
</myTags:editMasterUnbounded>

<myTags:editMasterElementWrapper path="${path}.wrapper"
                                 specifier="${specifier}-wrapper"
                                 object="${digitalObject}"
                                 label="${label}"
                                 id="${id}-wrapper"
                                 isRequired="${true}"
                                 isUnboundedList="${false}"
                                 cardText="${dataOutputPlaceHolder}"
                                 cardIcon="fas fa-sign-in-alt"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

