<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="entries" required="true" type="java.util.List"%>
<%@ attribute name="title" required="true" type="java.lang.String"%>
<%@ attribute name="adminType" required="true" type="java.lang.String"%>
<h4>${title}</h4>

<table class="table table-condensed">
    <thead>
    <tr>
        <th>Date Added</th>
        <th>Title</th>
        <th>Version(s)</th>
        <th>Author(s)</th>
        <th>Type</th>
        <th class="text-center">Preview</th>
        <th class="text-center">Edit</th>
        <th class="text-center">Comment(s)</th>
        <c:if test="${adminType == 'ISG_ADMIN'}">
            <th class="text-center">
                <c:choose>
                    <c:when test="${title == 'Approved'}">Make Public</c:when>
                    <c:otherwise>Approve</c:otherwise>
                </c:choose>
            </th>
            <th class="text-center">Reject</th>
        </c:if>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${entries}" var="entry">
        <c:if test="${entry.comments != null}">
            <script>
                entryComments["${entry.id.entryId}-${entry.id.revisionId}"] = [];
               <c:forEach items="${entry.sanitizedComments}" var="comment">
                    entryComments["${entry.id.entryId}-${entry.id.revisionId}"].push("${comment}");
                </c:forEach>
            </script>
        </c:if>

        <script>
            softwareXml["${entry.id.entryId}-${entry.id.revisionId}"] = "${entry.escapedXmlString}";
        </script>

        <tr id="tr-${entry.id.entryId}-${entry.id.revisionId}-${title}">
            <td>
                <c:choose>
                    <c:when test="${entry.dateAdded != null}">
                        <fmt:formatDate type = "date"
                                        dateStyle = "short"
                                        value="${entry.dateAdded}"/>
                    </c:when>
                    <c:otherwise>
                        N/A
                    </c:otherwise>
                </c:choose>
            </td>
            <c:choose>
                <c:when test="${entry.entry.title != null}">
                    <td>${fn:escapeXml(entry.entry.title)}</td>
                </c:when>
                <c:otherwise>
                    <td>${fn:escapeXml(entry.entry.name)}</td>
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${entry.entry.version != null && fn:length(entry.entry.version) > 0}">
                    <c:choose>
                        <c:when test="${fn:contains(entry.entryType, 'DataStandard')}">
                            <td>${fn:escapeXml(entry.entry.version)}</td>
                        </c:when>
                        <c:otherwise>
                            <td>
                                <c:forEach items="${entry.entry.version}" var="version" varStatus="versionLoop">
                                    ${fn:escapeXml(version)}<c:if test="${!versionLoop.last}">,</c:if>
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
                            ${fn:escapeXml(developer)}<c:if test="${!developerLoop.last}">,</c:if>
                        </c:forEach>
                    </td>
                </c:when>
                <c:when test="${entry.entry.creators != null && fn:length(entry.entry.creators) > 0}">
                    <td>
                        <c:forEach items="${entry.entry.creators}" var="creator" varStatus="creatorLoop">
                            <c:catch var="firstNameException">${fn:escapeXml(creator.firstName)}</c:catch>
                            <c:catch var="lastNameException">${fn:escapeXml(creator.lastName)}</c:catch>
                            <c:catch var="nameException">${fn:escapeXml(creator.name)}</c:catch>

                            <%--<c:choose>
                                <%--<c:when test="${empty firstNameException}">
                                    ${fn:escapeXml(creator.firstName)}
                                </c:when>
                                <c:when test="${empty lastNameException}">
                                    ${fn:escapeXml(creator.lastName)}
                                </c:when>
                                <c:when test="${empty nameException}">
                                    ${fn:escapeXml(creator.name)}
                                </c:when>
                            </c:choose>--%>
                            <c:if test="${!creatorLoop.last}">,</c:if>
                        </c:forEach>
                    </td>
                </c:when>
                <c:otherwise>
                    <td>N/A</td>
                </c:otherwise>
            </c:choose>
            <c:set var="splitEntryType" value="${fn:split(entry.entryType, '.')}"></c:set>
            <td>${splitEntryType[fn:length(splitEntryType) - 1]}</td>
            <td class="text-center"><button class="btn btn-xs btn-default" onclick='showModal(JSON.parse("${entry.entryJsonString}")["entry"],"${splitEntryType[fn:length(splitEntryType) - 1]}", softwareXml["${entry.id.entryId}-${entry.id.revisionId}"])'><icon class="glyphicon glyphicon-eye-open"></icon></button></td>
            <td class="text-center"><a href="${pageContext.request.contextPath}/add/${splitEntryType[fn:length(splitEntryType) - 1]}?entryId=${entry.id.entryId}&revisionId=${entry.id.revisionId}&categoryId=${entry.category.id}"><button class="btn btn-xs btn-default"><icon class="glyphicon glyphicon-edit"></icon></button></a></td>
            <td class="text-center"><button class="btn btn-xs btn-default" onclick="location.href='${pageContext.request.contextPath}/add/review/comments?entryId=${entry.id.entryId}&revisionId=${entry.id.revisionId}'"><icon class="glyphicon glyphicon-comment"></icon> <c:if test="${not empty entry.comments}">(${fn:length(entry.comments)})</c:if></button></td>
            <c:if test="${adminType == 'ISG_ADMIN'}">
                <td class="text-center"><button class="btn btn-xs btn-default" onclick="showReviewEntryModal('approveModal', '${entry.id.entryId}', '${entry.id.revisionId}', '${entry.category.id}', this, null, '${entry.getProperty('status')}', null);"><icon class="glyphicon glyphicon-check"></icon></button></td>
                <td class="text-center"><button id="reject-btn-${entry.id.entryId}-${entry.id.revisionId}" class="btn btn-xs btn-default" onclick="showReviewEntryModal('rejectModal', '${entry.id.entryId}', '${entry.id.revisionId}', '${entry.category.category}', this, null);"><icon class="glyphicon glyphicon-remove"></icon></button></td>
            </c:if>
        </tr>
        <script>
            <c:choose>
                <c:when test="${entry.getProperty('status') == 'rejected'}">
                    $("#tr-${entry.id.entryId}-${entry.id.revisionId}-${title}").css('background-color', '#f2dede');
                    $("#reject-btn-${entry.id.entryId}-${entry.id.revisionId}").addClass('disabled');
                </c:when>
                <c:when test="${entry.getProperty('status') == 'revised'}">
                    $("#tr-${entry.id.entryId}-${entry.id.revisionId}-${title}").css('background-color', '#feffb1');
                </c:when>
            </c:choose>
        </script>
    </c:forEach>
    </tbody>
</table>