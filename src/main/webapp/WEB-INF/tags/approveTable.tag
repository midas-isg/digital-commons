<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="entries" required="true" type="java.util.List"%>
<%@ attribute name="title" required="true" type="java.lang.String"%>
<%@ attribute name="adminType" required="true" type="java.lang.String"%>
<%@ attribute name="type" required="true" type="java.lang.String"%>
<%@ attribute name="toggleRejects" required="false" type="java.lang.Boolean"%>

<h4 class="inline">${title}</h4>
<c:if test="${toggleRejects}">
    <div class="form-check pull-right">
        <input type="checkbox" class="form-check-input" id="reject-check-${type}">
        <label class="form-check-label" for="reject-check-${type}">Show rejected entries</label>
    </div>
</c:if>
<table class="table table-condensed">
    <thead>
    <tr>
        <th>Date Added</th>
        <th>Title</th>
        <th>Version(s)</th>
        <th>Author(s)</th>
        <th>Type</th>
        <th>Entry Author</th>
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

        <tr id="tr-${entry.id.entryId}-${entry.id.revisionId}-${type}">
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
            <c:choose>
                <c:when test="${entry.usersId != null && fn:length(entry.usersId.name) > 0}">
                    <td>
                            ${fn:escapeXml(entry.usersId.name)}
                    </td>
                </c:when>
                <c:otherwise>
                    <td>N/A</td>
                </c:otherwise>
            </c:choose>
            <td class="text-center"><button class="btn btn-xs btn-default" onclick='showModal(JSON.parse("${entry.entryJsonString}")["entry"],"${splitEntryType[fn:length(splitEntryType) - 1]}", softwareXml["${entry.id.entryId}-${entry.id.revisionId}"])'><i class="far fa-eye"></i></button></td>
            <td class="text-center"><a href="${pageContext.request.contextPath}/add-digital-object?entryID=${entry.id.entryId}"><button class="btn btn-xs btn-default"><i class="fas fa-edit"></i></button></a></td>
            <td class="text-center"><button class="btn btn-xs btn-default" onclick="location.href='${pageContext.request.contextPath}/add/review/comments?entryId=${entry.id.entryId}&revisionId=${entry.id.revisionId}'"><i class="far fa-comment-alt"></i> <c:if test="${not empty entry.comments}">(${fn:length(entry.comments)})</c:if></button></td>
            <c:if test="${adminType == 'ISG_ADMIN'}">
                <td class="text-center"><button class="btn btn-xs btn-default" onclick="showReviewEntryModal('approveModal', '${entry.id.entryId}', '${entry.id.revisionId}', '${entry.category.id}', this, '${entry.getProperty('status')}');"><i class="far fa-check-square"></i></button></td>
                <td class="text-center"><button id="reject-btn-${entry.id.entryId}-${entry.id.revisionId}" class="btn btn-xs btn-default" onclick="showReviewEntryModal('rejectModal', '${entry.id.entryId}', '${entry.id.revisionId}', '${entry.category.category}', this, null);"><icon class="fa fa-minus-circle"></icon></button></td>
            </c:if>
        </tr>
        <script>
            <c:choose>
                <c:when test="${entry.getProperty('status') == 'rejected'}">
                    $("#tr-${entry.id.entryId}-${entry.id.revisionId}-${type}").addClass('rejected-entry');
                    $("#tr-${entry.id.entryId}-${entry.id.revisionId}-${type}").addClass('rejected-entry-${type}');
                    $("#tr-${entry.id.entryId}-${entry.id.revisionId}-${type}").addClass('hidden');
                    $("#reject-btn-${entry.id.entryId}-${entry.id.revisionId}").addClass('disabled');
                </c:when>
                <c:when test="${entry.getProperty('status') == 'revised'}">
                    $("#tr-${entry.id.entryId}-${entry.id.revisionId}-${type}").addClass('revised-entry');
                </c:when>
            </c:choose>
        </script>
    </c:forEach>
    </tbody>
</table>

<script>
    $("#reject-check-${type}").on('change', function () {
        if($("#reject-check-${type}").is(":checked")) {
            $(".rejected-entry-${type}").removeClass("hidden");
        } else {
            $(".rejected-entry-${type}").addClass("hidden");
        }
    })
</script>