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
            <form:form id="entry-form" action="${pageContext.request.contextPath}/addDiseaseForecaster"
                       modelAttribute="diseaseForecaster">
                <div class="form-group edit-form-group">
                    <label>Disease Forecaster</label>
                    <myTags:editSoftware categoryPaths="${categoryPaths}" selectedID="${selectedID}"></myTags:editSoftware>
                    <myTags:editNestedIdentifier specifier="diseases" placeholder="Disease" label="Diseases" path="diseases" identifiers="${diseaseForecaster.diseases}"></myTags:editNestedIdentifier>
                    <myTags:editUnboundedNonRequiredNonZeroLengthString formats="${diseaseForecaster.nowcasts}" label="Nowcasts" placeholder="Nowcast" specifier="nowcast" path="nowcasts"></myTags:editUnboundedNonRequiredNonZeroLengthString>
                    <myTags:editUnboundedNonRequiredNonZeroLengthString formats="${diseaseForecaster.outcomes}" label="Outcomes" placeholder="Outcome" specifier="outcome" path="outcomes"></myTags:editUnboundedNonRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString label="Forecast Frequency" placeholder="Forecast Frequency" specifier="forecast-frequency" path="forecastFrequency" string="${diseaseForecaster.forecastFrequency}"></myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString label="Type" placeholder="Type" specifier="type" path="type" string="${diseaseForecaster.type}"></myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editUnboundedRequiredNonZeroLengthStrig label="Forecasts" placeholder="Forecast" path="forecasts" specifier="forecasts" strings="${diseaseForecaster.forecasts}"></myTags:editUnboundedRequiredNonZeroLengthStrig>
                    <myTags:editNestedIdentifier specifier="location-coverage" placeholder="Location Coverage" label="Location Coverages" path="locationCoverage" identifiers="${diseaseForecaster.locationCoverage}"></myTags:editNestedIdentifier>
                </div>
                <button type="submit" class="btn btn-default pull-right">Submit</button>

            </form:form>
        </div>
    </div>
</div>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>