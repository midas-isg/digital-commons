<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="checked" required="false"
              type="java.lang.Boolean" %>

<div class="form-group edit-form-group">
    <label>${label}</label>
    <c:choose>
        <c:when test="${checked == true}">
            <input type="checkbox" name="${path}" checked>
        </c:when>
        <c:otherwise>
            <input type="checkbox" name="${path}">
        </c:otherwise>
    </c:choose>
</div>


