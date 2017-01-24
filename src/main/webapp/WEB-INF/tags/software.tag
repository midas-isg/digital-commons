<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="software" required="true"
              type="java.lang.Iterable"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
    <c:forEach items="${software}" var="folder" varStatus="loop">
        software.push({
            "text": "${folder.name}",
            "nodes": []
        });

        <c:forEach items="${folder.list}" var="item">
            <c:if test="${not empty item}">
                /*var collapseText = '';

                <c:if test="${not empty item.version}">
                    collapseText += 'Version: ' + '${item.version}';
                </c:if>

                <c:if test="${not empty item.developer}">
                    if(collapseText.length > 0) {
                        collapseText += '<br>';
                    }
                    collapseText += 'Developer(s): ' + '${item.developer}';
                </c:if>

                <c:if test="${not empty item.doi}">
                    if(collapseText.length > 0) {
                        collapseText += '<br>';
                    }
                    collapseText += '<br>DOI: ' + '${item.developer}';
                </c:if>

                <c:if test="${not empty item.url}">
                    if(collapseText.length > 0) {
                        collapseText += '<br>';
                    }
                    collapseText += 'Software location: ' + '${item.url}';
                </c:if>

                <c:if test="${not empty item.sourceCodeUrl}">
                    if(collapseText.length > 0) {
                        collapseText += '<br>';
                    }
                    collapseText += 'Source code location: ' + '${item.sourceCodeUrl}';
                </c:if>*/

                software[${loop.index}].nodes.push({
                    "text": '<div class="node-with-margin">' + getPopover("${pageContext.request.contextPath}", '${item.name}') + '</div>',
                    "url": "${pageContext.request.contextPath}/main/software/" + "${item.id}"
                });

                /*software[${loop.index}].nodes.push({
                 "text": "<div class=\"node-with-margin\">${item.name}</div>",
                 "url": "${pageContext.request.contextPath}/main/software/" + "${item.id}"
                 });*/

                /*software[${loop.index}].nodes.push({
                    "text": "<div class=\"node-with-margin\">" + collapsableNode("${pageContext.request.contextPath}", "${item.name}", collapseText) + "</div>",
                    "url": "${pageContext.request.contextPath}/main/software/" + "${item.id}"
                });*/
            </c:if>
        </c:forEach>
    </c:forEach>

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

