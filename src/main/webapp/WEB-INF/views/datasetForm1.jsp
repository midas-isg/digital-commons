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
    <myTags:datasetIndex active="basic"></myTags:datasetIndex>
    <div id="entryFormContent">
        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${showCategories}"></myTags:wizardHeader>
            <fmt:message key="dataset.title" var="titlePlaceHolder" />
            <myTags:editNonZeroLengthString label="Title"
                                            path="title"
                                            specifier="title"
                                            id="title"
                                            placeholder="${titlePlaceHolder}"
                                            isRequired="true"
                                            isInputGroup="${true}"
                                            string="${digitalObject.title}">
            </myTags:editNonZeroLengthString>

            <fmt:message key="dataset.description" var="descriptionPlaceHolder" />
            <myTags:editNonZeroLengthString path="description"
                                            string="${digitalObject.description}"
                                            specifier="description"
                                            id="description"
                                            isTextArea="true"
                                            isRequired="true"
                                            placeholder="${descriptionPlaceHolder}"
                                            isInputGroup="${true}"
                                            label="Description">
            </myTags:editNonZeroLengthString>
            <myTags:editIdentifier singleIdentifier="${digitalObject.identifier}"
                                   specifier="identifier"
                                   id="identifier"
                                   isUnboundedList="${false}"
                                   path="identifier"
                                   label="Identifier">
            </myTags:editIdentifier>

            <fmt:message key="dataset.dates" var="datesPlaceHolder" />
            <myTags:editMasterUnbounded listItems="${digitalObject.dates}"
                                        path="dates"
                                        label="Dates"
                                        addButtonLabel="Date"
                                        cardIcon="far fa-calendar-alt"
                                        cardText="${datesPlaceHolder}"
                                        tagName="date"
                                        specifier="dates">
            </myTags:editMasterUnbounded>
            <div class="row " id="entryFormContent-card-row"></div>

            <input hidden id="categoryID" name="categoryID" value="${categoryID}" type="number">
            <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next"
                   onclick="window.onbeforeunload = null;"/>
            <myTags:finishedEditingButton/>

        </form>
    </div>
</div>

<script>
    $(document).ready(function () {
        rearrangeCards('entryFormContent');


        $("#categoryValue").change(function () {
            var categoryValue = $(this).val();
            $("#categoryID").val(categoryValue)
            <%--$("#entry-form").attr("action", "${flowExecutionUrl}&_eventId=next&categoryID=" + action);--%>
        });

    });
</script>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>