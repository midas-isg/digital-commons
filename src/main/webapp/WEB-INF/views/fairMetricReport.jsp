<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<html>
<head>
    <myTags:head title="MIDAS Digital Commons"/>
    <myTags:header
            pageTitle="MIDAS Digital Commons"
            loggedIn="${loggedIn}"
            addEntry="${true}"
    />
    <fmt:setBundle basename="fairMetricsDescriptions"/>

    <myTags:analytics/>
<body id="commons-body">

<myTags:softwareModal/>
<fmt:parseDate value="${ report.created }" pattern="yyyy-MM-dd'T'HH:mm" var="createdDate" type="both"/>
<fmt:parseDate value="${ running.created }" pattern="yyyy-MM-dd'T'HH:mm" var="runningDate" type="both"/>

<div class="container-fluid">
    <div class="row">
        <!-- This is the results panel -->
        <div class="col-md-12 font-size-16">
            <h3 class="title-font" id="subtitle">
                FAIR Metrics Summary
            </h3>

            <table id="summary-fair-metrics-table" class="display table table-striped table-bordered" cellspacing="0"
                   width="100%">
                <thead>
                <tr>
                    <th rowspan="2" class="fair-metric-table-header">Digital Object Identifier</th>
                    <th colspan="13" class="text-center fair-metric-table-header">
                        <a class="color-white underline"
                           href="${pageContext.request.contextPath}/fair-metrics/description"> FAIR Metrics</a>
                    </th>
                </tr>
                <tr>
                    <c:forEach items="${keys}" var="key">
                        <th data-toggle="modal" class="pointer text-center underline"
                            data-title="<fmt:message key="${key.concat('-Column-Header')}" />"
                            data-target="#fairMetricsModal"
                            title="<fmt:message key="${key.concat('-Name')}" />"
                            data-fmid="<fmt:message key="${key}" />"
                            data-identifier="<fmt:message key="${key.concat('-Identifier')}" />"
                            data-url="<fmt:message key="${key.concat('-URL')}" />"
                            data-name="<fmt:message key="${key.concat('-Name')}" />"
                            data-principle="<fmt:message key="${key.concat('-Principle')}" />"
                            data-measured="<fmt:message key="${key.concat('-Measured')}" />"
                            data-why-measure="<fmt:message key="${key.concat('-Why-Measure')}" />"
                            data-must-provided="<fmt:message key="${key.concat('-Must-Provided')}" />"
                            data-how-measure="<fmt:message key="${key.concat('-How-Measure')}" />"
                            data-valid-result="<fmt:message key="${key.concat('-Valid-Result')}" />"
                            data-which-relevant="<fmt:message key="${key.concat('-Which-Relevant')}" />"
                            data-examples="<fmt:message key="${key.concat('-Examples')}" />"
                            data-comments="<fmt:message key="${key.concat('-Comments')}" />"
                        ><fmt:message key="${key.concat('-Column-Header')}"/></th>
                    </c:forEach>

                </tr>
                </thead>

                <td>average score</td>
                <c:forEach items="${keys}" var="key">
                    <td class="vertical-align-middle text-center"><c:out value="${scores[key]}"/></td>
                </c:forEach>

                </tr>

            </table>
            <button class="btn btn-primary run-metrics-button" onclick="toggleReport()">Show Metrics Report</button>

        </div>
    </div>

    <div id="full-report" class="row hidden">
        <!-- This is the results panel -->
        <div class="col-md-12 font-size-16">
            <h3 class="title-font" id="subtitle">
                FAIR Metrics (${report.results.size()} entries) since <fmt:formatDate type="both"
                                                                                      value="${createdDate}"/>
            </h3>
            <c:choose>
                <c:when test="${empty running}">
                </c:when>
                <c:otherwise>
                    <h4>Note: there are some pending reruns since <fmt:formatDate type="both"
                                                                                  value="${runningDate}"/></h4>
                </c:otherwise>
            </c:choose>
            <form action="./fair-metrics/run" method="post" id="form1"/>
            <c:if test="${adminType == 'ISG_ADMIN'}">
                <button class="btn btn-primary run-metrics-button" type="submit" form="form1" value="Submit">Rerun Metrics</button>
            </c:if>

            <table id="fair-metrics-table" class="display table table-striped table-bordered" cellspacing="0"
                   width="100%">
                <thead>
                <tr>
                    <th rowspan="2" class="fair-metric-table-header">Digital Object Identifier</th>
                    <th colspan="13" class="text-center fair-metric-table-header">
                        <a class="color-white underline"
                           href="${pageContext.request.contextPath}/fair-metrics/description"> FAIR Metrics</a>
                    </th>
                </tr>
                <tr>
                    <c:forEach items="${keys}" var="key">
                        <th data-toggle="modal" class="pointer text-center underline"
                            data-title="<fmt:message key="${key.concat('-Column-Header')}" />"
                            data-target="#fairMetricsModal"
                            title="<fmt:message key="${key.concat('-Name')}" />"
                            data-fmid="<fmt:message key="${key}" />"
                            data-identifier="<fmt:message key="${key.concat('-Identifier')}" />"
                            data-url="<fmt:message key="${key.concat('-URL')}" />"
                            data-name="<fmt:message key="${key.concat('-Name')}" />"
                            data-principle="<fmt:message key="${key.concat('-Principle')}" />"
                            data-measured="<fmt:message key="${key.concat('-Measured')}" />"
                            data-why-measure="<fmt:message key="${key.concat('-Why-Measure')}" />"
                            data-must-provided="<fmt:message key="${key.concat('-Must-Provided')}" />"
                            data-how-measure="<fmt:message key="${key.concat('-How-Measure')}" />"
                            data-valid-result="<fmt:message key="${key.concat('-Valid-Result')}" />"
                            data-which-relevant="<fmt:message key="${key.concat('-Which-Relevant')}" />"
                            data-examples="<fmt:message key="${key.concat('-Examples')}" />"
                            data-comments="<fmt:message key="${key.concat('-Comments')}" />"
                        ><fmt:message key="${key.concat('-Column-Header')}"/></th>
                    </c:forEach>

                </tr>
                </thead>
                <c:forEach items="${report.results}" var="row">
                    <tr>
                        <td><a href="javascript:void(0);" class="underline"
                               onclick="getIdentifierOpenModal('${row.subject}')"><c:out
                                value="${row.subject}"/></a>
                            <br>
                            <sub>${function:getTitleFromPayload(row.submittedPayload)}</sub>
                        </td>
                            <%--<td><c:out value="${row.results.size()}"/></td>--%>
                        <c:forEach items="${row.results}" var="result" varStatus="status">
                            <c:choose>
                                <c:when test="${result.hasValue == '0' or result.hasValue == '0.0'}">
                                    <td class="vertical-align-middle text-center"><i
                                            class="fas fa-times fair-metric-x"></i></td>
                                </c:when>
                                <c:when test="${result.hasValue == '1' or result.hasValue == '1.0' or result.hasValue == '0.99'}">
                                    <td class="vertical-align-middle text-center"><i
                                            class="fas fa-check theme-primary-color"></i></td>
                                </c:when>
                                <c:when test="${result.hasValue == '0.33'}">
                                    <td class="vertical-align-middle text-center">1 of 3<br>passed</td>
                                </c:when>
                                <c:when test="${result.hasValue == '0.66'}">
                                    <td class="vertical-align-middle text-center">2 of 3<br>passed</td>
                                </c:when>
                                <c:otherwise>
                                    <td class="vertical-align-middle"><c:out value="${result.hasValue}"/></td>
                                </c:otherwise>
                            </c:choose>

                        </c:forEach>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <br>
    <myTags:footer/>


    <div class="modal fade" id="fairMetricsModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header software-header">
                    <h2 class="modal-title sub-title-font pull-left color-white"></h2>
                </div>
                <div class="modal-body">
                    <div class="tab-content">
                        <div class="sub-title-font font-size-16 modal-software-item">
                            <h6 class="inline bold"><fmt:message key="FM-Identifier-Field"/></h6><br>
                            <span id="identifier"></span>
                        </div>
                        <div class="sub-title-font font-size-16 modal-software-item">
                            <h6 class="inline bold"><fmt:message key="FM-Principle-Field"/></h6><br>
                            <span id="principle"></span>
                        </div>
                        <div class="sub-title-font font-size-16 modal-software-item">
                            <h6 class="inline bold"><fmt:message key="FM-Measured-Field"/></h6><br>
                            <span id="measured"></span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" id="detailed-view-button">Detailed View</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>

