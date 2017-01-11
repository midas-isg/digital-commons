<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="dap" required="true"
	type="edu.pitt.isg.dc.digital.dap.DataAugmentedPublication"%>
<%@ attribute name="index" required="true"
			  type="java.lang.Integer"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:if test="${not empty dap}">
	var nodeText = "";
	var url = "";

	<c:if test="${not empty dap.typeText}">
		nodeText += "<strong>${dap.typeText}: </strong>";
	</c:if>

	<c:if test="${not empty dap.authorsText}">
		nodeText += "${dap.authorsText} ";
	</c:if>

	<c:if test="${not empty dap.publicationDateText}">
		nodeText += "(${dap.publicationDateText}) ";
	</c:if>

	<c:if test="${not empty dap.name}">
		nodeText += "${dap.name}. ";
	</c:if>

	<c:if test="${not empty dap.journal}">
		nodeText += "<i>${dap.journal}.</i> ";
	</c:if>

	<c:if test="${not empty dap.doi}">
		nodeText += "<i>doi: ${dap.doi}</i> ";
	</c:if>

	<c:if test="${not empty dap.url}">
		nodeText += "<i>${dap.url}</i>";
		url = "${dap.url}";
	</c:if>

	dataAugmentedPublications[${index}].nodes.push({
		"text": "<div class=\"node-with-margin\">" + nodeText + "</div>",
		"url": url
	});
</c:if>

