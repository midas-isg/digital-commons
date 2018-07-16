<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@attribute name="active" type="java.lang.String" required="true" %>


<button type="button" id="sidebarCollapse" class="btn btn-info navbar-btn">
    <i class="glyphicon glyphicon-align-left"></i>
    <span>Toggle Sidebar</span>
</button>

<!-- Sidebar Holder -->
<div class="wrapper">

    <nav id="sidebar">
        <div class="sidebar-header">
            <h3></h3>
        </div>

        <ul class="list-unstyled components">
            <c:choose>
                <c:when test="${active == 'basic'}">
                    <li class="active"><a href="#basicSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Basic Info</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#basicSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Basic Info</a></li>
                </c:otherwise>
            </c:choose>
            <ul class="collapse list-unstyled" id="basicSubmenu">
                <li><a href="${flowExecutionUrl}&_eventId=identifier">Identifier</a></li>
                <li><a href="${flowExecutionUrl}&_eventId=title">Title</a></li>
                <li><a href="${flowExecutionUrl}&_eventId=description">Description</a></li>
                <li><a href="${flowExecutionUrl}&_eventId=dates">Dates</a></li>
            </ul>

            <%--<li><a href="${flowExecutionUrl}&_eventId=identifier">Identifier</a></li>--%>
            <%--<li><a href="${flowExecutionUrl}&_eventId=title">Title</a></li>--%>
            <%--<li><a href="${flowExecutionUrl}&_eventId=description">Description</a></li>--%>
            <%--<li><a href="${flowExecutionUrl}&_eventId=dates">Dates</a></li>--%>

            <c:choose>
                <c:when test="${active == 'storedIn'}">
                    <li class="active"><a href="${flowExecutionUrl}&_eventId=storedIn">Stored In</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${flowExecutionUrl}&_eventId=storedIn">Stored In</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'spatialCoverage'}">
                    <li class="active"><a href="${flowExecutionUrl}&_eventId=spatialCoverage">Spatial Coverage</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${flowExecutionUrl}&_eventId=spatialCoverage">Spatial Coverage</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'types'}">
                    <li class="active"><a href="#typesSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Types</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#typesSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Types</a></li>
                </c:otherwise>
            </c:choose>
            <ul class="collapse list-unstyled" id="typesSubmenu">
                <li><a href="${flowExecutionUrl}&_eventId=types">Types</a></li>
                <li><a href="${flowExecutionUrl}&_eventId=availability">Availability</a></li>
                <li><a href="${flowExecutionUrl}&_eventId=refinement">Refinement</a></li>
                <li><a href="${flowExecutionUrl}&_eventId=aggregation">Aggregation</a></li>
            </ul>
            <%--<li><a href="${flowExecutionUrl}&_eventId=types">Types</a></li>--%>
            <%--<li><a href="${flowExecutionUrl}&_eventId=availability">Availability</a></li>--%>
            <%--<li><a href="${flowExecutionUrl}&_eventId=refinement">Refinement</a></li>--%>
            <%--<li><a href="${flowExecutionUrl}&_eventId=aggregation">Aggregation</a></li>--%>

            <c:choose>
                <c:when test="${active == 'distributions'}">
                    <li class="active"><a href="${flowExecutionUrl}&_eventId=distributions">Distributions</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${flowExecutionUrl}&_eventId=distributions">Distributions</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'primaryPublications'}">
                    <li class="active"><a href="${flowExecutionUrl}&_eventId=primaryPublications">Primary Publications</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${flowExecutionUrl}&_eventId=primaryPublications">Primary Publications</a></li>
                </c:otherwise>
            </c:choose>


            <c:choose>
                <c:when test="${active == 'citation'}">
                    <li class="active"><a href="#citationSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Citation</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#citationSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Citation</a></li>
                </c:otherwise>
            </c:choose>
            <ul class="collapse list-unstyled" id="citationSubmenu">
                <li><a href="${flowExecutionUrl}&_eventId=citations">Citations</a></li>
                <li><a href="${flowExecutionUrl}&_eventId=citationCount">Citation Count</a></li>
            </ul>
            <%--<li><a href="${flowExecutionUrl}&_eventId=citations">Citations</a></li>--%>
            <%--<li><a href="${flowExecutionUrl}&_eventId=citationCount">Citation Count</a></li>--%>

            <c:choose>
                <c:when test="${active == 'producedBy'}">
                    <li class="active"><a href="${flowExecutionUrl}&_eventId=producedBy">Produced By</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${flowExecutionUrl}&_eventId=producedBy">Produced By</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'creators'}">
                    <li class="active"><a href="${flowExecutionUrl}&_eventId=creators">Creators</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${flowExecutionUrl}&_eventId=creators">Creators</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'licenses'}">
                    <li class="active"><a href="${flowExecutionUrl}&_eventId=licenses">Licenses</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${flowExecutionUrl}&_eventId=licenses">Licenses</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'isAbout'}">
                    <li class="active"><a href="${flowExecutionUrl}&_eventId=isAbout">Is About</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${flowExecutionUrl}&_eventId=isAbout">Is About</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'acknowledges'}">
                    <li class="active"><a href="${flowExecutionUrl}&_eventId=acknowledges">Acknowledges</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${flowExecutionUrl}&_eventId=acknowledges">Acknowledges</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'extra'}">
                    <li class="active"><a href="#extraSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Extra Properties</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#extraSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Extra Properties</a></li>
                </c:otherwise>
            </c:choose>
            <ul class="collapse list-unstyled" id="extraSubmenu">
                <li><a href="${flowExecutionUrl}&_eventId=version">Version</a></li>
                <li><a href="${flowExecutionUrl}&_eventId=extraProperties">Extra Properties</a></li>
            </ul>
            <%--<li><a href="${flowExecutionUrl}&_eventId=version">Version</a></li>--%>
            <%--<li><a href="${flowExecutionUrl}&_eventId=extraProperties">Extra Properties</a></li>--%>
        </ul>
    </nav>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $("#sidebar").mCustomScrollbar({
            theme: "minimal"
        });

        $('#sidebarCollapse').on('click', function () {
            $('#sidebar, #content').toggleClass('active');
            $('.collapse.in').toggleClass('in');
            $('a[aria-expanded=true]').attr('aria-expanded', 'false');
        });
    });
</script>