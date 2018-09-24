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
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editIdentifier label="Identifier"
                       path="${path}.identifier"
                       isUnboundedList="${false}"
                       id="${specifier}-identifier"
                       singleIdentifier="${license.identifier}"
                       specifier="${specifier}-identifier">
</myTags:editIdentifier>
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
                                isRequired="${false}"
                                isUnboundedList="${false}"
                                path="${path}.version">
</myTags:editNonZeroLengthString>
<myTags:editPersonComprisedEntity path="${path}.creators"
                                  specifier="${specifier}-creators"
                                  label="Creator"
                                  createPersonOrganizationTags="${true}"
                                  personComprisedEntities="${license.creators}"
                                  isFirstRequired="false"
                                  showAddPersonButton="true"
                                  showAddOrganizationButton="true">
</myTags:editPersonComprisedEntity>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${license}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

