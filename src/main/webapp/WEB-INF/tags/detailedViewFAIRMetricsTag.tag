<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%@ attribute name="key" required="true"
              type="java.lang.String" %>

<%--
<%@ attribute name="lineage" required="false"
              type="java.util.List" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>
<%@ attribute name="entryID" required="true"
              type="java.lang.String" %>
<%@ attribute name="entryJson" required="true"
              type="java.lang.String" %>
<%@ attribute name="revId" required="true"
              type="java.lang.Long" %>
<%@ attribute name="id" required="true"
              type="java.lang.Long" %>
<%@ attribute name="type" required="true"
              type="java.lang.String" %>
<%@ attribute name="description" required="false"
              type="java.lang.String" %>
--%>



<fmt:setBundle basename="fairMetricsDescriptions"/>

<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">Metric Identifier: </h5><br>
    <span id="identifier"><fmt:message key="${key.concat('-Identifier')}" /></span>
</div>
<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">Metric Name: </h5><br>
    <span id="name"><fmt:message key="${key.concat('-Name')}" /></span>
</div>
<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">To which principle does it apply? </h5><br>
    <span id="principle"><fmt:message key="${key.concat('-Principle')}" /></span>
</div>
<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">What is being measured? </h5><br>
    <span id="measured"><fmt:message key="${key.concat('-Measured')}" /></span>
</div>
<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">Why should we measure it? </h5><br>
    <span id="whyMeasure"><fmt:message key="${key.concat('-Why-Measure')}" /></span>
</div>
<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">What must be provided? </h5><br>
    <span id="mustProvided"><fmt:message key="${key.concat('-Must-Provided')}" /></span>
</div>
<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">How do we measure it? </h5><br>
    <span id="howMeasure"><fmt:message key="${key.concat('-How-Measure')}" /></span>
</div>
<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">What is a valid result? </h5><br>
    <span id="validResult"><fmt:message key="${key.concat('-Valid-Result')}" /></span>
</div>
<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">For which digital resource(s) is this relevant? </h5><br>
    <span id="whichRelevant"><fmt:message key="${key.concat('-Which-Relevant')}" /></span>
</div>
<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">Examples of their application across types of digital
        resource: </h5><br>
    <span id="examples"><fmt:message key="${key.concat('-Examples')}" /></span>
</div>
<div class="sub-title-font font-size-16 modal-software-item">
    <h5 class="inline bold">Comments: </h5><br>
    <span id="comments"><fmt:message key="${key.concat('-Comments')}" /></span>
</div>


<%--
<div class="container metadata-container">
    <c:if test="${not empty lineage}">
    <div class="lineage">
        <myTags:categoryLineage lineage="${lineage}"/>
    </div>
    </c:if>
    <div class="section-content">
        <div class="col-12 background-white">
            <div class="margin-top-10">
                <div class="btn-toolbar pull-right">
                    <c:if test="${adminType == 'ISG_ADMIN' or adminType == 'MDC_EDITOR'}">
                        <div class="btn-group">
                            <button class="btn btn-light"><a
                                    href="${pageContext.request.contextPath}/add-digital-object?entryID=${entryID}">Edit
                                Digital Object</a></button>
                        </div>
                    </c:if>

                </div>
                <c:choose>
                    <c:when test="${not empty entryView.entry.title}">
                        <h3 class="inline">${entryView.entry.title}</h3>
                    </c:when>
                    <c:otherwise>
                        <h3 class="inline">${entryView.entry.name}</h3>
                    </c:otherwise>
                </c:choose>
            </div>
            <hr>
            <c:if test="${not empty entryView.entry.identifier}">
                <h5 class="sub-title-font">Identifier</h5>
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

            <h5 class="sub-title-font">Description</h5>
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
--%>
