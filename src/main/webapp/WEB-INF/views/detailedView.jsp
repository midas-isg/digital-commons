<%--
  Created by IntelliJ IDEA.
  User: mas400
  Date: 5/14/18
  Time: 3:26 PM
  To change this template use File | Settings | File Templates.
--%>
<html>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<myTags:head title="MIDAS Digital Commons"/>
<myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>


<body id="detailed-view-body">
<div class="container metadata-container">
    <div class="lineage">
        <myTags:categoryLineage lineage="${lineage}"/>
    </div>
    <div class="section-content">
        <div class="col-xs-12 background-white">
            <h3>${entryView.entry.title}</h3>
            <hr>
            <c:if test="${not empty entryView.entry.identifier}">
                <h4 class="sub-title-font">Identifier</h4>
                <c:choose>
                    <c:when test="${fn:contains(entryView.entry.identifier.identifier, 'http') or fn:contains(entryView.entry.identifier.identifier, 'www')}">
                        <a class="underline"
                           href="${entryView.entry.identifier.identifier}">${entryView.entry.identifier.identifier}</a>
                    </c:when>
                    <c:otherwise>
                        <span>${entryView.entry.identifier.identifier}</span>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <h4 class="sub-title-font">Description</h4>
            <div class="description-section">
                <c:choose>
                    <c:when test="${ not empty description}">
                        ${description}
                    </c:when>
                    <c:otherwise>
                        ${entryView.entry.humanReadableSynopsis}
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<div class="container metadata-container">
    <div class="metadata-wrapper">
        <section>
            <div class="metadata-header-wrapper">
                <h2 class="sub-title-font">About this ${type.replaceAll("(\\p{Ll})(\\p{Lu})","$1 $2")}</h2>
            </div>
            <div class="section-content">
                <dl class="metadata-column fancy">
                    <div>
                        <div class="metadata-section">
                            <myTags:datasetDates entryView="${entryView}"></myTags:datasetDates>
                        </div>
                        <hr aria-hidden="true">
                    </div>

                    <div class="metadata-section">
                        <div class="metadata-pair">
                            <dt class="metadata-pair-title">
                                Metadata format
                            </dt>
                            <dd class="metadata-detail-group-value">
                                <c:choose>
                                    <c:when test="${type != 'DataStandard' and type != 'Dataset' and type != 'DatasetWithOrganization'}">
                                        MDC Software Metadata Format
                                    </c:when>
                                    <c:otherwise><a
                                            href="https://docs.google.com/document/d/1hVcYRleE6-dFfn7qbF9Bv1Ohs1kTF6a8OwWUvoZlDto/edit"
                                            class="underline">DATS v2.2</a></c:otherwise>
                                </c:choose>
                            </dd>
                        </div>
                        <br>

                        <button class="btn btn-lg btn-primary metadata-button"
                                onclick="location.href='${pageContext.request.contextPath}/detailed-metadata-view/?id=${id}&revId=${revId}'">
                            View Metadata
                        </button>
                    </div>
                </dl>
                <div class="metadata-column tables" style="padding-bottom: 0px;">
                    <c:if test="${type != 'DataStandard'}">
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
                    </c:if>
                    <div class="metadata-table"></div>
                    <div class="metadata-table"><h4 class="sub-title-font">Topics</h4>
                        <table class="table table-condensed table-borderless table-discrete table-striped">
                            <tbody>
                            <tr>
                                <td>Category</td>
                                <c:choose>
                                    <c:when test="${fn:length(lineage) > 2}">
                                        <td>${lineage[2]}</td>
                                    </c:when>
                                    <c:otherwise>
                                        <td>${lineage[1]}</td>
                                    </c:otherwise>
                                </c:choose>
                            </tr>
                            <c:if test="${not empty entryView.entry.pathogenCoverage}">
                                <td>
                                    Pathogen coverage
                                </td>
                                <td>
                                    <c:forEach items="${entryView.entry.pathogenCoverage}" var="coverage"
                                               varStatus="status">
                                        <span class="capitalize">${coverage.identifier.identifierDescription}</span>${!status.last ? ',' : ''}
                                    </c:forEach>
                                </td>
                            </c:if>
                            <c:if test="${not empty entryView.entry.spatialCoverage or not empty entryView.entry.locationCoverage or not lineage.contains('Software')}">
                                <tr>
                                    <td>Spatial coverage</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty entryView.entry.spatialCoverage}">
                                                <c:forEach items="${entryView.entry.spatialCoverage}" var="coverage"
                                                           varStatus="status">
                                                    <%--${fn:toUpperCase(fn:substring(coverage.name, 0, 1))}${fn:toLowerCase(fn:substring(coverage.name, 1,fn:length(coverage.name)))}${!status.last ? ',' : ''}--%>
                                                    ${coverage.name}${!status.last ? ',' : ''}
                                                </c:forEach>
                                            </c:when>
                                            <c:when test="${not empty entryView.entry.locationCoverage}">
                                                <c:forEach items="${entryView.entry.locationCoverage}" var="coverage"
                                                           varStatus="status">
                                                    <span class="capitalize">${coverage.identifier.identifierDescription}</span>${!status.last ? ',' : ''}
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                ${entryView.category.category}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:if>
                            <c:if test="${not empty entryView.entry.isAbout}">
                                <tr>
                                    <td>Tags</td>
                                    <td>
                                        <div>
                                            <div class="tag-list" style="word-wrap: break-word;">
                                                <c:forEach items="${entryView.entry.isAbout}" var="isAbout"
                                                           varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${not empty isAbout.name}">
                                                            ${isAbout.name}${!status.last ? ',' : ''}
                                                        </c:when>
                                                        <c:when test="${not empty isAbout.value}">
                                                            ${isAbout.value}${!status.last ? ',' : ''}
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                            <c:if test="${not empty entryView.entry.hostSpeciesIncluded}">
                                <tr>
                                    <td>Host species included</td>
                                    <td>
                                        <div>
                                            <div class="tag-list" style="word-wrap: break-word;">
                                                <c:forEach items="${entryView.entry.hostSpeciesIncluded}"
                                                           var="hostSpeciesIncluded"
                                                           varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${not empty hostSpeciesIncluded.identifier.identifierDescription}">
                                                            ${fn:toUpperCase(fn:substring(hostSpeciesIncluded.identifier.identifierDescription, 0, 1))}${fn:toLowerCase(fn:substring(hostSpeciesIncluded.identifier.identifierDescription, 1,fn:length(hostSpeciesIncluded.identifier.identifierDescription)))}${!status.last ? ',' : ''}
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${not empty entryView.entry.distributions}">
                        <myTags:datasetDistributions entryView="${entryView}"></myTags:datasetDistributions>
                    </c:if>

                    <c:if test="${not empty entryView.entry.sourceCodeRelease}">
                        <div class="metadata-table">
                            <h4 class="sub-title-font">Source code release</h4>
                            <table class="table table-condensed table-borderless table-discrete table-striped">
                                <tbody>
                                <tr>
                                    <td>Source code links</td>
                                    <td>
                                            ${entryView.entry.sourceCodeRelease}
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <c:if test="${not empty entryView.entry.licenses}">
                        <div class="metadata-table"><h4 class="sub-title-font">Licensing and Attribution</h4>
                            <table class="table table-condensed table-borderless table-discrete table-striped">
                                <tbody>
                                <tr>
                                    <td>
                                        License
                                    </td>
                                    <td>
                                        <c:forEach items="${entryView.entry.licenses}" var="license" varStatus="status">
                                            ${license.name}${!status.last ? ',' : ''}
                                        </c:forEach>
                                    </td>
                                </tr>
                                <c:if test="${not empty entryView.entry.licenses[0].identifier}">
                                    <tr>
                                        <td>Source</td>
                                        <td>
                                            <c:forEach items="${entryView.entry.licenses}" var="license"
                                                       varStatus="status">
                                                <a href="${license.identifier.identifier}"
                                                   class="underline">${license.identifier.identifier}</a>${!status.last ? ',' : ''}
                                            </c:forEach>
                                        </td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                    <myTags:datasetCitations entryView="${entryView}"></myTags:datasetCitations>

                </div>
            </div>
        </section>
    </div>
</div>


<myTags:analytics/>

</body>

<myTags:footer/>

</html>