<script>
    function toggleReport() {
       $('#full-report').toggleClass('hidden');
       $(window).trigger('resize');
    }
    
    $(document).ready(function () {
        //add a second pagination to the top of the table
        $('#fair-metrics-table').DataTable({
            "dom": "<'row'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
                "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>" +
                "<'row'<'col-sm-12'tr>>" +
                "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            'createdRow': function (row, data, dataIndex) {
                $('td', row).css('padding', '.5rem');
                $('td', row).css('min-width', '53px');
                $('td:eq(0)', row).css('min-width', '150px');

            },
            "scrollX": true,
            ordering: false,
        });


        $('#fairMetricsModal').on('show.bs.modal', function (event) {
            var header = $(event.relatedTarget);
            var modal = $(this);

            var title = header.data('title');
            var fmid = "FM-" + header.data('title');
            var identifier = header.data('url');
            var name = header.data('name');
            var principle = header.data('principle');
            var measured = header.data('measured');
            var whyMeasure = header.data('why-measure');
            var mustProvided = header.data('must-provided');
            var howMeasure = header.data('how-measure');
            var validResult = header.data('valid-result');
            var whichRelevant = header.data('which-relevant');
            var examples = header.data('examples');
            var comments = header.data('comments');

            if (window.mobilecheck()) {
                window.location = ctx + "/fair-metrics/detailed-view/?key=" + "FM-" + title;
                $('#fairMetricsModal').modal('dispose');
            }

            modal.find('#detailed-view-button').attr("onClick", "location.href='" + ctx + "/fair-metrics/detailed-view/?key=" + "FM-" + title + "'")
            modal.find('.modal-title').html(title + " - " + name);
            modal.find('#identifier').html("<a class='underline link-break-all' href='" + identifier + "'target='_blank'>" + identifier + "</a>");
            /*
                        modal.find('#name').html(name);
            */
            modal.find('#principle').html(principle);
            modal.find('#measured').html(measured);
            /*
                        modal.find('#whyMeasure').html(whyMeasure);
                        modal.find('#mustProvided').html(mustProvided);
                        modal.find('#howMeasure').html(howMeasure);
                        modal.find('#validResult').html(validResult);
                        modal.find('#whichRelevant').html(whichRelevant);
                        modal.find('#examples').html(examples);
                        modal.find('#comments').html(comments);
            */
        })

    });
</script>
</html>
