<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="organization" required="false"
              type="edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isFirstRequired" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${organization}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isFirstRequired="${isFirstRequired}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editIdentifier specifier="${specifier}-identifier"
                       label="Identifier"
                       id="${specifier}-identifier"
                       path="${path}.identifier"
                       singleIdentifier="${organization.identifier}"
                       isUnboundedList="${false}">
</myTags:editIdentifier>
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            path="${path}.alternateIdentifiers"
                            tagName="identifier"
                            listItems="${organization.alternateIdentifiers}">
</myTags:editMasterUnbounded>
<myTags:editNonZeroLengthString label="Name"
                                placeholder=" The name of the organization."
                                string="${organization.name}"
                                isRequired="true"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                path="${path}.name">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString label="Abbreviation"
                                placeholder=" The shortname, abbreviation associated to the organization."
                                specifier="${specifier}-abbreviation"
                                path="${path}.abbreviation"
                                string="${organization.abbreviation}">
</myTags:editNonZeroLengthString>
<myTags:editPlace place="${organization.location}"
                  path="${path}.location"
                  specifier="${specifier}-location"
                  tagName="place"
                  id="${specifier}-location"
                  isUnboundedList="${false}"
                  label="Location">
</myTags:editPlace>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${organization}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isFirstRequired="${isFirstRequired}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>


