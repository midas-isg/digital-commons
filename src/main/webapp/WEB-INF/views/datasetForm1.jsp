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
    <myTags:datasetIndex active="basic"></myTags:datasetIndex>
    <div id="entryFormContent">
        <button type="button" id="sidebarCollapse"
                class="inline float-right btn btn-info btn-sm navbar-btn d-none d-sm-none d-md-block">
            <i class="glyphicon glyphicon-align-left"></i>
            <span>Toggle Sidebar</span>
        </button>
        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:editCategory selectedID="${categoryID}"
                                 isDisabled="${false}"
                                 categoryPaths="${categoryPaths}">
            </myTags:editCategory>
            <myTags:editIdentifier singleIdentifier="${digitalObject.identifier}"
                                   specifier="identifier"
                                   id="identifier"
                                   isUnboundedList="${false}"
                                   path="identifier"
                                   label="Identifier">
            </myTags:editIdentifier>
            <myTags:editNonZeroLengthString label="Title"
                                            path="title"
                                            specifier="title"
                                            placeholder=" The name of the dataset, usually one sentece or short description of the dataset."
                                            isRequired="true"
                                            string="${digitalObject.title}">
            </myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString path="description"
                                            string="${digitalObject.description}"
                                            specifier="description"
                                            isTextArea="true"
                                            placeholder=" A textual narrative comprised of one or more statements describing the dataset."
                                            label="Description">
            </myTags:editNonZeroLengthString>
            <myTags:editMasterUnbounded listItems="${digitalObject.dates}"
                                        path="dates"
                                        label="Dates"
                                        tagName="date"
                                        specifier="dates">
            </myTags:editMasterUnbounded>
            <input hidden id="categoryID" name="categoryID" value="${categoryID}" type="number">
            <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next"/>
        </form>
    </div>
</div>

<script>
    $(document).ready(function () {
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