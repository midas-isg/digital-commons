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
<div class="row">
<c:forEach items="${treeInfoArr}" var="treeInfo" varStatus="treeLoop">
    <c:if test="${treeInfo.category != 'Country' }">
        <%--In the last column we want Data Formats, then Standard Identifiers, then Websites with data.--%>
        <c:choose>
            <c:when test="${treeInfo.category == 'Data Formats'}">
                <div class="col-md-4">
                <div class="row">
                    <div class="col-sm-12">
                        <h3 class="content-title-font">${treeInfo.category}</h3>

                        <div id="tree-${treeLoop.index}" class="treeview" style="display: block"></div>

                    </div>
            </c:when>
            <c:when test="${treeInfo.category == 'Websites with data'}">
<%--
                <div class="col-sm-12">
                    <h3 class="content-title-font">Standard Identifiers</h3>
                    <div id="standard-identifiers-treeview" class="treeview"></div>
                </div>
--%>

                <div class="col-sm-12">
                    <h3 class="content-title-font">${treeInfo.category}</h3>
                    <div id="tree-${treeLoop.index}" class="treeview" style="display: block"></div>
                </div>
                </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="col-md-4">
                    <c:choose>
                        <c:when test="${treeInfo.category == 'Data'}">
                            <c:forEach items="${treeInfoArr}" var="checkTreeInfo" varStatus="loop">
                                <c:if test="${checkTreeInfo.category == 'Country'}">
                                    <c:set var="country_index" value="${loop.index}"/>
                                </c:if>
                            </c:forEach>

                            <h3 class="content-title-font">${treeInfo.category}
                                <div class="btn-group mr-1 mb-1">
                                    <button type="button" class="btn btn-default sort-by-dropdown btn-block dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        Sort by Category
                                    </button>
                                    <div class="dropdown-menu open-left" x-placement="bottom-start" style="position: absolute; transform: translate3d(0px, 40px, 0px); top: 0px; left: 0px; will-change: transform;">
                                        <a href="#" class="dropdown-item" id="drop-down-category" value="${treeLoop.index}">Category</a>
                                        <a href="#" class="dropdown-item" id="drop-down-location" value="${treeLoop.index}">Location</a>
                                    </div>
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
            </c:otherwise>
        </c:choose>

    </c:if>
    <script>
        $(document).ready(function () {
            // function setModalMaxHeight(element) {
            //     this.$element     = $(element);
            //     this.$content     = this.$element.find('.modal-content');
            //     var borderWidth   = this.$content.outerHeight() - this.$content.innerHeight();
            //     var dialogMargin  = $(window).width() < 768 ? 20 : 100;
            //     var contentHeight = $(window).height() - (dialogMargin + borderWidth);
            //     var headerHeight  = 96;
            //     var footerHeight  = this.$element.find('.modal-footer').outerHeight() || 0;
            //     var maxHeight     = contentHeight - (headerHeight + footerHeight);
            //     this.$content.css({
            //         'overflow': 'hidden'
            //     });
            //
            //     // this.$element
            //     //     .find('.modal-body').css({
            //     //     'max-height': maxHeight,
            //     //     'height': maxHeight,
            //     //     'overflow-y': 'auto'
            //     // });
            // }

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
            //
            // $(window).resize(function() {
            //     if ($('.modal.in').length != 0) {
            //         setModalMaxHeight($('.modal.in'));
            //     }
            // });


            $("#drop-down-category").click(function () {
                $('.sort-by-dropdown').html('Sort by Category <span class="caret"></span>');
                $('.sort-by-dropdown').val($(this).data('value'));

                var treeIndex = $(this).attr("value");
                $("#tree-check-box-div").hide();
                $("#tree-${country_index}").hide();
                $("#tree-" + treeIndex).show();
            });

            $("#drop-down-location").click(function () {
                $('.sort-by-dropdown').html('Sort by Location <span class="caret"></span>');
                $('.sort-by-dropdown').val($(this).data('value'));

                var treeIndex = $(this).attr("value");
                $("#tree-check-box-div").show();
                $("#tree-${country_index}").show();
                $("#tree-" + treeIndex).hide();
            });

        });

        $('#tree-${treeLoop.index}').treeview(getTreeviewInfo('${treeInfo.json}', '#tree-${treeLoop.index}', 'tree${treeLoop.index}'));
        expandNodesInSessionVariable('#tree-${treeLoop.index}', 'tree${treeLoop.index}', '');
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
