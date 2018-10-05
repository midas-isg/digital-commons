<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="col-12 d-block d-sm-none">
    <select class="selectpicker" id="fairMetricsMobileDropdown" onchange="this.options[this.selectedIndex].value && (window.location = this.options[this.selectedIndex].value);">
        <option value="" disabled="disabled">Go To...</option>
        <option value="${pageContext.request.contextPath}/fair-metrics">FAIR Metrics Report</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/description">FAIR Metrics Description</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-F1A">FAIR Metric FM-F1A</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-F1B">FAIR Metric FM-F1B</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-F2">FAIR Metric FM-F2</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-F3">FAIR Metric FM-F3</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-F4">FAIR Metric FM-F4</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-A1.1">FAIR Metric FM-A1.1</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-A1.2">FAIR Metric FM-A1.2</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-A2">FAIR Metric FM-A2</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-I1">FAIR Metric FM-I1</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-I3">FAIR Metric FM-I2</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-I4">FAIR Metric FM-I3</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-R1.1">FAIR Metric FM-R1.1</option>
        <option value="${pageContext.request.contextPath}/fair-metrics/detailed-view/?key=FM-R1.2">FAIR Metric FM-R1.2</option>
    </select>
</div>
