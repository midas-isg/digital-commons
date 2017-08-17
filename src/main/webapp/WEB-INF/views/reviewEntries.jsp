<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<myTags:head title="MIDAS Digital Commons"/>
<myTags:header
        pageTitle="MIDAS Digital Commons"
        loggedIn="${loggedIn}"
        addEntry="true"
/>

<body id="commons-body">
    <div id="content-body">

        <div id="commons-main-body" class="row">
            <div id="add-entry" class="tab-pane active">
                <myTags:reviewEntries
                        entries="${entries}"
                        categoryPaths="${categoryPaths}"
                        datasetEntries="${datasetEntries}"
                        dataStandardEntries="${dataStandardEntries}"
                        softwareEntries="${softwareEntries}"
                        approvedEntries="${approvedEntries}"/>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/bootstrap-treeview/1.2.0/bootstrap-treeview.min.js"></script>
    <script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/commons.js?v=" + Date.now() + "'><\/script>");</script>

    <myTags:analytics/>

</body>

<myTags:footer/>

</html>
