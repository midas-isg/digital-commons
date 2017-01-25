<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="libraryViewerUrl" required="true"
              type="java.lang.String"%>
<%@ attribute name="libraryViewerToken" required="true"
              type="java.lang.String"%>
<%@ attribute name="spewData" required="true"
              type="java.lang.Iterable"%>
<%@ attribute name="spewRegions" required="true"
              type="java.util.List"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
    /* var syntheticEcosystems = {
        text: "Synthetic ecosystems (by name)",
        nodes: []
    };

    var locations = [];
    var locationUrls = {};
    <c:forEach items="${spewData}" var="location" varStatus="loop">
        <c:if test="${not empty location.name}">
            locations.push('${location.name}');
        </c:if>

        <c:if test="${not empty location.url}">
            locationUrls['${location.name}'] = '${location.url}';
        </c:if>
    </c:forEach>
    locations.sort();

    var nameBins = ['A-E', 'F-L', 'M-R', 'S-Z'];

    var currentBin = 0;
    var lowerBound = nameBins[currentBin].charCodeAt(0);
    var upperBound = nameBins[currentBin].charCodeAt(2);
    for(var i=0; i < locations.length; i++) {
        var formattedLocation = formatLocation(locations[i]);
        var locationLetterAscii = formattedLocation.charCodeAt(0);

        if(locationLetterAscii >= lowerBound && locationLetterAscii <= upperBound) {
            if(i==0) {
                syntheticEcosystems.nodes.push({'text':nameBins[currentBin], 'nodes': []});
            }
        } else {
            while(!(locationLetterAscii >= lowerBound && locationLetterAscii <= upperBound)) {
                currentBin += 1;

                lowerBound = nameBins[currentBin].charCodeAt(0);
                upperBound = nameBins[currentBin].charCodeAt(2);
            }

            syntheticEcosystems.nodes.push({'text':nameBins[currentBin], 'nodes': []});
        }

        var ecosystem = {};

        if(locations[i] in locationUrls) {
            ecosystem['url'] = locationUrls[locations[i]];
        }

        ecosystem['text'] = "<div class=\"grandnode-with-margin\">" + getPopover("${pageContext.request.contextPath}" + "/resources/img/spew.jpg", formattedLocation, "${pageContext.request.contextPath}" + "/resources/img/spew_more_info.jpg") + "</div>";

        if('url' in ecosystem) {
            delete ecosystem['url'];
        }

        syntheticEcosystems.nodes[syntheticEcosystems.nodes.length - 1].nodes.push(ecosystem);
    } */

    var syntheticEcosystemsByRegion = {
        text: "Synthetic ecosystems",
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
            contentType : "application/json",
            url : ${libraryViewerUrl} + "collectionsJson/",
            dataType : 'json',
            headers : {
                "Authorization" : ${libraryViewerToken}
            },
            timeout : 100000,
            success : function(data) {
                libraryData = data;
            },
            error : function(e) {
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
            }
        });
        

    });

</script>

