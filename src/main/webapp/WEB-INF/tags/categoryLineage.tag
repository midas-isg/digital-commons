<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ attribute name="lineage" required="true"
              type="java.util.ArrayList" %>


<ol class="breadcrumb">

    <c:forEach items="${lineage}" var="category" varStatus="status">
        <c:choose>
            <c:when test="${status.first}">
                <li><i class="fa fa-home"></i></li>
            </c:when>
            <c:otherwise>
                <li>${category}</li>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</ol>