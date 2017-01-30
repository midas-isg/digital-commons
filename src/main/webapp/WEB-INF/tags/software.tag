<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="software" required="true"
              type="java.lang.Iterable"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
    <c:forEach items="${software}" var="folder" varStatus="loop">
        software.push({
            "text": "<span class=\"root-break\" onmouseover='toggleTitle(this)'>" + "${folder.name}" + "</span>",
            "nodes": []
        });

        <c:forEach items="${folder.list}" var="item">
            <c:if test="${not empty item}">
                var url = '';
                softwareDictionary['${item.name}'] = {};

                <c:if test="${not empty item.version}">
                    softwareDictionary['${item.name}']['version'] = '${item.version}';
                </c:if>

                <c:if test="${not empty item.developer}">
                    softwareDictionary['${item.name}']['developer'] = '${item.developer}';
                </c:if>

                <c:if test="${not empty item.doi}">
                    softwareDictionary['${item.name}']['doi'] = '${item.doi}';
                </c:if>

                <c:if test="${not empty item.sourceCodeUrl}">
                    softwareDictionary['${item.name}']['sourceCode'] = '${item.sourceCodeUrl}';
                    url = '${item.sourceCodeUrl}';
                </c:if>

                <c:if test="${not empty item.url}">
                    softwareDictionary['${item.name}']['location'] = '${item.url}';
                    url = '${item.url}';
                </c:if>

                <c:if test="${folder.name == 'Disease transmission models'}">
                    software[${loop.index}].nodes.push({
                        "text": '<div class="node-with-margin" onmouseover="toggleTitle(this)" onclick="openModal(\'${item.name}\')">' + "${item.name}" + '</div>',
                        "name": "${item.name}"
                    });
                </c:if>

                <c:if test="${folder.name != 'Disease transmission models'}">
                    software[${loop.index}].nodes.push({
                        "text": '<div class="node-with-margin" onmouseover="toggleTitle(this)">${item.name}</div>',
                        "url": url,
                        "name": "${item.name}"
                    });
                </c:if>
            </c:if>
        </c:forEach>
    </c:forEach>

    if(isSoftwareHardcoded) {
        hardcodeSoftware();
    }

    for(var i = 0; i < software.length; i++) {
        software[i].nodes.sort(compareNodes);
    }

    var $softwareTree = $('#algorithm-treeview').treeview({
        data: software,
        showBorder: false,
        collapseAll: true,

        expandIcon: "glyphicon glyphicon-chevron-right",
        collapseIcon: "glyphicon glyphicon-chevron-down",

        onNodeSelected: function(event, data) {
            if(typeof data['nodes'] != undefined) {
                $('#algorithm-treeview').treeview('toggleNodeExpanded', [data.nodeId, { levels: 1, silent: true } ]).treeview('unselectNode', [data.nodeId, {silent: true}]);
            }

            if(data.url != null && data.state.selected == true) {
                window.location.href = data.url;
            }
        }
    });

    $('#algorithm-treeview').treeview('collapseAll', { silent: true });

</script>

