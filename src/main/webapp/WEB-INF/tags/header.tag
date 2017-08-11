<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="pageTitle" type="java.lang.String" %>
<%@ attribute name="subTitle" type="java.lang.String" %>
<%@ attribute name="loggedIn" type="java.lang.Boolean" %>
<%@ attribute name="adminType" type="java.lang.String" %>

<c:if test="${iframe != true}">
    <div class="spacer">
        <nav class="navbar navbar-default navbar-fixed-top" id="header">
            <div class="main-nav container-fluid ">
                <div class="navbar-header">
                    <button type="button"
                            class="navbar-toggle collapsed margin-top-22"
                            data-toggle="collapse"
                            data-target="#navbar-collapse"
                            aria-expanded="false">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a href="${pageContext.request.contextPath}">
                        <img alt="MIDAS"
                             class="navbar-brand-mod"
                             src="${pageContext.request.contextPath}/resources/img/midas-logo-gray-small.png"></a>
                    <h2 id="page-title-big"
                        class="leaf visible hidden-xs hidden-sm hidden-md margin-top-22">${pageTitle}</h2>
                    <h3 id="page-title"
                        class="font-size-20 leaf hidden hidden-sm hidden-md hidden-lg margin-top-30">${pageTitle}</h3>
                </div>

            <div class="collapse navbar-collapse" id="navbar-collapse">
                        <%--<myTags:navBar contextPath="${pageContext.request.contextPath}" mainPath="${pageContext.request.contextPath}/main" dataToggle=""></myTags:navBar>--%>
                        <myTags:navBar contextPath="${pageContext.request.contextPath}" adminType="${adminType}" mainPath="" dataToggle="tab"></myTags:navBar>
                <ul class="nav navbar-nav navbar-right">
                    <c:choose>
                        <c:when test="${loggedIn == true}">
                            <c:set var="urlLevel" value="${pageContext.request.contextPath}/logout"/>
                            <form class="navbar-form" action="${urlLevel}" method="GET">
                                <button type="submit" class="btn btn-default margin-top-13"
                                        onclick="sessionStorage.clear();">Logout
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <c:set var="urlLevel" value="${pageContext.request.contextPath}/login"/>
                            <form class="navbar-form" action="${urlLevel}" method="GET">
                                <button type="submit" class="btn btn-default margin-top-13"
                                        onclick="sessionStorage.clear();">Log in
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>

                </ul>
            </div>
        </div><!-- /.container-fluid -->
    </nav>
    </div>
</c:if>

<script>
    function loadExternalSite() {
        window.open(document.getElementById("libraryFrame").src);
    }

    $(window).on("resize", function () {
        var maxWidthLarge = 1300;
        var maxWidthMedium = 1186;
        var maxWidthSmall = 982;
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