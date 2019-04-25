<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<c:if test="${not empty entryView.entry.controlMeasures}">
    <tr>
        <td>Control Measures</td>
        <td>
            <div>
                <div class="tag-list" style="word-wrap: break-word;">
                    <c:forEach items="${entryView.entry.controlMeasures}"
                               var="controlMeasure"
                               varStatus="varStatus">
                         <a href="${controlMeasure.identifier.identifier}" class="color-white badge badge-primary">${controlMeasure.identifier.identifierDescription}</a>
                    </c:forEach>
                </div>
            </div>
        </td>
    </tr>
</c:if>
