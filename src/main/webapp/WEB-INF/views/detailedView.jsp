<%--
  Created by IntelliJ IDEA.
  User: mas400
  Date: 5/14/18
  Time: 3:26 PM
  To change this template use File | Settings | File Templates.
--%>
<html>
<head>
    <title>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <html lang="en">

        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
        <%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

        <myTags:head title="MIDAS Digital Commons"/>

        <myTags:header
                pageTitle="MIDAS Digital Commons"
                loggedIn="${loggedIn}"/>

<body id="commons-body">
<div id="content-body">
    <h3>${title}</h3>
    <div class="tab-content">
        <div class="tab-pane fade in active" id="modal-html">
            <myTags:softwareModalItems></myTags:softwareModalItems>
        </div>
    </div>

</div>

<script>
    $(document).ready(function(){
        toggleModalItems(${entryJson}, "${type}");
    });


</script>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>
</title>
</head>
<body>

</body>
</html>
