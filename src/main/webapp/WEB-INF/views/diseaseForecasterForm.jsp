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
        <button type="button" id="sidebarCollapse"
                class="inline float-right btn btn-info btn-sm navbar-btn d-none d-sm-none d-md-block">
            <i class="glyphicon glyphicon-align-left"></i>
            <span>Toggle Sidebar</span>
        </button>
        <form id="entry-form" method="post" action="${flowExecutionUrl}">
<%--
            <label>Disease Forecaster</label>
--%>
            <myTags:editMasterUnbounded specifier="diseases"
                                        placeholder="Disease"
                                        label="Diseases"
                                        path="diseases"
                                        tagName="softwareIdentifier"
                                        listItems="${digitalObject.diseases}">
            </myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded listItems="${digitalObject.nowcasts}"
                                        label="Nowcasts"
                                        placeholder="Nowcast"
                                        specifier="nowcast"
                                        tagName="string"
                                        path="nowcasts">
            </myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded listItems="${digitalObject.outcomes}"
                                        label="Outcomes"
                                        placeholder="Outcome"
                                        specifier="outcome"
                                        tagName="string"
                                        path="outcomes">
            </myTags:editMasterUnbounded>
            <myTags:editNonZeroLengthString label="Forecast Frequency"
                                            placeholder="Forecast Frequency"
                                            specifier="forecast-frequency"
                                            path="forecastFrequency"
                                            string="${digitalObject.forecastFrequency}">
            </myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString label="Type"
                                            placeholder="Type"
                                            specifier="type"
                                            path="type"
                                            string="${digitalObject.type}">
            </myTags:editNonZeroLengthString>
            <%--TODO: Forecast is a required element for Disease Forecasters -- need to updated editMasterElementWrapper.tag--%>
            <myTags:editMasterUnbounded label="Forecasts"
                                        placeholder="Forecast"
                                        path="forecasts"
                                        specifier="forecasts"
                                        isRequired="${false}"
                                        isFirstRequired="${true}"
                                        tagName="string"
                                        listItems="${digitalObject.forecasts}">
            </myTags:editMasterUnbounded>

            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"/>
            <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit"/>

        </form>
    </div>
</div>


<myTags:analytics/>

</body>

<myTags:footer/>

</html>