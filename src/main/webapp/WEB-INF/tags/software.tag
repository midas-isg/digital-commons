<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="software" required="true"
              type="java.util.List"%>
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
            var nodeText = "";
            var url = "#";

            <c:if test="${not empty item}">
                <c:if test="${not empty item.name}">
                    nodeText += ${item.name} + " ";
                </c:if>

                <c:if test="${not empty item.version}">
                    nodeText += "(" + ${item.version} + "). ";
                </c:if>

                <c:if test="${not empty item.developer}">
                    nodeText += ${item.developer} + ". ";
                </c:if>

                <c:if test="${not empty item.doi}">
                    nodeText += "<i>" + ${item.doi} + ".</i> ";
                </c:if>

                <c:if test="${not empty item.url}">
                    nodeText += "<i>" + ${item.url} + ".</i> ";
                </c:if>

                <c:if test="${not empty item.sourceCodeUrl}">
                    nodeText += "<i>Source: " + ${item.sourceCodeUrl} + ".</i> ";
                </c:if>

                software[${loop.index}].nodes.push({
                    "text": "<div class=\"node-with-margin\">" + nodeText + "</div>",
                    "url": url
                });
            </c:if>
        </c:forEach>
    </c:forEach>

    var $softwareTree = $('#algorithm-treeview').treeview({
        data: software
    });

    $('#algorithm-treeview').on('nodeSelected', function(event, data) {
        if(data.url != null && data.state.selected == true) {
            window.location.href = data.url;
        }
    });
</script>

