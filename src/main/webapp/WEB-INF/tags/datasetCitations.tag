<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<%--<div class="metadata-row">--%>
<%--<div class="metadata-pair">--%>
<%--<dt class="metadata-pair-title">Updated</dt>--%>
<%--<dd class="metadata-pair-value">August 27, 2015</dd>--%>
<%--</div>--%>
<%--</div>--%>

<c:if test="${not empty entryView.entry.citations}">
    <div class="metadata-table"><h4 class="sub-title-font">Citations</h4>
        <table class="table table-condensed table-borderless table-discrete">
            <tbody>
                <c:forEach items="${entryView.entry.citations}" var="citation">
                    <tr>
                        <td>
                            <div class="metadata-table"><h4 class="sub-title-font">${citation.publicationVenue}</h4>
                                <table class="table table-condensed table-borderless table-discrete table-striped">
                                    <tbody>
                                        <c:if test="${not empty citation.type}">
                                            <tr>
                                                <td>
                                                    Citation type
                                                </td>
                                                <td>
                                                        ${citation.type.value}
                                                </td>
                                            </tr>
                                        </c:if>
                                        <c:if test="${not empty citation.title}">
                                            <tr>
                                                <td>
                                                    Title
                                                </td>
                                                <td>
                                                        ${citation.title}
                                                </td>
                                            </tr>
                                        </c:if>
                                        <c:if test="${not empty citation.dates}">
                                            <tr>
                                                <td>
                                                    Published
                                                </td>
                                                <td>
                                                    <c:forEach items="${citation.dates}" var="date"
                                                               varStatus="status">
                                                        <c:if test="${not empty date.date}">
                                                            ${date.date}${!status.last ? ',' : ''}
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                            </tr>
                                        </c:if>
                                        <c:if test="${not empty citation.authors}">
                                            <tr>
                                                <td>
                                                    Authors
                                                </td>
                                                <td>
                                                    <c:forEach items="${citation.authors}" var="author"
                                                               varStatus="status">
                                                        <c:if test="${not empty author.fullName}">
                                                            ${author.fullName}${!status.last ? ',' : ''}
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                            </tr>
                                        </c:if>
                                        <c:if test="${not empty citation.identifier.identifier}">
                                            <tr>
                                                <td>
                                                    Identifier
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${fn:contains(citation.identifier.identifier,'http')}">
                                                            <a href="${citation.identifier.identifier}" class="underline">
                                                                    ${citation.identifier.identifier}
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${citation.identifier.identifier}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</c:if>
