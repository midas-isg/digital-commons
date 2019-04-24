<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>
<%@ attribute name="lineage" required="true"
              type="java.util.List" %>

<c:if test="${not lineage.contains('Data Formats') and (not empty entryView.entry.spatialCoverage or not empty entryView.entry.locationCoverage or not lineage.contains('Software'))}">
    <tr>
        <td>Spatial coverage</td>
        <td>
            <c:choose>
                <c:when test="${not empty entryView.entry.spatialCoverage}">
                    <c:forEach items="${entryView.entry.spatialCoverage}" var="coverage"
                               varStatus="varStatus">
                        <%--${fn:toUpperCase(fn:substring(coverage.name, 0, 1))}${fn:toLowerCase(fn:substring(coverage.name, 1,fn:length(coverage.name)))}${!status.last ? ',' : ''}--%>
                        ${coverage.name}${!varStatus.last ? ',' : ''}
                    </c:forEach>
                </c:when>
                <c:when test="${not empty entryView.entry.locationCoverage}">
                    <c:forEach items="${entryView.entry.locationCoverage}" var="coverage"
                               varStatus="varStatus">
                        <span class="capitalize">${coverage.identifier.identifierDescription}</span>${!varStatus.last ? ',' : ''}
                    </c:forEach>
                </c:when>
                <c:when test="${not empty entryView.category.category}">
                    ${entryView.category.category}
                </c:when>
                <c:otherwise>
                    Undocumented
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
</c:if>
