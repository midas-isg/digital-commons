<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <myTags:favicon></myTags:favicon>

    <!--<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">-->
    <link href="${pageContext.request.contextPath}/resources/css/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <title>MIDAS Digital Commons</title>

    <!-- jQuery imports -->
    <script src="https://code.jquery.com/jquery-2.1.3.min.js"
            integrity="sha256-ivk71nXhz9nsyFDoYoGf2sbjrR9ddh+XDkCcfZxjvcM=" crossorigin="anonymous"></script>

    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap-treeview/1.2.0/bootstrap-treeview.min.css"
          rel="stylesheet">

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/resources/js/tether.min.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap/3.3.6/bootstrap.min.js" defer></script>
    <script>document.write("<link href='${pageContext.request.contextPath}/resources/css/main.css?v=" + Date.now() + "'rel='stylesheet'>");</script>

    <script src="${pageContext.request.contextPath}/resources/js/raphael.min.js"></script>
    <script src="http://flowchart.js.org/flowchart-latest.js"></script>

    <link href="//cdn.datatables.net/1.10.15/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="//cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>

    <script>var ctx = "${pageContext.request.contextPath}"</script>
</head>
<c:choose>
    <c:when test="${preview eq true}">
        <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="true" preview="true" wantCollapse="true" iframe="false" addEntry="true"></myTags:header>
    </c:when>
    <c:otherwise>
        <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="true" preview="false" wantCollapse="true" iframe="false" addEntry="true"></myTags:header>

    </c:otherwise>
</c:choose>
<body id="commons-body">
<div id="content-body">

    <div id="commons-main-body" class="row">
        <div id="add-entry" class="tab-pane active">
            <myTags:reviewEntries entries="${entries}" datasetEntries="${datasetEntries}" dataStandardEntries="${dataStandardEntries}" softwareEntries="${softwareEntries}"></myTags:reviewEntries>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/bootstrap-treeview/1.2.0/bootstrap-treeview.min.js"></script>
<script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/commons.js?v=" + Date.now() + "'><\/script>");</script>
</div>

<!-- uncomment for dev and production -->
<script>
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-91508504-1', 'auto');
    /*ga('create', 'UA-91508504-1', {
     'cookieDomain': 'none'
     });*/
</script>

</body>

<myTags:footer></myTags:footer>

</html>
