<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="distribution" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Distribution" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>

<fmt:message key="dataset.distribution" var="distributionPlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${distribution}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${distributionPlaceHolder}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.distribution.title" var="titlePlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.title"
                                specifier="${specifier}-title"
                                id="${specifier}-title"
                                placeholder="${titlePlaceHolder}"
                                string="${distribution.title}"
                                isUnboundedList="${false}"
                                isInputGroup="${true}"
                                isRequired="${true}"
                                updateCardTabTitleText="${isUnboundedList}"
                                label="Title">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.distribution.description" var="descriptionPlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.description"
                                string="${distribution.description}"
                                specifier="${specifier}-description"
                                id="${specifier}-description"
                                placeholder="${descriptionPlaceHolder}"
                                label="Description"
                                isUnboundedList="${false}"
                                isInputGroup="${true}"
                                isRequired="${true}"
                                isTextArea="True">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.distribution.version" var="versionPlaceHolder" />
<myTags:editNonZeroLengthString label="Version"
                                placeholder="${versionPlaceHolder}"
                                specifier="${specifier}-version"
                                id="${specifier}-version"
                                isUnboundedList="${false}"
                                string="${distribution.version}"
                                isInputGroup="${true}"
                                isRequired="${true}"
                                path="${path}.version">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.distribution.size" var="sizePlaceHolder" />
<myTags:editFloat path="${path}.size"
                  specifier="${specifier}-size"
                  id="${specifier}-size"
                  number="${distribution.size}"
                  placeholder="${sizePlaceHolder}"
                  label="Size">
</myTags:editFloat>

<myTags:editAccess path="${path}.access"
                   specifier="${specifier}-access"
                   id="${specifier}-access"
                   tagName="access"
                   isUnboundedList="${false}"
                   isAccessRequired="${true}"
                   access="${distribution.access}">
</myTags:editAccess>
<myTags:editIdentifier label="Identifier"
                       specifier="${specifier}-identifier"
                       path="${path}.identifier"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       singleIdentifier="${distribution.identifier}">
</myTags:editIdentifier>

<fmt:message key="dataset.alternateIdentifier" var="alternateIdentifierPlaceHolder" />
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            addButtonLabel="Alternate Identifiers"
                            path="${path}.alternateIdentifiers"
                            cardText="${alternateIdentifierPlaceHolder}"
                            cardIcon="fa fa-id-card"
                            tagName="identifier"
                            listItems="${distribution.alternateIdentifiers}">
</myTags:editMasterUnbounded>

<myTags:editDataRepository label="Stored In"
                           path="${path}.storedIn"
                           dataRepository="${distribution.storedIn}"
                           id="${id}-storedIn"
                           specifier="${specifier}-storedIn">
</myTags:editDataRepository>

<fmt:message key="dataset.distribution.dates" var="datesPlaceHolder" />
<myTags:editMasterUnbounded listItems="${distribution.dates}"
                            path="${path}.dates"
                            cardText="${datesPlaceHolder}"
                            cardIcon="far fa-calendar-alt"
                            tagName="date"
                            label="Dates"
                            addButtonLabel="Date"
                            specifier="${specifier}-dates">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.distribution.licenses" var="licensesPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.licenses"
                            listItems="${distribution.licenses}"
                            cardText="${licensesPlaceHolder}"
                            cardIcon="fab fa-creative-commons"
                            tagName="license"
                            label="Licenses"
                            addButtonLabel="License"
                            specifier="${specifier}-licenses">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.distribution.conformsTo" var="conformsToPlaceHolder" />
<myTags:editMasterUnbounded label="Conforms To"
                            addButtonLabel="Conforms To"
                            path="${path}.conformsTo"
                            listItems="${distribution.conformsTo}"
                            cardText="${conformsToPlaceHolder}"
                            cardIcon="fas fa-clipboard-list"
                            tagName="dataStandard"
                            specifier="${specifier}-conformsTo">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.distribution.qualifiers" var="qualifiersPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.qualifiers"
                            specifier="${specifier}-qualifiers"
                            cardText="${qualifiersPlaceHolder}"
                            cardIcon="far fa-file-archive"
                            tagName="annotation"
                            listItems="${distribution.qualifiers}"
                            addButtonLabel="Qualifier"
                            label="Qualifiers">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.distribution.formats" var="formatsPlaceHolder" />
<myTags:editMasterUnbounded listItems="${distribution.formats}"
                            tagName="string"
                            path="${path}.formats"
                            specifier="${specifier}-formats"
                            cardText="${formatsPlaceHolder}"
                            cardIcon="far fa-file-alt"
                            isRequired="${false}"
                            placeholder="${formatsPlaceHolder}"
                            addButtonLabel="Format"
                            label="Formats">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.distribution.unit" var="unitPlaceHolder" />
<myTags:editAnnotation annotation="${distribution.unit}"
                       path="${path}.unit"
                       specifier="${specifier}-unit"
                       id="${specifier}-unit"
                       isUnboundedList="${false}"
                       cardText="${unitPlaceHolder}"
                       cardIcon="fas fa-balance-scale"
                       isRequired="${false}"
                       label="Unit">
</myTags:editAnnotation>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${distribution}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 showCardFooter="${true}"
                                 cardText="${distributionPlaceHolder}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

