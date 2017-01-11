<%--
  Created by IntelliJ IDEA.
  User: amd176
  Date: 1/10/17
  Time: 3:28 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>MIDAS Digital Commons - Software Information</title>

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

</head>

<body id="commons-body">
<div class="row">
    <div class="col-md-12">
        <h1>MIDAS Digital Commons - Software Information</h1>
        <hr>
        <h2>${software.name}</h2>

        <c:if test="${not empty software.version}">
            <div>
                <h4 class="inline">Version: </h4>
                ${software.version}
            </div>
        </c:if>

        <c:if test="${not empty software.developer}">
            <div>
                <h4 class="inline">Developer(s):</h4>
                ${software.developer}
            </div>
        </c:if>

        <c:if test="${not empty software.doi}">
            <div>
                <h4 class="inline">DOI: </h4>
                ${software.doi}
            </div>
        </c:if>

        <c:if test="${not empty software.url}">
            <div>
                <h4 class="inline">URL: </h4>
                <a href="${software.url}">${software.url}</a>
            </div>
        </c:if>

        <c:if test="${not empty software.sourceCodeUrl}">
            <div>
                <h4 class="inline">Source Control: </h4>
                <a href="${software.sourceCodeUrl}">${software.sourceCodeUrl}</a>
            </div>
        </c:if>

        <br>

        <a href="${pageContext.request.contextPath}/home"><button type="button" class="btn btn-default"><icon class="glyphicon glyphicon-chevron-left"></icon> Home</button></a>
    </div>
</div>
</div>

</body>
</html>
