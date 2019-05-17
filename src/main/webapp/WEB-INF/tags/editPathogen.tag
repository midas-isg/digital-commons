<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="pathogen" required="false"
              type="edu.pitt.isg.mdc.v1_0.Pathogen" %>
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


<fmt:message key="software.pathogen" var="cardText" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${pathogen}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isRequired="${isRequired}"
                                 cardText="${cardText}"
                                 cardIcon="fa fa-id-card-o"
                                 tagName="pathogen"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<myTags:editSoftwareIdentifier label="${label}"
                               path="${path}.identifier"
                               identifier="${pathogen.identifier}"
                               isUnboundedList="${false}"
                               isRequired="${false}"
                               id="${specifier}-identifier"
                               updateCardTabTitleText="${true}"
                               specifier="${specifier}-identifier">
</myTags:editSoftwareIdentifier>

<%--<c:when test="${tagName == 'softwareIdentifier'}">
    <myTags:editSoftwareIdentifier label="${label}"
                                   path="${path}[${varStatus.count-1}].identifier"
                                   identifier="${listItem.identifier}"
                                   isUnboundedList="${true}"
                                   isRequired="${isRequired}"
                                   id="${specifier}-${varStatus.count-1}"
                                   specifier="${specifier}-${varStatus.count-1}">
    </myTags:editSoftwareIdentifier>
</c:when>--%>

<fmt:message key="software.pathogenEvolutionModels.pathogens.strainName" var="strainNamePlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.strainName"
                                specifier="${specifier}-strainName"
                                id="${specifier}-strainName"
                                placeholder="${strainNamePlaceHolder}"
                                isRequired="${false}"
                                isInputGroup="${true}"
                                label="Strain Name"
                                string="${pathogen.strainName}">
</myTags:editNonZeroLengthString>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${pathogen}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${cardText}"
                                 isRequired="${isRequired}"
                                 tagName="pathogen"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>


