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
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-xs-12">
            <form method="post" id="entry-form" action="${flowExecutionUrl}">
                <div class="form-group edit-form-group">
                    <label>Disease Forecaster</label>
                    <%--<myTags:editSoftware categoryPaths="${categoryPaths}" selectedID="${selectedID}"></myTags:editSoftware>--%>
                    <myTags:editNestedIdentifier specifier="diseases" placeholder="Disease" label="Diseases" path="diseases" identifiers="${software.diseases}"></myTags:editNestedIdentifier>
                    <myTags:editUnboundedNonRequiredNonZeroLengthString formats="${software.nowcasts}" label="Nowcasts" placeholder="Nowcast" specifier="nowcast" path="nowcasts"></myTags:editUnboundedNonRequiredNonZeroLengthString>
                    <myTags:editUnboundedNonRequiredNonZeroLengthString formats="${software.outcomes}" label="Outcomes" placeholder="Outcome" specifier="outcome" path="outcomes"></myTags:editUnboundedNonRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString label="Forecast Frequency" placeholder="Forecast Frequency" specifier="forecast-frequency" path="forecastFrequency" string="${software.forecastFrequency}"></myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString label="Type" placeholder="Type" specifier="type" path="type" string="${software.type}"></myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editUnboundedRequiredNonZeroLengthString label="Forecasts" placeholder="Forecast" path="forecasts" specifier="forecasts" strings="${software.forecasts}"></myTags:editUnboundedRequiredNonZeroLengthString>
                    <%--<myTags:editNestedIdentifier specifier="location-coverage" placeholder="Location Coverage" label="Location Coverages" path="locationCoverage" identifiers="${software.locationCoverage}"></myTags:editNestedIdentifier>--%>
                </div>
                <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"/>
                <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit"/>

            </form>
        </div>
    </div>
</div>
<%--

<script>
    $(document).ready(function () {
        $("#categoryValue").change(function() {
            var action = $(this).val()
            $("#entry-form").attr("action", "${pageContext.request.contextPath}/addDiseaseForecasters/" + action + "?entryId=${entryId}&revisionId=${revisionId}");
        });

    });
</script>
--%>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>