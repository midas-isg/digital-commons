<!DOCTYPE HTML>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>MIDAS Digital Commons</title>
    <myTags:favicon></myTags:favicon>

    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">

    <!-- jQuery imports -->
    <script src="https://code.jquery.com/jquery-2.1.3.min.js"
            integrity="sha256-ivk71nXhz9nsyFDoYoGf2sbjrR9ddh+XDkCcfZxjvcM=" crossorigin="anonymous"></script>

    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap-treeview/1.2.0/bootstrap-treeview.min.css"
          rel="stylesheet">

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap/3.3.6/bootstrap.min.js"></script>
    <title>MIDAS Digital Commons</title>

</head>
<body>
<div class="container-fluid">
    <myTags:header pageTitle="Resource Not Found" loggedIn="${loggedIn}"></myTags:header>

    <div class="row">
        <div class="col-md-12">
            <br>
            <button type="button" class="btn btn-default">
                <a href="${pageContext.request.contextPath}/main">
                    <icon class="glyphicon glyphicon-chevron-left"></icon>
                    Home
                </a>
            </button>

            <button type="button" class="btn btn-default pull-right">
                <a href="${pageContext.request.contextPath}/add/review">
                    Review Submissions
                    <icon class="glyphicon glyphicon-chevron-right"></icon>
                </a>
            </button>

            <br>
            <h3 class="text-center">Your entry has been successfully added. An email request has been sent to the
                administrator. Approval is pending.</h3>

        </div>
    </div>
</div>

</body>
</html>


