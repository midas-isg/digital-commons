<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="datasetEntries" required="true"
              type="java.util.List"%>
<%@ attribute name="dataStandardEntries" required="true"
              type="java.util.List"%>
<%@ attribute name="softwareEntries" required="true"
              type="java.util.List"%>

<div class="col-sm-4">
    <h3 class="content-title-font">Software</h3>
    <div id="algorithm-treeview" class="treeview"></div>
    <div id="tycho-treeview" class="treeview"></div>
</div>
<div class="col-sm-4">
    <h3 class="content-title-font">Data</h3>
    <div id="data-and-knowledge-treeview" class="treeview"></div>
</div>
<div class="col-sm-4">
    <div class="legend-large hidden-xs">
        <button id="show-legend" class="btn btn-default btn-xs" onclick="toggleLegend('show')">Show Legend</button>
        <div id="main-legend" class="legend display-none">
            <button id="legend-button" class="btn btn-default btn-xs" onclick="toggleLegend('hide')">Hide</button>
            <myTags:legendTable/>
        </div>
    </div>

    <h3 class="content-title-font">Data Formats</h3>
    <div id="data-formats-treeview" class="treeview"></div>

    <h3 class="content-title-font">Standard Identifiers</h3>
    <div id="standard-identifiers-treeview" class="treeview"></div>
</div>

<div class="col-sm-4">
    <div class="legend-small hidden-sm hidden-md hidden-lg">
        <myTags:legendTable/>
    </div>
</div>

<script>
    <c:forEach items="${softwareEntries}" var="softwareEntry" varStatus="softwareLoop">
        digitalObjs["software"].push(getEntryFromJson('${softwareEntry.entryJsonString}'));
    </c:forEach>

    createBootstrapTree(digitalObjs["software"], "#algorithm-treeview", "expandedSoftware");
</script>