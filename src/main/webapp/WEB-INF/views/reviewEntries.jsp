<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<myTags:head title="MIDAS Digital Commons"/>
<c:choose>
    <c:when test="${preview eq true}">
        <myTags:header
                pageTitle="MIDAS Digital Commons"
                loggedIn="true" preview="true"
                wantCollapse="true" iframe="false"
                addEntry="true"/>
    </c:when>
    <c:otherwise>
        <myTags:header
                pageTitle="MIDAS Digital Commons"
                loggedIn="true"
                preview="false"
                wantCollapse="true"
                iframe="false"
                addEntry="true"/>
    </c:otherwise>
</c:choose>
<body id="commons-body">
    <div id="content-body">

        <div id="commons-main-body" class="row">
            <div id="add-entry" class="tab-pane active">
                <myTags:reviewEntries
                        entries="${entries}"
                        datasetEntries="${datasetEntries}"
                        dataStandardEntries="${dataStandardEntries}"
                        softwareEntries="${softwareEntries}"/>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/bootstrap-treeview/1.2.0/bootstrap-treeview.min.js"></script>
    <script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/commons.js?v=" + Date.now() + "'><\/script>");</script>

    <myTags:analytics/>

</body>

<myTags:footer/>

</html>
