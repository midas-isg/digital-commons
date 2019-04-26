<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<div class="metadata-table"><h4 class="sub-title-font">Licensing and attribution</h4>
    <table class="table table-condensed table-borderless table-discrete table-striped">
        <tbody>
        <tr>
            <td>
                License
            </td>
            <td>
                <c:forEach items="${entryView.entry.licenses}" var="license" varStatus="varStatus">
                    ${license.name}${!varStatus.last ? ',' : ''}
                </c:forEach>
            </td>
        </tr>
        <c:if test="${not empty entryView.entry.licenses[0].identifier}">
            <tr>
                <td>Source</td>
                <td>
                    <c:forEach items="${entryView.entry.licenses}" var="license"
                               varStatus="varStatus">
                        <a href="${license.identifier.identifier}"
                           class="underline">${license.identifier.identifier}</a>${!varStatus.last ? ',' : ''}
                    </c:forEach>
                </td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
