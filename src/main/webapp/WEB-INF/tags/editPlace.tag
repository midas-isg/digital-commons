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
                                 cardText="A spatially bounded entity."
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString path="${path}.name"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                placeholder=" The name of the place."
                                string="${place.name}"
                                isRequired="true"
                                isInputGroup="${true}"
                                label=" Name">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.description"
                                specifier="${specifier}-description"
                                id="${specifier}-description"
                                string="${place.description}"
                                isTextArea="true"
                                isRequired="true"
                                isInputGroup="${true}"
                                placeholder=" A textual narrative comprised of one or more statements describing the place."
                                label="Description">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.postalAddress"
                                specifier="${specifier}-postalAddress"
                                id="${specifier}-postalAddress"
                                string="${place.postalAddress}"
                                isRequired="true"
                                isInputGroup="${true}"
                                placeholder=" A physical street address."
                                label="Postal Address">
</myTags:editNonZeroLengthString>
<myTags:editSelect path="${path}.geometry"
                   specifier="${specifier}-geometry"
                   label="Geometry"
                   enumData="${place.geometry}"
                   enumList="${geometryEnums}"
                   cardText="A region of a space."
                   isRequired="true"
                   tagName="geometry"
                   id="${specifier}-geometry">
</myTags:editSelect>
<myTags:editIdentifier specifier="${specifier}-identifier"
                       label="Identifier"
                       path="${path}.identifier"
                       id="${specifier}-identifier"
                       singleIdentifier="${place.identifier}"
                       isUnboundedList="${false}">
</myTags:editIdentifier>
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            addButtonLabel="Alternate Identifier"
                            path="${path}.alternateIdentifiers"
                            cardText="Information about an alternate identifier (other than the primary)."
                            tagName="identifier"
                            listItems="${place.alternateIdentifiers}">
</myTags:editMasterUnbounded>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${place}"
                                 label="${label}"
                                 id="${id}"
                                 cardText="A spatially bounded entity."
                                 showCardFooter="${true}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
