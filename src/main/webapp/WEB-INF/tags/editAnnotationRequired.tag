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

<c:choose>
    <c:when test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
        <div class="form-group control-group edit-form-group has-error">
    </c:when>
    <c:otherwise>
        <div class="form-group control-group edit-form-group">
    </c:otherwise>
</c:choose>

    <div class="form-group edit-form-group">
        <label>${label}</label>
        <div class="form-group edit-form-group">
            <label>Value</label>
            <input type="text" class="form-control" value="${annotation.value}" name="${path}.value"
                   placeholder=" Value">
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
    </div>

        <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
            <span class="error-color">${message.text}</span>
        </c:forEach>
</div>
