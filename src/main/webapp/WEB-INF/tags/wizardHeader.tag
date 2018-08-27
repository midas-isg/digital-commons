<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ attribute name="showCategories" required="false"
              type="java.lang.Boolean" %>

<myTags:categoryLineage lineage="${categoryName}" hasSidebar="${true}"/>

<c:choose>
    <c:when test="${showCategories}">
        <br>
        <myTags:editCategory selectedID="${categoryID}"
                             categoryPaths="${categoryPaths}">
        </myTags:editCategory>
    </c:when>
</c:choose>

<script>
    $(document).ready(function () {
        <c:if test="${not empty anchor}">
            try {
                var element_to_scroll_to = document.getElementById("${anchor}");
                element_to_scroll_to.scrollIntoView();
            } catch (e) {

            }
        </c:if>
    });

    window.onbeforeunload = function () {
        return true;
    };
</script>