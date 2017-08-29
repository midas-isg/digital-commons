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

<c:forEach items="${treeInfoArr}" var="treeInfo" varStatus="treeLoop">
    <div class="col-sm-4">
        <c:if test="${treeLoop.last}">
            <div class="legend-large hidden-xs">
                <button id="show-legend" class="btn btn-default btn-xs" onclick="toggleLegend('show')">Show Legend</button>
                <div id="main-legend" class="legend display-none">
                    <button id="legend-button" class="btn btn-default btn-xs" onclick="toggleLegend('hide')">Hide</button>
                    <myTags:legendTable/>
                </div>
            </div>
        </c:if>
        <h3 class="content-title-font">${treeInfo.category}</h3>
        <div id="tree-${treeLoop.index}" class="treeview"></div>
        <c:if test="${treeLoop.last}">
            <h3 class="content-title-font">Standard Identifiers</h3>
            <div id="standard-identifiers-treeview" class="treeview"></div>
        </c:if>
    </div>
    <script>
        $('#tree-${treeLoop.index}').treeview(getTreeviewInfo('${treeInfo.json}', '#tree-${treeLoop.index}', 'tree${treeLoop.index}'));
        expandNodesInSessionVariable('#tree-${treeLoop.index}', 'tree${treeLoop.index}');
    </script>
</c:forEach>

<div class="col-sm-4">
    <div class="legend-small hidden-sm hidden-md hidden-lg">
        <myTags:legendTable/>
    </div>
</div>
