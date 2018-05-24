<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="categoryPaths" required="false"
              type="java.util.Map" %>
<%@ attribute name="selectedID" required="false"
              type="java.lang.Integer" %>


<div class="form-group edit-form-group">
    <label class="item-label">Category</label>
    <div class="item-input">
        <select class="item-input-text" name="category" id="categoryValue">
            <option value="none">None provided</option>
            <c:forEach items="${categoryPaths}" var="categoryPath">
                <c:choose>
                    <c:when test="${categoryPath.key==0}"><option selected value="${categoryPath.key}">${categoryPath.value}</option></c:when>
                    <c:when test="${categoryPath.key==selectedID}">
                        <option selected value="${categoryPath.key}">${categoryPath.value}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${categoryPath.key}">${categoryPath.value}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
    </div>
    <div class="item-error" style="display: none;">Invalid</div>
</div>
