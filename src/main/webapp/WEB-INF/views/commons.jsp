<%--
  Created by IntelliJ IDEA.
  User: jdl50
  Date: 1/6/17
  Time: 3:15 PM
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

    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
    <%--<link href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css" rel="stylesheet">--%>
    <%--<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">--%>
    <title>MIDAS Digital Commons</title>

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

<myTags:header pageTitle="MIDAS Digital Commons"></myTags:header>
<body id="commons-body">
<%--<h1>MIDAS Digital Commons</h1>--%>
<ul class="nav nav-tabs">
    <li role="presentation" class="active"><a data-toggle="tab" href="#browse">Browse</a></li>
    <li role="presentation"><a data-toggle="tab" href="#search">Search</a></li>
</ul>

<%--Library Viewer Modal--%>
<div id="libraryViewerModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="tab-content">
        <div id="browse" class="tab-pane fade in active">
            <div class="col-sm-4">
                <h2>Software</h2>
                <div id="algorithm-treeview" class="treeview"></div>
            </div>
            <div class="col-sm-4">
                <h2>Data &amp; Knowledge</h2>
                <div id="data-and-knowledge-treeview" class="treeview"></div>
            </div>
            <div class="col-sm-4">
                <h2>Data-Augmented Publications</h2>
                <div id="publications-treeview" class="treeview"></div>
            </div>
        </div>
        <div id="search" class="tab-pane fade">
            <iframe src="http://ide.obc.io/#/" class="fullscreen" frameBorder="0">
                <p>Your browser does not support iframes. Please visit <a href="http://ide.obc.io/#/">http://ide.obc.io/#/</a> to search.</p>
            </iframe>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/bootstrap-treeview/1.2.0/bootstrap-treeview.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/commons.js"></script>

<myTags:software software="${software}"></myTags:software>
<myTags:dataAugmentedPublications dataAugmentedPublications="${dataAugmentedPublications}"></myTags:dataAugmentedPublications>
<myTags:libraryViewerCollections libraryViewerUrl="${libraryViewerUrl}" libraryViewerToken="${libraryViewerToken}" spewData="${spew}"></myTags:libraryViewerCollections>
</body>

</html>
