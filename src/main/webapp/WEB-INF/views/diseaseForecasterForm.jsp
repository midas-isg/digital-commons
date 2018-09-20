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
    <myTags:softwareIndex active="diseaseForecasterForm"></myTags:softwareIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <fmt:message key="software.diseaseForecaster.type" var="typePlaceHolder" />
            <myTags:editNonZeroLengthString label="Type"
                                            placeholder="${typePlaceHolder}"
                                            specifier="type"
                                            id="type"
                                            path="type"
                                            cardText="${typePlaceHolder}"
                                            isInputGroup="${true}"
                                            isRequired="${true}"
                                            string="${digitalObject.type}">
            </myTags:editNonZeroLengthString>

            <fmt:message key="software.diseaseForecaster.forecastFrequency" var="forecastFrequencyPlaceHolder" />
            <myTags:editNonZeroLengthString label="Forecast Frequency"
                                            placeholder="${forecastFrequencyPlaceHolder}"
                                            specifier="forecast-frequency"
                                            id="forecast-frequency"
                                            path="forecastFrequency"
                                            cardText="${forecastFrequencyPlaceHolder}"
                                            isInputGroup="${true}"
                                            isRequired="${true}"
                                            string="${digitalObject.forecastFrequency}">
            </myTags:editNonZeroLengthString>
            <%--TODO: Forecast is a required element for Disease Forecasters -- need to updated editMasterElementWrapper.tag--%>

            <fmt:message key="software.diseaseForecaster.forecasts" var="forecastsPlaceHolder" />
            <myTags:editMasterUnbounded label="Forecasts"
                                        addButtonLabel="Forecast"
                                        placeholder="${forecastsPlaceHolder}"
                                        path="forecasts"
                                        specifier="forecasts"
                                        isRequired="${true}"
                                        cardText="${forecastsPlaceHolder}"
                                        isFirstRequired="${true}"
                                        tagName="string"
                                        listItems="${digitalObject.forecasts}">
            </myTags:editMasterUnbounded>

            <fmt:message key="software.diseaseForecaster.diseases" var="diseasesPlaceHolder" />
            <myTags:editMasterUnbounded specifier="diseases"
                                        placeholder="${diseasesPlaceHolder}"
                                        label="Diseases"
                                        addButtonLabel="Disease"
                                        path="diseases"
                                        cardText="${diseasesPlaceHolder}"
                                        tagName="softwareIdentifier"
                                        listItems="${digitalObject.diseases}">
            </myTags:editMasterUnbounded>

            <fmt:message key="software.diseaseForecaster.nowcasts" var="nowcastsPlaceHolder" />
            <myTags:editMasterUnbounded listItems="${digitalObject.nowcasts}"
                                        label="Nowcasts"
                                        addButtonLabel="Nowcast"
                                        placeholder="${nowcastsPlaceHolder}"
                                        specifier="nowcast"
                                        cardText="${nowcastsPlaceHolder}"
                                        tagName="string"
                                        path="nowcasts">
            </myTags:editMasterUnbounded>

            <fmt:message key="software.diseaseForecaster.outcomes" var="outcomesPlaceHolder" />
            <myTags:editMasterUnbounded listItems="${digitalObject.outcomes}"
                                        label="Outcomes"
                                        addButtonLabel="Outcome"
                                        placeholder="${outcomesPlaceHolder}"
                                        specifier="outcome"
                                        cardText="${outcomesPlaceHolder}"
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