<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <myTags:head title="MIDAS Digital Commons"/>
    <myTags:header
            pageTitle="MIDAS Digital Commons"
            loggedIn="${loggedIn}"
            addEntry="${true}"
    />
        <fmt:setBundle basename="fairMetricsDescriptions" />


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
            <form action="/digital-commons/fm/run" method="post" id="form1" />
            <button class="btn btn-primary" type="submit" form="form1" value="Submit">Rerun Metrics</button>
            <table id="resultTable" datatable="ng" class="table table-striped table-bordered" dt-options="dtOptions"
                   dt-columns="dtColumns">
            </table>
            <table id="entry-table" class="display table table-striped table-bordered" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>Digital Object Identifier</th>
                    <%--<th>FM</th>--%>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-F1A" />" data-target="#fairMetricsModal" >FM-F1A</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-F1B" />" data-target="#fairMetricsModal" >FM-F1B</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-F2" />" data-target="#fairMetricsModal" >FM-F2</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-F3" />" data-target="#fairMetricsModal" >FM-F3</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-F4" />" data-target="#fairMetricsModal" >FM-F4</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM_A1.1" />" data-target="#fairMetricsModal" >FM-A1.1</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM_A1.2" />" data-target="#fairMetricsModal" >FM-A1.2</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-A2" />" data-target="#fairMetricsModal" >FM-A2</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-I1" />" data-target="#fairMetricsModal" >FM-I1</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-I2" />" data-target="#fairMetricsModal" >FM-I2</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-I3" />" data-target="#fairMetricsModal" >FM-I3</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-R1.1" />" data-target="#fairMetricsModal" >FM-R1.1</th>
                    <th data-toggle="modal" data-measured="<fmt:message key="FM-R1.2" />" data-target="#fairMetricsModal" >FM-R1.2</th>
                </tr>
                </thead>
                <c:forEach items="${report.results}" var="row">
                    <tr>
                        <td onclick="getIdentifierOpenModal('${row.subject}')"><c:out value="${row.subject}"/></td>
                        <%--<td><c:out value="${row.results.size()}"/></td>--%>
                        <c:forEach items="${row.results}" var="result" varStatus="status">
                            <c:choose>
                                <c:when test="${result.hasValue == '0' or result.hasValue == '0.0'}">
                                    <td><i class="fas fa-times fair-metric-x"></i></td>
                                </c:when>
                                <c:when test="${result.hasValue == '1' or result.hasValue == '1.0' or result.hasValue == '0.99'}">
                                    <td><i class="fas fa-check theme-primary-color"></i></td>
                                </c:when>
                                <c:otherwise>
                                    <td><c:out value="${result.hasValue}"/></td>
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


    <div class="modal" id="fairMetricsModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>

<script>
    $(document).ready(function (){
        $('#entry-table').DataTable({

        });

        $('#fairMetricsModal').on('show.bs.modal', function (event) {
            var header = $(event.relatedTarget);
            var measured = header.data('measured');

            var modal = $(this);
            modal.find('.modal-body').append(measured);

        })
    });
</script>
</html>
