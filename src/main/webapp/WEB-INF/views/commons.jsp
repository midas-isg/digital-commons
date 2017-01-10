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

    <title>MIDAS Digital Commons</title>

    <!-- Bootstrap CSS -->

    <link href="${pageContext.request.contextPath}/resources/css/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap-treeview/1.2.0/bootstrap-treeview.min.css"
          rel="stylesheet">

</head>

<body>
<div class="row">
    <hr>

    <div class="col-sm-4">
        <h2>Algorithms</h2>
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

<script src="https://code.jquery.com/jquery-2.1.3.min.js"
        integrity="sha256-ivk71nXhz9nsyFDoYoGf2sbjrR9ddh+XDkCcfZxjvcM=" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap-treeview/1.2.0/bootstrap-treeview.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/commons.js"></script>

<script type="text/javascript">
    $(document).ready(function () {
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : ${libraryViewerUrl} + "collectionsJson/",
            dataType : 'json',
            headers : {
                "Authorization" : "JWT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJadzRjM1FiMzBNQ2w3eUpsNjNjWHppbGR1RTdOb05SdSIsImlhdCI6MTQ3Njg5MzM4MiwianRpIjoiMzExZGE3MDJkM2QzMTNkMDY3N2Y0NjVhYzliZDk2ODQ5IiwiaXNzIjoiWnc0YzNRYjMwTUNsN3lKbDYzY1h6aWxkdUU3Tm9OUnUiLCJzdWIiOiJsaWJyYXJ5Vmlld2VyIiwicm9sZXMiOlsiSVNHX1VTRVIiLCJJU0dfQURNSU4iXX0.yN5JJjGUF15WCwnvw084B-4AGi7cMMRU5qI6ZiT5C1o"
            },
            timeout : 100000,
            success : function(data) {
                var $dataAndKnowledgeTree = $('#data-and-knowledge-treeview').treeview({
                    data: getDataAndKnowledgeTree(data, ${libraryViewerUrl}),
                });
                return data;
            },
            error : function(e) {
                console.log(data);
                console.log("ERROR: ", e);
            },
            complete : function(e) {
                $('#data-and-knowledge-treeview').on('nodeSelected', function(event, data) {
                    if(data.url != null && data.state.selected == true) {
                        window.location.href = data.url, '_blank';
                    }
                });
                console.log("DONE");
            }
        });
    });



</script>

</body>
</html>
