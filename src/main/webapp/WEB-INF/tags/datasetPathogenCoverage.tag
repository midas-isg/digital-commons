<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<c:if test="${not empty entryView.entry.pathogenCoverage}">
    <td>
        Pathogen coverage
    </td>
    <td>
        <c:forEach items="${entryView.entry.pathogenCoverage}" var="coverage"
                   varStatus="varStatus">
            <span class="capitalize">${coverage.identifier.identifierDescription}</span>${!varStatus.last ? ',' : ''}
        </c:forEach>
    </td>
</c:if>
