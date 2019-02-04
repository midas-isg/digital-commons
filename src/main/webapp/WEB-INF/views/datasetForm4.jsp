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
    <myTags:datasetIndex active="types"></myTags:datasetIndex>
    <div id="entryFormContent">

        <form method="post" id="entry-form" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>
            <div id="types">
                <fmt:message key="dataset.types" var="typesPlaceHolder" />
                <myTags:editMasterUnbounded path="types"
                                            specifier="types"
                                            label="Types"
                                            addButtonLabel="Type"
                                            isRequired="${true}"
                                            cardText="${typesPlaceHolder}"
                                            cardIcon="fas fa-info"
                                            tagName="type"
                                            listItems="${digitalObject.types}">
                </myTags:editMasterUnbounded>
            </div>
            <div id="availability">
                <fmt:message key="dataset.availability" var="availabilityPlaceHolder" />
                <myTags:editNonZeroLengthString path="availability"
                                                string="${digitalObject.availability}"
                                                specifier="availability"
                                                id="availability"
                                                isRequired="${true}"
                                                isInputGroup="${true}"
                                                placeholder="${availabilityPlaceHolder}"
                                                label="Availability">
                </myTags:editNonZeroLengthString>
            </div>
            <div id="refinement">
                <fmt:message key="dataset.refinement" var="refinementPlaceHolder" />
                <myTags:editNonZeroLengthString path="refinement"
                                                string="${digitalObject.refinement}"
                                                specifier="refinement"
                                                id="refinement"
                                                isRequired="${true}"
                                                isInputGroup="${true}"
                                                placeholder="${refinementPlaceHolder}"
                                                label="Refinement">
                </myTags:editNonZeroLengthString>
            </div>
            <div id="aggregation">
                <fmt:message key="dataset.aggregation" var="aggregationPlaceHolder" />
                <myTags:editNonZeroLengthString path="aggregation"
                                                string="${digitalObject.aggregation}"
                                                specifier="aggregation"
                                                id="aggregation"
                                                isRequired="${true}"
                                                isInputGroup="${true}"
                                                placeholder="${aggregationPlaceHolder}"
                                                label="Aggregation">
                </myTags:editNonZeroLengthString>
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