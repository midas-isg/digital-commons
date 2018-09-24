<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>

<html>
<head>
    <myTags:head title="MIDAS Digital Commons"/>
    <myTags:header
            pageTitle="MIDAS Digital Commons"
            loggedIn="${loggedIn}"
            addEntry="${true}"
    />

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
            <button type="submit" form="form1" value="Submit">Rerun Metrics</button>
            <table id="resultTable" datatable="ng" class="table table-striped table-bordered" dt-options="dtOptions"
                   dt-columns="dtColumns">
            </table>
            <table id="entry-table" class="display table table-striped table-bordered" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>Subject</th>
                    <%--<th>FM</th>--%>
                    <th>FM-F1A</th>
                    <th>FM-F1B</th>
                    <th>FM-F2</th>
                    <th>FM-F3</th>
                    <th>FM-F4</th>
                    <th>FM-A1.1</th>
                    <th>FM-A1.2</th>
                    <th>FM-A2</th>
                    <th>FM-I1</th>
                    <th>FM-I2</th>
                    <th>FM-I3</th>
                    <th>FM-R1.1</th>
                    <th>FM-R1.2</th>
                </tr>
                </thead>
                <c:forEach items="${report.results}" var="row">
                    <tr>
                        <td><c:out value="${row.subject}"/></td>
                        <%--<td><c:out value="${row.results.size()}"/></td>--%>
                        <c:forEach items="${row.results}" var="result">
                            <td><c:out value="${result.hasValue}"/></td>
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
</body>

<script>
    $(document).ready(function (){
    });
</script>
</html>
