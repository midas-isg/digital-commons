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
    <c:if test="${treeInfo.category != 'Country' }">
        <div class="col-sm-4">
            <c:choose>
                <c:when test="${treeInfo.category == 'Data'}">
                    <c:forEach items="${treeInfoArr}" var="checkTreeInfo" varStatus="loop">
                        <c:if test="${checkTreeInfo.category == 'Country'}">
                            <c:set var ="country_index" value = "${loop.index}"/>
                        </c:if>
                    </c:forEach>

                    <h3 class="content-title-font">${treeInfo.category}

                        <div class="dropdown inline">
                            <button class="btn btn-default dropdown-toggle sort-by-dropdown" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                Sort by Category
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                                <li><a href="#" id="drop-down-category" value="${treeLoop.index}">Category</a></li>
                                <li><a href="#" id="drop-down-location" value="${treeLoop.index}">Location</a></li>
                            </ul>
                        </div>
                    </h3>
                    <div id="tree-${country_index}" class="treeview" style="display: none"></div>
                </c:when>
                <c:otherwise>
                    <h3 class="content-title-font">${treeInfo.category}</h3>
                </c:otherwise>
            </c:choose>

            <div id="tree-${treeLoop.index}" class="treeview" style="display: block"></div>
        </div>
    </c:if>
    <script>
        $(document).ready(function() {
            $("#drop-down-category").click(function () {
                $(this).parents(".dropdown").find('.btn').html('Sort by Category <span class="caret"></span>');
                $(this).parents(".dropdown").find('.btn').val($(this).data('value'));

                var treeIndex = $(this).attr("value");
                $("#tree-check-box-div").hide();
                $("#tree-${country_index}").hide();
                $("#tree-" + treeIndex).show();
            });

            $("#drop-down-location").click(function () {
                $(this).parents(".dropdown").find('.btn').html('Sort by Location <span class="caret"></span>');
                $(this).parents(".dropdown").find('.btn').val($(this).data('value'));

                var treeIndex = $(this).attr("value");
                $("#tree-check-box-div").show();
                $("#tree-${country_index}").show();
                $("#tree-" + treeIndex).hide();
            });

        });

        $('#tree-${treeLoop.index}').treeview(getTreeviewInfo('${treeInfo.json}', '#tree-${treeLoop.index}', 'tree${treeLoop.index}'));
        expandNodesInSessionVariable('#tree-${treeLoop.index}', 'tree${treeLoop.index}');
    </script>
</c:forEach>

<div class="col-sm-4">
    <h3 class="content-title-font">Standard Identifiers</h3>
    <div id="standard-identifiers-treeview" class="treeview"></div>
</div>

<div class="col-sm-4">
    <div class="legend-large hidden-xs">
        <button id="show-legend" class="btn btn-default btn-xs" onclick="toggleLegend('show')">Show Legend</button>
        <div id="main-legend" class="legend display-none">
            <button id="legend-button" class="btn btn-default btn-xs" onclick="toggleLegend('hide')">Hide</button>
            <myTags:legendTable/>
        </div>
    </div>
</div>

<div class="col-sm-4">
    <div class="legend-small hidden-sm hidden-md hidden-lg">
        <myTags:legendTable/>
    </div>
</div>
