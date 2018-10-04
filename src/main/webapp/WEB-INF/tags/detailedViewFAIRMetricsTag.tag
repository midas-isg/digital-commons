<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%@ attribute name="key" required="true"
              type="java.lang.String" %>
<%@ attribute name="exampleText" required="true"
              type="java.lang.String" %>


<fmt:setBundle basename="fairMetricsDescriptions"/>
<div class="container metadata-container">
    <div class="section-content">
        <div class="col-12 background-white">
            <div class="margin-top-10">
                <div class="btn-toolbar pull-right">
                    <%--<div class="btn-group">--%>
                        <button class="btn btn-primary fair-metrics-report-button">
                            <a class="color-white" href="${pageContext.request.contextPath}/fair-metrics/">FAIR Metrics Report</a>
                        </button>
                        <button id="sidebarCollapse"
                                class="btn btn-primary d-none d-sm-none d-md-block">
                            Toggle Sidebar
                        </button>
                    <%--</div>--%>
                </div>
                <h3 class="inline"><%--FAIR Metric: --%><fmt:message key="${key.concat('-Column-Header')}" /> - <fmt:message key="${key.concat('-Name')}"/></h3>
            </div>
            <h12 class="italic font-small-3">The MIDAS Digital Commons uses the FAIR Metrics defined by Wilkinson, M. D. et al, in the FAIRMetrics GitHub repository located <a class="underline" target="_blank" href="https://github.com/FAIRMetrics/Metrics">here</a>.  A description of each metric is provided below for convenience, but we recommend that you refer to the repository above for the most recent updates to the metrics.</h12>
            <hr>
            <div class="metadata-column tables" style="padding-bottom: 0px;">
                <div class="metadata-table"><h4 class="sub-title-font"></h4>
                    <table class="table table-condensed table-borderless table-discrete table-striped">
                        <tbody>
                        <tr>
                            <td >
                                <span class="bold" data-toggle="tooltip" title="FAIR Metrics should, themselves, be FAIR objects, and thus should have globally unique identifiers.">Metric Identifier:</span>
                            </td>
                            <td>${key}: <a class="underline link-break-all" href="<fmt:message key="${key.concat('-URL')}" />"
                                           target="_blank"><fmt:message key="${key.concat('-URL')}"/></a></td>
                        </tr>
<%--
                        <tr>
                            <td class="bold">Metric Name:</td>
                            <td><fmt:message key="${key.concat('-Name')}"/></td>
                        </tr>
--%>
                        <tr>
                            <td class="bold" data-toggle="tooltip" title="Metrics should address only one sub-principle, since each FAIR principle is particular to one feature of a digital resource; metrics that address multiple principles are likely to be measuring multiple features, and those should be separated whenever possible.">To which principle does it apply?</td>
                            <td><fmt:message key="${key.concat('-Principle')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold" data-toggle="tooltip" title="A precise description of the aspect of that digital resource that is going to be evaluated">What is being measured?</td>
                            <td><fmt:message key="${key.concat('-Measured')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold" data-toggle="tooltip" title="Describe why it is relevant to measure this aspect">Why should we measure it?</td>
                            <td><fmt:message key="${key.concat('-Why-Measure')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold" data-toggle="tooltip" title="What information is required to make this measurement?">What must be provided?</td>
                            <td><fmt:message key="${key.concat('-Must-Provided')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold" data-toggle="tooltip" title="In what way will that information be evaluated?">How do we measure it?</td>
                            <td><fmt:message key="${key.concat('-How-Measure')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold" data-toggle="tooltip" title="What outcome represents 'success' versus 'failure'">What is a valid result?</td>
                            <td><fmt:message key="${key.concat('-Valid-Result')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold" data-toggle="tooltip" title="If possible, a metric should apply to all digital resources; however, some metrics may be applicable only to a subset. In this case, it is necessary to specify the range of resources to which the metric is reasonably applicable.">For which digital resource(s) is this relevant?</td>
                            <td><fmt:message key="${key.concat('-Which-Relevant')}"/></td>
                        </tr>
                        <c:if test="${exampleText == 'None'}">
                            <tr>
                                <td class="bold" data-toggle="tooltip" title="Whenever possible, provide an existing example of success, and an example of failure.">Examples of their application across types of digital
                                    resource:
                                </td>
                                <td>${exampleText}</td>
                            </tr>
                        </c:if>
                        <%--
                                                <tr>
                                                    <td>Comments:</td>
                                                    <td><fmt:message key="${key.concat('-Comments')}" /></td>
                                                </tr>
                        --%>
                        </tbody>
                    </table>
                </div>
                <c:choose>
                    <c:when test="${key == 'FM-F1A'}">
                        <myTags:fairMetricsFMF1AExample></myTags:fairMetricsFMF1AExample>
                    </c:when>
                    <c:when test="${key == 'FM-F1B'}">
                        <myTags:fairMetricsFMF1BExample></myTags:fairMetricsFMF1BExample>
                    </c:when>
                    <c:when test="${key == 'FM-F2'}">
                        <myTags:fairMetricsFMF2Example></myTags:fairMetricsFMF2Example>
                    </c:when>
                    <c:when test="${key == 'FM-F4'}">
                        <myTags:fairMetricsFMF4Example></myTags:fairMetricsFMF4Example>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $(function () {
            $('[data-toggle="tooltip"]').tooltip()
        })
    });
</script>
