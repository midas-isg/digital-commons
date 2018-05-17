<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<div class="metadata-table">
    <h4 class="sub-title-font">Distributions</h4>
    <table class="table table-condensed table-borderless table-discrete">

        <tbody>
        <c:forEach items="${entryView.entry.distributions}" var="distribution">
            <tr>
                <td>
                    <h4 class="sub-title-font">
                        <c:choose>
                            <c:when test="${not empty distribution.title}">
                                ${distribution.title}
                            </c:when>
                            <c:when test="${not empty distribution.identifier}">
                                ${distribution.identifier.identifier}
                            </c:when>
                        </c:choose>
                        <c:if test="${not empty distribution.formats}">
                            (${distribution.formats[0]})
                        </c:if>
                    </h4>
                    <table class="table table-condensed table-borderless table-discrete table-striped">
                        <tbody>
                        <c:if test="${not empty distribution.access.landingPage}">
                            <tr>
                                <td>Landing page</td>
                                <td><a href="${entryView.entry.distributions[0].access.landingPage}"
                                       class="underline">${entryView.entry.distributions[0].access.landingPage}</a> <i
                                        class="fa fa-external-link" aria-hidden="true"></i>
                                </td>
                            </tr>
                        </c:if>
                        <c:if test="${not empty distribution.access.accessURL}">
                            <tr>
                                <td>Access URL</td>
                                <td>
                                    <a href="${distribution.access.accessURL}"
                                       class="underline">${distribution.access.accessURL}</a> <i
                                        class="fa fa-arrow-circle-o-down" aria-hidden="true"></i>
                                </td>
                            </tr>
                        </c:if>
                        <c:if test="${not empty distribution.conformsTo}">
                            <tr>
                                <td>Conforms to</td>
                                <td>
                                    <c:forEach items="${distribution.conformsTo}" var="conforms"
                                               varStatus="status">
                                        <c:choose>
                                            <c:when test="${not empty conforms.alternateIdentifiers}">
                                                <a href="${conforms.alternateIdentifiers[0].identifier}"
                                                   class="underline">
                                                        ${conforms.name}${!status.last ? ',' : ''}
                                                </a>
                                            </c:when>
                                            <c:when test="${not empty conforms.type}">
                                                <a href="${conforms.type.valueIRI}" class="underline">
                                                        ${conforms.name}${!status.last ? ',' : ''}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                ${conforms.name}${!status.last ? ',' : ''}
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </td>
                            </tr>
                        </c:if>
                        <c:if test="${not empty distribution.dates}">
                            <tr>
                                <td class="capitalize">
                                        ${distribution.dates[0].type.value}
                                </td>
                                <td>
                                        ${distribution.dates[0].date}
                                </td>
                            </tr>
                        </c:if>

                        <c:if test="${not empty distribution.licenses}">
                            <tr>
                                <td>
                                    License
                                </td>
                                <td>
                                    <c:forEach items="${distribution.licenses}" var="license" varStatus="status">
                                        <c:choose>
                                            <c:when test="${not empty distribution.licenses[0].identifier}">
                                                <a href="${distribution.licenses[0].identifier.identifier}"
                                                   class="underline">${license.name}</a>
                                            </c:when>
                                            <c:otherwise>
                                                ${license.name}${!status.last ? ',' : ''}
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </td>
                            </tr>

                        </c:if>
                        </tbody>
                    </table>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
