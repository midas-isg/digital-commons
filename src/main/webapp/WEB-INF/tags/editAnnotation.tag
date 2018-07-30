<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="annotation" required="false"
              type="edu.pitt.isg.mdc.dats2_2.IsAbout" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="showRemoveButton" required="true"
              type="java.lang.Boolean" %>

<%--<div class="form-group control-group edit-form-group">--%>
<c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
    <div class="has-error">
</c:if>
    <c:if test="${showRemoveButton}">
        <label>${label}</label>
        <button class="btn btn-danger ${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
    </c:if>
    <div class="form-group edit-form-group">
        <label>Value</label>
        <input type="text" class="form-control" value="${annotation.value}" name="${path}.value" placeholder="Value">
    </div>

    <c:set var="valueIRIPath" value="${path}.valueIRI"/>
    <c:choose>
        <c:when test="${not empty flowRequestContext.messageContext.getMessagesBySource(valueIRIPath)}">
            <div class="form-group edit-form-group has-error">
        </c:when>
        <c:otherwise>
            <div class="form-group edit-form-group">
        </c:otherwise>
    </c:choose>
    <label>Value IRI</label>
    <input type="text" class="form-control" value="${annotation.valueIRI}" name="${valueIRIPath}"
           placeholder="Value IRI">

    <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(valueIRIPath)}" var="message">
        <span class="error-color">${message.text}</span>
    </c:forEach>
    </div>

<c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
    <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
        <span class="error-color">${message.text}</span>
    </c:forEach>
    </div>
</c:if>


<%--</div>--%>

<c:if test="${showRemoveButton}">
    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-remove", function () {
                clearAndHideEditControlGroup(this);
                // $(this).parent(".control-group").remove();
                <%--$(".${specifier}-add-annotation").show();--%>
                $("#${specifier}-add-annotation").show();
            });

        });
    </script>
</c:if>
