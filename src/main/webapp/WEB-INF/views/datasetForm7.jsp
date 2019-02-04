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
    <myTags:datasetIndex active="citation"></myTags:datasetIndex>

    <div id="entryFormContent">

        <form method="post" id="entry-form" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>
            <div id="citationCount">
                <fmt:message key="dataset.citationCount" var="citationCountPlaceHolder" />
                <myTags:editFloat path="citationCount"
                                  id="citationCount"
                                  specifier="citationCount"
                                  number="${digitalObject.citationCount}"
                                  label="Citation Count"
                                  placeholder="${citationCountPlaceHolder}">
                </myTags:editFloat>
            </div>
            <div id="citations">
                <fmt:message key="dataset.citation" var="citationPlaceHolder" />
                <myTags:editMasterUnbounded path="citations"
                                            specifier="citations"
                                            listItems="${digitalObject.citations}"
                                            cardText="${citationPlaceHolder}"
                                            cardIcon="fas fa-quote-right"
                                            tagName="publication"
                                            addButtonLabel="Citation"
                                            label="Citations">
                </myTags:editMasterUnbounded>
            </div>

            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"
                   onclick="window.onbeforeunload = null;"/>
            <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next"
                   onclick="window.onbeforeunload = null;"/>
            <myTags:finishedEditingButton/>

        </form>
    </div>
</div>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>