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
    <myTags:softwareIndex active="diseaseForecasterForm"></myTags:softwareIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <myTags:editNonZeroLengthString label="Type"
                                            placeholder="Type of forecasting the software produces."
                                            specifier="type"
                                            id="type"
                                            path="type"
                                            cardText="Type of forecasting the software produces."
                                            isInputGroup="${true}"
                                            isRequired="${true}"
                                            string="${digitalObject.type}">
            </myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString label="Forecast Frequency"
                                            placeholder="How often the software updates output on one or more predicted count data items."
                                            specifier="forecast-frequency"
                                            id="forecast-frequency"
                                            path="forecastFrequency"
                                            cardText="How often the software updates output on one or more predicted count data items."
                                            isInputGroup="${true}"
                                            isRequired="${true}"
                                            string="${digitalObject.forecastFrequency}">
            </myTags:editNonZeroLengthString>
            <%--TODO: Forecast is a required element for Disease Forecasters -- need to updated editMasterElementWrapper.tag--%>
            <myTags:editMasterUnbounded label="Forecasts"
                                        addButtonLabel="Forecast"
                                        placeholder="A description of future conditions."
                                        path="forecasts"
                                        specifier="forecasts"
                                        isRequired="${true}"
                                        cardText="A description of future conditions."
                                        isFirstRequired="${true}"
                                        tagName="string"
                                        listItems="${digitalObject.forecasts}">
            </myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded specifier="diseases"
                                        placeholder="A disposition to undergo pathological processes that exists in an organism because of one or more disorders in that organism."
                                        label="Diseases"
                                        addButtonLabel="Disease"
                                        path="diseases"
                                        cardText="A disposition to undergo pathological processes that exists in an organism because of one or more disorders in that organism."
                                        tagName="softwareIdentifier"
                                        listItems="${digitalObject.diseases}">
            </myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded listItems="${digitalObject.nowcasts}"
                                        label="Nowcasts"
                                        addButtonLabel="Nowcast"
                                        placeholder="A description of present conditions or a forecast of those immediately expected."
                                        specifier="nowcast"
                                        cardText="A description of present conditions or a forecast of those immediately expected."
                                        tagName="string"
                                        path="nowcasts">
            </myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded listItems="${digitalObject.outcomes}"
                                        label="Outcomes"
                                        addButtonLabel="Outcome"
                                        placeholder="A processual entity that is either the outcome of a disease course or a part of a disease course and has etiological relevance."
                                        specifier="outcome"
                                        cardText="A processual entity that is either the outcome of a disease course or a part of a disease course and has etiological relevance."
                                        tagName="string"
                                        path="outcomes">
            </myTags:editMasterUnbounded>

            <div class="row " id="entryFormContent-card-row"></div>

            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous" onclick="window.onbeforeunload = null;"/>
            <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit" onclick="window.onbeforeunload = null;"/>

        </form>
    </div>
</div>
<script>
    $(document).ready(function () {
        rearrangeCards('entryFormContent');
    });
</script>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>