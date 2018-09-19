<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>

<html>
<head>
    <myTags:head/>
    <%--<script src="${pageContext.request.contextPath}/resources/js/commons.js"></script>--%>
    <script src="${pageContext.request.contextPath}/resources/js/lodash.min.js"></script>
        <%--pageTitle="Search"--%>
    <myTags:header
            pageTitle="MIDAS Digital Commons"
            loggedIn="${loggedIn}"
            addEntry="${true}"
    />

    <myTags:analytics/>
<body id="commons-body">

<myTags:softwareModal/>

<div class="margin-top-22">
    <div class="row">
        <!-- This is the results panel -->
        <div class="col-md-12 font-size-16">
            <h3 class="title-font" id="subtitle">
                FAIR Metrics (${report.results.size()})
            </h3>
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