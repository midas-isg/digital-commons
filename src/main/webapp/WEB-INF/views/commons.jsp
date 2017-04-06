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

    <script>var ctx = "${pageContext.request.contextPath}"</script>
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
                        <table class="table table-sm" style="
                            margin-bottom: 3px;
                        ">
                            <tbody>
                                <tr>
                                    <td><i class="ae-color legend-font"><b>AE</b></i></td>
                                    <td><i>Apollo-Encoded</i></td>
                                </tr>

                                <tr>
                                    <td><i class="olympus-color legend-font"><b>RROO</b></i></td>
                                    <td><i>Ready to Run On Olympus</i></td>
                                </tr>

                                <tr>
                                    <td><i class="sso-color legend-font"><b>SSO</b></i></td>
                                    <td><i>Requires (single) sign on</i></td>
                                </tr>

                                <tr>
                                    <td><i class="udsi-color legend-font"><b>UDSI</b></i></td>
                                    <td><i>Available via the Universal Disease Simulator Interface</i></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="col-sm-4">
                    <h3 class="content-title-font">Web Services</h3>
                    <div id="webservices-treeview" class="treeview"></div>
                </div>

                <div class="col-sm-4">
                    <div class="legend-small hidden-sm hidden-md hidden-lg">
                        <table class="table table-sm" style="
                            margin-bottom: 3px;
                        ">
                            <tbody>
                            <tr>
                                <td><i class="ae-color legend-font"><b>AE</b></i></td>
                                <td><i>Apollo-Encoded</i></td>
                            </tr>

                            <tr>
                                <td><i class="olympus-color legend-font"><b>RROO</b></i></td>
                                <td><i>Ready to Run On Olympus</i></td>
                            </tr>

                            <tr>
                                <td><i class="sso-color legend-font"><b>SSO</b></i></td>
                                <td><i>Requires (single) sign on</i></td>
                            </tr>

                            <tr>
                                <td><i class="udsi-color legend-font"><b>UDSI</b></i></td>
                                <td><i>Available via the Universal Disease Simulator Interface</i></td>
                            </tr>
                            </tbody>
                        </table>
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
                    <h3 class="title-font">Olympus</h3>
                    <div class="font-size-16 standard-font">
                        <div class="col-sm-7 no-padding">
                            Olympus is a linux-based supercomputer intended to be a workspace for model development and running experiments.   It is configured with several programming languages, compilers, and popular development tools (listed below) for general modeling work.  Olympus is also configured to run 4 disease transmission models, and hosts synthetic ecosystems for many countries.
                            <br><br>
                            Olympus is provided as a free resource to members of the MIDAS network. To sign up for an account on Olympus, please visit <a href="http://epimodels.org" class="underline">http://epimodels.org</a>.
                            <br><br>
                            For more information on Olympus, please read this <a class="underline" href="${pageContext.request.contextPath}/resources/pdf/olympus-presentation.pdf" download>PowerPoint presentation</a> or watch the video <span class="hidden-xs">to the right.</span> <span class="hidden-lg hidden-md hidden-sm">below.</span>
                            <br><br>
                        </div>
                        <div class="col-sm-5 no-padding">
                            <iframe id="olympus-video" style="width:100%" height="275" src="" data-src="//www.youtube.com/embed/8DoMUjl_yCw" frameborder="0" allowfullscreen></iframe>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12">
                    <h3 class="title-font">Software available on Olympus</h3>
                    <div class="font-size-16 standard-font">
                        <div class="col-sm-12 no-padding">
                            A list of the programming languages, compilers, development tools, and disease transmission models that are available on Olympus is shown below. A wiki describing how to use Olympus is available at <a href="https://git.isg.pitt.edu/hpc/olympus/wikis/home" class="underline">https://git.isg.pitt.edu/hpc/olympus/wikis/home</a>.
                            <br/><br/>
                            If you require software on Olympus that is not listed below, please contact <a href="mailto:remarks@psc.edu" class="underline">remarks@psc.edu</a>.<br/><br/>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <h4 class="subtitle-font">System Software</h4>
                    <div id="system-software-treeview" class="treeview"></div>
                </div>
                <div class="col-sm-4">
                    <h4 class="subtitle-font">Tools</h4>
                    <h5 class="tools">Statistical analysis</h5>
                    <div id="statistical-analysis-treeview" class="treeview"></div>
                    <h5 class="tools">Image manipulation</h5>
                    <div id="image-manipulation-treeview" class="treeview"></div>
                    <h5 class="tools">Genetic sequence</h5>
                    <div id="genetic-sequence-treeview" class="treeview"></div>
                </div>
                <div class="col-sm-4">
                    <h4 class="subtitle-font">Disease Transmission Models</h4>
                    <div class="dtm-disclaimer"><i>These entries are cross-references of disease transmission models listed on the ‘Content’ page.</i></div>
                    <div id="disease-transmission-models-treeview" class="treeview"></div>

                    <h4 class="subtitle-font">Modeling Platforms</h4>
                    <div id="modeling-platforms-treeview" class="treeview"></div>
                </div>
            </div>
            <div id="workflows" class="tab-pane fade">
                <div class="col-sm-12">
                    <h3 class="title-font">Workflows on Olympus</h3>
                    <div class="font-size-16 standard-font">
                        <span>
                            These scripts and all the programs they invoke are staged on the Olympus cluster.
                            Follow the instructions below to execute a workflow on your Olympus account.
                            Alternatively, you can copy and edit the script before running on Olympus.
                        </span>
                    </div>
                    <div>
                        <h3 class="title-font">Construct a location-specific disease transmission model</h3>
                        <div class="font-size-16 standard-font">
                            <span class="col-md-12 col-lg-12 no-padding">
                                The LSDTM script requests the name of the synthetic population ('Synthia' or 'SPEW') and the location
                                (US, state, or county code). It creates a runnable instance of FRED for that location.
                            </span>

                            <div class="col-md-6 col-lg-6 no-padding">
                                <div style="margin-top:10px">
                                    <label>Select location:</label><br>
                                    <select class="form-control" id="location-select" style="max-width:280px" onchange="checkLocationSelect()"><option value=""></option></select>
                                </div>
                                <div style="margin-top:10px" id="synthpop-radios">
                                    <label disabled="disabled">Select available synthetic population(s) for location:</label><br>
                                    <label disabled="disabled" class="radio-inline"><input type="radio" name="synthpop" value="spew" onclick="drawDiagram()" disabled>SPEW</label>
                                    <label disabled="disabled" class="radio-inline"><input type="radio" name="synthpop" value="synthia" onclick="drawDiagram()" disabled>Synthia</label>
                                </div>
                                <div style="margin-top:10px; margin-bottom:10px" id="dtm-radios">
                                    <label>Select disease transmission model:</label><br>
                                    <label class="radio-inline"><input type="radio" name="dtm" value="fred" onclick="drawDiagram()" checked>FRED</label>
                                </div>

                                <label id="workflow-diagram-label"></label>
                                <div id="workflow-diagram" style="overflow:scroll"></div>
                            </div>

                            <div id="lsdtm-script-container" class="col-md-6 col-lg-6 no-padding" style="display:none; margin-top:10px">
                                <label>LSDTM script</label><br>
                                <div style="position:relative"
                                     onmouseenter="$('#lsdtm-script-btns').fadeIn();"
                                     onmouseleave="$('#lsdtm-script-btns').fadeOut();">
                                    <pre style="max-height:450px; overflow:scroll"><code id="lsdtm-script"></code></pre>
                                    <div id="lsdtm-script-btns" style="display:none">
                                        <button class="btn btn-xs btn-default"
                                                style="top: 4px;right: 30px; position:absolute;"
                                                onclick="copyToClipboard('#lsdtm-script')">
                                            <icon class="glyphicon glyphicon glyphicon-copy"></icon>
                                        </button>
                                        <button class="btn btn-xs btn-default"
                                                style="top: 4px;right: 4px; position:absolute;"
                                                onclick="download('lsdtm.sh', '#lsdtm-script')">
                                            <icon class="glyphicon glyphicon glyphicon-download"></icon>
                                        </button>
                                    </div>
                                </div>

                                <label>Example invocation of the LSDTM script</label><br>
                                <div style="position:relative"
                                     onmouseenter="$('#run-lsdtm-script-btns').fadeIn();"
                                     onmouseleave="$('#run-lsdtm-script-btns').fadeOut();">
                                    <pre style="max-height:150px; overflow:scroll"><code id="run-lsdtm-script"></code></pre>

                                    <div id="run-lsdtm-script-btns" style="display:none">
                                        <button class="btn btn-xs btn-default"
                                                style="top: 4px;right: 30px; position:absolute;"
                                                onclick="copyToClipboard('#run-lsdtm-script')">
                                            <icon class="glyphicon glyphicon glyphicon-copy"></icon>
                                        </button>
                                        <button class="btn btn-xs btn-default"
                                                style="top: 4px;right: 4px; position:absolute;"
                                                onclick="download('invoke-lsdtm.txt', '#run-lsdtm-script')">
                                            <icon class="glyphicon glyphicon glyphicon-download"></icon>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="about" class="tab-pane fade">
                <myTags:about></myTags:about>
            </div>
            <c:forEach items="${dataAugmentedPublications}" var="pub" varStatus="loop">
                <div id="publication-${pub.paper.id}-${pub.data.id}" class="tab-pane fade">
                    <div class="col-md-12">
                        <h3 class="title-font" id="subtitle">
                            Data-augmented Publication
                        </h3>

                        <myTags:addDataAugmentedPublications publication="${pub.paper}"></myTags:addDataAugmentedPublications>
                        <myTags:addDataAugmentedPublications publication="${pub.data}"></myTags:addDataAugmentedPublications>

                        <button type="button" class="btn btn-default" onclick="activeTab('content')"><icon class="glyphicon glyphicon-chevron-left"></icon> Back</button>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

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
