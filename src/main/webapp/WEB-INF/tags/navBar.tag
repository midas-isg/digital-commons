<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@attribute name="contextPath" type="java.lang.String" %>
<%@attribute name="mainPath" type="java.lang.String" %>
<%@attribute name="dataToggle" type="java.lang.String" %>
<%@attribute name="adminType" type="java.lang.Boolean" %>

<ul class="nav nav-tabs navbar-nav col-12" role="tablist">
    <li><a id="content-tab" class="nav-link navbar-nav-link font-size-16" data-toggle="${dataToggle}" href="${mainPath}#content">Content</a></li>
    <li class="dropdown">
        <a class="nav-link navbar-nav-link dropdown-toggle font-size-16 navbar-dropdown" href="javascript:void(0);" onclick="return false;" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Search
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
            <a class="dropdown-item" href="${contextPath}/search">Conventional DB search</a>
            <a class="dropdown-item" data-toggle="${dataToggle}" href="${mainPath}#search">Ontology-based search</a>
        </div>
    </li>
    <li><a class="nav-link navbar-nav-link font-size-16" data-toggle="${dataToggle}" href="${mainPath}#compute-platform">Compute Platform</a></li>
    <li><a class="nav-link navbar-nav-link font-size-16" data-toggle="${dataToggle}" href="${mainPath}#workflows" onclick="setTimeout(function(){drawDiagram()}, 300);">Workflows</a></li>
    <li class="dropdown">
        <a class="nav-link navbar-nav-link dropdown-toggle font-size-16 navbar-dropdown" href="javascript:void(0);" onclick="return false;" id="fairDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            FAIR Analysis
        </a>
        <div class="dropdown-menu" aria-labelledby="fairDropdown">
            <a class="dropdown-item" href="${contextPath}/fair-metrics">Fair Metrics</a>
            <a class="dropdown-item" href="http://meterdev.onbc.io/#/">FAIR-O-Meter</a>
        </div>
    </li>
    <c:if test="${adminType == 'ISG_ADMIN' or adminType == 'MDC_EDITOR'}">
        <li class="dropdown ">
            <a href="javascript:void(0);" onclick="return false;" id="add-digital-object" class="nav-link navbar-nav-link dropdown-toggle leaf font-size-16 navbar-dropdown" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Manage Digital Objects <span class="caret"></span></a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                <c:choose>
                    <c:when test="${adminType == 'ISG_ADMIN'}">
                        <h6 class="dropdown-header">Admin</h6>
                    </c:when>
                    <c:when test="${adminType == 'MDC_EDITOR'}">
                        <h6 class="dropdown-header">Edit</h6>
                    </c:when>
                </c:choose>
                <a class="dropdown-item" href="${contextPath}/add/review">Review Submissions</a>
                <div class="dropdown-divider"></div>
                <h6 class="dropdown-header">Add</h6>
                <a class="dropdown-item" href="${contextPath}/add-data-gov-record-by-id">Add Data.gov Dataset</a>
                <a class="dropdown-item" href="${contextPath}/add-digital-object">Add Digital Object</a>
            </div>
        </li>

    </c:if>
    <li class="about-tab"><a class="nav-link navbar-nav-link font-size-16 margin-right-10" data-toggle="${dataToggle}" href="${mainPath}#about">About</a></li>

    <c:choose>
        <c:when test="${loggedIn == true}">
            <c:set var="urlLevel" value="${pageContext.request.contextPath}/logout"/>
            <form class="form-inline pull-right" action="${urlLevel}" method="GET">
                <button class="btn btn-outline-light my-2 my-sm-0" type="submit"
                        onclick="sessionStorage.clear();">Logout
                </button>
            </form>
        </c:when>
        <c:otherwise>
            <c:set var="urlLevel" value="${pageContext.request.contextPath}/login"/>
            <form class="form-inline pull-right" action="${urlLevel}" method="GET">
                <button class="btn btn-outline-light my-2 my-sm-0" type="submit"
                        onclick="sessionStorage.clear();">Log in
                </button>
            </form>

        </c:otherwise>
    </c:choose>
</ul>
<%--<ul class="nav nav-tabs navbar-nav" role="tablist">--%>
    <%--<li><a class="nav-link navbar-nav-link font-size-16" data-toggle="${dataToggle}" href="${mainPath}#about">About</a></li>--%>

<%--</ul>--%>