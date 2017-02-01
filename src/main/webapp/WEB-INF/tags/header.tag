<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="pageTitle" type="java.lang.String" %>
<%@ attribute name="subTitle" type="java.lang.String" %>
<%@ attribute name="loggedIn" type="java.lang.Boolean" %>
<%@ attribute name="wantCollapse" type="java.lang.Boolean" %>
<%@ attribute name="iframe" type="java.lang.Boolean" %>
<%@ attribute name="pub" type="edu.pitt.isg.dc.digital.dap.DataAugmentedPublication" %>

    <c:if test="${iframe != true}">
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
                        <ul class="nav navbar-nav navbar-padding tabs">
                            <li class="active "><a class="leaf font-size-20 padding-top-30" data-toggle="tab"
                                                   href="#browse">Browse</a></li>
                            <li><a class="leaf font-size-20 padding-top-30 " data-toggle="tab" href="#search">Search</a>
                            <li><a class="leaf font-size-20 padding-top-30 " data-toggle="tab" href="#about">About</a></li>
                            <c:forEach items="${dataAugmentedPublications}" var="pub" varStatus="loop">
                                <li class="hidden"><a class="leaf font-size-20 padding-top-30 " data-toggle="tab" href="#publication-${pub.paper.id}-${pub.data.id}">About</a></li>
                            </c:forEach>
                        </ul>
                    </c:if>
                    <%--<ul class="nav navbar-nav navbar-right">--%>
                        <%--<c:if test="${loggedIn == true}">--%>
                            <%--<c:set var="urlLevel" value="${pageContext.request.contextPath}/logout"/>--%>
                        <%--<form class="navbar-form" action="${urlLevel}" method="GET">--%>
                            <%--<button type="submit" class="btn btn-default margin-top-13">Logout</button>--%>
                        <%--</form>--%>
                        <%--</c:if>--%>
                        <%--<c:if test="${iframe == true}">
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
                        </c:if>--%>
                    <%--</ul>--%>
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
                    <span class="">Open external site</span>
                    <icon class="glyphicon glyphicon-chevron-right"></icon>
                </a>
            </div>

            <div style="margin-top:5px; margin-right:5px; position:absolute; left:40%">
                <span class="leaf hidden-xs">MIDAS SSO-enabled site</span>
            </div>

            <div class="pull-left leaf" style="margin-top:5px; margin-left:5px">
                <a class="leaf" href="${pageContext.request.contextPath}/main">
                    <icon class="glyphicon glyphicon-chevron-left"></icon>
                    <span class="">Back to Digital Commons</span>
                </a>
            </div>
        </div>
        <%--<style>
            .navbar-xs { min-height:22px; border-radius:0; background-color:#0c2b65;}
            .navbar-xs .navbar-brand{ padding: 2px 8px;font-size: 14px;line-height: 14px; }
            .navbar-xs .navbar-nav > li > a { border-right:1px solid #ddd; padding-top: 1px; padding-bottom: 2px; line-height: 16px }
        </style>
        <div class="spacer-small">
        <nav class="navbar navbar-default navbar-xs" role="navigation" style="max-height: 30px;">
            <!-- Brand and toggle get grouped for better mobile display -->
            <!--<div class="navbar-header">
                <a class="leaf margin-top-13" href="${pageContext.request.contextPath}/main">
                    <icon class="glyphicon glyphicon-chevron-left"></icon>
                    Back to Digital Commons
                </a>
                <a class="leaf margin-top-13" href="#" onclick="loadExternalSite()">Open external site
                    <icon class="glyphicon glyphicon-chevron-right"></icon>
                </a>
            </div>-->
            <ul class="nav navbar-nav navbar-left" style="margin-left:1px !important">
                <li>
                    <a style="border-right:none !important" class="leaf" href="${pageContext.request.contextPath}/main">
                        <icon class="glyphicon glyphicon-chevron-left"></icon>
                        <span class="hidden-xs">Back to Digital Commons</span>
                    </a>
                </li>
            </ul>
            <ul class="nav navbar-nav">
                <li class="leaf" style="position:absolute;left:43%;">
                    MIDAS SSO-enabled site
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right" style="margin-right:1px !important">
                <li>
                    <a style="border-right:none !important" class="leaf" href="#" onclick="loadExternalSite()">
                        <span class="hidden-xs">Open external site</span>
                        <icon class="glyphicon glyphicon-chevron-right"></icon>
                    </a>
                </li>
            </ul>
        </nav>
        </div>--%>
    </c:if>

<script>
    function loadExternalSite() {
        window.open(document.getElementById("libraryFrame").src);
    }

</script>