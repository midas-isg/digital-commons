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


    <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.19/css/dataTables.bootstrap4.min.css">
    <myTags:analytics/>
<body id="commons-body">

<myTags:softwareModal/>

<div class="container-fluid">
    <div class="row">
        <!-- This is the results panel -->
        <div class="col-md-12 font-size-16">
            <h3 class="title-font" id="subtitle">
                FAIR Metrics (${report.results.size()} entries) since ${report.created}
            </h3>
            <c:choose>
                <c:when test="${empty running}">
                </c:when>
                <c:otherwise>
                    <h4>Note: there are some pending reruns since ${running.created}</h4>
                </c:otherwise>
            </c:choose>
            <form action="/digital-commons/fair-metrics/run" method="post" id="form1"/>
            <c:if test="${adminType == 'ISG_ADMIN' or adminType == 'MDC_EDITOR'}">
                <button class="btn btn-primary" type="submit" form="form1" value="Submit">Rerun Metrics</button>
            </c:if>

            <table id="fair-metrics-table" class="display table table-striped table-bordered" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>Digital Object Identifier</th>
                    <c:forEach items="${keys}" var="key">
                        <th data-toggle="modal" class="pointer" data-title="<fmt:message key="${key.concat('-Column-Header')}" />" data-target="#fairMetricsModal"
                            title="<fmt:message key="${key.concat('-Name')}" />"
                            data-identifier="<fmt:message key="${key.concat('-Identifier')}" />"
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
                        ><fmt:message key="${key.concat('-Column-Header')}" /></th>
                    </c:forEach>

                </tr>
                </thead>
                <c:forEach items="${report.results}" var="row">
                    <tr>
                        <td><a href="javascript:void(0)" onclick="getIdentifierOpenModal('${row.subject}')"><c:out
                                value="${row.subject}"/></a>
                            <br>
                            <sub>${function:getTitleFromPayload(row.submittedPayload)}</sub>
                        </td>
                            <%--<td><c:out value="${row.results.size()}"/></td>--%>
                        <c:forEach items="${row.results}" var="result" varStatus="status">
                            <c:choose>
                                <c:when test="${result.hasValue == '0' or result.hasValue == '0.0'}">
                                    <td class="vertical-align-middle text-center"><i class="fas fa-times fair-metric-x"></i></td>
                                </c:when>
                                <c:when test="${result.hasValue == '1' or result.hasValue == '1.0' or result.hasValue == '0.99'}">
                                    <td class="vertical-align-middle text-center"><i class="fas fa-check theme-primary-color"></i></td>
                                </c:when>
                                <c:when test="${result.hasValue == '0.33'}">
                                    <td class="vertical-align-middle text-center">1 of 3</td>
                                </c:when>
                                <c:when test="${result.hasValue == '0.66'}">
                                    <td class="vertical-align-middle text-center">2 of 3</td>
                                </c:when>
                                <c:otherwise>
                                    <td class="vertical-align-middle"><c:out value="${result.hasValue}"/></td>
                                </c:otherwise>
                            </c:choose>

                        </c:forEach>
                    </tr>
                </c:forEach>
                <%--<tfoot>--%>
                <%--<tr>--%>
                <%--<th>Subject</th>--%>
                <%--<th>FM</th>--%>
                <%--</tr>--%>
                <%--</tfoot>--%>
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
                            <h6 class="inline bold">Metric Identifier: </h6><br>
                            <span id="identifier"></span>
                        </div>
                        <div class="sub-title-font font-size-16 modal-software-item">
                            <h6 class="inline bold">Metric Name: </h6><br>
                            <span id="name"></span>
                        </div>
                        <div class="sub-title-font font-size-16 modal-software-item">
                            <h6 class="inline bold">To which principle does it apply? </h6><br>
                            <span id="principle"></span>
                        </div>
                        <div class="sub-title-font font-size-16 modal-software-item">
                            <h6 class="inline bold">What is being measured? </h6><br>
                            <span id="measured"></span>
                        </div>
                        <%--
                                                <div class="sub-title-font font-size-16 modal-software-item">
                                                    <h6 class="inline bold">Why should we measure it? </h6><br>
                                                    <span id="whyMeasure"></span>
                                                </div>
                                                <div class="sub-title-font font-size-16 modal-software-item">
                                                    <h6 class="inline bold">What must be provided? </h6><br>
                                                    <span id="mustProvided"></span>
                                                </div>
                                                <div class="sub-title-font font-size-16 modal-software-item">
                                                    <h6 class="inline bold">How do we measure it? </h6><br>
                                                    <span id="howMeasure"></span>
                                                </div>
                                                <div class="sub-title-font font-size-16 modal-software-item">
                                                    <h6 class="inline bold">What is a valid result? </h6><br>
                                                    <span id="validResult"></span>
                                                </div>
                                                <div class="sub-title-font font-size-16 modal-software-item">
                                                    <h6 class="inline bold">For which digital resource(s) is this relevant? </h6><br>
                                                    <span id="whichRelevant"></span>
                                                </div>
                                                <div class="sub-title-font font-size-16 modal-software-item">
                                                    <h6 class="inline bold">Examples of their application across types of digital
                                                        resource: </h6><br>
                                                    <span id="examples"></span>
                                                </div>
                                                <div class="sub-title-font font-size-16 modal-software-item">
                                                    <h6 class="inline bold">Comments: </h6><br>
                                                    <span id="comments"></span>
                                                </div>
                        --%>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>

<script>
    $(document).ready(function () {
        //add a second pagination to the top of the table
        $('#fair-metrics-table').DataTable({
            "dom": "<'row'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
                "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>" +
                "<'row'<'col-sm-12'tr>>" +
                "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            'createdRow': function (row, data, dataIndex) {
                $('td', row).css('min-width', '65px');
            },
            ordering: false,
            responsive: true

        });

        $('#fairMetricsModal').on('show.bs.modal', function (event) {
            var header = $(event.relatedTarget);
            var modal = $(this);

            var title = header.data('title');
            var identifier = header.data('identifier');
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

            modal.find('.modal-title').html(title);
            modal.find('#identifier').html(identifier);
            modal.find('#name').html(name);
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
