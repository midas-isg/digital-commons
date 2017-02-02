<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="libraryViewerUrl" required="true"
              type="java.lang.String"%>
<%@ attribute name="libraryViewerToken" required="true"
              type="java.lang.String"%>
<%@ attribute name="spewRegions" required="true"
              type="java.util.List"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
    var syntheticEcosystemsByRegion = {
        text: "<span onmouseover='toggleTitle(this)'>Synthetic ecosystems</span>",
        nodes: []
    };

    <c:forEach items="${spewRegions}" var="region" varStatus="loop">
        <c:if test="${not empty region.children}">
            syntheticEcosystemsByRegion.nodes.push({'name': "${region.name}", 'text':formatLocation("${region.name}"), 'nodes': []});
            var currentNode = syntheticEcosystemsByRegion.nodes[syntheticEcosystemsByRegion.nodes.length - 1].nodes;
            <c:forEach items="${region.children}" var="child">
                <myTags:recurseRegions region="${child.value}"></myTags:recurseRegions>
            </c:forEach>
        </c:if>
        <c:if test="${empty region.children}">
            syntheticEcosystemsByRegion.nodes.push({'name': "${region.name}", 'text':formatLocation("${region.name}")});
        </c:if>
    </c:forEach>

    syntheticEcosystemsByRegion.nodes.sort(compareNodes);

    for(var i in syntheticEcosystemsByRegion.nodes) {
        syntheticEcosystemsByRegion.nodes[i].nodes.sort(compareNodes);
    }

    $(document).ready(function () {
        var libraryData;
        $.ajax({
            type : "GET",
            contentType : "application/json; charset=utf-8",
            url : "/digital-commons/main/getCollectionsJson",
            dataType : 'json',
            data: {},
            cache: false,
            timeout : 100000,
            success : function(data) {
                libraryData = data;
            },
            error : function(xhr, textStatus, errorThrown) {
                console.log(xhr.responseText);
                console.log(textStatus);
                console.log(errorThrown);
                libraryData = null;
            },
            complete : function(e) {
                $('#data-and-knowledge-treeview').treeview({
                    data: getDataAndKnowledgeTree(libraryData, syntheticEcosystemsByRegion, ${libraryViewerUrl}, "${pageContext.request.contextPath}"),
                    showBorder: false,

                    expandIcon: "glyphicon glyphicon-chevron-right",
                    collapseIcon: "glyphicon glyphicon-chevron-down",
                });
                $('#data-and-knowledge-treeview').treeview('collapseAll', { silent: true });
                $('#data-and-knowledge-treeview').on('nodeSelected', function(event, data) {
                    if(typeof data['nodes'] != undefined) {
                        $('#data-and-knowledge-treeview').treeview('toggleNodeExpanded', [data.nodeId, { levels: 1, silent: true } ]).treeview('unselectNode', [data.nodeId, {silent: true}]);
                    }

                    var expandedDataAndKnowledge = $.parseJSON(sessionStorage.getItem("expandedDataAndKnowledge"));

                    if(data.state.expanded) {
                        if(expandedDataAndKnowledge != null) {
                            var index = expandedDataAndKnowledge.indexOf(data.nodeId);
                            if (index > -1) {
                                expandedDataAndKnowledge.splice(index, 1);
                            }
                        }
                    } else {
                        if(expandedDataAndKnowledge != null) {
                            var index = expandedDataAndKnowledge.indexOf(data.nodeId);
                            if (index <= -1) {
                                expandedDataAndKnowledge.push(data.nodeId);
                            }
                        } else {
                            expandedDataAndKnowledge = [];
                            expandedDataAndKnowledge.push(data.nodeId);
                        }
                    }

                    sessionStorage.setItem("expandedDataAndKnowledge", JSON.stringify(expandedDataAndKnowledge));

                    if(data.url != null && data.state.selected == true) {
                        var url  = data.url;
                        if(url.search("apolloLibraryViewer") > -1) {
//                        if($.contains(data.url, "apolloLibraryViewer")) {
                            $(location).attr('href', "${pageContext.request.contextPath}" + "/main/view?url=" + encodeURIComponent(data.url));
                        } else {
                            $(location).attr('href', data.url);
                        }
                    }
                });
                var expandedDataAndKnowledge = $.parseJSON(sessionStorage.getItem("expandedDataAndKnowledge"));
                var toRemove = [];
                if(expandedDataAndKnowledge != null) {
                    for (var i = 0; i < expandedDataAndKnowledge.length; i++) {
                        try {
                            $('#data-and-knowledge-treeview').treeview('expandNode', [expandedDataAndKnowledge[i], {silent: true}]);
                        } catch(err) {
                            toRemove.push(i);
                        }
                    }

                    if(toRemove.length > 0) {
                        for(var i = 0; i < toRemove.length; i++) {
                            expandedDataAndKnowledge.splice(toRemove[i], 1);
                        }

                        sessionStorage.setItem("expandedDataAndKnowledge", JSON.stringify(expandedDataAndKnowledge));
                    }
                }
            }
        });
        

    });

</script>

