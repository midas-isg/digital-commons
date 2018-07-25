<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@attribute name="active" type="java.lang.String" required="true" %>


<button type="button" id="sidebarCollapse" class="btn btn-info navbar-btn hidden-xs">
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
                <li><a href="#" onclick="submitForm('identifier')">Identifier</a></li>
                <li><a href="#" onclick="submitForm('title')">Title</a></li>
                <li><a href="#" onclick="submitForm('description')">Description</a></li>
                <li><a href="#" onclick="submitForm('dates')">Dates</a></li>
            </ul>

            <c:choose>
                <c:when test="${active == 'storedIn'}">
                    <li class="active"><a href="#" onclick="submitForm('storedIn')">Stored In</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#" onclick="submitForm('storedIn')">Stored In</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'spatialCoverage'}">
                    <li class="active"><a href="#" onclick="submitForm('spatialCoverage')">Spatial Coverage</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#" onclick="submitForm('spatialCoverage')">Spatial Coverage</a></li>
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
                <li><a href="#" onclick="submitForm('types')">Types</a></li>
                <li><a href="#" onclick="submitForm('availability')">Availability</a></li>
                <li><a href="#" onclick="submitForm('refinement')">Refinement</a></li>
                <li><a href="#" onclick="submitForm('aggregation')">Aggregation</a></li>
            </ul>

            <c:choose>
                <c:when test="${active == 'distributions'}">
                    <li class="active"><a href="#" onclick="submitForm('distributions')">Distributions</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#" onclick="submitForm('distributions')">Distributions</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'primaryPublications'}">
                    <li class="active"><a href="#" onclick="submitForm('primaryPublications')">Primary Publications</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#" onclick="submitForm('primaryPublications')">Primary Publications</a></li>
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
                <li><a href="#" onclick="submitForm('citations')">Citations</a></li>
                <li><a href="#" onclick="submitForm('citationCount')">Citation Count</a></li>
            </ul>

            <c:choose>
                <c:when test="${active == 'producedBy'}">
                    <li class="active"><a href="#" onclick="submitForm('producedBy')">Produced By</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#" onclick="submitForm('producedBy')">Produced By</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'creators'}">
                    <li class="active"><a href="#" onclick="submitForm('creators')">Creators</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#" onclick="submitForm('creators')">Creators</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'licenses'}">
                    <li class="active"><a href="#" onclick="submitForm('licenses')">Licenses</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#" onclick="submitForm('licenses')">Licenses</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'isAbout'}">
                    <li class="active"><a href="#" onclick="submitForm('isAbout')">Is About</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#" onclick="submitForm('isAbout')">Is About</a></li>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${active == 'acknowledges'}">
                    <li class="active"><a href="#" onclick="submitForm('acknowledges')">Acknowledges</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="#" onclick="submitForm('acknowledges')">Acknowledges</a></li>
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
                <li><a href="#" onclick="submitForm('version')">Version</a></li>
                <li><a href="#" onclick="submitForm('extraProperties')">Extra Properties</a></li>
            </ul>
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
    
    function submitForm(indexValue) {
        $("#entry-form").attr("action", "${flowExecutionUrl}&_eventId=index&indexValue=" + indexValue);
        document.getElementById("entry-form").submit();
    }
</script>