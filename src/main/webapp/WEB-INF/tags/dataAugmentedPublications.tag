<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="dataAugmentedPublications" required="true"
	type="java.lang.Iterable"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
	<c:forEach items="${dataAugmentedPublications}" var="pub" varStatus="loop">
    <s:eval
                expression="T(edu.pitt.isg.dc.utils.DigitalCommonsHelper).generateDisplayTitle(pub)"
                var="pubTitle"/>

		dataAugmentedPublications.push({
			"text": "${pubTitle}",
            "url": "${pageContext.request.contextPath}/publication/" + "${pub.paper.id}" + "/" + "${pub.data.id}"

        });

	</c:forEach>

	var $dataAugmentedPublicationsTree = $('#publications-treeview').treeview({
		data: dataAugmentedPublications,
	});

	$('#publications-treeview').on('nodeSelected', function(event, data) {
		if(data.url != null && data.state.selected == true) {
            $('#publications-treeview').treeview('unselectNode', [data.nodeId, {silent: true}]);
            window.location.href = data.url;
		}
	});
</script>

