<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="dataAugmentedPublications" required="true"
	type="java.lang.Iterable"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
	<c:forEach items="${dataAugmentedPublications}" var="pub" varStatus="loop">
		dataAugmentedPublications.push({
			"text": "${pub.name}",
			"nodes": []
		});

		<myTags:addDataAugmentedPublications dap="${pub.paper}" index="${loop.index}"></myTags:addDataAugmentedPublications>
		<myTags:addDataAugmentedPublications dap="${pub.data}" index="${loop.index}"></myTags:addDataAugmentedPublications>
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

