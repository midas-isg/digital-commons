<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@attribute name="contextPath" type="java.lang.String" %>
<%@attribute name="mainPath" type="java.lang.String" %>
<%@attribute name="dataToggle" type="java.lang.String" %>

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
    <li><a class="leaf font-size-18 padding-top-30 " data-toggle="${dataToggle}" href="${mainPath}#search">Search<sup><i style="color: gold">beta</i></sup></a></li>
    <li><a class="leaf font-size-18 padding-top-30 " data-toggle="${dataToggle}" href="${mainPath}#compute-platform">Compute Platform</a></li>
    <li><a class="leaf font-size-18 padding-top-30 " data-toggle="${dataToggle}" href="${mainPath}#workflows" onclick="setTimeout(function(){drawDiagram()}, 300);">Workflows</a></li>
    <li class="dropdown">
        <a href="" class="dropdown-toggle leaf font-size-18 padding-top-30" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Add Entry <span class="caret"></span></a>
        <ul class="dropdown-menu pull-right">
            <li><a href="${contextPath}/add/dataFormatConverters">Data Format Converters</a></li>
            <li><a href="${contextPath}/add/dataService">Data Service</a></li>
            <li class="dropdown-submenu">
                <a tabindex="-1" href="" onclick="preventClick()">Dataset</a>
                <ul class="dropdown-menu">
                    <li><a tabindex="-1" href="${pageContext.request.contextPath}/add/dataset?datasetType=DiseaseSurveillanceData">Disease Surveillance Data</a></li>
                    <li><a tabindex="-1" href="${pageContext.request.contextPath}/add/dataset?datasetType=MortalityData">Mortality Data</a></li>
                    <li><a tabindex="-1" href="" onclick='customDatasetClick()'>Custom</a></li>
                </ul>
            </li>                                                    <li><a href="${pageContext.request.contextPath}/add/dataStandard">Data Standard</a></li>
            <li><a href="${contextPath}/add/dataVisualizers">Data Visualizers</a></li>
            <li><a href="${contextPath}/add/diseaseForecasters">Disease Forecasters</a></li>
            <li><a href="${contextPath}/add/diseaseTransmissionModel">Disease Transmission Model</a></li>
            <li><a href="${contextPath}/add/diseaseTransmissionTreeEstimators">Disease Transmission Tree Estimators</a></li>
            <li><a href="${contextPath}/add/modelingPlatforms">Modeling Platforms</a></li>
            <li><a href="${contextPath}/add/pathogenEvolutionModels">Pathogen Evolution Models</a></li>
            <li><a href="${contextPath}/add/phylogeneticTreeConstructors">Phylogenetic Tree Constructors</a></li>
            <li><a href="${contextPath}/add/populationDynamicsModel">Population Dynamics Model</a></li>
            <li><a href="${contextPath}/add/syntheticEcosystemConstructors">Synthetic Ecosystem Constructor</a></li>
        </ul>
    </li>
    <li><a class="leaf font-size-18 padding-top-30 " data-toggle="${dataToggle}" href="${mainPath}#about">About</a></li>
</ul>