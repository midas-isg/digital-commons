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
                    <h3 class="content-title-font">Datasets</h3>
                    <div id="data-and-knowledge-treeview" class="treeview"></div>
                </div>
                <div class="col-sm-4">
                    <h3 class="content-title-font">Data-augmented Publications</h3>
                    <div id="publications-treeview" class="treeview"></div>
                    <div style="margin-bottom: 45px; position: fixed; margin-right: 10px; right: 0; bottom: 0; z-index:100;" class="hidden-xs">
                        <button id="show-legend" class="btn btn-default btn-xs" onclick="$('#show-legend').hide(); $('#main-legend').show();">Show Legend</button>
                        <div id="main-legend" class="legend" style="display:none">
                            <button style="position:absolute; right:6px; top:9px" class="btn btn-default btn-xs" onclick="$('#main-legend').hide(); $('#show-legend').show();">Hide</button>
                            <table class="table table-sm" style="
                                margin-bottom: 3px;
                            ">
                                <tbody>
                                    <tr>
                                        <td><i class="ae-color legend-font"><b>AE</b></i></td>
                                        <td><i><span class="underline">A</span>pollo-<span class="underline">E</span>ncoded</i></td>
                                    </tr>

                                    <tr>
                                        <td><i class="olympus-color legend-font"><b>AOC</b></i></td>
                                        <td><i><span class="underline">A</span>vailable on <span class="underline">O</span>lympus <span class="underline">C</span>luster</i></td>
                                    </tr>

                                    <tr>
                                        <td><i class="sso-color legend-font"><b>SSO</b></i></td>
                                        <td><i>Requires (<span class="underline">S</span>ingle) <span class="underline">S</span>ign <span class="underline">O</span>n</i></td>
                                    </tr>

                                    <tr>
                                        <td><i class="udsi-color legend-font"><b>UIDS</b></i></td>
                                        <td><i>Available via the <span class="underline">U</span>niversal <span class="underline">I</span>nterface to <span class="underline">D</span>isease <span class="underline">S</span>imulators</i></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                        <h3 class="content-title-font">Web Services</h3>
                        <div id="webservices-treeview" class="treeview"></div>

                        <h3 class="content-title-font">Data Formats</h3>
                        <div id="data-formats-treeview" class="treeview"></div>

                        <h3 class="content-title-font">Standard Identifiers</h3>
                        <div id="standard-identifiers-treeview" class="treeview"></div>
                </div>

                <div class="col-sm-4">
                    <div class="legend-small hidden-sm hidden-md hidden-lg">
                        <table class="table table-sm" style="
                            margin-bottom: 3px;
                        ">
                            <tbody>
                            <tr>
                                <td><i class="ae-color legend-font"><b>AE</b></i></td>
                                <td><i><span class="underline">A</span>pollo-<span class="underline">E</span>ncoded</i></td>
                            </tr>

                            <tr>
                                <td><i class="olympus-color legend-font"><b>AOC</b></i></td>
                                <td><i><span class="underline">A</span>vailable on <span class="underline">O</span>lympus <span class="underline">C</span>luster</i></td>
                            </tr>

                            <tr>
                                <td><i class="sso-color legend-font"><b>SSO</b></i></td>
                                <td><i>Requires (<span class="underline">S</span>ingle) <span class="underline">S</span>ign <span class="underline">O</span>n</i></td>
                            </tr>

                            <tr>
                                <td><i class="udsi-color legend-font"><b>UIDS</b></i></td>
                                <td><i>Available via the <span class="underline">U</span>niversal <span class="underline">I</span>nterface to <span class="underline">D</span>isease <span class="underline">S</span>imulators</i></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
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
                <myTags:workflows></myTags:workflows>
            </div>
            <div id="search" class="tab-pane fade">
                <myTags:search></myTags:search>
            </div>
            <div id="add-entry" class="tab-pane fade">
                <myTags:addEntry></myTags:addEntry>
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
    <myTags:dataFormats></myTags:dataFormats>
    <myTags:standardIdentifiers></myTags:standardIdentifiers>
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
