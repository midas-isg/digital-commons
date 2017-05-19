<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="region" required="true"
              type="edu.pitt.isg.dc.digital.spew.SpewLocation"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:if test="${not empty region.children}">
    <c:if test="${region.name == 'united states of america'}">
        currentNode.push({'name': "${region.name}", 'text': formatLocation("${region.name}") + " <b><i class=\"olympus-color\"><sup>AOC</sup></i></b><span class='badge'>[${region.children.size()}]</span>", 'nodes': []});
        var childNodes = currentNode[currentNode.length - 1].nodes;
        <c:forEach items="${region.children}" var="child" varStatus="childLoop">
            if("${child.value.name}" in stateHash) {
                childNodes.push({
                    'name': stateHash["${child.value.name}"],
                    'text': "<span onmouseover='toggleTitle(this)' onclick='openModal(\"syntheticEcosystems\", \"${child.value.name}\")'>" + formatLocation(stateHash["${child.value.name}"]) + "</span> <b><i class=\"olympus-color\"><sup>AOC</sup></i></b>"
                });
            }
        </c:forEach>
        childNodes.sort(compareNodes);
    </c:if>
    <c:if test="${region.name != 'united states of america'}">
        /* currentNode.push({'name': "${region.name}", 'text': formatLocation("${region.name}"), 'nodes': []});
        currentNode = currentNode[currentNode.length - 1].nodes;

        currentNode.push({'name': "${region.name}", 'text': formatLocation("${region.name}")}); */
        <c:forEach items="${region.children}" var="child" varStatus="childLoop">
            <myTags:recurseRegions region="${child.value}"></myTags:recurseRegions>
        </c:forEach>
    </c:if>
</c:if>
<c:if test="${empty region.children && region.name != 'burkina faso'}">
    <c:if test="${region.name != 'canada'}">
        $('#location-select').append('<option value="' + '${region.name}_${region.code}' + '">' + formatLocation('${region.name}') + '</option>');
    </c:if>

    currentNode.push({
        'name': "${region.name}",
        'text': "<span onmouseover='toggleTitle(this)' onclick='openModal(\"syntheticEcosystems\", \"${region.code}\")'>" + formatLocation("${region.name}") + " </span> <b><i class=\"olympus-color\"><sup>AOC</sup></i></b>"
    });

    $.getJSON( ctx + '/resources/spew-dats-json/' + "${region.code}" + '.json' + '?v=' + Date.now(), function( data ) {
        addDatsToDictionary(syntheticEcosystemsDictionary, data, "${region.code}");
        countryHash["${region.code}"] = formatLocation("${region.name}");
    });
</c:if>