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
    <script src="${pageContext.request.contextPath}/resources/js/tether.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap/3.3.6/bootstrap.min.js"></script>

</head>
<c:choose>
    <c:when test="${preview == true}">
        <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="true" preview="true" wantCollapse="true" iframe="false"></myTags:header>
    </c:when>
    <c:otherwise>
        <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="true" preview="false" wantCollapse="true" iframe="false"></myTags:header>

    </c:otherwise>
</c:choose>
<body id="commons-body">
<div id="content">

    <myTags:softwareModal></myTags:softwareModal>

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
                    <h2 class="title-font">Data-augmented Publications</h2>
                    <div id="publications-treeview" class="treeview"></div>
                </div>
            </div>
            <!--<div id="search" class="tab-pane fade">
                <iframe src="http://ide.obc.io/#/" class="fullscreen" frameBorder="0">
                    <p>Your browser does not support iframes. Please visit <a href="http://ide.obc.io/#/">http://ide.obc.io/#/</a>
                        to search.</p>
                </iframe>
            </div>-->
            <div id="about" class="tab-pane fade">
                <myTags:about></myTags:about>
            </div>
            <c:forEach items="${dataAugmentedPublications}" var="pub" varStatus="loop">
                <div id="publication-${pub.paper.id}-${pub.data.id}" class="tab-pane fade">
                    <div class="col-md-12">
                        <h2 class="title-font" id="subtitle">
                            Data-augmented Publication
                        </h2>

                        <myTags:addDataAugmentedPublications publication="${pub.paper}"></myTags:addDataAugmentedPublications>
                        <myTags:addDataAugmentedPublications publication="${pub.data}"></myTags:addDataAugmentedPublications>

                        <button type="button" class="btn btn-default" onclick="activeTab('browse')"><icon class="glyphicon glyphicon-chevron-left"></icon> Back</button>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script>
        $('#commons-body').on('click', function (e) {
            //did not click a popover toggle or popover
            if ($(e.target).attr('class') !== 'bs-popover') {
                $("[rel=popover]").not(e.target).popover("destroy");
                $(".popover").remove();
            }
        });

        $(document).ready(function() {
            if (location.hash) {
                $("a[href='" + location.hash + "']").tab("show");
            }
            $(document.body).on("click", "a[data-toggle]", function(event) {
                location.hash = this.getAttribute("href");
            });
        });
        $(window).on("popstate", function() {
            var anchor = location.hash || $("a[data-toggle='tab']").first().attr("href");
            $("a[href='" + anchor + "']").tab("show");
        });
    </script>

    <script src="${pageContext.request.contextPath}/resources/js/bootstrap-treeview/1.2.0/bootstrap-treeview.min.js"></script>
    <script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/commons.js?v=" + Date.now() + "'><\/script>");</script>

    <myTags:software software="${software}"></myTags:software>
    <myTags:dataAugmentedPublications
            dataAugmentedPublications="${dataAugmentedPublications}"></myTags:dataAugmentedPublications>
    <myTags:libraryViewerCollections libraryViewerUrl="${libraryViewerUrl}" libraryViewerToken="${libraryViewerToken}"
                                     spewRegions="${spewRegions}"></myTags:libraryViewerCollections>
</div>

</body>

<myTags:footer></myTags:footer>

</html>
