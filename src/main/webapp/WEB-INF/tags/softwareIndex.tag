<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@attribute name="active" type="java.lang.String" required="true" %>

<!-- Sidebar Holder -->

<nav id="sidebar">
    <ul class="list-unstyled components">
        <li <c:if test="${active == 'softwareForm1'}">class="active"</c:if>><a href="#softwareForm1" onclick="event.preventDefault();" data-toggle="collapse"
                                                                       aria-expanded="false" class="dropdown-toggle">Identifying
            Info</a>

            <ul class="collapse list-unstyled" id="softwareForm1">
                <li><a href="#" onclick="submitForm('title')">Title</a></li>
                <li><a href="#" onclick="submitForm('humanReadableSynopsis')">Human Readable Synopsis</a></li>
                <li><a href="#" onclick="submitForm('productName')">Product Name</a></li>
                <li><a href="#" onclick="submitForm('sourceCodeRelease')">Source Code Release</a></li>
                <li><a href="#" onclick="submitForm('identifier')">identifier</a></li>
                <li><a href="#" onclick="submitForm('dataInputFormats')">Data Input Formats</a></li>
                <li><a href="#" onclick="submitForm('dataOutputFormats')">Data Output Formats</a></li>
                <li><a href="#" onclick="submitForm('webApplications')">Web Applications</a></li>
            </ul>
        </li>
        <li <c:if test="${active == 'softwareForm2'}">class="active"</c:if>><a href="#softwareForm2" onclick="event.preventDefault();" data-toggle="collapse"
                                                                               aria-expanded="false" class="dropdown-toggle">Detailed
            Info</a>

            <ul class="collapse list-unstyled" id="softwareForm2">
                <li><a href="#" onclick="submitForm('license')">License</a></li>
                <li><a href="#" onclick="submitForm('source')">Source</a></li>
                <li><a href="#" onclick="submitForm('website')">Website</a></li>
                <li><a href="#" onclick="submitForm('documentation')">Documentation</a></li>
                <li><a href="#" onclick="submitForm('availableOnOlympus')">Available On Olympus</a></li>
                <li><a href="#" onclick="submitForm('availableOnUIDS')">Available On UIDS</a></li>
                <li><a href="#" onclick="submitForm('signInRequired')">Sign In Required</a></li>
                <li><a href="#" onclick="submitForm('developers')">Developers</a></li>
                <li><a href="#" onclick="submitForm('publicationsThatUsedRelease')">Publications That Used Release</a></li>
                <li><a href="#" onclick="submitForm('executables')">Executables</a></li>
                <li><a href="#" onclick="submitForm('version')">Version</a></li>
                <li><a href="#" onclick="submitForm('publicationsAboutRelease')">Publications About Release</a></li>
                <li><a href="#" onclick="submitForm('grants')">Grants</a></li>
                <li><a href="#" onclick="submitForm('locationCoverage')">Location Coverage</a></li>
            </ul>
        </li>

        <c:choose>
            <c:when test="${softwareType == 'Disease forecasters'}">
                <li <c:if test="${active == 'diseaseForecasterForm'}">class="active"</c:if>><a href="#diseaseForecasterForm" onclick="event.preventDefault();" data-toggle="collapse"
                                                                                       aria-expanded="false" class="dropdown-toggle">Category
                    Info</a>

                    <ul class="collapse list-unstyled" id="diseaseForecasterForm">
                        <li><a href="#" onclick="submitForm('type')">Type</a></li>
                        <li><a href="#" onclick="submitForm('forecastFrequency')">Forecast Frequency</a></li>
                        <li><a href="#" onclick="submitForm('forecasts')">Forecasts</a></li>
                        <li><a href="#" onclick="submitForm('diseases')">Diseases</a></li>
                        <li><a href="#" onclick="submitForm('nowcasts')">Nowcasts</a></li>
                        <li><a href="#" onclick="submitForm('outcomes')">Outcomes</a></li>
                    </ul>
                </li>
            </c:when>
            <c:when test="${softwareType == 'Data services'}">
                <li <c:if test="${active == 'dataServiceForm'}">class="active"</c:if>><a href="#dataServiceForm" onclick="event.preventDefault();" data-toggle="collapse"
                                                                                               aria-expanded="false" class="dropdown-toggle">Category
                    Info</a>

                    <ul class="collapse list-unstyled" id="dataServiceForm">
                        <li><a href="#" onclick="submitForm('accessPointType')">Access Point Type</a></li>
                        <li><a href="#" onclick="submitForm('accessPointDescription')">Access Point Description</a></li>
                        <li><a href="#" onclick="submitForm('accessPointURL')">Access Point URL</a></li>
                    </ul>
                </li>
            </c:when>
