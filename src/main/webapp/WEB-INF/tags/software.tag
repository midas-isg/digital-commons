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
            <c:if test="${not empty item}">
                software[${loop.index}].nodes.push({
                    "text": "<div class=\"node-with-margin\">" + "${item.name}" + "</div>",
                    "url": "${pageContext.request.contextPath}/software/" + "${item.id}"
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

