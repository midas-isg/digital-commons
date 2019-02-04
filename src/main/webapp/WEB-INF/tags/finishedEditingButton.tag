<%@ taglib tagdir="/WEB-INF/tags/webflow" prefix="webflowTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ attribute name="wantLoader" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isControl" required="false"
              type="java.lang.Boolean" %>

<c:choose>
    <c:when test="${isLastPage}">
        <input type="submit" onclick="window.onbeforeunload = null;" name="_eventId_submit" class="btn btn-default pull-right" value="
            <c:choose>
                <c:when test="${editing}">
                    Finished Editing
                </c:when>
                <c:otherwise>
                    Add New Entry
                </c:otherwise>
            </c:choose>
        ">

    </c:when>
    <c:otherwise>
        <c:if test="${editing}">
            <button class="btn btn-default float-right" onclick="finishEditing()">Finished Editing</button>
            <br>
        </c:if>
    </c:otherwise>
</c:choose>


<script>
    function finishEditing(indexValue) {
        window.onbeforeunload = null;

        $("#entry-form").attr("action", "${flowExecutionUrl}&_eventId=index&indexValue=submit");
        document.getElementById("entry-form").submit();
    }
</script>