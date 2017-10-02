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
    <c:if test="${treeInfo.category != 'Country' and  treeInfo.category != 'Country by Category'}">
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
            <c:if test="${treeInfo.category == 'Data'}">
                <c:forEach items="${treeInfoArr}" var="checkTreeInfo" varStatus="loop">
                    <c:if test="${checkTreeInfo.category == 'Country'}">
                        <c:set var ="country_index" value = "${loop.index}"/>
                    </c:if>
                    <c:if test="${checkTreeInfo.category == 'Country by Category'}">
                        <c:set var = "country_by_category_index" value = "${loop.index}"/>
                    </c:if>
                </c:forEach>
                <form>
                    <label class="radio-inline">
                        <input type="radio" checked="checked" name="dataradio" id="data" value="${treeLoop.index}">Data
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="dataradio" id="location" value="${treeLoop.index}">Location (by country)
                    </label>
                </form>
                <div class="form-check form-check-inline" id="tree-check-box-div" style="display: none" onclick="toggleListing()">
                    <span class="form-check-label">
                        <input class="form-check-input" id="tree-check-box" type="checkbox" value="">
                        Organize by datatype
                    </span>
                </div>
                <div id="tree-${country_index}" class="treeview" style="display: none"></div>
                <div id="tree-${country_by_category_index}" class="treeview" style="display: none"></div>
            </c:if>
            <div id="tree-${treeLoop.index}" class="treeview"></div>
            <c:if test="${treeLoop.last}">
                <h3 class="content-title-font">Standard Identifiers</h3>
                <div id="standard-identifiers-treeview" class="treeview"></div>
            </c:if>
        </div>
    </c:if>
    <script>
        $(document).ready(function() {
            $("input[name$='dataradio']").click(function() {
                var treeIndex = $(this).val();
                var id =  $(this).attr("id");
                if(id == "location") {
                    $("#tree-check-box-div").show();
                    toggleListing();
                    $("#tree-" + treeIndex).hide();
                } else {
                    $("#tree-check-box-div").hide();
                    $("#tree-${country_by_category_index}").hide();
                    $("#tree-${country_index}").hide();
                    $("#tree-" + treeIndex).show();
                }
            });
        });

        function toggleListing() {
            if (document.getElementById('tree-check-box').checked) {
                $("#tree-${country_index}").hide();
                $("#tree-${country_by_category_index}").show();
            } else {
                $("#tree-${country_index}").show();
                $("#tree-${country_by_category_index}").hide();
            }
        }

        $('#tree-${treeLoop.index}').treeview(getTreeviewInfo('${treeInfo.json}', '#tree-${treeLoop.index}', 'tree${treeLoop.index}'));
        expandNodesInSessionVariable('#tree-${treeLoop.index}', 'tree${treeLoop.index}');
    </script>
</c:forEach>

<div class="col-sm-4">
    <div class="legend-small hidden-sm hidden-md hidden-lg">
        <myTags:legendTable/>
    </div>
</div>
