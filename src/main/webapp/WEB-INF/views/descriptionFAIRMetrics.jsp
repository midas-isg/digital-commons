<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

    <fmt:setBundle basename="fairMetricsDescriptions"/>

    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>

</head>
<body id="detailed-view-body">
<myTags:fairMetricsIndex active="description"></myTags:fairMetricsIndex>
<div id="entryFormContent">
    <div class="container metadata-container">
        <div class="section-content">
            <div class="col-12 background-white">
                <div class="margin-top-10">
                    <div class="btn-toolbar pull-right">
                        <button class="btn btn-primary fair-metrics-report-button">
                            <a class="color-white" href="${pageContext.request.contextPath}/fair-metrics/">FAIR Metrics
                                Report</a>
                        </button>
                        <button id="sidebarCollapse"
                                class="btn btn-primary d-none d-sm-none d-md-block">
                            Toggle Sidebar
                        </button>
                    </div>
                    <h3 class="inline">FAIR Metrics Description</h3>
                </div>
                <h12 class="italic font-small-3">The MIDAS Digital Commons uses the FAIR Metrics defined by
                    Wilkinson, M. D. et al, in the FAIRMetrics GitHub repository located <a class="underline"
                                                                                            target="_blank"
                                                                                            href="https://github.com/FAIRMetrics/Metrics">here</a>.
                    A description of each metric is provided below for convenience, but we recommend that you refer
                    to the repository above for the most recent updates to the metrics.
                </h12>
                <hr>

                <div class="metadata-column tables" style="padding-bottom: 0px;">
                    <div class="metadata-table"><h4 class="sub-title-font"></h4>
                        <table class="table table-condensed table-borderless table-discrete table-striped">
                            <tbody>
                            <c:forEach items="${keys}" var="key" varStatus="status">
                                <c:choose>
                                    <c:when test="${key == 'FM-F1A'}">
                                        <tr>
                                            <th colspan="2">
                                               Findable
                                            </th>
                                        </tr>
                                    </c:when>
                                    <c:when test="${key == 'FM-A1.1'}">
                                        <tr>
                                            <th colspan="2">
                                                Accessible
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:when test="${key == 'FM-I1'}">
                                        <tr>
                                            <th colspan="2">
                                               Interoperable
                                            </th>
                                        </tr>
                                    </c:when>
                                    <c:when test="${key == 'FM-R1.1'}">
                                        <tr>
                                            <th colspan="2">
                                                Reusable
                                            </th>
                                        </tr>
                                    </c:when>
                                </c:choose>
                                <tr>
                                    <td class="bold">
                                        ${key}
                                    </td>
                                    <td>
                                        <fmt:message key="${key.concat('-Measured')}"/>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>