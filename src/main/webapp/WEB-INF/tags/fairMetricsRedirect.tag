<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="col-12 d-block d-md-none dropdown-menu-fair-metrics-redirect">
    <select class="custom-select" title="Redirect To..." id="fairMetricsMobileDropdown" onchange="this.options[this.selectedIndex].value && (window.location = this.options[this.selectedIndex].value);">
        <option value="" >Select To View...</option>
        <option value="${pageContext.request.contextPath}/fair-metrics">FAIR Metrics Report</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/description">FAIR Metrics Descriptions</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-F1A">Metric: FM-F1A</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-F1B">Metric: FM-F1B</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-F2">Metric: FM-F2</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-F3">Metric: FM-F3</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-F4">Metric: FM-F4</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-A1.1">Metric: FM-A1.1</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-A1.2">Metric: FM-A1.2</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-A2">Metric: FM-A2</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-I1">Metric: FM-I1</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-I2">Metric: FM-I2</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-I3">Metric: FM-I3</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-R1.1">Metric: FM-R1.1</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-R1.2">Metric: FM-R1.2</option>
    </select>
</div>
