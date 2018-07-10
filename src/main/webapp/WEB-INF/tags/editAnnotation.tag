<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="annotation" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Annotation" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="showRemoveButton" required="true"
              type="java.lang.Boolean" %>
<%@attribute name="supportError" required="false" type="java.lang.Boolean" %>

<%--<div class="form-group control-group edit-form-group">--%>
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
    <c:choose>
        <c:when test="${supportError}">
            <spring:bind path="${path}.valueIRI">
                <div class="form-group edit-form-group  ${status.error ? 'has-error' : ''}">
                    <label>Value IRI</label>
                    <input type="text" class="form-control" value="${annotation.valueIRI}" name="${path}.valueIRI"
                           placeholder="Value IRI">
                </div>
                <form:errors path="${path}.valueIRI" class="error-color"/>
            </spring:bind>
        </c:when>
        <c:otherwise>
            <div class="form-group edit-form-group">
                <label>Value IRI</label>
                <input type="text" class="form-control" value="${annotation.valueIRI}" name="${path}.valueIRI"
                       placeholder="Value IRI">
            </div>
        </c:otherwise>
    </c:choose>
<%--</div>--%>

<c:if test="${showRemoveButton}">
    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-remove", function () {
                $(this).parent(".control-group").remove();
                <%--$(".${specifier}-add-annotation").show();--%>
                $("#${specifier}-add-annotation").show();
            });

        });
    </script>
</c:if>
