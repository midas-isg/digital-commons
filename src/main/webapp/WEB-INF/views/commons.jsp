<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<head>
    <script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-91508504-1', 'auto');
        ga('send', 'pageview');

    </script>
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
    <script src="${pageContext.request.contextPath}/resources/js/tether.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap/3.3.6/bootstrap.min.js"></script>
    <script>document.write("<link href='${pageContext.request.contextPath}/resources/css/main.css?v=" + Date.now() + "'rel='stylesheet'>");</script>

</head>
<c:choose>
    <c:when test="${preview eq true}">
        <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="true" preview="true" wantCollapse="true" iframe="false"></myTags:header>
    </c:when>
    <c:otherwise>
        <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="true" preview="false" wantCollapse="true" iframe="false"></myTags:header>

    </c:otherwise>
</c:choose>
<body id="commons-body">
<div id="content-body">

    <myTags:softwareModal></myTags:softwareModal>

    <div id="commons-main-body" class="row">
        <div class="tab-content">
            <div id="content" class="tab-pane fade in active">
                <div class="col-sm-4">
                    <h3 class="content-title-font">Software</h3>
                    <div id="algorithm-treeview" class="treeview"></div>
                </div>
                <div class="col-sm-4">
                    <h3 class="content-title-font">Data &amp; Knowledge</h3>
                    <div id="data-and-knowledge-treeview" class="treeview"></div>
                </div>
                <div class="col-sm-4">
                    <h3 class="content-title-font">Data-augmented Publications</h3>
                    <div id="publications-treeview" class="treeview"></div>
                    <div class="legend hidden-xs">
                        <p><i class="olympus-color legend-font">(O)</i><i> = available on Olympus</i></p>
                    </div>
                </div>

                <div class="col-sm-4">
                    <h3 class="content-title-font">Web Services</h3>
                    <div id="webservices-treeview" class="treeview"></div>
                </div>

                <div class="col-sm-4">
                    <div class="legend-small hidden-sm hidden-md hidden-lg">
                        <p><i class="olympus-color legend-font">(O)</i><i> = available on Olympus</i></p>
                    </div>
                </div>
            </div>
            <div id="web-services" class="tab-pane fade">
                <div class="col-sm-12">
                    <h2 class="title-font">Web Services</h2>
                    <h3 class="sub-title-font">Apollo Broker Service</h3>
                    <div class="font-size-16 standard-font">
                        The Apollo Broker Service is the web service used by applications like the Simple End User
                        Apollo
                        Application to run Disease Transmission Models, and interact with the Apollo Library.
                        <br><br>
                        The Apollo Broker Service has a RESTful and SOAP interface. The documentation for the RESTful
                        endpoints
                        is at: <a class="underline"
                                  href="https://research.rods.pitt.edu/broker-service-rest-frontend-4.0.1/sdoc.jsp">https://research.rods.pitt.edu/broker-service-rest-frontend-4.0.1/sdoc.jsp</a>.
                        The WSDL of the SOAP service can be found here: <a
                            href="https://research.rods.pitt.edu/broker-service-war-4.0.1/services/apolloservice?wsdl"
                            class="underline">https://research.rods.pitt.edu/broker-service-war-4.0.1/services/apolloservice?wsdl</a>
                        <br><br>
                        For more information on the Apollo Broker Service, please email <a class="underline"
                                                                                           href="mailto:jdl50@pitt.edu">John
                        Levander</a>.
                    </div>
                    <br>

                    <h3 class="sub-title-font">Apollo Library Viewer</h3>
                    <div class="font-size-16 standard-font">
                        The Apollo Library Viewer has a RESTful API that allows users to access case count data that is
                        stored
                        in the Apollo Library. The link to the documentation is at:
                        <a class="underline"
                           href="https://research.rods.pitt.edu/apolloLibraryViewer-401/sdoc.jsp">https://research.rods.pitt.edu/apolloLibraryViewer-401/sdoc.jsp</a>.
                    </div>
                    <br>

                    <h3 class="sub-title-font">Apollo Location Service</h3>
                    <div class="font-size-16 standard-font">
                        The Apollo Location Service contains a RESTful API that allows users to lookup INCITS codes,
                        Apollo Location Codes, and many other types of geographic information that is available for
                        locations
                        that are stored in the Apollo Location Service Database. The documentation for this service is
                        located
                        here (sign-up required):
                        <a class="underline" href="http://betaweb.rods.pitt.edu/ls/api-docs">http://betaweb.rods.pitt.edu/ls/api-docs</a>.
                    </div>
                    <br>

                    <h3 class="sub-title-font">EpiCaseMap</h3>
                    <div class="font-size-16 standard-font">
                        EpiCaseMap contains a RESTful API that allows users to upload time-coordinate series data
                        and create visualizations for comparing and contrasting data visually. It facilitates this by
                        providing methods for creating, retrieving, updating, and deleting time-coordinate series,
                        visualizations, and related metadata.

                        The documentation for this service is located here (sign-up required): <a class="underline"
                                                                                                  href="http://betaweb.rods.pitt.edu/epicasemap/api">http://betaweb.rods.pitt.edu/epicasemap/api</a>.
                    </div>
                    <br>
                    <div id="web-services-treeview" class="treeview"></div>
                </div>
            </div>
            <div id="compute-platform" class="tab-pane fade">
                <div class="col-sm-12">
                    <h2 class="title-font">Compute Platform</h2>
                    <div class="font-size-16 standard-font">
                        The Olympus supercomputer serves as the compute platform for the MIDAS Digital Commons. MIDAS researchers can use Olympus to use, share, and modify digital objects hosted on the platform. The platform runs on 2,684 cores, 16TB of RAM, and has 160TB of shared disk space.
                        <br><br>
                    To sign up for an account on Olympus, please visit <a href="http://epimodels.org" class="underline">http://epimodels.org</a>.
                        <br><br>

                    </div>
                </div>
                <div class="col-sm-4">
                    <h3 class="subtitle-font">Disease Transmission Models</h3>
                    <div id="disease-transmission-models-treeview" class="treeview"></div>
                </div>
                <div class="col-sm-4">
                    <h3 class="subtitle-font">System Software</h3>
                    <div id="system-software-treeview" class="treeview"></div>
                </div>
                <div class="col-sm-4">
                    <h3 class="subtitle-font">Tools</h3>
                    <div id="tools-treeview" class="treeview"></div>
                </div>
            </div>
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

                        <button type="button" class="btn btn-default" onclick="activeTab('content')"><icon class="glyphicon glyphicon-chevron-left"></icon> Back</button>
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

            /*if($(e.target).attr('data-toggle') == 'tab') {
                if($(e.target).attr('href') == '#data-and-knowledge') {
                    $('#data-and-knowledge-tab').addClass('highlighted-item');
                } else {
                    $('#data-and-knowledge-tab').removeClass('highlighted-item');
                }
            }*/
            //$('[data-toggle="tooltip"]').not(e.target).popover("destroy");
            $('[data-toggle="tooltip"]').tooltip({trigger : 'hover', delay: 350});
        });



        $(document).ready(function() {
            if (location.hash) {
                $("a[href='" + location.hash + "']").tab("show");
                if(location.hash.includes('publication')) {
                    $('#data-and-knowledge-tab').addClass('highlighted-item');
                }
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
    <myTags:webServices></myTags:webServices>
    <myTags:computePlatform></myTags:computePlatform>
</div>

</body>

<myTags:footer></myTags:footer>

</html>
