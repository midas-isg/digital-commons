<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<c:if test="${not empty entryView.entry.hostSpeciesIncluded}">
    <tr>
        <td>Host species included</td>
        <td>
            <div>
                <div class="tag-list" style="word-wrap: break-word;">
                    <c:forEach items="${entryView.entry.hostSpeciesIncluded}"
                               var="hostSpeciesIncluded"
                               varStatus="varStatus">
                        <c:choose>
                            <c:when test="${not empty hostSpeciesIncluded.identifier.identifierDescription}">
                                <span class="badge badge-info">${fn:toUpperCase(fn:substring(hostSpeciesIncluded.identifier.identifierDescription, 0, 1))}${fn:toLowerCase(fn:substring(hostSpeciesIncluded.identifier.identifierDescription, 1,fn:length(hostSpeciesIncluded.identifier.identifierDescription)))}</span>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                </div>
            </div>
        </td>
    </tr>
</c:if>
