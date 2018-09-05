<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="license" required="false"
              type="edu.pitt.isg.mdc.dats2_2.License" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${license}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="A legal document giving official permission to do something with a Resource. It is assumed that an external vocabulary will describe with sufficient granularity the permission for redistribution, modification, derivation, reuse, etc. and conditions for citation/acknowledgment."
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString path="${path}.name"
                                placeholder=" Name of License"
                                string="${license.name}"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                isRequired="${true}"
                                isUnboundedList="${false}"
                                label="Name">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString label="Version"
                                placeholder=" Version"
                                specifier="${specifier}-version"
                                id="${specifier}-version"
                                string="${license.version}"
                                isRequired="${true}"
                                isUnboundedList="${false}"
                                path="${path}.version">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier label="Identifier"
                       path="${path}.identifier"
                       isUnboundedList="${false}"
                       id="${specifier}-identifier"
                       singleIdentifier="${license.identifier}"
                       specifier="${specifier}-identifier">
</myTags:editIdentifier>

<myTags:editMasterUnbounded path="${path}.creators"
                            specifier="${specifier}-creators"
                            label="Creator"
                            createPersonOrganizationTags="${true}"
                            listItems="${license.creators}"
                            isFirstRequired="false"
                            showAddPersonButton="true"
                            cardText="The person(s) or organization(s) responsible for writing the license."
                            tagName="personComprisedEntity"
                            showAddOrganizationButton="true">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${license}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="A legal document giving official permission to do something with a Resource. It is assumed that an external vocabulary will describe with sufficient granularity the permission for redistribution, modification, derivation, reuse, etc. and conditions for citation/acknowledgment."
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

