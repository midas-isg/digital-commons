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
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@attribute name="supportError" required="false" type="java.lang.Boolean" %>

<div class="form-group control-group edit-form-group">

<c:choose>
    <c:when test="${supportError}">
        <spring:bind path="${path}">
            <div class="form-group edit-form-group ${status.error ? 'has-error' : ''}">
                <label>${label}</label>
                    <div class="form-group edit-form-group">
                        <label>Value</label>
                        <input type="text" class="form-control" value="${annotation.value}" name="${path}.value" placeholder=" Value">
                    </div>
                    <spring:bind path="${path}.valueIRI">
                        <div class="form-group edit-form-group ${status.error ? 'has-error' : ''}">
                            <label>Value IRI</label>
                            <input type="text" class="form-control" value="${annotation.valueIRI}" name="${path}.valueIRI" placeholder="Value IRI">
                            <form:errors path="${path}.valueIRI" class="error-color"/>
                        </div>
                    </spring:bind>
                    <form:errors path="${path}" class="error-color"/>
            </div>
        </spring:bind>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group edit-form-group">
                <label>Value</label>
                <input type="text" class="form-control" value="${annotation.value}" name="${path}.value" placeholder="Value">
            </div>
            <div class="form-group edit-form-group">
                <label>Value IRI</label>
                <input type="text" class="form-control" value="${annotation.valueIRI}" name="${path}.valueIRI" placeholder="Value IRI">
            </div>
        </div>
    </c:otherwise>
</c:choose>
</div>