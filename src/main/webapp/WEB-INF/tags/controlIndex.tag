<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Sidebar Holder -->

<nav id="sidebar">
    <ul class="list-unstyled components">
        <li class="active"><a href="#">Select Category</a></li>
    </ul>
</nav>

<script type="text/javascript">
    $(document).ready(function () {
        $('#sidebarCollapse').click(function () {
            $('#sidebar, #entryFormContent').toggleClass('active');
        });
    });

</script>
