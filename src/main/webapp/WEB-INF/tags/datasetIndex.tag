<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


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
            <li><a href="${flowExecutionUrl}&_eventId=identifier">Identifier</a></li>
            <li><a href="${flowExecutionUrl}&_eventId=title">Title</a></li>
            <li><a href="${flowExecutionUrl}&_eventId=description">Description</a></li>
            <li><a href="${flowExecutionUrl}&_eventId=dates">Dates</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=storedIn">Stored In</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=spatialCoverage">Spatial Coverage</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=types">Types</a></li>
            <li><a href="${flowExecutionUrl}&_eventId=availability">Availability</a></li>
            <li><a href="${flowExecutionUrl}&_eventId=refinement">Refinement</a></li>
            <li><a href="${flowExecutionUrl}&_eventId=aggregation">Aggregation</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=distributions">Distributions</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=primaryPublications">Primary Publications</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=citations">Citations</a></li>
            <li><a href="${flowExecutionUrl}&_eventId=citationCount">Citation Count</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=producedBy">Produced By</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=creators">Creators</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=licenses">Licenses</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=isAbout">Is About</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=acknowledges">Acknowledges</a></li>

            <li><a href="${flowExecutionUrl}&_eventId=version">Version</a></li>
            <li><a href="${flowExecutionUrl}&_eventId=extraProperties">Extra Properties</a></li>
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