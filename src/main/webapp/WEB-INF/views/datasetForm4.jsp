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
    <myTags:datasetIndex active="types"></myTags:datasetIndex>
    <div id="entryFormContent">

        <form method="post" id="entry-form" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <div id="types">
                <myTags:editMasterUnbounded path="types"
                                            specifier="types"
                                            label="Types"
                                            cardText="A term, ideally from a controlled terminology, identifying the dataset type or nature of the data, placing it in a typology."
                                            tagName="type"
                                            listItems="${digitalObject.types}">
                </myTags:editMasterUnbounded>
            </div>
            <div id="availability">
                <myTags:editNonZeroLengthString path="availability"
                                                string="${digitalObject.availability}"
                                                specifier="availability"
                                                placeholder=" A qualifier indicating the different types of availability for a dataset (available, unavailable, embargoed, available with restriction, information not available)."
                                                label="Availability">
                </myTags:editNonZeroLengthString>
            </div>
            <div id="refinement">
                <myTags:editNonZeroLengthString path="refinement"
                                                string="${digitalObject.refinement}"
                                                specifier="refinement"
                                                placeholder=" A qualifier to describe the level of data processing of the dataset and its distributions."
                                                label="Refinement">
                </myTags:editNonZeroLengthString>
            </div>
            <div id="aggregation">
                <myTags:editNonZeroLengthString path="aggregation"
                                                string="${digitalObject.aggregation}"
                                                specifier="aggregation"
                                                placeholder=" A qualifier indicating if the entity represents an 'instance of dataset' or a 'collection of datasets'."
                                                label="Aggregation">
                </myTags:editNonZeroLengthString>
            </div>
            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"
                   onclick="window.onbeforeunload = null;"/>
            <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next"
                   onclick="window.onbeforeunload = null;"/>

        </form>
    </div>
</div>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>