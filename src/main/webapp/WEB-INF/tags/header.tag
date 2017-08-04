<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="pageTitle" type="java.lang.String" %>
<%@ attribute name="subTitle" type="java.lang.String" %>
<%@ attribute name="loggedIn" type="java.lang.Boolean" %>
<%@ attribute name="preview" type="java.lang.Boolean" %>
<%@ attribute name="wantCollapse" type="java.lang.Boolean" %>
<%@ attribute name="iframe" type="java.lang.Boolean" %>
<%@ attribute name="addEntry" type="java.lang.Boolean" %>

<c:if test="${iframe != true}">
    <div class="spacer">
    <nav class="navbar navbar-default navbar-fixed-top" id="header">
        <div class="main-nav container-fluid ">
            <div class="navbar-header">
                <c:if test="${wantCollapse == true}">
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
                </c:if>
                <c:choose>
                    <c:when test="${preview}">
                        <a href="${pageContext.request.contextPath}/main">
                            <img alt="MIDAS"
                                 class="navbar-brand-mod"
                                 src="${pageContext.request.contextPath}/resources/img/midas-logo-gray-small.png"></a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}">
                            <img alt="MIDAS"
                                 class="navbar-brand-mod"
                                 src="${pageContext.request.contextPath}/resources/img/midas-logo-gray-small.png"></a>
                    </c:otherwise>
                </c:choose>
                <h2 id="page-title-big" class="leaf visible hidden-xs hidden-sm hidden-md margin-top-22">${pageTitle}</h2>
                <h3 id="page-title" class="font-size-20 leaf hidden hidden-sm hidden-md hidden-lg margin-top-30">${pageTitle}</h3>
            </div>

            <div class="collapse navbar-collapse" id="navbar-collapse">
                <c:if test="${loggedIn == true && iframe == false}">
                    <c:if test="${addEntry == true}">
                        <myTags:navBar contextPath="${pageContext.request.contextPath}" mainPath="${pageContext.request.contextPath}/main" dataToggle=""></myTags:navBar>
                    </c:if>
                    <c:if test="${addEntry != true}">
                        <myTags:navBar contextPath="${pageContext.request.contextPath}" mainPath="" dataToggle="tab"></myTags:navBar>
                    </c:if>
                </c:if>
                <ul class="nav navbar-nav navbar-right">
                    <c:if test="${(loggedIn == true and preview == false) and addEntry != true}">
                        <c:set var="urlLevel" value="${pageContext.request.contextPath}/logout"/>
                    <form class="navbar-form" action="${urlLevel}" method="GET">
                        <button type="submit" class="btn btn-default margin-top-13" onclick="sessionStorage.clear();">Logout</button>
                    </form>
                    </c:if>
                </ul>
            </div>
        </div><!-- /.container-fluid -->
    </nav>
    </div>
</c:if>
<c:if test="${iframe == true}">
    <div class="spacer-small"></div>

    <div style="height:30px; width:100%; background-color:#0c2b65; position:fixed; top:0">
        <div class="pull-right" style="margin-top:5px; margin-right:5px">
            <a class="leaf" href="#" onclick="loadExternalSite()">
                <span class="hidden-extra-xs">Open external site</span>
                <icon class="glyphicon glyphicon-chevron-right"></icon>
            </a>
        </div>

        <div style="margin-top:5px; margin-right:5px; position:absolute; left:40%">
            <span class="leaf hidden-xs">MIDAS SSO-enabled site</span>
        </div>

        <div class="pull-left leaf" style="margin-top:5px; margin-left:5px">
            <a class="leaf" href="${pageContext.request.contextPath}/main">
                <icon class="glyphicon glyphicon-chevron-left"></icon>
                <span class="hidden-extra-xs">Back to Digital Commons</span>
            </a>
        </div>
    </div>
</c:if>

<script>
    function loadExternalSite() {
        window.open(document.getElementById("libraryFrame").src);
    }

    $(window).on("resize", function() {
        var maxWidthLarge = 1214;
        var maxWidthMedium = 1103;
        var maxWidthSmall = 882;
        if( $(window).width() < maxWidthLarge) {
            hideTitle('page-title-big');
        } else {
            showTitle('page-title-big');
        }

        if($(window).width() >= maxWidthMedium && $(window).width() < maxWidthLarge) {
            showTitle('page-title');
        } else {
            hideTitle('page-title');
        }

        if($(window).width() < maxWidthSmall) {
            showTitle('page-title');
        }
    }).resize();

    function hideTitle(title) {
        var d = document.getElementById(title);
        console.log(d);
        d.classList.remove('visible');
        d.classList.add('hidden');
    }

    function showTitle(title) {
        var d = document.getElementById(title);
        d.classList.remove('hidden');
        d.classList.add('visible');
    }
</script>