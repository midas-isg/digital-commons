<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ attribute name="showCategories" required="false"
              type="java.lang.Boolean" %>

<myTags:categoryLineage lineage="${categoryName}"/>

<c:choose>
    <c:when test="${showCategories}">
        <myTags:editCategory selectedID="${categoryID}"
                             categoryPaths="${categoryPaths}">
        </myTags:editCategory>
    </c:when>
</c:choose>