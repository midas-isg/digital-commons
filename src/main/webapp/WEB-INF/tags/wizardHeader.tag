<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ attribute name="showCategories" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="wantLoader" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isControl" required="false"
              type="java.lang.Boolean" %>

<myTags:categoryLineage lineage="${categoryName}" hasSidebar="${true}" isControl="${isControl}"/>

<c:if test="${wantLoader}">
    <div class="loading ">
        <div class="loading-wheel"></div>
    </div>
</c:if>


<c:choose>
    <c:when test="${showCategories}">
        <br>
        <myTags:editCategory selectedID="${categoryID}"
                             categoryPaths="${categoryPaths}">
        </myTags:editCategory>
        <input hidden id="categoryID" name="categoryID" value="${categoryID}" type="number">
    </c:when>
</c:choose>

<script>
    $(document).ready(function () {
        $("#categoryValue").change(function () {
            var categoryValue = $(this).val();
            $("#categoryID").val(categoryValue)
            <%--$("#entry-form").attr("action", "${flowExecutionUrl}&_eventId=next&categoryID=" + action);--%>
        });

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