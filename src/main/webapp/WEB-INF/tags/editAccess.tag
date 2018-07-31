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
<%@ attribute name="isAccessRequired" required="true"
              type="java.lang.Boolean" %>

<c:choose>
    <c:when test="${not function:isObjectEmpty(access)}">
        <c:choose>
            <c:when test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
                <div class="form-group edit-form-group has-error">
            </c:when>
            <c:otherwise>
                <div class="form-group edit-form-group">
            </c:otherwise>
        </c:choose>
        <label>Access</label>
            <c:if test="${not isAccessRequired}">
                <button class="btn btn-danger access-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </c:if>
            <myTags:editIdentifier label="Identifier" specifier="${specifier}-identifier"
                                   path="${path}.identifier"
                                   identifier="${access.identifier}"
                                   unbounded="False">
            </myTags:editIdentifier>
            <myTags:editIdentifier specifier="${specifier}-alternateIdentifiers"
                                   label="Alternate Identifiers"
                                   path="${path}.alternateIdentifiers"
                                   identifiers="${access.alternateIdentifiers}"
                                   unbounded="${true}">
            </myTags:editIdentifier>
            <myTags:editRequiredNonZeroLengthString path="${path}.landingPage"
                                                    placeholder=" A web page that contains information about the associated dataset or other research object and a direct link to the object itself."
                                                    string="${access.landingPage}"
                                                    label="Landing Page">
            </myTags:editRequiredNonZeroLengthString>
            <myTags:editNonRequiredNonZeroLengthString path="${path}.accessURL"
                                                       specifier="${specifier}-accessURL"
                                                       placeholder="A URL from which the resource (dataset or other research object) can be retrieved, i.e. a direct link to the object itself."
                                                       string="${access.accessURL}"
                                                       label="Access URL">
            </myTags:editNonRequiredNonZeroLengthString>
            <myTags:editAnnotationUnbounded path="${path}.types"
                                            specifier="${specifier}-types"
                                            annotations="${access.types}"
                                            label="Types">
            </myTags:editAnnotationUnbounded>
            <myTags:editAnnotationUnbounded path="${path}.authorizations"
                                            specifier="${specifier}-authorizations"
                                            annotations="${access.authorizations}"
                                            label="Authorizations">
            </myTags:editAnnotationUnbounded>
            <myTags:editAnnotationUnbounded path="${path}.authentications"
                                            specifier="${specifier}-authentications"
                                            annotations="${access.authentications}"
                                            label="Authentications">
            </myTags:editAnnotationUnbounded>
        <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
            <span class="error-color">${message.text}</span>
        </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
                <div class="form-group edit-form-group has-error">
            </c:when>
            <c:otherwise>
                <div class="form-group edit-form-group">
            </c:otherwise>
        </c:choose>
        <label>Access</label>
            <c:if test="${not isAccessRequired}">
                <button class="btn btn-danger access-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </c:if>
            <myTags:editIdentifier label="Identifier" specifier="${specifier}-identifier"
                                   path="${path}.identifier"
                                   unbounded="False">
            </myTags:editIdentifier>
            <myTags:editIdentifier specifier="${specifier}-alternateIdentifiers"
                                   label="Alternate Identifiers"
                                   path="${path}.alternateIdentifiers"
                                   unbounded="${true}">
            </myTags:editIdentifier>
            <myTags:editRequiredNonZeroLengthString path="${path}.landingPage"
                                                    placeholder=" A web page that contains information about the associated dataset or other research object and a direct link to the object itself."
                                                    label="Landing Page">
            </myTags:editRequiredNonZeroLengthString>
            <myTags:editNonRequiredNonZeroLengthString path="${path}.accessURL"
                                                       specifier="${specifier}-accessURL"
                                                       placeholder="A URL from which the resource (dataset or other research object) can be retrieved, i.e. a direct link to the object itself."
                                                       label="Access URL">
            </myTags:editNonRequiredNonZeroLengthString>
            <myTags:editAnnotationUnbounded path="${path}.types"
                                            specifier="${specifier}-types"
                                            label="Types">
            </myTags:editAnnotationUnbounded>
            <myTags:editAnnotationUnbounded path="${path}.authorizations"
                                            specifier="${specifier}-authorizations"
                                            label="Authorizations">
            </myTags:editAnnotationUnbounded>
            <myTags:editAnnotationUnbounded path="${path}.authentications"
                                            specifier="${specifier}-authentications"
                                            label="Authentications">
            </myTags:editAnnotationUnbounded>
        <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
            <span class="error-color">${message.text}</span>
        </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

