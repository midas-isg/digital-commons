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
<div class="wrapper">
    <myTags:datasetIndex active="types"></myTags:datasetIndex>
    <div id="entryFormContent">
        <button type="button" id="sidebarCollapse"
                class="inline float-right btn btn-info btn-sm navbar-btn d-none d-sm-none d-md-block">
            <i class="glyphicon glyphicon-align-left"></i>
            <span>Toggle Sidebar</span>
        </button>
        <form method="post" id="entry-form" action="${flowExecutionUrl}">
            <myTags:editMasterUnbounded path="types"
                                        specifier="types"
                                        label="Types"
                                        tagName="type"
                                        listItems="${dataset.types}">
            </myTags:editMasterUnbounded>

            <myTags:editNonZeroLengthString path="availability"
                                            string="${dataset.availability}"
                                            specifier="availability"
                                            placeholder=" A qualifier indicating the different types of availability for a dataset (available, unavailable, embargoed, available with restriction, information not available)."
                                            label="Availability">
            </myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString path="refinement"
                                            string="${dataset.refinement}"
                                            specifier="refinement"
                                            placeholder=" A qualifier to describe the level of data processing of the dataset and its distributions."
                                            label="Refinement">
            </myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString path="aggregation"
                                            string="${dataset.aggregation}"
                                            specifier="aggregation"
                                            placeholder=" A qualifier indicating if the entity represents an 'instance of dataset' or a 'collection of datasets'."
                                            label="Aggregation">
            </myTags:editNonZeroLengthString>

            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"/>
            <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next"/>

        </form>
    </div>
</div>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>