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
    <myTags:softwareIndex active="diseaseTransmissionTreeEstimatorForm"></myTags:softwareIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

                <myTags:editMasterUnbounded path="hostSpeciesIncluded"
                                            specifier="host-species-included"
                                            label="Host Species Included"
                                            tagName="softwareIdentifier"
                                            placeholder="Host Species Included"
                                            listItems="${digitalObject.hostSpeciesIncluded}"
                                            isRequired="${false}">
                </myTags:editMasterUnbounded>
                <myTags:editMasterUnbounded path="pathogenCoverage"
                                            specifier="pathogen-coverage"
                                            label="Pathogen Coverage"
                                            tagName="softwareIdentifier"
                                            placeholder="Pathogen Coverage"
                                            listItems="${digitalObject.pathogenCoverage}"
                                            isRequired="${false}">
                </myTags:editMasterUnbounded>

                <%--
                                <myTags:editNestedIdentifier specifier="hostSpeciesIncluded"
                                                         placeholder="Host Species Included"
                                                         label="Host Species Included" path="hostSpeciesIncluded"
                                                         identifiers="${diseaseTransmissionTreeEstimator.hostSpeciesIncluded}"></myTags:editNestedIdentifier>
                            <myTags:editNestedIdentifier specifier="pathogenCoverage"
                                                         placeholder="Pathogen Coverage"
                                                         label="Pathogen Coverage" path="pathogenCoverage"
                                                         identifiers="${diseaseTransmissionTreeEstimator.pathogenCoverage}"></myTags:editNestedIdentifier>
                --%>
            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous" onclick="window.onbeforeunload = null;"/>
            <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit" onclick="window.onbeforeunload = null;"/>

        </form>
    </div>
</div>


<myTags:analytics/>

</body>

<myTags:footer/>

</html>