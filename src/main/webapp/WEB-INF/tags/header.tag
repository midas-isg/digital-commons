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
    <nav class="navbar fixed-top navbar-expand-lg navbar-dark bg-navbar">
        <a href="${pageContext.request.contextPath}">
            <img alt="MIDAS"
                 class="navbar-brand-mod navbar-brand"
                 src="${pageContext.request.contextPath}/resources/img/midas-logo-gray-small.png">
        </a>
        <h2 id="page-title-big"
            class="leaf d-none d-lg-block">${pageTitle}</h2>
        <h5 id="page-title"
            class="leaf d-lg-none d-xl-none">${pageTitle}</h5>

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar-collapse"
                aria-controls="navbar-collapse" aria-expanded="true" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbar-collapse">
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

            <c:choose>
                <c:when test="${loggedIn == true}">
                    <c:set var="urlLevel" value="${pageContext.request.contextPath}/logout"/>
                    <form class="form-inline">
                        <button class="btn btn-outline-light my-2 my-sm-0" type="submit"
                                onclick="sessionStorage.clear();">Logout
                        </button>
                    </form>
                </c:when>
                <c:otherwise>
                    <c:set var="urlLevel" value="${pageContext.request.contextPath}/login"/>
                    <form class="form-inline">
                        <button class="btn btn-outline-light my-2 my-sm-0" type="submit"
                                onclick="sessionStorage.clear();">Log in
                        </button>
                    </form>

                </c:otherwise>
            </c:choose>
        </div>
    </nav>
</div>

<script>
    $(window).on("resize", function () {
        var maxWidthLarge;
        var maxWidthMedium;
        var maxWidthSmall;

        <c:choose>
        <c:when test="${loggedIn == true}">
        maxWidthLarge = 1350;
        maxWidthMedium = 1230;
        maxWidthSmall = 1010;
        </c:when>
        <c:otherwise>
        maxWidthLarge = 1110;
        maxWidthMedium = 810;
        maxWidthSmall = 810;
        </c:otherwise>
        </c:choose>

        if ($(window).width() < maxWidthLarge) {
            hideTitle('page-title-big');
        } else {
            showTitle('page-title-big');
        }

        if ($(window).width() >= maxWidthMedium && $(window).width() < maxWidthLarge) {
            showTitle('page-title');
        } else {
            hideTitle('page-title');
        }

        if ($(window).width() < maxWidthSmall) {
            showTitle('page-title');
        }
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