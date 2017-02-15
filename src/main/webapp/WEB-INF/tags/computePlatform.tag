<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<script>
    $('#software-environment-treeview').treeview({
        data: getSoftwareEnvironmentTreeview(),
        showBorder: false,

        expandIcon: "glyphicon glyphicon-chevron-right",
        collapseIcon: "glyphicon glyphicon-chevron-down",
        highlightSelected: false
    });

    $('#disease-transmission-models-treeview').treeview({
        data: getDiseaseTransmissionModelTreeview(),
        showBorder: false,

        expandIcon: "glyphicon glyphicon-chevron-right",
        collapseIcon: "glyphicon glyphicon-chevron-down",
        highlightSelected: false
    });

    $('#system-software-treeview').treeview({
        data: getSystemSoftwareTreeview(),
        showBorder: false,

        expandIcon: "glyphicon glyphicon-chevron-right",
        collapseIcon: "glyphicon glyphicon-chevron-down",
        highlightSelected: false
    });

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