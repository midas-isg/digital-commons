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

<myTags:header
        pageTitle="MIDAS Digital Commons"
        loggedIn="${loggedIn}"/>

<body id="detailed-view-body">
<div class="container">
    <div class="row">
        <div class="lineage">
            <myTags:categoryLineage lineage="${lineage}"/>
        </div>
        <div class="col-sm-12 background-white">
            <h3>${title}</h3>
            <hr>
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

            <h4 class="sub-title-font">Description</h4>
            <span>${entryView.entry.description}</span>
        </div>


        <%--<div class="col-md-4 col-sm-12">--%>
        <%--<h4 class="sub-title-font">Updated</h4>--%>
        <%--<h2>${entryView.entry.producedBy.startDate.date}</h2>--%>
        <%--</div>--%>

        <%--<div class="col-md-8 col-sm-12">--%>

        <%--</div>--%>
    </div>
</div>

<div class="container metadata-container">
    <div class="metadata-wrapper">
        <section>
            <div class="metadata-header-wrapper">
                <h2 class="sub-title-font">About this Dataset</h2>
            </div>
            <div class="section-content">
                <dl class="metadata-column fancy">
                    <div>
                        <div class="metadata-section">
                            <myTags:datasetDates entryView="${entryView}"></myTags:datasetDates>
                            <%--<div class="metadata-row">--%>

                            <%--<div class="metadata-pair">--%>
                            <%--<dt class="metadata-pair-title">Updated</dt>--%>
                            <%--<dd class="metadata-pair-value">August 27, 2015</dd>--%>
                            <%--</div>--%>
                            <%--</div>--%>
                            <%--<div class="metadata-row metadata-detail-groups">--%>
                            <%--<div class="metadata-detail-group">--%>
                            <%--<dt class="metadata-detail-group-title">Data Updated</dt>--%>
                            <%--<dd class="metadata-detail-group-value">June 19, 2013</dd>--%>
                            <%--</div>--%>
                            <%--<div class="metadata-detail-group">--%>
                            <%--<dt class="metadata-detail-group-title">Metadata Updated</dt>--%>
                            <%--<dd class="metadata-detail-group-value">August 27, 2015</dd>--%>
                            <%--</div>--%>
                            <%--</div>--%>
                            <%--<div class="metadata-row metadata-detail-groups">--%>
                            <%--<div class="metadata-detail-group">--%>
                            <%--<dt class="metadata-detail-group-title">Date Created</dt>--%>
                            <%--<dd class="metadata-detail-group-value">June 19, 2013</dd>--%>
                            <%--</div>--%>
                            <%--</div>--%>
                        </div>
                        <hr aria-hidden="true">
                    </div>
                    <div class="metadata-section">
                        <div class="metadata-row">
                            <div class="metadata-pair metadata-detail-group">
                                <dt class="metadata-pair-title">Views</dt>
                                <dd class="metadata-pair-value">2,241</dd>
                            </div>
                            <div class="metadata-pair metadata-detail-group">
                                <dt class="metadata-pair-title">Downloads</dt>
                                <dd class="metadata-pair-value">8,317</dd>
                            </div>
                        </div>
                    </div>
                    <hr aria-hidden="true">
                    <div class="metadata-section">
                        <div class="metadata-row metadata-detail-groups">
                            <div class="metadata-detail-group">
                                <dt class="metadata-detail-group-title">Data Provided by</dt>
                                <dd class="metadata-detail-group-value">PRAMS</dd>
                            </div>
                            <div class="metadata-detail-group">
                                <dt class="metadata-detail-group-title">Dataset Owner</dt>
                                <dd class="metadata-detail-group-value">Helen Ding</dd>
                            </div>
                        </div>
                        <button class="btn btn-sm btn-primary btn-block contact-dataset-owner"
                                data-modal="contact-form">Contact Dataset Owner
                        </button>
                    </div>
                </dl>
                <div class="metadata-column tables" style="padding-bottom: 0px;">
                    <div class="metadata-table"><h4 class="sub-title-font">Common Core</h4>
                        <table class="table table-condensed table-borderless table-discrete table-striped">
                            <tbody>
                            <c:if test="${not empty entryView.entry.creators}">
                                <tr>
                                    <td>Created by</td>
                                    <td>
                                        <c:forEach items="${entryView.entry.creators}" var="creator" varStatus="status">
                                            <c:choose>
                                                <c:when test="${not empty creator.name}">
                                                    ${creator.name}${!status.last ? ',' : ''}
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
                            <c:if test="${not empty entryView.entry.producedBy}">
                                <tr>
                                    <td>Produced by</td>
                                    <td>
                                            ${entryView.entry.producedBy.name}
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                    <div class="metadata-table"></div>
                    <div class="metadata-table"><h4 class="sub-title-font">Topics</h4>
                        <table class="table table-condensed table-borderless table-discrete table-striped">
                            <tbody>
                            <tr>
                                <td>Category</td>
                                <td>${lineage[2]}</td>
                            </tr>
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
                                        <c:otherwise>${entryView.category.category}</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td>Tags</td>
                                <td>
                                    <div class="collapsible">
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
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${not empty entryView.entry.distributions}">
                        <div class="metadata-table">
                            <h4 class="sub-title-font">Distributions</h4>
                            <table class="table table-condensed table-borderless table-discrete table-striped">
                                <tbody>
                                <c:forEach items="${entryView.entry.distributions}" var="distribution">
                                    <tr>
                                        <c:choose>
                                            <c:when test="${not empty distribution.formats}">
                                                <td>
                                                        ${distribution.formats[0]}
                                                </td>
                                            </c:when>
                                            <c:otherwise>
                                                <td>Access URL</td>
                                            </c:otherwise>
                                        </c:choose>
                                        <td>
                                            <a href="${distribution.access.accessURL}"
                                               class="underline">${distribution.access.accessURL}</a>
                                            <c:if test="${not empty distribution.conformsTo}">
                                                <br>
                                                Conforms to:
                                                <c:forEach items="${distribution.conformsTo}" var="conforms" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${not empty conforms.alternateIdentifiers}">
                                                            <a href="${conforms.alternateIdentifiers[0].identifier}" class="underline">
                                                                ${conforms.name}${!status.last ? ',' : ''}
                                                            </a>
                                                        </c:when>
                                                        <c:when test="${not empty conforms.type}">
                                                            <a href="${conforms.valueIRI}" class="underline">
                                                                    ${conforms.name}${!status.last ? ',' : ''}
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${conforms.name}${!status.last ? ',' : ''}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
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
                                <tr>
                                    <td>Source</td>
                                    <td>
                                        <c:forEach items="${entryView.entry.licenses}" var="license" varStatus="status">
                                            <a href="${license.identifier.identifier}"
                                               class="underline">${license.identifier.identifier}</a>${!status.last ? ',' : ''}
                                        </c:forEach>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <div class="metadata-table-toggle-group desktop" style="display: none;"><a
                            class="metadata-table-toggle more" tabindex="0" role="button">Show More</a><a
                            class="metadata-table-toggle less" tabindex="0" role="button">Show Less</a></div>
                    <div class="metadata-table-toggle-group mobile" style="display: none;">
                        <button class="btn btn-block btn-default metadata-table-toggle more mobile">Show More</button>
                        <button class="btn btn-block btn-default metadata-table-toggle less mobile">Show Less</button>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>


<script>
    $(document).ready(function () {
        toggleModalItems(${entryJson}, "${type}");
    });


</script>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>
</title>
</head>
<body>

</body>
</html>
