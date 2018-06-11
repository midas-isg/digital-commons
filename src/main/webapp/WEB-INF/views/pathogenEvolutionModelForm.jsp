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
            <form:form id="entry-form" action="${pageContext.request.contextPath}/addPathogenEvolutionModel/${categoryID}"
                       modelAttribute="pathogenEvolutionModel">
                <div class="form-group edit-form-group">
                    <label>Pathogen Evolution Model</label>

                    <myTags:editSoftware categoryPaths="${categoryPaths}" selectedID="${selectedID}"></myTags:editSoftware>
                    <myTags:editNestedIdentifier specifier="pathogens" path="pathogens" identifiers="${pathogenEvolutionModel.pathogens}" placeholder="Pathogen" label="Pathogens"></myTags:editNestedIdentifier>
                    <%--<myTags:editNestedIdentifier specifier="location-coverate" path="locationCoverage" identifiers="${pathogenEvolutionModel.locationCoverage}" placeholder="Location Coverage" label="Location Coverage"></myTags:editNestedIdentifier>--%>

                </div>
                <button type="submit" class="btn btn-default pull-right">Submit</button>

            </form:form>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        $("#categoryValue").change(function() {
            var action = $(this).val()
            $("#entry-form").attr("action", "${pageContext.request.contextPath}/addPathogenEvolutionModel/" + action);
        });

    });
</script>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>