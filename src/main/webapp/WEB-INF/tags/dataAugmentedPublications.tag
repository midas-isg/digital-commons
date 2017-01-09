<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="dataAugmentedPublications" required="true"
	type="java.util.List"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
	<c:forEach items="${dataAugmentedPublications}" var="pub" varStatus="loop">
		dataAugmentedPublications.push({
			"text": "${pub.text}",
			"nodes": []
		});

		<c:forEach items="${pub.nodes}" var="node">
			dataAugmentedPublications[${loop.index}].nodes.push({
				"text": "<div class=\"node-with-margin\"><strong>${node.type}: </strong>" + "${node.publicationInfo} <i>${node.doiInfo}</i></div>",
				"url": '${node.url}'
			});
		</c:forEach>
	</c:forEach>

	var $dataAugmentedPublicationsTree = $('#publications-treeview').treeview({
		data: dataAugmentedPublications,
	});

	$('#publications-treeview').on('nodeSelected', function(event, data) {
		if(data.url != null && data.state.selected == true) {
			window.location.href = data.url;
		}
	});
</script>

