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
    <link href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css" rel="stylesheet">
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
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

<myTags:header pageTitle="MIDAS Digital Commons" loggedIn="true" iframe="false"></myTags:header>
<body id="commons-body">
<br>
<ul id="commons-main-tabs" class="nav nav-tabs">
    <li role="presentation" class="active"><a data-toggle="tab" href="#browse">Browse</a></li>
    <li role="presentation"><a data-toggle="tab" href="#search">Search</a></li>
</ul>

<%--"Click here" modal--%>
<div id="pageModal" class="modal fade">
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


<div id="commons-main-body" class="row">
    <div class="tab-content">
        <div id="browse" class="tab-pane fade in active">
            <div class="col-sm-4">
                <h2 class="title-font">Software</h2>
                <div id="algorithm-treeview" class="treeview"></div>
            </div>
            <div class="col-sm-4">
                <h2 class="title-font">Data &amp; Knowledge</h2>
                <div id="data-and-knowledge-treeview" class="treeview"></div>
            </div>
            <div class="col-sm-4">
                <h2 class="title-font">Data-Augmented Publications</h2>
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

<script>
    $('#commons-body').on('click', function (e) {
        console.log('here');
        //did not click a popover toggle or popover
        if ($(e.target).attr('class') !== 'bs-popover') {
            $("[rel=popover]").not(e.target).popover("destroy");
            $(".popover").remove();
        }
    });
</script>

<script src="${pageContext.request.contextPath}/resources/js/bootstrap-treeview/1.2.0/bootstrap-treeview.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/commons.js"></script>

<myTags:software software="${software}"></myTags:software>
<myTags:dataAugmentedPublications dataAugmentedPublications="${dataAugmentedPublications}"></myTags:dataAugmentedPublications>
<myTags:libraryViewerCollections libraryViewerUrl="${libraryViewerUrl}" libraryViewerToken="${libraryViewerToken}" spewData="${spew}" spewRegions="${spewRegions}"></myTags:libraryViewerCollections>

    <!--<div id="panelOne" class="panel panel-default">
        <div class="panel-heading" role="tab" id="headingOne" style="padding:1px 3px">
            <span class="panel-title" style="font-size:12px;">
                <a role="button" data-toggle="collapse" data-parent="#accordion" aria-expanded="false" aria-controls="collapseOne" style="text-decoration: none">
                    Collapsible Group Item #1
                </a>
            </span>
        </div>
        <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
            <div class="panel-body" style="padding:1px 3px; font-size:12px">
                Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
            </div>
        </div>
    </div>

    <script>
        $('#collapseOne').collapse('hide');
        $('#panelOne').hover(function() {
            $('#collapseOne').collapse('toggle');
        });
    </script>-->

</body>

</html>
