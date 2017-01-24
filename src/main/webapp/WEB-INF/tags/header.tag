<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="pageTitle" type="java.lang.String" %>
<%@ attribute name="subTitle" type="java.lang.String" %>
<%@ attribute name="loggedIn" type="java.lang.Boolean" %>
<%@ attribute name="iframe" type="java.lang.Boolean" %>

<div class="spacer">
    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="main-nav container-fluid ">
            <div class="nav navbar-nav">
                <a href="${pageContext.request.contextPath}">
                    <img alt="MIDAS" class="navbar-brand-mod"
                         src="${pageContext.request.contextPath}/resources/img/midas-logo-gray-small_4.png"></a>
                <h1 class="leaf inline-block">${pageTitle}</h1>
            </div>


            <ul class="nav navbar-nav navbar-right">
                <c:if test="${loggedIn == true}">
                    <c:set var="urlLevel" value="${pageContext.request.contextPath}/logout"/>
                    <form class="navbar-form" action="${urlLevel}" method="GET">
                        <button type="submit" class="btn btn-default margin-top-13">Logout</button>
                    </form>
                </c:if>
                <c:if test="${iframe == true}">
                    <li>
                        <a class="leaf" href="${pageContext.request.contextPath}/main">
                            <icon class="glyphicon glyphicon-chevron-left"></icon>
                            Back to Digital Commons
                        </a>
                    </li>
                    <li>
                        <a class="leaf" href="#" onclick="loadExternalSite()">Open external site
                            <icon class="glyphicon glyphicon-chevron-right"></icon>
                        </a>
                    </li>
                </c:if>
            </ul>

        </div><!-- /.container-fluid -->
    </nav>
</div>

<c:if test="${not empty subTitle}">
    <h2 class="title-font">
            ${subTitle}
    </h2>
</c:if>