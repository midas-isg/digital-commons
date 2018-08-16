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
<div class="container">
    <div class="row">
        <div class="col-xs-12">
            <form method="post" id="entry-form" action="${flowExecutionUrl}">
                <div class="form-group edit-form-group">
                    <label>Disease Transmission Model</label>
<%--
                    <myTags:editSoftware categoryPaths="${categoryPaths}" selectedID="${selectedID}"></myTags:editSoftware>
--%>

                    <myTags:editNestedIdentifier specifier="control-measures" placeholder="Control Measure" label="Control Measures" path="controlMeasures" identifiers="${diseaseTransmissionModel.controlMeasures}"></myTags:editNestedIdentifier>
                    <myTags:editNestedIdentifier specifier="host-species-included" placeholder="Host Species Included" label="Host Species Included" path="hostSpeciesIncluded" identifiers="${diseaseTransmissionModel.hostSpeciesIncluded}"></myTags:editNestedIdentifier>
                    <%--<myTags:editNestedIdentifier specifier="location-coverage" placeholder="Location Coverage" label="Location Coverages" path="locationCoverage" identifiers="${diseaseTransmissionModel.locationCoverage}"></myTags:editNestedIdentifier>--%>
                    <myTags:editNestedIdentifier specifier="pathogen-coverage" placeholder="Pathogen Coverage" label="Pathogen Coverages" path="pathogenCoverage" identifiers="${diseaseTransmissionModel.pathogenCoverage}"></myTags:editNestedIdentifier>
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
            $("#entry-form").attr("action", "${pageContext.request.contextPath}/addDiseaseTransmissionModel/" + action + "?entryId=${entryId}&revisionId=${revisionId}");
        });

    });
</script>
--%>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>