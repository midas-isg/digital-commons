<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="pageTitle" type="java.lang.String" %>
<%@ attribute name="subTitle" type="java.lang.String" %>
<%@ attribute name="loggedIn" type="java.lang.Boolean" %>
<%@ attribute name="preview" type="java.lang.Boolean" %>
<%@ attribute name="wantCollapse" type="java.lang.Boolean" %>
<%@ attribute name="iframe" type="java.lang.Boolean" %>
<%@ attribute name="addEntry" type="java.lang.Boolean" %>


    <c:if test="${iframe != true}">
        <div class="spacer">
        <nav class="navbar navbar-default navbar-fixed-top" id="header">
            <div class="main-nav container-fluid ">
                <div class="navbar-header">
                    <c:if test="${wantCollapse == true}">
                        <button type="button" class="navbar-toggle collapsed margin-top-22" data-toggle="collapse"
                                data-target="#navbar-collapse" aria-expanded="false">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                    </c:if>
                    <c:choose>
                        <c:when test="${preview}">
                            <a href="${pageContext.request.contextPath}/main">
                                <img alt="MIDAS" class="navbar-brand-mod"
                                     src="${pageContext.request.contextPath}/resources/img/midas-logo-gray-small.png"></a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}">
                                <img alt="MIDAS" class="navbar-brand-mod"
                                     src="${pageContext.request.contextPath}/resources/img/midas-logo-gray-small.png"></a>
                        </c:otherwise>
                    </c:choose>
                    <h2 id="page-title-big" class="leaf visible hidden-xs hidden-sm hidden-md margin-top-22">${pageTitle}</h2>
                    <h3 id="page-title" class="font-size-20 leaf hidden hidden-sm hidden-md hidden-lg margin-top-30">${pageTitle}</h3>
                </div>

                <style>

                    .dropdown-submenu {
                        position: relative;
                    }

                    .dropdown-submenu>.dropdown-menu {
                        top: 0;
                        left: 100%;
                        margin-top: -6px;
                        margin-left: -1px;
                        -webkit-border-radius: 0 6px 6px 6px;
                        -moz-border-radius: 0 6px 6px;
                        border-radius: 0 6px 6px 6px;
                    }

                    .dropdown-submenu:hover>.dropdown-menu {
                        display: block;
                    }

                    .dropdown-submenu>a:after {
                        display: block;
                        content: " ";
                        float: right;
                        width: 0;
                        height: 0;
                        border-color: transparent;
                        border-style: solid;
                        border-width: 5px 0 5px 5px;
                        border-left-color: #ccc;
                        margin-top: 5px;
                        margin-right: -10px;
                    }

                    .dropdown-submenu:hover>a:after {
                        border-left-color: #fff;
                    }

                    .dropdown-submenu.pull-left {
                        float: none;
                    }

                    .dropdown-submenu.pull-left>.dropdown-menu {
                        left: -100%;
                        margin-left: 10px;
                        -webkit-border-radius: 6px 0 6px 6px;
                        -moz-border-radius: 6px 0 6px 6px;
                        border-radius: 6px 0 6px 6px;
                    }
                </style>

                <script>
                    function preventClick() {
                        event.preventDefault();
                        event.stopPropagation();
                    }

                    function customDatasetClick() {
                        preventClick();

                        var custom = prompt("Please enter your custom dataset name.", "");

                        var requestObj = {
                            'datasetType': 'custom',
                            'customValue': custom
                        };

                        window.location = "${pageContext.request.contextPath}/add/dataset?" + $.param( requestObj );
                    }
                </script>

                <div class="collapse navbar-collapse" id="navbar-collapse">
                    <c:if test="${loggedIn == true && iframe == false}">
                        <ul class="nav navbar-nav navbar-padding">
                            <c:if test="${addEntry == true}">
                                <li><a id="content-tab" class="leaf font-size-18 padding-top-30" href="${pageContext.request.contextPath}/main#content">Content</a></li>
                                <li><a class="leaf font-size-18 padding-top-30 " href="${pageContext.request.contextPath}/main#search">Search<sup><i style="color: gold">beta</i></sup></a></li>
                                <li><a class="leaf font-size-18 padding-top-30 " href="${pageContext.request.contextPath}/main#compute-platform">Compute Platform</a></li>
                                <li><a class="leaf font-size-18 padding-top-30 " href="${pageContext.request.contextPath}/main#workflows" onclick="setTimeout(function(){drawDiagram()}, 300);">Workflows</a></li>
                                <%--<li class="active "><a class="leaf font-size-18 padding-top-30 " href="${pageContext.request.contextPath}/midas-sso/add">Add Entry</a></li>--%>
                                <li class="dropdown">
                                    <a href="" class="dropdown-toggle leaf font-size-18 padding-top-30" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Add Entry <span class="caret"></span></a>
                                    <ul class="dropdown-menu pull-right">
                                        <li><a href="${pageContext.request.contextPath}/add/dataFormatConverters">Data Format Converters</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/dataService">Data Service</a></li>
                                        <%--<li><a href="${pageContext.request.contextPath}/add/dataset">Dataset</a></li>--%>
                                        <li class="dropdown-submenu">
                                            <a tabindex="-1" href="" onclick="preventClick()">Dataset</a>
                                            <ul class="dropdown-menu">
                                                <li><a tabindex="-1" href="${pageContext.request.contextPath}/add/dataset?datasetType=DiseaseSurveillanceData">Disease Surveillance Data</a></li>
                                                <li><a tabindex="-1" href="${pageContext.request.contextPath}/add/dataset?datasetType=MortalityData">Mortality Data</a></li>
                                                <li><a tabindex="-1" href="" onclick='customDatasetClick()'>Custom</a></li>
                                            </ul>
                                        </li>
                                        <li><a href="${pageContext.request.contextPath}/add/dataStandard">Data Standard</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/dataVisualizers">Data Visualizers</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/diseaseForecasters">Disease Forecasters</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/diseaseTransmissionModel">Disease Transmission Model</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/diseaseTransmissionTreeEstimators">Disease Transmission Tree Estimators</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/modelingPlatforms">Modeling Platforms</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/pathogenEvolutionModels">Pathogen Evolution Models</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/phylogeneticTreeConstructors">Phylogenetic Tree Constructors</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/populationDynamicsModel">Population Dynamics Model</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/syntheticEcosystemConstructor">Synthetic Ecosystem Constructor</a></li>
                                    </ul>
                                </li>
                                <li><a class="leaf font-size-18 padding-top-30 " href="${pageContext.request.contextPath}/main#about">About</a></li>
                            </c:if>
                            <c:if test="${addEntry != true}">
                                <li><a id="content-tab" class="leaf font-size-18 padding-top-30" data-toggle="tab" href="#content">Content</a></li>
                                <li><a class="leaf font-size-18 padding-top-30 " data-toggle="tab" href="#search">Search<sup><i style="color: gold">beta</i></sup></a></li>
                                <li><a class="leaf font-size-18 padding-top-30 " data-toggle="tab" href="#compute-platform">Compute Platform</a></li>
                                <li><a class="leaf font-size-18 padding-top-30 " data-toggle="tab" href="#workflows" onclick="setTimeout(function(){drawDiagram()}, 300);">Workflows</a></li>
                                <%--<li><a class="leaf font-size-18 padding-top-30 " href="${pageContext.request.contextPath}/midas-sso/add">Add Entry</a></li>--%>
                                <li class="dropdown">
                                    <a href="" class="dropdown-toggle leaf font-size-18 padding-top-30" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Add Entry <span class="caret"></span></a>
                                    <ul class="dropdown-menu pull-right">
                                        <li><a href="${pageContext.request.contextPath}/add/dataFormatConverters">Data Format Converters</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/dataService">Data Service</a></li>
                                            <%--<li><a href="${pageContext.request.contextPath}/add/dataset">Dataset</a></li>--%>
                                        <li class="dropdown-submenu">
                                            <a tabindex="-1" href="" onclick="preventClick()">Dataset</a>
                                            <ul class="dropdown-menu">
                                                <li><a tabindex="-1" href="${pageContext.request.contextPath}/add/dataset?datasetType=DiseaseSurveillanceData">Disease Surveillance Data</a></li>
                                                <li><a tabindex="-1" href="${pageContext.request.contextPath}/add/dataset?datasetType=MortalityData">Mortality Data</a></li>
                                                <li><a tabindex="-1" href="" onclick='customDatasetClick()'>Custom</a></li>
                                            </ul>
                                        </li>                                                    <li><a href="${pageContext.request.contextPath}/add/dataStandard">Data Standard</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/dataVisualizers">Data Visualizers</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/diseaseForecasters">Disease Forecasters</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/diseaseTransmissionModel">Disease Transmission Model</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/diseaseTransmissionTreeEstimators">Disease Transmission Tree Estimators</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/modelingPlatforms">Modeling Platforms</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/pathogenEvolutionModels">Pathogen Evolution Models</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/phylogeneticTreeConstructors">Phylogenetic Tree Constructors</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/populationDynamicsModel">Population Dynamics Model</a></li>
                                        <li><a href="${pageContext.request.contextPath}/add/syntheticEcosystemConstructor">Synthetic Ecosystem Constructor</a></li>
                                    </ul>
                                </li>
                                <li><a class="leaf font-size-18 padding-top-30 " data-toggle="tab" href="#about">About</a></li>
                            </c:if>
                        </ul>
                    </c:if>
                    <ul class="nav navbar-nav navbar-right">
                        <c:if test="${(loggedIn == true and preview == false) and addEntry != true}">
                            <c:set var="urlLevel" value="${pageContext.request.contextPath}/logout"/>
                        <form class="navbar-form" action="${urlLevel}" method="GET">
                            <button type="submit" class="btn btn-default margin-top-13" onclick="sessionStorage.clear();">Logout</button>
                        </form>
                        </c:if>
                    </ul>
                </div>
            </div><!-- /.container-fluid -->
        </nav>
        </div>
    </c:if>
    <c:if test="${iframe == true}">
        <div class="spacer-small"></div>

        <div style="height:30px; width:100%; background-color:#0c2b65; position:fixed; top:0">
            <div class="pull-right" style="margin-top:5px; margin-right:5px">
                <a class="leaf" href="#" onclick="loadExternalSite()">
                    <span class="hidden-extra-xs">Open external site</span>
                    <icon class="glyphicon glyphicon-chevron-right"></icon>
                </a>
            </div>

            <div style="margin-top:5px; margin-right:5px; position:absolute; left:40%">
                <span class="leaf hidden-xs">MIDAS SSO-enabled site</span>
            </div>

            <div class="pull-left leaf" style="margin-top:5px; margin-left:5px">
                <a class="leaf" href="${pageContext.request.contextPath}/main">
                    <icon class="glyphicon glyphicon-chevron-left"></icon>
                    <span class="hidden-extra-xs">Back to Digital Commons</span>
                </a>
            </div>
        </div>
    </c:if>

<script>
    function loadExternalSite() {
        window.open(document.getElementById("libraryFrame").src);
    }

    $(window).on("resize", function() {
//        if( $(window).width() < 945) {
        if( $(window).width() < 1170) {
            hideTitle('page-title-big');
        } else {
            showTitle('page-title-big');
        }

        if($(window).width() > 767 && $(window).width() < 861 ) {
            showTitle('page-title');
        }
        if($(window).width() > 860) {
            hideTitle('page-title');
        }
    }).resize();

    function hideTitle(title) {
        var d = document.getElementById(title);
        d.classList.remove('visible');
        d.classList.add('hidden');
    }
    function showTitle(title) {
        var d = document.getElementById(title);
        d.classList.remove('hidden');
        d.classList.add('visible');
    }

//    $('.nav a').on('click', function () {
//        if ($(window).width() < 850) {
//            $('.navbar-toggle').click();
//        }
//    });

</script>