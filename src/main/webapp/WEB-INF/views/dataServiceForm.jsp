<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
    <fmt:setBundle basename="cardText" />

    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>

</head>
<body>
<div class="wrapper">
    <myTags:softwareIndex active="dataServiceForm"></myTags:softwareIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <fmt:message key="software.dataService" var="dataServicePlaceHolder" />
            <myTags:editMasterUnbounded path="dataServiceDescription"
                                        specifier="dataServiceDescription"
                                        label="Data Service Descriptions"
                                        addButtonLabel="Data Service Description"
                                        isRequired="${false}"
                                        isFirstRequired="${true}"
                                        cardText="${dataServicePlaceHolder}"
                                        cardIcon="fas fa-exchange-alt"
                                        listItems="${digitalObject.dataServiceDescription}"
                                        tagName="dataServiceDescription">
            </myTags:editMasterUnbounded>

            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous" onclick="window.onbeforeunload = null;"/>
            <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit" onclick="window.onbeforeunload = null;"/>

        </form>
    </div>
</div>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>