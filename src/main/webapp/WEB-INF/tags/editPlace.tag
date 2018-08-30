<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="place" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Place" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${place}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString path="${path}.name"
                                specifier="${specifier}-name"
                                placeholder=" The name of the place."
                                string="${place.name}"
                                isRequired="true"
                                label=" Name">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier specifier="${specifier}-identifier"
                       label="Identifier"
                       path="${path}.identifier"
                       id="${specifier}-identifier"
                       singleIdentifier="${place.identifier}"
                       isUnboundedList="${false}">
</myTags:editIdentifier>
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            path="${path}.alternateIdentifiers"
                            tagName="identifier"
                            listItems="${place.alternateIdentifiers}">
</myTags:editMasterUnbounded>
<myTags:editNonZeroLengthString path="${path}.description"
                                specifier="${specifier}-description"
                                string="${place.description}"
                                isTextArea="true"
                                placeholder=" A textual narrative comprised of one or more statements describing the place."
                                label="Description">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.postalAddress"
                                specifier="${specifier}-postalAddress"
                                string="${place.postalAddress}"
                                placeholder=" A physical street address."
                                label="Postal Address">
</myTags:editNonZeroLengthString>
<myTags:editSelect path="${path}.geometry"
                   specifier="${specifier}-geometry"
                   label="Geometry"
                   enumData="${place.geometry}"
                   enumList="${geometryEnums}"
                   tagName="geometry"
                   id="${specifier}-geometry">
</myTags:editSelect>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${place}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
