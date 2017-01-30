<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="pageTitle" type="java.lang.String" %>
<%@ attribute name="subTitle" type="java.lang.String" %>
<%@ attribute name="loggedIn" type="java.lang.Boolean" %>
<%@ attribute name="wantCollapse" type="java.lang.Boolean" %>
<%@ attribute name="iframe" type="java.lang.Boolean" %>

<div class="spacer">
    <nav class="navbar navbar-default navbar-fixed-top" id="header">
        <div class="main-nav container-fluid ">
            <div class="navbar-header">
                <c:if test="${wantCollapse == true}">
                    <button type="button" class="navbar-toggle collapsed margin-top-22" data-toggle="collapse"
                            data-target="#navbar-collapse" aria-expanded="false">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                </c:if>

                <a href="${pageContext.request.contextPath}">
                    <img alt="MIDAS" class="navbar-brand-mod hidden-md hidden-lg"
                         src="${pageContext.request.contextPath}/resources/img/midas-logo-gray-small_4.png"></a>
                <h4 class="leaf inline-block hidden-md hidden-lg margin-top-30">${pageTitle}</h4>
            </div>

            <div class="nav navbar-nav hidden-xs hidden-sm">
                <a href="${pageContext.request.contextPath}">
                    <img alt="MIDAS" class="navbar-brand-mod"
                         src="${pageContext.request.contextPath}/resources/img/midas-logo-gray-small_4.png"></a>
                <h1 class="leaf inline-block">${pageTitle}</h1>
            </div>

            <div class="collapse navbar-collapse" id="navbar-collapse">
                <c:if test="${loggedIn == true && iframe == false}">
                    <ul class="nav navbar-nav navbar-padding">
                        <li class="active "><a class="leaf font-size-20 padding-top-30" data-toggle="tab"
                                               href="#browse">Browse</a></li>
                        <li><a class="leaf font-size-20 padding-top-30 " data-toggle="tab" href="#search">Search</a>
                        <li><a class="leaf font-size-20 padding-top-30 " href="${pageContext.request.contextPath}/main/about">About</a>
                        </li>
                    </ul>
                </c:if>
                <ul class="nav navbar-nav navbar-right">
                    <c:if test="${loggedIn == true}">
                        <c:set var="urlLevel" value="${pageContext.request.contextPath}/logout"/>
                    <form class="navbar-form" action="${urlLevel}" method="GET">
                        <button type="submit" class="btn btn-default margin-top-13">Logout</button>
                    </form>
                    </c:if>
                    <c:if test="${iframe == true}">
                    <li>
                        <a class="leaf margin-top-13" href="${pageContext.request.contextPath}/main">
                            <icon class="glyphicon glyphicon-chevron-left"></icon>
                            Back to Digital Commons
                        </a>
                    </li>
                    <li>
                        <a class="leaf margin-top-13" href="#" onclick="loadExternalSite()">Open external site
                            <icon class="glyphicon glyphicon-chevron-right"></icon>
                        </a>
                    </li>
                    </c:if>

            </div>

            </ul>
        </div><!-- /.container-fluid -->
    </nav>
</div>

<c:if test="${not empty subTitle}">
    <h2 class="title-font" id="subtitle">
            ${subTitle}
    </h2>
</c:if>

<script>
    function loadExternalSite() {
        window.open(document.getElementById("libraryFrame").src);
    }

</script>