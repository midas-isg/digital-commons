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

    hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-system-software.json", systemsSoftware, systemsSoftwareDictionary, systemsSoftwareSettings, '#system-software-treeview', 'expandedSystemsSoftware');

    $('#tools-treeview').treeview({
        data: getToolsTreeview(),
        showBorder: false,

        expandIcon: "glyphicon glyphicon-chevron-right",
        collapseIcon: "glyphicon glyphicon-chevron-down",
        emptyIcon: "bullet-point	",
        showBorder: false,
        highlightSelected: false
    });
</script>