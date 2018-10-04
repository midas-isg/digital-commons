<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@attribute name="active" type="java.lang.String" required="true" %>

<!-- Sidebar Holder -->

<nav id="sidebar">
    <ul class="list-unstyled components">
        <li <c:if test="${active == 'basic'}">class="active"</c:if>><a href="#basicSubmenu" onclick="event.preventDefault();" data-toggle="collapse"
                                                                       aria-expanded="false" class="dropdown-toggle">Basic
            Info</a>

            <ul class="collapse list-unstyled" id="basicSubmenu">
                <li><a href="#" onclick="submitForm('title')">Title</a></li>
                <li><a href="#" onclick="submitForm('description')">Description</a></li>
                <li><a href="#" onclick="submitForm('identifier')">Identifier</a></li>
                <li><a href="#" onclick="submitForm('dates')">Dates</a></li>
            </ul>
        </li>

        <li <c:if test="${active == 'storedIn'}">class="active"</c:if>><a href="#" onclick="submitForm('storedIn')">Stored
            In</a></li>

        <li <c:if test="${active == 'spatialCoverage'}">class="active"</c:if>><a href="#"
                                                                                 onclick="submitForm('spatialCoverage')">Spatial
            Coverage</a></li>

        <li <c:if test="${active == 'types'}">class="active"</c:if>><a href="#typesSubmenu" onclick="event.preventDefault();" data-toggle="collapse"
                                                                       aria-expanded="false"
                                                                       class="dropdown-toggle">Types</a>
            <ul class="collapse list-unstyled" id="typesSubmenu">
                <li><a href="#" onclick="submitForm('types')">Types</a></li>
                <li><a href="#" onclick="submitForm('availability')">Availability</a></li>
                <li><a href="#" onclick="submitForm('refinement')">Refinement</a></li>
                <li><a href="#" onclick="submitForm('aggregation')">Aggregation</a></li>
            </ul>
        </li>

        <li <c:if test="${active == 'distributions'}">class="active" </c:if>><a href="#"
                                                                                onclick="submitForm('distributions')">Distributions</a>
        </li>

        <li <c:if test="${active == 'primaryPublications'}">class="active"</c:if>><a href="#"
                                                                                     onclick="submitForm('primaryPublications')">Primary
            Publications</a></li>

        <li <c:if test="${active == 'citation'}">class="active"</c:if> >
            <a href="#citationSubmenu"
               data-toggle="collapse"
               aria-expanded="false"
               class="dropdown-toggle">Citation</a>
            <ul class="collapse list-unstyled" id="citationSubmenu">
                <li><a href="#" onclick="submitForm('citationCount')">Citation Count</a></li>
                <li><a href="#" onclick="submitForm('citations')">Citations</a></li>
            </ul>
        </li>

        <li <c:if test="${active == 'producedBy'}">class="active"</c:if> ><a href="#"
                                                                                 onclick="submitForm('producedBy')">Produced
            By</a></li>


        <li <c:if test="${active == 'creators'}">class="active"</c:if> ><a href="#"
                                                                               onclick="submitForm('creators')">Creators</a>
        </li>


        <li <c:if test="${active == 'licenses'}">class="active"</c:if> ><a href="#"
                                                                               onclick="submitForm('licenses')">Licenses</a>
        </li>


        <li <c:if test="${active == 'isAbout'}">class="active"</c:if> ><a href="#" onclick="submitForm('isAbout')">Is
            About</a></li>


        <li <c:if test="${active == 'acknowledges'}">class="active"</c:if> ><a href="#"
                                                                                   onclick="submitForm('acknowledges')">Acknowledges</a>
        </li>

        <li <c:if test="${active == 'extra'}">class="active"</c:if> ><a href="#extraSubmenu" onclick="event.preventDefault();" data-toggle="collapse"
                                                                            aria-expanded="false"
                                                                            class="dropdown-toggle">Extra Properties</a>
        </li>
        <ul class="collapse list-unstyled" id="extraSubmenu">
            <li><a href="#" onclick="submitForm('version')">Version</a></li>
            <li><a href="#" onclick="submitForm('extraProperties')">Extra Properties</a></li>
        </ul>
    </ul>
</nav>

<script type="text/javascript">
    $(document).ready(function () {
        $('#sidebarCollapse').click(function () {
            $('#sidebar, #entryFormContent').toggleClass('active');
        });
    });

    function submitForm(indexValue) {
        window.onbeforeunload = null;

        $("#entry-form").attr("action", "${flowExecutionUrl}&_eventId=index&indexValue=" + indexValue);
        document.getElementById("entry-form").submit();
    }
</script>
