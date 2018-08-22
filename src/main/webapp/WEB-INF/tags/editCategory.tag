<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="categoryPaths" required="false"
              type="java.util.Map" %>
<%@ attribute name="selectedID" required="false"
              type="java.lang.Integer" %>
<%@ attribute name="isDisabled" required="false"
              type="java.lang.Boolean" %>

<div class="form-group control-group col-md-9 col-sm-12 no-padding full-width <c:if
        test="${ not empty flowRequestContext.messageContext.getMessagesBySource('category')}">has-error</c:if>">
    <label class="item-label">Category</label>
    <select <c:if test="${isDisabled}">disabled</c:if> class="custom-select " name="category" id="categoryValue">
            <option value="0">Please Select...</option>
            <c:forEach items="${categoryPaths}" var="categoryPath">
                <c:choose>
                    <c:when test="${categoryPath.key==0}">
                        <option selected value="${categoryPath.key}">${categoryPath.value}</option>
                    </c:when>
                    <c:when test="${categoryPath.key==selectedID}">
                        <option selected value="${categoryPath.key}">${categoryPath.value}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${categoryPath.key}">${categoryPath.value}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
    <c:if test="${ not empty flowRequestContext.messageContext.getMessagesBySource('category')}">
        <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource('category')}" var="message">
            <span class="error-color">${message.text}</span>
        </c:forEach>
    </c:if>
</div>
