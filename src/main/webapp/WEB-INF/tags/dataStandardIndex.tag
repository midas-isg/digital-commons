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
                <li><a href="#" onclick="submitForm('name')">Name</a></li>
                <li><a href="#" onclick="submitForm('description')">Description</a></li>
                <li><a href="#" onclick="submitForm('version')">Version</a></li>
                <li><a href="#" onclick="submitForm('type')">Type</a></li>
                <li><a href="#" onclick="submitForm('identifier')">Identifier</a></li>
                <li><a href="#" onclick="submitForm('alternateIdentifiers')">Alternate Identifiers</a></li>
                <li><a href="#" onclick="submitForm('license')">License</a></li>
                <li><a href="#" onclick="submitForm('extraProperties')">Extra Properties</a></li>
            </ul>
        </li>
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
