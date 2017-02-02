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
            "url": "${pageContext.request.contextPath}/main/publication/" + "${pub.paper.id}" + "/" + "${pub.data.id}",
			"paperId": "${pub.paper.id}",
			"dataId": "${pub.data.id}"

        });

	</c:forEach>

	var $dataAugmentedPublicationsTree = $('#publications-treeview').treeview({
		data: dataAugmentedPublications,
        expandIcon: "glyphicon glyphicon-chevron-right",
        collapseIcon: "glyphicon glyphicon-chevron-down",
		emptyIcon: "bullet-point	",
		showBorder: false,
	});

	$('#publications-treeview').on('nodeSelected', function(event, data) {
		if(data.url != null && data.state.selected == true) {
            $('#publications-treeview').treeview('unselectNode', [data.nodeId, {silent: true}]);
			activeTab("publication-" + data.paperId + "-" + data.dataId);
            //window.location.href = data.url;
		}
	});
</script>

