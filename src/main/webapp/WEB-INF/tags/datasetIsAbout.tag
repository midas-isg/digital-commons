<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<c:if test="${not empty entryView.entry.isAbout}">
    <tr>
        <td>Tags</td>
        <td>
                <div class="tag-list">
                    <c:forEach items="${entryView.entry.isAbout}" var="isAbout"
                               varStatus="varStatus">
                        <c:choose>
                            <c:when test="${not empty isAbout.name && not empty isAbout.identifier.identifier && not empty isAbout.identifier.identifierSource}">
                                <c:set var="identifier" value="${isAbout.identifier.identifier}" />
                                <c:set var="identifierSource" value="${isAbout.identifier.identifierSource}" />
                                <c:set var="bioportalLink" value="http://bioportal.bioontology.org/ontologies/SNOMEDCT/${identifier}" />
                                <c:choose>
                                    <c:when test="${fn:contains(identifierSource,'https://biosharing.org/bsg-s000098')}">
                                        <a href="${bioportalLink}" class="color-white badge badge-info">${isAbout.name}</a>
                                    </c:when>
                                    <c:when test="${fn:contains(identifier,'http://purl.bioontology.org/ontology/SNOMEDCT/')}">
                                        <c:set var="identifier" value="${fn:replace(identifier, 'http://purl.bioontology.org/ontology/SNOMEDCT/', 'http://bioportal.bioontology.org/ontologies/SNOMEDCT/')}" />
                                        <a href="${identifier}" class="color-white badge badge-info">${isAbout.name}</a>
                                    </c:when>
                                    <c:when test="${fn:contains(identifier,'http')}">
                                        <a href="${identifier}" class="color-white badge badge-info">${isAbout.name}</a>
                                    </c:when>
                                    <c:when test="${fn:contains(identifierSource,'http')}">
                                        <a href="${identifierSource}" class="color-white badge badge-info">${isAbout.name}</a>
                                    </c:when>
                                </c:choose>
                            </c:when>
                            <c:when test="${not empty isAbout.name}">
                                <span class="color-white badge badge-info">${isAbout.name}</span>
                            </c:when>
                            <c:when test="${not empty isAbout.value && not empty isAbout.valueIRI}">
                                <c:set var="valueIRI" value="${isAbout.valueIRI}" />
                                <c:if test="${fn:contains(valueIRI,'http://purl.bioontology.org/ontology/SNOMEDCT/')}">
                                    <c:set var="valueIRI" value="${fn:replace(valueIRI, 'http://purl.bioontology.org/ontology/SNOMEDCT/', 'http://bioportal.bioontology.org/ontologies/SNOMEDCT/')}" />
                                </c:if>
                                <c:choose>
                                    <c:when test="${fn:contains(valueIRI, 'http')}">
                                        <a href="${valueIRI}" class="color-white badge badge-info">${isAbout.value}</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="color-white badge badge-info">${isAbout.value}</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:when test="${not empty isAbout.value}">
                                <span class="color-white badge badge-info">${isAbout.value}</span>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                </div>
        </td>
    </tr>
</c:if>
