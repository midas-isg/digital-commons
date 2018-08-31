<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="singleIdentifier" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Identifier" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${singleIdentifier}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="Information about the primary identifier."
                                 tagName="identifier"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString path="${path}.identifier"
                                specifier="${specifier}-identifier"
                                id="${specifier}-identifier"
                                placeholder="A code uniquely identifying an entity locally to a system or globally."
                                isRequired="${true}"
                                label="Identifier"
                                string="${singleIdentifier.identifier}">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.identifierSource"
                                specifier="${specifier}-identifierSource"
                                id="${specifier}-identifierSource"
                                placeholder="The identifier source represents information about the organisation/namespace responsible for minting the identifiers. It must be provided if the identifier is provided."
                                isRequired="${true}"
                                label="Identifier Source"
                                string="${singleIdentifier.identifierSource}">
</myTags:editNonZeroLengthString>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${singleIdentifier}"
                                 label="${label}"
                                 id="${id}"
                                 cardText="Information about the primary identifier."
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="identifier"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

