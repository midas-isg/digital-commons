<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="access" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Access" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isAccessRequired" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${access}"
                                 label="Access"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isRequired="${isAccessRequired}"
                                 tagName="access"
                                 cardText="Information about resources that provide the means to obtain an asset (a dataset or other research object)."
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString path="${path}.landingPage"
                                placeholder=" A web page that contains information about the associated dataset or other research object and a direct link to the object itself."
                                string="${access.landingPage}"
                                isRequired="true"
                                isUnboundedList="false"
                                specifier="${specifier}-landingPage"
                                id="${specifier}-landingPage"
                                isInputGroup="${true}"
                                label="Landing Page">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.accessURL"
                                specifier="${specifier}-accessURL"
                                placeholder="A URL from which the resource (dataset or other research object) can be retrieved, i.e. a direct link to the object itself."
                                string="${access.accessURL}"
                                isRequired="${true}"
                                id="${specifier}-accessURL"
                                isInputGroup="${true}"
                                label="Access URL">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier label="Identifier"
                       specifier="${specifier}-identifier"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       path="${path}.identifier"
                       singleIdentifier="${access.identifier}">
</myTags:editIdentifier>
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            addButtonLabel="Alternate Identifier"
                            label="Alternate Identifiers"
                            path="${path}.alternateIdentifiers"
                            cardText="Information about an alternate identifier (other than the primary)."
                            tagName="identifier"
                            listItems="${access.alternateIdentifiers}">
</myTags:editMasterUnbounded>

<myTags:editMasterUnbounded path="${path}.types"
                            specifier="${specifier}-types"
                            listItems="${access.types}"
                            cardText="Method to obtain the resource, ideally specified from a controlled vocabulary or ontology."
                            tagName="annotation"
                            addButtonLabel="Type"
                            label="Types">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.authorizations"
                            specifier="${specifier}-authorizations"
                            cardText="Types of verification that accessing the resource is allowed. Authorization occurs before successful authentication and refers to the process of obtaining approval to use a data set. Ideally specified from a controlled vocabulary or ontology."
                            tagName="annotation"
                            listItems="${access.authorizations}"
                            addButtonLabel="Authorization"
                            label="Authorizations">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.authentications"
                            specifier="${specifier}-authentications"
                            cardText="Types of verification of the credentials for accessing the resource, it is the identification process at the time of access. ideally specified from a controlled vocabulary or ontology."
                            tagName="annotation"
                            listItems="${access.authentications}"
                            addButtonLabel="Authentication"
                            label="Authentications">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${access}"
                                 label="Access"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isRequired="${isAccessRequired}"
                                 cardText="Information about resources that provide the means to obtain an asset (a dataset or other research object)."
                                 showCardFooter="${true}"
                                 tagName="access"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

