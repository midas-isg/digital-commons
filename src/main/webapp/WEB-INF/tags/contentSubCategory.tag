<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="datasetEntries" required="true"
              type="java.util.List" %>
<%@ attribute name="dataStandardEntries" required="true"
              type="java.util.List" %>
<%@ attribute name="softwareEntries" required="true"
              type="java.util.List" %>
<%@ attribute name="subCategoryId" required="true"
              type="java.lang.Long" %>

<c:choose>
    <c:when test="${subCategoryId == 9}">
        <c:set var="subCategoryTreeInfoArr" scope="page" value="${diseaseForecastersTreeInfoArr}"/>
        <c:set var="softwareColumnHeader" scope="page" value="Disease Forecasters and Related Software"/>
        <c:set var="treeCategory" scope="page" value="df"/>
    </c:when>
    <c:when test="${subCategoryId == 14}">
        <c:set var="subCategoryTreeInfoArr" scope="page" value="${pathogenEvolutionModelsTreeInfoArr}"/>
        <c:set var="softwareColumnHeader" scope="page" value="Pathogen Evolution Models and Related Software"/>
        <c:set var="treeCategory" scope="page" value="pem"/>
    </c:when>
    <c:when test="${subCategoryId == 10}">
        <c:set var="subCategoryTreeInfoArr" scope="page" value="${diseaseTransmissionModelsTreeInfoArr}"/>
        <c:set var="softwareColumnHeader" scope="page" value="Disease Transmisson Models and Related Software"/>
        <c:set var="treeCategory" scope="page" value="dtm"/>
    </c:when>
</c:choose>
<div class="row">
<c:forEach items="${subCategoryTreeInfoArr}" var="treeInfo" varStatus="treeLoop">
    <c:if test="${treeInfo.category != 'Country' }">
        <%--In the last column we want Data Formats, then Standard Identifiers, then Websites with data.--%>
        <c:choose>
            <c:when test="${treeInfo.category == 'Data Formats'}">
                <div class="col-md-4">
                <div class="row">
                    <div class="col-sm-12">
                        <h3 class="content-title-font">${treeInfo.category}</h3>

                        <div id="tree-${treeCategory}-${treeLoop.index}" class="treeview" style="display: block"></div>

                    </div>
            </c:when>
            <c:when test="${treeInfo.category == 'Websites with data'}">
<%--
                <div class="col-sm-12">
                    <h3 class="content-title-font">${treeInfo.category}</h3>
                    <div id="tree-${treeCategory}-${treeLoop.index}" class="treeview" style="display: block"></div>
                </div>
--%>
                </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="col-md-4">
                    <c:choose>
                        <c:when test="${treeInfo.category == 'Data'}">
<%--
                            <c:forEach items="${treeInfoArr}" var="checkTreeInfo" varStatus="loop">
                                <c:if test="${checkTreeInfo.category == 'Country'}">
                                    <c:set var="country_index" value="${loop.index}"/>
                                </c:if>
                            </c:forEach>
--%>

                            <h3 class="content-title-font">${treeInfo.category}
                            </h3>
                            <%--<div id="tree-${treeCategory}-${country_index}" class="treeview" style="display: none"></div>--%>
                        </c:when>
                        <c:when test="${treeInfo.category == 'Models and Other Software'}">
                            <h3 class="content-title-font">${softwareColumnHeader}</h3>
                        </c:when>
                        <c:otherwise>
                            <h3 class="content-title-font">${treeInfo.category}
                            </h3>
                        </c:otherwise>
                    </c:choose>

                    <div id="tree-${treeCategory}-${treeLoop.index}" class="treeview" style="display: block"></div>
                </div>
            </c:otherwise>
        </c:choose>

    </c:if>
    <script>
        $(document).ready(function () {

            $('.modal').on('show.bs.modal', function() {
                $(this).show();
                // setModalMaxHeight(this);

                $("#software-description").attr('style', '');
                $(".helpicon-description").show();
                $(".hideicon-description").hide();
                $("#software-is-about").attr('style', '');
                $(".helpicon-is-about").show();
                $(".hideicon-is-about").hide();
            });

        });

        if('${treeInfo.category}' != 'Websites with data'){
            $('#tree-${treeCategory}-${treeLoop.index}').treeview(getTreeviewInfo('${treeInfo.json}', '#tree-${treeCategory}-${treeLoop.index}', 'tree${treeCategory}${treeLoop.index}'));
            expandNodesInSessionVariable('#tree-${treeCategory}-${treeLoop.index}', 'tree${treeCategory}${treeLoop.index}', '${treeCategory}');
        }
    </script>
</c:forEach>
</div>

<div class="col-md-4">
    <div class="legend-large d-none d-sm-block">
        <button id="show-legend" class="btn btn-default btn-xs" onclick="toggleLegend('show')">Show Legend</button>
        <div id="main-legend" class="legend display-none">
            <button id="legend-button" class="btn btn-default btn-xs" onclick="toggleLegend('hide')">Hide</button>
            <myTags:legendTable/>
        </div>
    </div>
</div>

<div class="col-md-4">
    <div class="legend-small d-block d-sm-none">
        <myTags:legendTable/>
    </div>
</div>
