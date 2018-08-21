<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>

</head>
<body>
<div class="wrapper">
    <myTags:softwareIndex active="dataServiceForm"></myTags:softwareIndex>
    <div id="entryFormContent">
        <button type="button" id="sidebarCollapse"
                class="inline float-right btn btn-info btn-sm navbar-btn d-none d-sm-none d-md-block">
            <i class="glyphicon glyphicon-align-left"></i>
            <span>Toggle Sidebar</span>
        </button>
        <form id="entry-form" method="post" action="${flowExecutionUrl}">
<%--
            <label>Data Service</label>
--%>
            <myTags:editMasterUnbounded path="dataServiceDescription"
                                        specifier="dataServiceDescription"
                                        label="Data Service Description"
                                        isRequired="${false}"
                                        isFirstRequired="${true}"
                                        listItems="${dataService.dataServiceDescription}"
                                        tagName="dataServiceDescription">
            </myTags:editMasterUnbounded>
<%--
            <myTags:editDataServiceDescription accessPointTypes="${accessPointTypes}"
                                               descriptions="${dataService.dataServiceDescription}">
            </myTags:editDataServiceDescription>
--%>

            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"/>
            <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit"/>

        </form>
    </div>
</div>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>