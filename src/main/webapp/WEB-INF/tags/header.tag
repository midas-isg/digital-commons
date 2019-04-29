<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="pageTitle" type="java.lang.String" %>
<%@ attribute name="subTitle" type="java.lang.String" %>
<%@ attribute name="loggedIn" type="java.lang.Boolean" %>
<%@ attribute name="adminType" type="java.lang.String" %>
<%@ attribute name="addEntry" type="java.lang.Boolean" %>

<div class="spacer">

    <nav class="navbar fixed-top navbar-expand-lg navbar-dark  flex-md-row bg-navbar py-0  py-md-0">
        <button type="button" onclick="location.href = '${pageContext.request.contextPath}/main'" class="navbar-brand btn btn-outline-light no-opacity">mdc</button>
        <%--<a class="navbar-brand" href="${pageContext.request.contextPath}">--%>
            <%--<img src="${pageContext.request.contextPath}/resources/img/midas-logo-gray-small_smaller.png" height="50" class="d-inline-block align-top" alt="">--%>
        <%--</a>--%>
        <h5 id="page-title"
            class="leaf">Digital Commons</h5>


        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavDropdown">
            <c:choose>
                <c:when test="${addEntry == true}">
                    <myTags:navBar contextPath="${pageContext.request.contextPath}"
                                   mainPath="${pageContext.request.contextPath}/main"
                                   dataToggle=""></myTags:navBar>
                </c:when>
                <c:otherwise>
                    <myTags:navBar contextPath="${pageContext.request.contextPath}" mainPath=""
                                   dataToggle="tab"></myTags:navBar>
                </c:otherwise>
            </c:choose>

        </div>
    </nav>
</div>

<script>
    $('.nav-link').on('click',function() {
        if(!$(this).prop('className').split(' ').includes("dropdown-toggle")) {
            $('.navbar-collapse').collapse('hide');
        }
    });
    $(window).on("resize", function () {
        var maxWidthLarge;
        var maxWidthMedium;
        var maxWidthSmall;

        <c:choose>
        <c:when test="${loggedIn == true}">
        maxWidthLarge = 1350;
        maxWidthMedium = 1230;
        maxWidthSmall = 992;
        </c:when>
        <c:otherwise>
        maxWidthLarge = 1110;
        maxWidthMedium = 810;
        maxWidthSmall = 810;
        </c:otherwise>
        </c:choose>

        // if ($(window).width() < maxWidthLarge) {
        //     hideTitle('page-title-big');
        // } else {
        //     showTitle('page-title-big');
        // }
        //
        // if ($(window).width() >= maxWidthMedium && $(window).width() < maxWidthLarge) {
        //     showTitle('page-title');
        // } else {
        //     hideTitle('page-title');
        // }
        //
        // if ($(window).width() < maxWidthSmall) {
        //     showTitle('page-title');
        // }
    }).resize();

    function hideTitle(title) {
        var d = document.getElementById(title);
        d.classList.remove('visible');
        d.classList.add('hidden');
    }

    function showTitle(title) {
        var d = document.getElementById(title);
        d.classList.remove('hidden');
        d.classList.add('visible');
    }
</script>