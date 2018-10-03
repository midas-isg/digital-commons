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
                        <button class="btn btn-primary">
                            <a class="color-white" href="/digital-commons/fair-metrics/">FAIR Metrics Report</a>
                        </button>
                        <button type="button" id="sidebarCollapse"
                                class="btn btn-primary">
                            <span>Toggle Sidebar</span>
                        </button>
                    <%--</div>--%>
                </div>
                <h3 class="inline">FAIR Metric: <fmt:message key="${key.concat('-Column-Header')}" /></h3>
            </div>
            <h12 class="italic font-small-3">For your convenience the information below has been provided from: <a class="underline" target="_blank" href="https://github.com/FAIRMetrics/Metrics">https://github.com/FAIRMetrics/Metrics</a></h12>
            <hr>
            <div class="metadata-column tables" style="padding-bottom: 0px;">
                <div class="metadata-table"><h4 class="sub-title-font"></h4>
                    <table class="table table-condensed table-borderless table-discrete table-striped">
                        <tbody>
                        <tr>
                            <td class="bold">Metric Identifier:</td>
                            <td>${key}: <a class="underline" href="<fmt:message key="${key.concat('-URL')}" />"
                                           target="_blank"><fmt:message key="${key.concat('-URL')}"/></a></td>
                        </tr>
                        <tr>
                            <td class="bold">Metric Name:</td>
                            <td><fmt:message key="${key.concat('-Name')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold">To which principle does it apply?</td>
                            <td><fmt:message key="${key.concat('-Principle')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold">What is being measured?</td>
                            <td><fmt:message key="${key.concat('-Measured')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold">Why should we measure it?</td>
                            <td><fmt:message key="${key.concat('-Why-Measure')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold">What must be provided?</td>
                            <td><fmt:message key="${key.concat('-Must-Provided')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold">How do we measure it?</td>
                            <td><fmt:message key="${key.concat('-How-Measure')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold">What is a valid result?</td>
                            <td><fmt:message key="${key.concat('-Valid-Result')}"/></td>
                        </tr>
                        <tr>
                            <td class="bold">For which digital resource(s) is this relevant?</td>
                            <td><fmt:message key="${key.concat('-Which-Relevant')}"/></td>
                        </tr>
                        <c:if test="${exampleText == 'None'}">
                            <tr>
                                <td class="bold">Examples of their application across types of digital
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

