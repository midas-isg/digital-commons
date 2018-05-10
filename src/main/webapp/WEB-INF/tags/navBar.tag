<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@attribute name="contextPath" type="java.lang.String" %>
<%@attribute name="mainPath" type="java.lang.String" %>
<%@attribute name="dataToggle" type="java.lang.String" %>
<%@attribute name="adminType" type="java.lang.Boolean" %>

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

        if(custom != null && custom != "") {
            window.location = "${pageContext.request.contextPath}/add/dataset?" + $.param( requestObj );
        }
    }
</script>

<ul class="nav navbar-nav navbar-padding">
    <li><a id="content-tab" class="leaf font-size-18 padding-top-30" data-toggle="${dataToggle}" href="${mainPath}#content">Content</a></li>
    <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle font-size-18 padding-top-30" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Search
            <span class="caret"></span>
        </a>
        <ul class="nav-link dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="nav-link dropdown-item" href="${contextPath}/search">Conventional DB search</a></li>
            <li><a class="nav-link dropdown-item" data-toggle="${dataToggle}" href="${mainPath}#search">Ontology-based search</a></li>
        </ul>
    </li>
    <li><a class="leaf font-size-18 padding-top-30 " data-toggle="${dataToggle}" href="${mainPath}#compute-platform">Compute Platform</a></li>
    <li><a class="leaf font-size-18 padding-top-30 " data-toggle="${dataToggle}" href="${mainPath}#workflows" onclick="setTimeout(function(){drawDiagram()}, 300);">Workflows</a></li>
    <c:if test="${adminType == 'ISG_ADMIN' or adminType == 'MDC_EDITOR'}">
        <li class="dropdown">
            <a href="_" id="add-digital-object" class="dropdown-toggle leaf font-size-18 padding-top-30" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Manage Digital Objects <span class="caret"></span></a>
            <ul class="dropdown-menu pull-right">
                <c:choose>
                    <c:when test="${adminType == 'ISG_ADMIN'}">
                        <li class="dropdown-header">Admin</li>
                    </c:when>
                    <c:when test="${adminType == 'MDC_EDITOR'}">
                        <li class="dropdown-header">Edit</li>
                    </c:when>
                </c:choose>
                <li><a href="${contextPath}/add/review">Review Submissions</a></li>
                <li role="presentation" class="divider"></li>
                <li class="dropdown-header">Harvest</li>
                <li><a href="${contextPath}/addDataGovRecordById">Add Data.gov Dataset</a></li>
                <li role="presentation" class="divider"></li>
                <li class="dropdown-header">Add</li>
                <li><a href="${contextPath}/add/dataFormatConverters?categoryId=6">Data Format Converter</a></li>
                <li><a href="${contextPath}/add/dataService?categoryId=7">Data Service</a></li>
                <%--<li><a href="${contextPath}/add/dataset?categoryId=">Dataset</a></li>--%>
                <li class="dropdown-submenu">
                    <a tabindex="-1" href="" onclick="preventClick()">Dataset</a>
                    <ul class="dropdown-menu">
                        <li><a tabindex="-1" href="${contextPath}/add/dataset?categoryId=">Dataset with Person</a></li>
                        <li><a tabindex="-1" href="${contextPath}/add/datasetWithOrganization?categoryId=">Dataset with Organization</a></li>
                    </ul>
                </li>
                <li><a href="${pageContext.request.contextPath}/add/dataStandard?categoryId=4">Data Format</a></li>
                <li><a href="${contextPath}/add/dataVisualizers?categoryId=8">Data Visualizer</a></li>
                <li><a href="${contextPath}/add/diseaseForecasters?categoryId=9">Disease Forecaster</a></li>
                <li><a href="${contextPath}/add/diseaseTransmissionModel?categoryId=10">Disease Transmission Model</a></li>
                <li><a href="${contextPath}/add/diseaseTransmissionTreeEstimators?categoryId=12">Disease Transmission Tree Estimator</a></li>
                <li><a href="${contextPath}/add/metagenomicAnalysis?categoryId=448">Metagenomic Analysis</a></li>
                <li><a href="${contextPath}/add/modelingPlatforms?categoryId=13">Modeling Platform</a></li>
                <li><a href="${contextPath}/add/pathogenEvolutionModels?categoryId=14">Pathogen Evolution Model</a></li>
                <li><a href="${contextPath}/add/phylogeneticTreeConstructors?categoryId=15">Phylogenetic Tree Constructor</a></li>
                <li><a href="${contextPath}/add/populationDynamicsModel?categoryId=11">Population Dynamics Model</a></li>
                <li><a href="${contextPath}/add/syntheticEcosystemConstructors?categoryId=16">Synthetic Ecosystem Constructor</a></li>
            </ul>
        </li>
    </c:if>
    <li><a class="leaf font-size-18 padding-top-30 " data-toggle="${dataToggle}" href="${mainPath}#about">About</a></li>
</ul>