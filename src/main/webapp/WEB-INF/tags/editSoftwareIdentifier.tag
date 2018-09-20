<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="identifier" required="false"
              type="edu.pitt.isg.mdc.v1_0.Identifier" %>
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



<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${identifier}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isRequired="${isRequired}"
                                 cardText="Information about the primary identifier."
                                 cardIcon="fa fa-id-card-o"
                                 tagName="softwareIdentifier"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString path="${path}.identifier"
                                specifier="${specifier}-identifier"
                                id="${specifier}-identifier"
                                placeholder="A code uniquely identifying an entity locally to a system or globally."
                                cardText="A code uniquely identifying an entity locally to a system or globally."
                                isRequired="${true}"
                                isInputGroup="${true}"
                                label="Identifier"
                                updateCardTabTitleText="${true}"
                                string="${identifier.identifier}">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.identifierSource"
                                specifier="${specifier}-identifierSource"
                                id="${specifier}-identifierSource"
                                placeholder="The identifier source represents information about the organisation/namespace responsible for minting the identifiers. It must be provided if the identifier is provided."
                                cardText="The identifier source represents information about the organisation/namespace responsible for minting the identifiers. It must be provided if the identifier is provided."
                                isRequired="${true}"
                                isInputGroup="${true}"
                                label="Identifier Source"
                                string="${identifier.identifierSource}">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.identifierDescription"
                                specifier="${specifier}-identifierDescription"
                                id="${specifier}-identifierDescription"
                                placeholder="Information describing the identifier."
                                cardText="Information describing the identifier."
                                isRequired="${true}"
                                isInputGroup="${true}"
                                label="Identifier Description"
                                string="${identifier.identifierDescription}">
</myTags:editNonZeroLengthString>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${identifier}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="Information about the primary identifier."
                                 isRequired="${isRequired}"
                                 tagName="softwareIdentifier"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>


