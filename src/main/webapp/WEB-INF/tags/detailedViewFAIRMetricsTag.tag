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
                        <a class="color-white" href="${pageContext.request.contextPath}/fair-metrics/">FAIR Metrics
                            Report</a>
                    </button>
                    <button id="sidebarCollapse"
                            class="btn btn-primary d-none d-sm-none d-md-block">
                        Toggle Sidebar
                    </button>
                    <%--</div>--%>
                </div>
                <h3 class="inline"><%--FAIR Metric: --%>
                    <c:choose>
                        <c:when test="${key == 'FM'}">
                            About FAIR Metrics
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="${key.concat('-Column-Header')}"/> - <fmt:message key="${key.concat('-Name')}"/></h3>
                        </c:otherwise>
                    </c:choose>
            </div>
            <br>
            <h12 class="italic font-small-3">The MIDAS Digital Commons uses the FAIR Metrics defined by Wilkinson, M. D.
                et al, in the FAIRMetrics GitHub repository located <a class="underline" target="_blank"
                                                                       href="https://github.com/FAIRMetrics/Metrics">here</a>.
                A description of each metric is provided below for convenience, but we recommend that you refer to the
                repository above for the most recent updates to the metrics.
            </h12>
            <hr>
            <div class="metadata-column tables" style="padding-bottom: 0px;">
                <div class="metadata-table"><h4 class="sub-title-font"></h4>
                    <table class="table table-condensed table-borderless table-discrete table-striped">
                        <tbody>
                        <tr>
                            <td>
                                <span class="bold" data-toggle="tooltip"
                                      title="<fmt:message key="FM-Identifier" />"><fmt:message key="FM-Identifier-Field" /></span>
                            </td>
                            <td><%--${key}: --%><a class="underline link-break-all"
                                           href="<fmt:message key="${key.concat('-URL')}" />"
                                           target="_blank"><fmt:message key="${key.concat('-URL')}"/></a></td>
                        </tr>
                        <%--
                                                <tr>
                                                    <td class="bold"  data-toggle="tooltip" title="<fmt:message key="FM-Name" />"><fmt:message key="FM-Name-Field" /></td>
                                                    <td><fmt:message key="${key.concat('-Name')}"/></td>
                                                </tr>
                        --%>
                        <tr>
                            <td>
                                <span class="bold" data-toggle="tooltip"
                                      title="<fmt:message key="FM-Principle" />"><fmt:message key="FM-Principle-Field" /></span>
                            </td>
                            <td><fmt:message key="${key.concat('-Principle')}"/></td>
                        </tr>
                        <tr>
                            <td>
                                <span class="bold" data-toggle="tooltip"
                                      title="<fmt:message key="FM-Measured" />"><fmt:message key="FM-Measured-Field" /></span>
                            </td>
                            <td><fmt:message key="${key.concat('-Measured')}"/></td>
                        </tr>
                        <tr>
                            <td>
                                <span class="bold" data-toggle="tooltip"
                                      title="<fmt:message key="FM-Why-Measure" />"><fmt:message key="FM-Why-Measure-Field" /></span>
                            </td>
                            <td><fmt:message key="${key.concat('-Why-Measure')}"/></td>
                        </tr>
                        <tr>
                            <td>
                                <span class="bold" data-toggle="tooltip"
                                      title="<fmt:message key="FM-Must-Provided" />"><fmt:message key="FM-Must-Provided-Field" /></span>
                            </td>
                            <td><fmt:message key="${key.concat('-Must-Provided')}"/></td>
                        </tr>
                        <tr>
                            <td>
                                <span class="bold" data-toggle="tooltip"
                                      title="<fmt:message key="FM-How-Measure" />"><fmt:message key="FM-How-Measure-Field" /></span>
                            </td>
                            <td><fmt:message key="${key.concat('-How-Measure')}"/></td>
                        </tr>
                        <tr>
                            <td>
                                <span class="bold" data-toggle="tooltip"
                                      title="<fmt:message key="FM-Valid-Result" />"><fmt:message key="FM-Valid-Result-Field" /></span>
                            </td>
                            <td><fmt:message key="${key.concat('-Valid-Result')}"/></td>
                        </tr>
                        <tr>
                            <td>
                                <span class="bold" data-toggle="tooltip"
                                      title="<fmt:message key="FM-Which-Relevant" />"><fmt:message key="FM-Which-Relevant-Field" /></span>
                            </td>
                            <td><fmt:message key="${key.concat('-Which-Relevant')}"/></td>
                        </tr>
                        <c:if test="${exampleText == 'None' or key == 'FM'}">
                            <tr>
                                <td>
                                    <span class="bold" data-toggle="tooltip"
                                          title="<fmt:message key="FM-Examples" />"><fmt:message key="FM-Examples-Field" /></span>
                                </td>
                                <td><fmt:message key="${key.concat('-Examples')}"/></td>
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
                <c:if test="${key == 'FM-F1A' or key == 'FM-F1B' or key == 'FM-F2' or key == 'FM-F4'}">
                    <div class="metadata-table">
                        <h5 class="sub-title-font">
                            <span data-toggle="tooltip" title="<fmt:message key="FM-Examples" />">
                                <fmt:message key="FM-Examples-Field" />
                            </span>
                        </h5>
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
                </c:if>
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
