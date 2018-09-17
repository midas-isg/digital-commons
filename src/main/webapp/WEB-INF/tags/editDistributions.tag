<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

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


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${distribution}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="(From DCAT) Represents a specific available form of a dataset. Each dataset might be available in different forms, these forms might represent different formats of the dataset or different endpoints. Examples of distributions include a downloadable CSV file, an API or an RSS feed."
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString path="${path}.title"
                                specifier="${specifier}-title"
                                id="${specifier}-title"
                                placeholder=" The name of the dataset, usually one sentece or short description of the dataset."
                                string="${distribution.title}"
                                isUnboundedList="${false}"
                                isInputGroup="${true}"
                                isRequired="${true}"
                                label="Title">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.description"
                                string="${distribution.description}"
                                specifier="${specifier}-description"
                                id="${specifier}-description"
                                placeholder=" A textual narrative comprised of one or more statements describing the dataset distribution."
                                label="Description"
                                isUnboundedList="${false}"
                                isInputGroup="${true}"
                                isRequired="${true}"
                                isTextArea="True">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString label="Version"
                                placeholder=" A release point for the dataset when applicable."
                                specifier="${specifier}-version"
                                id="${specifier}-version"
                                isUnboundedList="${false}"
                                string="${distribution.version}"
                                isInputGroup="${true}"
                                isRequired="${true}"
                                path="${path}.version">
</myTags:editNonZeroLengthString>
<myTags:editFloat path="${path}.size"
                  specifier="${specifier}-size"
                  id="${specifier}-size"
                  number="${distribution.size}"
                  placeholder=" The size of the dataset."
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
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            addButtonLabel="Alternate Identifiers"
                            path="${path}.alternateIdentifiers"
                            cardText="Information about an alternate identifier (other than the primary)."
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
<myTags:editMasterUnbounded listItems="${distribution.dates}"
                            path="${path}.dates"
                            cardText="Relevant dates for the datasets, e.g. creation date or last modification date may be added."
                            cardIcon="far fa-calendar-alt"
                            tagName="date"
                            label="Dates"
                            addButtonLabel="Date"
                            specifier="${specifier}-dates">
</myTags:editMasterUnbounded>

<myTags:editMasterUnbounded path="${path}.licenses"
                            listItems="${distribution.licenses}"
                            cardText="The terms of use of the dataset distribution."
                            cardIcon="fab fa-creative-commons"
                            tagName="license"
                            label="Licenses"
                            addButtonLabel="License"
                            specifier="${specifier}-licenses">
</myTags:editMasterUnbounded>
<%--TODO: add icon for conforms to--%>
<myTags:editMasterUnbounded label="Conforms To"
                            addButtonLabel="Conforms To"
                            path="${path}.conformsTo"
                            listItems="${distribution.conformsTo}"
                            cardText="A data standard whose requirements and constraints are met by the dataset."
                            cardIcon="fas fa-clipboard-list"
                            tagName="dataStandard"
                            specifier="${specifier}-conformsTo">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.qualifiers"
                            specifier="${specifier}-qualifiers"
                            cardText="One or more characteristics of the dataset distribution (e.g. how it relates to other distributions, if the data is raw or processed, compressed or encrypted)."
                            cardIcon="far fa-file-archive"
                            tagName="annotation"
                            listItems="${distribution.qualifiers}"
                            addButtonLabel="Qualifier"
                            label="Qualifiers">
</myTags:editMasterUnbounded>

<myTags:editMasterUnbounded listItems="${distribution.formats}"
                            tagName="string"
                            path="${path}.formats"
                            specifier="${specifier}-formats"
                            cardText="The technical format of the dataset distribution. Use the file extension or MIME type when possible. (Definition adapted from DataCite)"
                            cardIcon="far fa-file-alt"
                            isRequired="${false}"
                            placeholder=" The technical format of the dataset distribution. Use the file extension or MIME type when possible."
                            addButtonLabel="Format"
                            label="Formats">
</myTags:editMasterUnbounded>

<myTags:editAnnotation annotation="${distribution.unit}"
                       path="${path}.unit"
                       specifier="${specifier}-unit"
                       id="${specifier}-unit"
                       isUnboundedList="${false}"
                       cardText="The unit of measurement used to estimate the size of the dataset (e.g, petabyte). Ideally, the unit should be coming from a reference controlled terminology."
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
                                 cardText="(From DCAT) Represents a specific available form of a dataset. Each dataset might be available in different forms, these forms might represent different formats of the dataset or different endpoints. Examples of distributions include a downloadable CSV file, an API or an RSS feed."
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

