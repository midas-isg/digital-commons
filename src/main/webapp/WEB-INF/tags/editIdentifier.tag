<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="singleIdentifier" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Identifier" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>


<div id="${id}" class="form-group edit-form-group <c:if test="${isUnboundedList and empty singleIdentifier}">hide</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <div id="${specifier}-add-input-button" class="input-group control-group">
            <div class="input-group-btn">
                <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
                        class="fa fa-plus-circle"></i> Add
                        ${label}
                </button>
            </div>
        </div>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(singleIdentifier) and not isUnboundedList}">hide</c:if>">
        <button class="btn btn-danger ${specifier}-identifier-remove" type="button"><i
                class="fa fa-minus-circle"></i>
            Remove
        </button>
        <c:set var="identifierPath" value="${path}.identifier"/>
        <c:set var="identifierSourcePath" value="${path}.identifierSource"/>
        <div class="form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(identifierPath)}"> has-error</c:if>">
            <label>Identifier</label>
            <input type="text" class="form-control" value="${singleIdentifier.identifier}"
                   name="${path}.identifier"
                   placeholder=" A code uniquely identifying an entity locally to a system or globally.">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(identifierPath)}"
                       var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </div>

        <div class="form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(identifierSourcePath)}"> has-error</c:if>">
            <label>Identifier Source</label>
            <input type="text" class="form-control" value="${singleIdentifier.identifierSource}"
                   name="${path}.identifierSource"
                   placeholder=" The identifier source represents information about the organisation/namespace responsible for minting the identifiers. It must be provided if the identifier is provided.">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(identifierSourcePath)}"
                       var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </div>
    </div>

    <script type="text/javascript">

        $(document).ready(function () {
            $("body").on("click", ".${specifier}-add-identifier", function (e) {
                e.stopImmediatePropagation();

                $("#${specifier}-input-block").removeClass("hide");
                $("#${specifier}-add-input-button").addClass("hide");

            });

            //Remove section
            $("body").on("click", ".${specifier}-identifier-remove", function () {
                clearAndHideEditControlGroup(this);
                $("#${specifier}-input-block").addClass("hide");
                $("#${specifier}-add-input-button").removeClass("hide");
            });
        });

    </script>
</div>
