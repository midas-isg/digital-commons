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

<ul class="nav nav-tabs navbar-nav mr-auto" role="tablist">
    <li><a id="content-tab" class="nav-link font-size-18" data-toggle="${dataToggle}" href="${mainPath}#content">Content</a></li>
    <li class="dropdown">
        <a class="nav-link dropdown-toggle font-size-18 navbar-dropdown" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Search
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
            <a class="dropdown-item" href="${contextPath}/search">Conventional DB search</a>
            <a class="dropdown-item" data-toggle="${dataToggle}" href="${mainPath}#search">Ontology-based search</a>
        </div>
    </li>
    <li><a class="nav-link font-size-18" data-toggle="${dataToggle}" href="${mainPath}#compute-platform">Compute Platform</a></li>
    <li><a class="nav-link font-size-18" data-toggle="${dataToggle}" href="${mainPath}#workflows" onclick="setTimeout(function(){drawDiagram()}, 300);">Workflows</a></li>
    <c:if test="${adminType == 'ISG_ADMIN' or adminType == 'MDC_EDITOR'}">
        <li class="dropdown ">
            <a href="#" id="add-digital-object" class="nav-link dropdown-toggle leaf font-size-18 navbar-dropdown" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Manage Digital Objects <span class="caret"></span></a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                <c:choose>
                    <c:when test="${adminType == 'ISG_ADMIN'}">
                        <h6 class="dropdown-header">Admin</h6>
                    </c:when>
                    <c:when test="${adminType == 'MDC_EDITOR'}">
                        <h6 class="dropdown-header">Edit</h6>
                    </c:when>
                </c:choose>
                <a class="dropdown-item" href="${contextPath}/add/review">Review Submissions</a>
                <div class="dropdown-divider"></div>
                <h6 class="dropdown-header">Harvest</h6>
                <a class="dropdown-item" href="${contextPath}/addDataGovRecordById">Add Data.gov Dataset</a>
                <div class="dropdown-divider"></div>
                <h6 class="dropdown-header">Add</h6>
                <a class="dropdown-item" href="${contextPath}/addDataFormatConverters">Data Format Converter</a>
                <a class="dropdown-item" href="${contextPath}/addDataService">Data Service</a>
                <%--<li><a href="${contextPath}/add/dataset?categoryId=">Dataset</a></li>--%>
                <div class="dropdown-submenu nav-submenu">
                    <a class=" dropdown-toggle dropdown-item " tabindex="-1" href=""
                       onclick="preventClick()">Dataset</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" tabindex="-1" href="${contextPath}/addDataset">Dataset with
                            Person</a></li>
                        <li><a class="dropdown-item" tabindex="-1" href="${contextPath}/addDatasetWithOrganization/">Dataset
                            with Organization</a></li>

                    </ul>
                </div>

                <a class="dropdown-item" href="${pageContext.request.contextPath}/addDataStandard">Data Format</a>
                <a class="dropdown-item" href="${contextPath}/addDataVisualizers">Data Visualizer</a>
                <a class="dropdown-item" href="${contextPath}/addDiseaseForecasters">Disease Forecaster</a>
                <a class="dropdown-item" href="${contextPath}/addDiseaseTransmissionModel">Disease Transmission Model</a>
                <a class="dropdown-item" href="${contextPath}/addDiseaseTransmissionTreeEstimators">Disease Transmission Tree Estimator</a>
                <a class="dropdown-item" href="${contextPath}/addMetagenomicAnalysis">Metagenomic Analysis</a>
                <a class="dropdown-item" href="${contextPath}/addModelingPlatforms">Modeling Platform</a>
                <a class="dropdown-item" href="${contextPath}/addPathogenEvolutionModels">Pathogen Evolution Model</a>
                <a class="dropdown-item" href="${contextPath}/addPhylogeneticTreeConstructors">Phylogenetic Tree Constructor</a>
                <a class="dropdown-item" href="${contextPath}/addPopulationDynamicsModel">Population Dynamics Model</a>
                <a class="dropdown-item" href="${contextPath}/addSyntheticEcosystemConstructors">Synthetic Ecosystem Constructor</a>
            </div>
        </li>

    </c:if>
    <li><a class="nav-link font-size-18" data-toggle="${dataToggle}" href="${mainPath}#about">About</a></li>
</ul>