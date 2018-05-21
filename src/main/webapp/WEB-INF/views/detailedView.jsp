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
                                onclick="location.href='${pageContext.request.contextPath}/detailed-metadata-view/?id=${id}'">
                            View Metadata
                        </button>
                    </div>
                </dl>
                <div class="metadata-column tables" style="padding-bottom: 0px;">
                    <c:if test="${type != 'DataStandard'}">
                        <myTags:datasetCreatorInfo entryView="${entryView}"></myTags:datasetCreatorInfo>
                    </c:if>
                    <div class="metadata-table"></div>
                    <myTags:datasetTopics entryView="${entryView}" lineage="${lineage}"/>

                    <c:if test="${not empty entryView.entry.distributions}">
                        <myTags:datasetDistributions entryView="${entryView}"></myTags:datasetDistributions>
                    </c:if>

                    <c:if test="${not empty entryView.entry.sourceCodeRelease}">
                        <myTags:datasetSourceCode entryView="${entryView}"></myTags:datasetSourceCode>
                    </c:if>

                    <c:if test="${not empty entryView.entry.licenses}">
                        <myTags:datasetLicenses entryView="${entryView}"></myTags:datasetLicenses>
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