<%--
            <c:when test="${softwareType == 'dataStandard'}">
                <li <c:if test="${active == 'dataStandardForm'}">class="active"</c:if>><a href="#dataStandardForm" onclick="event.preventDefault();" data-toggle="collapse"
                                                                                         aria-expanded="false" class="dropdown-toggle">Category
                    Info</a>

                    <ul class="collapse list-unstyled" id="dataStandardForm">
                        <li><a href="#" onclick="submitForm('ds-')"></a></li>
                    </ul>
                </li>
            </c:when>
--%>
            <c:when test="${softwareType == 'Data visualizers'}">
                <li <c:if test="${active == 'dataVisualizerForm'}">class="active"</c:if>><a href="#dataVisualizerForm" onclick="event.preventDefault();" data-toggle="collapse"
                                                                                         aria-expanded="false" class="dropdown-toggle">Category
                    Info</a>

                    <ul class="collapse list-unstyled" id="dataVisualizerForm">
                        <li><a href="#" onclick="submitForm('visualizationType')">Visualization Type</a></li>
                    </ul>
                </li>
            </c:when>
            <c:when test="${softwareType == 'Disease transmission models'}">
                <li <c:if test="${active == 'diseaseTransmissionModelForm'}">class="active"</c:if>><a href="#diseaseTransmissionModelForm" onclick="event.preventDefault();" data-toggle="collapse"
                                                                                            aria-expanded="false" class="dropdown-toggle">Category
                    Info</a>

                    <ul class="collapse list-unstyled" id="diseaseTransmissionModelForm">
                        <li><a href="#" onclick="submitForm('controlMeasure')">Control Measure</a></li>
                        <li><a href="#" onclick="submitForm('hostSpeciesIncluded')">Host Species Included</a></li>
                        <li><a href="#" onclick="submitForm('pathogenCoverage')">Pathogen Coverage</a></li>
                    </ul>
                </li>
            </c:when>
            <c:when test="${softwareType == 'Disease transmission tree estimators'}">
                <li <c:if test="${active == 'diseaseTransmissionTreeEstimatorForm'}">class="active"</c:if>><a href="#diseaseTransmissionTreeEstimatorForm" onclick="event.preventDefault();" data-toggle="collapse"
                                                                                                      aria-expanded="false" class="dropdown-toggle">Category
                    Info</a>

                    <ul class="collapse list-unstyled" id="diseaseTransmissionTreeEstimatorForm">
                        <li><a href="#" onclick="submitForm('hostSpeciesIncludedTree')">Host Species Included</a></li>
                        <li><a href="#" onclick="submitForm('pathogenCoverageTree')">Pathogen Coverage</a></li>
                    </ul>
                </li>
            </c:when>
            <c:when test="${softwareType == 'Pathogen evolution models'}">
                <li <c:if test="${active == 'pathogenEvolutionModelForm'}">class="active"</c:if>><a href="#pathogenEvolutionModelForm" onclick="event.preventDefault();" data-toggle="collapse"
                                                                                                              aria-expanded="false" class="dropdown-toggle">Category
                    Info</a>

                    <ul class="collapse list-unstyled" id="pathogenEvolutionModelForm">
                        <li><a href="#" onclick="submitForm('pathogens')">Pathogens</a></li>
                    </ul>
                </li>
            </c:when>
            <c:when test="${softwareType == 'Population dynamics models'}">
                <li <c:if test="${active == 'populationDynamicsModelForm'}">class="active"</c:if>><a href="#populationDynamicsModelForm" onclick="event.preventDefault();" data-toggle="collapse"
                                                                                                    aria-expanded="false" class="dropdown-toggle">Category
                    Info</a>

                    <ul class="collapse list-unstyled" id="populationDynamicsModelForm">
                        <li><a href="#" onclick="submitForm('populationSpeciesIncluded')">Population Species Included</a></li>
                    </ul>
                </li>
            </c:when>
        </c:choose>

    </ul>
</nav>

<script type="text/javascript">
    $(document).ready(function () {
        $('#sidebarCollapse').click(function () {
            $('#sidebar, #entryFormContent').toggleClass('active');
        });
    });

    function submitForm(indexValue) {
        window.onbeforeunload = null;

        $("#entry-form").attr("action", "${flowExecutionUrl}&_eventId=index&indexValue=" + indexValue);
        document.getElementById("entry-form").submit();
    }
</script>
