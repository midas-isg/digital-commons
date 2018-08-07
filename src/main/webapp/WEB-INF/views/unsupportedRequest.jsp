<!DOCTYPE HTML>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>

<myTags:head title="MIDAS Digital Commons"/>
<myTags:header pageTitle="Unsupported Request" loggedIn="${loggedIn}" addEntry="${true}"></myTags:header>

<body>
<div class="container-fluid">

    <div class="row">
        <div class="col-md-12">

            <br>
            <a href="${pageContext.request.contextPath}/main">
                <button type="button" class="btn btn-default">
                    <icon class="fa fa-chevron-left"></icon>
                    Home
                </button>
            </a>
            <br>

            <h3 class="text-center">Status 400: The request is not currently supported by the Digital Commons.</h3>

        </div>
    </div>
</div>
</body>
</html>
