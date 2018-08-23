<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ attribute name="lineage" required="true"
              type="java.util.List" %>


<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <c:forEach items="${lineage}" var="category" varStatus="varStatus">
            <c:choose>
                <c:when test="${varStatus.first}">
                    <c:choose>
                        <c:when test="${category == 'Root'}">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/main"><i
                                    class="fa fa-home"></i></a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="breadcrumb-item">${category}</li>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:when test="${varStatus.last}">
                    <li class="breadcrumb-item active">${category}</li>
                </c:when>
                <c:otherwise>
                    <li class="breadcrumb-item">${category}</li>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </ol>
</nav>