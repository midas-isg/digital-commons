<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>
<%@ attribute name="string" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>

<%--<spring:bind path="${path}">--%>
    <div class="form-group edit-form-group">
        <label>${label}</label>
        <%--<form:input path="${path}" value="" type="text" class="form-control" placeholder="${placeholder}"></form:input>--%>
        <c:choose>
            <c:when test="${not empty string}">
                <input name="${path}" type="text" value="${string}" class="form-control" placeholder="${placeholder}">
            </c:when>
            <c:otherwise>
                <input type="text" class="form-control" name="${path}" placeholder="${placeholder}"/>
            </c:otherwise>
        </c:choose>
        <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="err">
            <span class="error-color">${err.text}</span>
        </c:forEach>
        <%--<form:errors path="${path}" class="error-color"/>--%>
    </div>
<%--</spring:bind>--%>
