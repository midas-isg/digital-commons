<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
    <fmt:setBundle basename="cardText" />

    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>

</head>
<body>
<div class="wrapper">
    <myTags:softwareIndex active="populationDynamicsModelForm"></myTags:softwareIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <fmt:message key="software.populationDynamicsModels.populationSpeciesIncluded" var="populationSpeciesIncludedPlaceHolder" />
            <myTags:editMasterUnbounded path="populationSpeciesIncluded"
                                            specifier="populationSpeciesIncluded"
                                            label="Population Species Included"
                                            addButtonLabel="Population Species"
                                            tagName="softwareIdentifier"
                                            placeholder="${populationSpeciesIncludedPlaceHolder}"
                                            cardText="${populationSpeciesIncludedPlaceHolder}"
                                            listItems="${digitalObject.populationSpeciesIncluded}"
                                            isRequired="${true}">
                </myTags:editMasterUnbounded>

            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous" onclick="window.onbeforeunload = null;"/>
            <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit" onclick="window.onbeforeunload = null;"/>

        </form>
    </div>
</div>


<myTags:analytics/>


</body>

<myTags:footer/>

</html>