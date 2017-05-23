<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="libraryViewerUrl" required="true"
              type="java.lang.String"%>
<%@ attribute name="libraryViewerToken" required="true"
              type="java.lang.String"%>
<%@ attribute name="spewRegions" required="true"
              type="java.util.List"%>
<%@ attribute name="spewRegionCount" required="false"
              type="java.lang.Integer"%>
<%@ attribute name="spewAmericaCount" required="false"
              type="java.lang.Integer"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
    var syntheticEcosystemsByRegion = {
        text: "<span onmouseover='toggleTitle(this)'>SPEW synthetic ecosystems</span> <span class='badge'>[${spewRegionCount}]</span> ",
        nodes: []
    };

    <c:forEach items="${spewRegions}" var="region" varStatus="loop">
        <c:if test="${not empty region.children}">
            syntheticEcosystemsByRegion.nodes.push({'name': "${region.name}", 'text':formatLocation("${region.name}") + " <b><i class=\"olympus-color\"><sup>AOC</sup></i></b>", 'nodes': []});
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
    sortSelect("#location-select");

    for(var i in syntheticEcosystemsByRegion.nodes) {
        if(syntheticEcosystemsByRegion.nodes[i].nodes != null) {
            syntheticEcosystemsByRegion.nodes[i].nodes.sort(compareNodes);
        }
    }
//    var spewContentsLength =0;
    for(var i = 0; i < syntheticEcosystemsByRegion.nodes.length; i++) {
        var nodeName = syntheticEcosystemsByRegion.nodes[i].name;
        var innerNodesLength = syntheticEcosystemsByRegion.nodes[i].nodes.length;
//        spewContentsLength += innerNodesLength;
        if(syntheticEcosystemsByRegion.nodes[i].text.includes("Americas")) {
            syntheticEcosystemsByRegion.nodes[i].text += "<span class='badge'>[${spewAmericaCount}]</span>";
        } else {
            syntheticEcosystemsByRegion.nodes[i].text += "<span class='badge'>[" + innerNodesLength + "]</span>";
        }
    }
    $(document).ready(function () {
        var libraryData;
        $.ajax({
            type : "GET",
            contentType : "application/json; charset=utf-8",
            url : "${pageContext.request.contextPath}/getCollectionsJson",
            dataType : 'json',
            data: {},
            cache: false,
            timeout : 100000,
            success : function(data) {
                libraryData = data;
                //console.log(libraryData);
            },
            error : function(xhr, textStatus, errorThrown) {
                console.log(xhr.responseText);
                console.log(textStatus);
                console.log(errorThrown);
                libraryData = null;
            },
            complete : function(e) {
                getDataAndKnowledgeTree(libraryData, syntheticEcosystemsByRegion, ${libraryViewerUrl}, "${pageContext.request.contextPath}");
            }
        });
        

    });

</script>

