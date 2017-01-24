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
    var syntheticEcosystems = {
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

        ecosystem['text'] = "<div class=\"grandnode-with-margin\">" + getPopover("${pageContext.request.contextPath}" + "/resources/img/syneco.png", formattedLocation, 'openLibraryFrame', [ecosystem['url']]) + "</div>";

        if('url' in ecosystem) {
            delete ecosystem['url'];
        }

        syntheticEcosystems.nodes[syntheticEcosystems.nodes.length - 1].nodes.push(ecosystem);
    }

    var syntheticEcosystemsByRegion = {
        text: "Synthetic ecosystems (by region)",
        nodes: []
    };

    <c:forEach items="${spewRegions}" var="region" varStatus="loop">
        console.log("${region.name}");

        <c:forEach items="${region.children}" var="child">
            console.log("${child}");
        </c:forEach>

        console.log("${region.children}");
    </c:forEach>



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
                    data: getDataAndKnowledgeTree(libraryData, syntheticEcosystems, ${libraryViewerUrl}),
                    showBorder: false,
                    backColor: "#092940",
                    onhoverColor: "#397AAC",
                    color: "white",
                    expandIcon: "glyphicon glyphicon-chevron-right",
                    collapseIcon: "glyphicon glyphicon-chevron-down",
                });
                $('#data-and-knowledge-treeview').treeview('collapseAll', { silent: true });
                $('#data-and-knowledge-treeview').on('nodeSelected', function(event, data) {
                    if(typeof data['nodes'] != undefined) {
                        $('#data-and-knowledge-treeview').treeview('toggleNodeExpanded', [data.nodeId, { levels: 1, silent: true } ]).treeview('unselectNode', [data.nodeId, {silent: true}]);
                    }
                    if(data.url != null && data.state.selected == true) {
                        document.getElementById("libraryFrame").parentNode.style.display='';
//                        document.getElementById("iframeNav").style.display='';
                        document.getElementById("commons-main-body").style.display='none';
                        document.getElementById("commons-main-tabs").style.display='none';

                        window.open(data.url, "libraryFrame");
                    }
                });
            }
        });
        

    });

</script>

