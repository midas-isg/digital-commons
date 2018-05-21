<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<div class="metadata-table"><h4 class="sub-title-font">Creator Information</h4>
    <table class="table table-condensed table-borderless table-discrete table-striped">
        <tbody>
        <c:if test="${not empty entryView.entry.creators}">
            <tr>
                <td>Created by</td>
                <td>
                    <c:forEach items="${entryView.entry.creators}" var="creator"
                               varStatus="status">
                        <c:choose>
                            <c:when test="${not empty creator.name}">
                                <c:choose>
                                    <c:when test="${creator.name.getClass().simpleName == 'String'}">
                                        ${creator.name}${!status.last ? ',' : ''}
                                    </c:when>
                                    <c:otherwise>
                                        ${creator.name.description}${!status.last ? ',' : ''}
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:when test="${not empty creator.fullName}">
                                ${creator.fullName}${!status.last ? ',' : ''}
                            </c:when>
                            <c:otherwise>
                                ${creator.firstName} ${creator.lastName}${!status.last ? ',' : ''}
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </td>
            </tr>
            <c:if test="${not empty entryView.entry.creators[0].email}">
                <tr>
                    <td>Creator emails</td>
                    <td>
                        <c:forEach items="${entryView.entry.creators}" var="creator"
                                   varStatus="status">
                            <c:if test="${not empty creator.email}">
                                <a href="mailto:${creator.email}"
                                   class="underline">${creator.email}</a>${!status.last ? ',' : ''}
                            </c:if>
                        </c:forEach>
                    </td>
                </tr>
            </c:if>
        </c:if>
        <c:if test="${not empty entryView.entry.developers}">
            <tr>
                <td>Developers</td>
                <td>
                    <c:forEach items="${entryView.entry.developers}" var="developer"
                               varStatus="status">
                        ${developer}${!status.last ? ',' : ''}
                    </c:forEach>
                </td>
            </tr>
        </c:if>
        <c:if test="${not empty entryView.entry.producedBy}">
            <tr>
                <td>Produced by</td>
                <td>
                        ${entryView.entry.producedBy.name}
                </td>
            </tr>
        </c:if>
        <c:if test="${not empty entryView.entry.source}">
            <tr>
                <td>Code repository source</td>
                <td><a href="${entryView.entry.source}"
                       class="underline">${entryView.entry.source}</a></td>
            </tr>
        </c:if>

        </tbody>
    </table>
</div>
