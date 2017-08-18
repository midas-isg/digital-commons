<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="entries" required="true" type="java.util.List"%>
<%@ attribute name="title" required="true" type="java.lang.String"%>
<h4>${title}</h4>

<table class="table table-condensed">
    <thead>
    <tr>
        <th>Title</th>
        <th>Version(s)</th>
        <th>Author(s)</th>
        <th>Type</th>
        <th>Preview</th>
        <th>Edit</th>
        <th>Comment(s)</th>
        <th>
            <c:choose>
                <c:when test="${title == 'Approved'}">Make Public</c:when>
                <c:otherwise>Approve</c:otherwise>
            </c:choose>
        </th>
        <th>Reject</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${entries}" var="entry">
        <c:if test="${entry.comments != null}">
            <script>
                entryComments["${entry.id.entryId}-${entry.id.revisionId}"] = [];
                <c:forEach items="${entry.comments}" var="comment">
                    entryComments["${entry.id.entryId}-${entry.id.revisionId}"].push("${comment}");
                </c:forEach>
            </script>
        </c:if>

        <tr id="tr-${entry.id.entryId}-${entry.id.revisionId}">
            <c:choose>
                <c:when test="${entry.entry.title != null}">
                    <td>${entry.entry.title}</td>
                </c:when>
                <c:otherwise>
                    <td>${entry.entry.name}</td>
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${entry.entry.version != null && fn:length(entry.entry.version) > 0}">
                    <c:choose>
                        <c:when test="${fn:contains(entry.entryType, 'DataStandard')}">
                            <td>${entry.entry.version}</td>
                        </c:when>
                        <c:otherwise>
                            <td>
                                <c:forEach items="${entry.entry.version}" var="version" varStatus="versionLoop">
                                    ${version}<c:if test="${!versionLoop.last}">,</c:if>
                                </c:forEach>
                            </td>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <td>N/A</td>
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${entry.entry.developers != null && fn:length(entry.entry.developers) > 0}">
                    <td>
                        <c:forEach items="${entry.entry.developers}" var="developer" varStatus="developerLoop">
                            ${developer}<c:if test="${!developerLoop.last}">,</c:if>
                        </c:forEach>
                    </td>
                </c:when>
                <c:when test="${entry.entry.creators != null && fn:length(entry.entry.creators) > 0}">
                    <td>
                        <c:forEach items="${entry.entry.creators}" var="creator" varStatus="creatorLoop">
                            ${creator.firstName} ${creator.lastName}<c:if test="${!creatorLoop.last}">,</c:if>
                        </c:forEach>
                    </td>
                </c:when>
                <c:otherwise>
                    <td>N/A</td>
                </c:otherwise>
            </c:choose>
            <c:set var="splitEntryType" value="${fn:split(entry.entryType, '.')}"></c:set>
            <td>${splitEntryType[fn:length(splitEntryType) - 1]}</td>
            <td class="text-center"><button class="btn btn-xs btn-default" onclick='showModal(JSON.parse("${entry.entryJsonString}")["entry"],"${splitEntryType[fn:length(splitEntryType) - 1]}")'><icon class="glyphicon glyphicon-eye-open"></icon></button></td>
            <td class="text-center"><a href="${pageContext.request.contextPath}/add/${splitEntryType[fn:length(splitEntryType) - 1]}?entryId=${entry.id.entryId}&revisionId=${entry.id.revisionId}&categoryId=${entry.category.id}"><button class="btn btn-xs btn-default"><icon class="glyphicon glyphicon-edit"></icon></button></a></td>
            <td class="text-center"><button class="btn btn-xs btn-default" onclick="showReviewEntryModal('commentModal', '${entry.id.entryId}', '${entry.id.revisionId}', '${entry.category.id}', this, entryComments['${entry.id.entryId}-${entry.id.revisionId}']);"><icon class="glyphicon glyphicon-comment"></icon></button></td>
            <td class="text-center"><button class="btn btn-xs btn-default" onclick="showReviewEntryModal('approveModal', '${entry.id.entryId}', '${entry.id.revisionId}', '${entry.category.id}', this, null, '${entry.getProperty('status')}');"><icon class="glyphicon glyphicon-check"></icon></button></td>
            <td class="text-center"><button id="reject-btn-${entry.id.entryId}-${entry.id.revisionId}" class="btn btn-xs btn-default" onclick="showReviewEntryModal('rejectModal', '${entry.id.entryId}', '${entry.id.revisionId}', '${entry.category.category}', this, entryComments['${entry.id.entryId}-${entry.id.revisionId}']);"><icon class="glyphicon glyphicon-remove"></icon></button></td>
        </tr>
        <script>
            <c:choose>
                <c:when test="${entry.getProperty('status') == 'rejected'}">
                    $("#tr-${entry.id.entryId}-${entry.id.revisionId}").css('background-color', '#f2dede');
                    $("#reject-btn-${entry.id.entryId}-${entry.id.revisionId}").addClass('disabled');
                </c:when>
                <c:when test="${entry.getProperty('status') == 'revised'}">
                    $("#tr-${entry.id.entryId}-${entry.id.revisionId}").css('background-color', '#feffb1');
                </c:when>
            </c:choose>
        </script>
    </c:forEach>
    </tbody>
</table>