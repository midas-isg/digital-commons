<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<script>
    $('#disease-transmission-models-treeview').treeview({
        data: getDiseaseTransmissionModelTreeview(),
        showBorder: false,

        expandIcon: "glyphicon glyphicon-chevron-right",
        collapseIcon: "glyphicon glyphicon-chevron-down",
        highlightSelected: false
    });

    hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-disease-transmission-models.json", diseaseTransmissionModel, diseaseTransmissionModelDictionary, diseaseTransmissionModelSettings, '#disease-transmission-models-treeview', 'expandedDiseaseTransmissionModels');

    hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-system-software.json", systemsSoftware, systemsSoftwareDictionary, systemsSoftwareSettings, '#system-software-treeview', 'expandedSystemsSoftware');

    hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-tools.json", tools, toolsDictionary, toolsSettings, '#tools-treeview', 'expandedTools');

</script>