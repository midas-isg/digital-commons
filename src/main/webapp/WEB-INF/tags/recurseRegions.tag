<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="region" required="true"
              type="edu.pitt.isg.dc.digital.spew.SpewLocation"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:if test="${not empty region.children}">
    /* currentNode.push({'name': "${region.name}", 'text': formatLocation("${region.name}"), 'nodes': []});
    currentNode = currentNode[currentNode.length - 1].nodes;

    currentNode.push({'name': "${region.name}", 'text': formatLocation("${region.name}")}); */
    <c:forEach items="${region.children}" var="child" varStatus="childLoop">
        <myTags:recurseRegions region="${child.value}"></myTags:recurseRegions>
    </c:forEach>
</c:if>
<c:if test="${empty region.children}">
    currentNode.push({'name': "${region.name}", 'text': "<span onmouseover='toggleTitle(this)'>" + formatLocation("${region.name}") + "</span>", 'url': "${region.url}"});
</c:if>