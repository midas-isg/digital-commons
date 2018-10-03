<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@attribute name="active" type="java.lang.String" required="true" %>

<!-- Sidebar Holder -->

<nav id="sidebar">
    <ul class="list-unstyled components">
        <p class="font-size-20">FAIR Metrics Descriptions</p>
        <c:forEach items="${keys}" var="key">
            <li <c:if test="${active == key}">class="active"</c:if>><a
                    href="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=${key}">${key}</a></li>
        </c:forEach>

    </ul>
</nav>

<script type="text/javascript">
    $(document).ready(function () {
        $('#sidebarCollapse').click(function () {
            $('#sidebar, #entryFormContent').toggleClass('active');
        });
    });
</script>
