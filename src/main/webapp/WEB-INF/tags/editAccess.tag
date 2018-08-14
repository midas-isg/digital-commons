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


<div id="${id}"
     class="form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${not isAccessRequired and function:isObjectEmpty(access)}">hide</c:if>">
    <c:if test="${isAccessRequired and not isUnboundedList}">
        <label>Access</label>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group <c:if test="${isUnboundedList}">edit-form-group</c:if>" <c:if test="${function:isObjectEmpty(access) and not isAccessRequired and not isUnboundedList}">hide</c:if>">
        <c:if test="${not isAccessRequired}">
            <button class="btn btn-danger ${specifier}-access-remove" type="button"><i
                    class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </c:if>
        <myTags:editIdentifier label="Identifier" specifier="${specifier}-identifier"
                               path="${path}.identifier"
                               singleIdentifier="${access.identifier}"
                               isUnboundedList="false"
                               id="${specifier}-identifier">
        </myTags:editIdentifier>
        <myTags:editIdentifierUnbounded specifier="${specifier}-alternateIdentifiers"
                                        label="Alternate Identifiers"
                                        path="${path}.alternateIdentifiers"
                                        identifiers="${access.alternateIdentifiers}">
        </myTags:editIdentifierUnbounded>
        <myTags:editNonZeroLengthString path="${path}.landingPage"
                                        placeholder=" A web page that contains information about the associated dataset or other research object and a direct link to the object itself."
                                        string="${access.landingPage}"
                                        isRequired="true"
                                        isUnboundedList="false"
                                        specifier="${specifier}-landingPage"
                                        id="${specifier}-landingPage"
                                        label="Landing Page">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString path="${path}.accessURL"
                                        specifier="${specifier}-accessURL"
                                        placeholder="A URL from which the resource (dataset or other research object) can be retrieved, i.e. a direct link to the object itself."
                                        string="${access.accessURL}"
                                        id="${specifier}-accessURL"
                                        label="Access URL">
        </myTags:editNonZeroLengthString>
        <myTags:editMasterUnbounded path="${path}.types"
                                        specifier="${specifier}-types"
                                        listItems="${access.types}"
                                        tagName="annotation"
                                        label="Types">
        </myTags:editMasterUnbounded>
<%--
        <myTags:editAnnotationUnbounded path="${path}.types"
                                        specifier="${specifier}-types"
                                        annotations="${access.types}"
                                        label="Types">
        </myTags:editAnnotationUnbounded>
--%>
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
    <script type="text/javascript">

        $(document).ready(function () {
/*

            $("body").on("click", ".${specifier}-add-access", function (e) {
                e.stopImmediatePropagation();

                $("#${specifier}-input-block").removeClass("hide");
                //add button not necessary -- in distributions its required and in Data Repository is a list
                <%--$("#${specifier}-add-input-button").addClass("hide");--%>

            });
*/

            //Remove section
            $("body").on("click", ".${specifier}-access-remove", function () {
                clearAndHideEditControlGroup(this);
                $("#${specifier}-input-block").addClass("hide");
                $("#${specifier}-add-input-button").removeClass("hide");
            });
        });

    </script>

</div>

