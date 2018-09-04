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
    <myTags:datasetIndex active="isAbout"></myTags:datasetIndex>

    <div id="entryFormContent">

        <form method="post" id="entry-form" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <myTags:editMasterUnbounded path="isAbout"
                                specifier="isAbout"
                                listItems="${digitalObject.isAbout}"
                                        tagName="isAbout"
                                        cardText="Different entities associated with this dataset."
                                label="Is About"
                                showAddAnnotationButton="true"
                                showAddBiologicalEntityButton="true">
            </myTags:editMasterUnbounded>
<%--
            <myTags:editIsAbout path="isAbout"
                                        specifier="isAbout"
                                        isAboutList="${digitalObject.isAbout}"
                                        label="Is About"
                                        showAddAnnotationButton="true"
                                        showAddBiologicalEntityButton="true">
            </myTags:editIsAbout>
--%>

            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous" onclick="window.onbeforeunload = null;"/>
            <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next" onclick="window.onbeforeunload = null;"/>

        </form>
    </div>
</div>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>