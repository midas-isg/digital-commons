<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="publication" required="true"
	type="edu.pitt.isg.dc.digital.dap.DataAugmentedPublication"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

	<h3 class="sub-title-font">${publication.name}</h3>

	<c:if test="${not empty publication.typeText}">
		<div class="font-size-16">
			<h4 class="inline">Type: </h4>
				${publication.typeText}
		</div>
	</c:if>


	<c:if test="${not empty publication.authorsText}">
		<div class="font-size-16">
			<h4 class="inline">Authors: </h4>
				${publication.authorsText}
		</div>
	</c:if>

	<c:if test="${not empty publication.publicationDateText}">
		<div class="font-size-16">
			<h4 class="inline">Publication date:</h4>
				${publication.publicationDateText}
		</div>
	</c:if>

	<c:if test="${not empty publication.name}">
		<div class="font-size-16">
			<h4 class="inline">Publication Name:</h4>
				${publication.name}
		</div>
	</c:if>

	<c:if test="${not empty publication.journal}">
		<div class="font-size-16">
			<h4 class="inline">Journal:</h4>
				${publication.journal}
		</div>
	</c:if>

	<c:if test="${not empty publication.doi}">
		<div class="font-size-16">
			<h4 class="inline">DOI: </h4>
				${publication.doi}
		</div>
	</c:if>

	<c:if test="${not empty publication.url}">
		<div class="font-size-16">
			<h4 class="inline">URL: </h4>
			<a href="${publication.url}">${publication.url}</a>
		</div></c:if>


	<br>

