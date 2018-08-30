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
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editAccess path="${path}.access"
                   specifier="${specifier}-access"
                   id="${specifier}-access"
                   tagName="access"
                   isUnboundedList="${false}"
                   isAccessRequired="true"
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
                            path="${path}.alternateIdentifiers"
                            tagName="identifier"
                            listItems="${distribution.alternateIdentifiers}">
</myTags:editMasterUnbounded>
<myTags:editNonZeroLengthString path="${path}.title"
                                specifier="${specifier}-title"
                                placeholder=" The name of the dataset, usually one sentece or short description of the dataset."
                                string="${distribution.title}"
                                isUnboundedList="${false}"
                                isRequired="${false}"
                                label="Title">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.description"
                                string="${distribution.description}"
                                specifier="${specifier}-description"
                                placeholder=" A textual narrative comprised of one or more statements describing the dataset distribution."
                                label="Description"
                                isUnboundedList="${false}"
                                isRequired="${false}"
                                isTextArea="True">
</myTags:editNonZeroLengthString>
<myTags:editDataRepository label="Stored In"
                           path="${path}.storedIn"
                           dataRepository="${distribution.storedIn}"
                           id="${id}-storedIn"
                           specifier="${specifier}-storedIn">
</myTags:editDataRepository>
<myTags:editMasterUnbounded listItems="${distribution.dates}"
                            path="${path}.dates"
                            tagName="date"
                            label="Dates"
                            specifier="${specifier}-dates">
</myTags:editMasterUnbounded>
<myTags:editNonZeroLengthString label="Version"
                                placeholder=" A release point for the dataset when applicable."
                                specifier="${specifier}-version"
                                isUnboundedList="${false}"
                                string="${distribution.version}"
                                path="${path}.version">
</myTags:editNonZeroLengthString>
<myTags:editMasterUnbounded path="${path}.licenses"
                            listItems="${distribution.licenses}"
                            tagName="license"
                            label="License"
                            specifier="${specifier}-licenses">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded label="Conforms To"
                            path="${path}.conformsTo"
                            listItems="${distribution.conformsTo}"
                            tagName="dataStandard"
                            specifier="${specifier}-conformsTo">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.qualifiers"
                            specifier="${specifier}-qualifiers"
                            tagName="annotation"
                            listItems="${distribution.qualifiers}"
                            label="Qualifiers">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded listItems="${distribution.formats}"
                            tagName="string"
                            path="${path}.formats"
                            specifier="${specifier}-formats"
                            isRequired="${false}"
                            placeholder=" The technical format of the dataset distribution. Use the file extension or MIME type when possible."
                            label="Formats">
</myTags:editMasterUnbounded>
<myTags:editFloat path="${path}.size"
                  specifier="${specifier}-size"
                  id="${specifier}-size"
                  number="${distribution.size}"
                  placeholder=" The size of the dataset."
                  label="Size">
</myTags:editFloat>
<myTags:editAnnotation annotation="${distribution.unit}"
                       path="${path}.unit"
                       specifier="${specifier}-unit"
                       id="${specifier}-unit"
                       isUnboundedList="${false}"
                       isRequired="${false}"
                       label="Unit">
</myTags:editAnnotation>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${distribution}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

