<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<script>
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var target = $(e.target).attr("href") // activated tab
        if (target == '#compute-platform') {

            $('#disease-transmission-models-treeview').treeview({
                data: getDiseaseTransmissionModelTreeview(),
                showBorder: false,

                expandIcon: "glyphicon glyphicon-chevron-right",
                collapseIcon: "glyphicon glyphicon-chevron-down",
                highlightSelected: false
            });

            hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-disease-transmission-models.json", diseaseTransmissionModel, diseaseTransmissionModelDictionary, diseaseTransmissionModelSettings, '#disease-transmission-models-treeview', 'expandedDiseaseTransmissionModels', 'diseaseTransmissionModels');

            hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-modeling-platforms.json", modelingPlatforms, modelingPlatformsDictionary, modelingPlatformsSettings, '#modeling-platforms-treeview', 'expandedModelingPlatforms', 'diseaseTransmissionModels');

            hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-system-software.json", systemsSoftware, systemsSoftwareDictionary, systemsSoftwareSettings, '#system-software-treeview', 'expandedSystemsSoftware', 'systemSoftware');

            hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-genetic-sequence.json", geneticSequence, geneticSequenceDictionary, geneticSequenceSettings, '#genetic-sequence-treeview', 'expandedGeneticSequence', 'tools');

            hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-statistical-analysis.json", statisticalAnalysis, statisticalAnalysisDictionary, statisticalAnalysisSettings, '#statistical-analysis-treeview', 'expandedStatisticalAnalysis', 'tools');

            hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-image-manipulation.json", imageManipulation, imageManipulationDictionary, imageManipulationSettings, '#image-manipulation-treeview', 'expandedImageManipulation', 'tools');
        }
    });
</script>
