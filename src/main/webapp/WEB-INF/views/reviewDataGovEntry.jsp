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
            <myTags:reviewDataGovEntry
                    returnMessage="${returnMessasge}"/>
        </div>
    </div>
</div>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>
