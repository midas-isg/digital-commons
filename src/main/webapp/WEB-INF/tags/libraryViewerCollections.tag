<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="libraryViewerUrl" required="true"
              type="java.lang.String"%>
<%@ attribute name="libraryViewerToken" required="true"
              type="java.lang.String"%>
<%@ attribute name="spewData" required="true"
              type="java.lang.Iterable"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
    var syntheticEcosystems = {
        text: "Synthetic ecosystems",
        nodes: []
    };

    <c:forEach items="${spewData}" var="location" varStatus="loop">
        var ecosystem = {};

        <c:if test="${not empty location.name}">
            ecosystem['text'] = '${location.name}';
        </c:if>

        <c:if test="${not empty location.url}">
            ecosystem['url'] = '${location.url}';
        </c:if>

        syntheticEcosystems.nodes.push(ecosystem);
    </c:forEach>

    $(document).ready(function () {
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
                var $dataAndKnowledgeTree = $('#data-and-knowledge-treeview').treeview({
                    data: getDataAndKnowledgeTree(data, syntheticEcosystems, ${libraryViewerUrl}),
                    showBorder: false,
                    expandIcon: "glyphicon glyphicon-chevron-right",
                    collapseIcon: "glyphicon glyphicon-chevron-down",
                });
                return data;
            },
            error : function(e) {
                console.log(data);
                console.log("ERROR: ", e);
            },
            complete : function(e) {
                $('#data-and-knowledge-treeview').treeview('collapseAll', { silent: true });
                $('#data-and-knowledge-treeview').on('nodeSelected', function(event, data) {
                    if(typeof data['nodes'] != undefined) {
                        $('#data-and-knowledge-treeview').treeview('toggleNodeExpanded', [data.nodeId, { levels: 1, silent: true } ]).treeview('unselectNode', [data.nodeId, {silent: true}]);
                    }
                    if(data.url != null && data.state.selected == true) {
                        window.open(data.url);
                    }
                });
            }
        });
        

    });

</script>

