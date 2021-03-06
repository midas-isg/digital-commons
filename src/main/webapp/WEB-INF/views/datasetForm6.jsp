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
    <myTags:datasetIndex active="primaryPublications"></myTags:datasetIndex>
    <div id="entryFormContent">

        <form method="post" id="entry-form" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}" wantLoader="${true}"></myTags:wizardHeader>

            <fmt:message key="dataset.primaryPublications" var="primaryPublicationsPlaceHolder" />
            <myTags:editMasterUnbounded path="primaryPublications"
                                        specifier="primaryPublications"
                                        listItems="${digitalObject.primaryPublications}"
                                        cardText="${primaryPublicationsPlaceHolder}"
                                        cardIcon="fas fa-book"
                                        tagName="publication"
                                        addButtonLabel="Primary Publication"
                                        label="Primary Publications">
            </myTags:editMasterUnbounded>

            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous" onclick="window.onbeforeunload = null;"/>
            <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next" onclick="window.onbeforeunload = null;"/>
            <myTags:finishedEditingButton/>

        </form>
    </div>
</div>

<script>
    $(document).ready(function () {
        toggleLoadingScreen();
        // $('.loading').addClass("hide");

    });
</script>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>