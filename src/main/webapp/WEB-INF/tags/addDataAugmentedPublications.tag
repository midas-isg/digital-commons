<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="publication" required="true"
	type="edu.pitt.isg.dc.digital.dap.DataAugmentedPublication"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

	<h3 class="sub-title-font"><a class="underline" href="${publication.url}">${publication.name}</a></h3>

	<%--<c:if test="${not empty publication.typeText}">--%>
		<%--<div class="font-size-20 standard-font text-capitalize">--%>
				<%--${publication.typeText}--%>
		<%--</div>--%>
	<%--</c:if>--%>


	<c:if test="${not empty publication.authorsText}">
		<div class="publication-info font-size-16">
				${publication.authorsText}
		</div>
	</c:if>

	<%--<c:if test="${not empty publication.publicationDateText}">--%>
		<%--<div class="font-size-16">--%>
			<%--<h4 class="inline">Publication date:</h4>--%>
				<%--${publication.publicationDateText}--%>
		<%--</div>--%>
	<%--</c:if>--%>


	<c:if test="${not empty publication.journal}">
		<div class="font-size-16 standard-font">
				<%--${publication.typeText} |--%>
					published
					<fmt:parseDate pattern="M-dd-yyyy" value="${publication.publicationDateText}" var="parsedDate" />
					<fmt:formatDate value="${parsedDate}" pattern="dd MMM yyyy" />,
						${publication.journal}
		</div>
	</c:if>

	<c:if test="${not empty publication.doi}">
		<div class="font-size-16">
			<h4 class="inline standard-font">doi: </h4>
			<a class="underline standard-font" href="${publication.url}">${publication.doi} <i class="fa fa-external-link" aria-hidden="true"></i></a>
		</div>
	</c:if>


	<br>

