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
    <myTags:softwareIndex active="diseaseTransmissionTreeEstimatorForm"></myTags:softwareIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <fmt:message key="software.diseaseTransmissionTreeEstimators.hostSpeciesIncluded" var="hostSpeciesIncludedPlaceHolder" />
            <myTags:editMasterUnbounded path="hostSpeciesIncluded"
                                            specifier="host-species-included"
                                            label="Host Species Included"
                                            addButtonLabel="Host Species"
                                            tagName="softwareIdentifier"
                                            placeholder="${hostSpeciesIncludedPlaceHolder}"
                                            cardText="${hostSpeciesIncludedPlaceHolder}"
                                            cardIcon="fas fa-crow"
                                            listItems="${digitalObject.hostSpeciesIncluded}"
                                            isRequired="${false}">
                </myTags:editMasterUnbounded>

            <fmt:message key="software.diseaseTransmissionTreeEstimators.pathogenCoverage" var="pathogenCoveragePlaceHolder" />
            <myTags:editMasterUnbounded path="pathogenCoverage"
                                            specifier="pathogen-coverage"
                                            label="Pathogen Coverages"
                                            addButtonLabel="Pathogen Coverage"
                                            tagName="softwareIdentifier"
                                            placeholder="${pathogenCoveragePlaceHolder}"
                                            cardText="${pathogenCoveragePlaceHolder}"
                                            cardIcon="fas fa-microscope"
                                            listItems="${digitalObject.pathogenCoverage}"
                                            isRequired="${false}">
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