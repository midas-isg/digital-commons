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
        <th>JSON Data</th>
        <th>Approve</th>
        <th>Reject</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${entries}" var="entry">
        <tr>
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
            <td><button class="btn btn-xs btn-default" onclick='showModal(JSON.parse("${entry.entryJsonString}")["entry"],"${splitEntryType[fn:length(splitEntryType) - 1]}")'>View</button></td>
            <td><button class="btn btn-xs btn-success" onclick="showReviewEntryModal('approveModal', '${entry.id.entryId}', '${entry.id.revisionId}', '${entry.category.id}', this);"><icon class="glyphicon glyphicon-check"></icon></button></td>
            <td><button class="btn btn-xs btn-danger" onclick="showReviewEntryModal('rejectModal', '${entry.id.entryId}', '${entry.id.revisionId}', '${entry.category.category}', this);"><icon class="glyphicon glyphicon-trash"></icon></button></td>
        </tr>
    </c:forEach>
    </tbody>
</table>