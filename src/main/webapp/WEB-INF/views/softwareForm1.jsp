<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
    <%@ taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>

</head>
<body>
<div class="wrapper">
    <myTags:softwareIndex active="softwareForm1"></myTags:softwareIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

                    <myTags:editNonZeroLengthString label="Title"
                                                    placeholder="Title"
                                                    path="title"
                                                    isRequired="${true}"
                                                    isUnboundedList="${false}"
                                                    isInputGroup="${true}"
                                                    id="title"
                                                    specifier="title"
                                                    string="${digitalObject.title}">
                    </myTags:editNonZeroLengthString>
                    <myTags:editNonZeroLengthString label="Human Readable Synopsis"
                                                    placeholder="Human Readable Synopsis"
                                                    path="humanReadableSynopsis"
                                                    isRequired="${true}"
                                                    isTextArea="${true}"
                                                    isInputGroup="${true}"
                                                    specifier="humanReadableSynopsis"
                                                    isUnboundedList="${false}"
                                                    id="humanReadableSynopsis"
                                                    string="${digitalObject.humanReadableSynopsis}">
                    </myTags:editNonZeroLengthString>
                <myTags:editNonZeroLengthString path="product"
                                                string="${digitalObject.product}"
                                                isRequired="${false}"
                                                isUnboundedList="${false}"
                                                isInputGroup="${true}"
                                                id="product"
                                                specifier="product"
                                                placeholder="Product Name"
                                                label="Product Name">
                </myTags:editNonZeroLengthString>
                <myTags:editSoftwareIdentifier identifier="${digitalObject.identifier}"
                                               specifier="identifier"
                                               path="identifier"
                                               isUnboundedList="${false}"
                                               tagName="identifier"
                                               id="identifier"
                                               label="Identifier">
                </myTags:editSoftwareIdentifier>
                <myTags:editMasterUnbounded label="Data Input Formats"
                                            addButtonLabel="Data Input Format"
                                            placeholder="Data Input Format"
                                            path="dataInputFormats"
                                            specifier="dataInputFormats"
                                            isRequired="${false}"
                                            cardText="The entities used as input."
                                            listItems="${digitalObject.dataInputFormats}"
                                            tagName="string">
                </myTags:editMasterUnbounded>
                <myTags:editMasterUnbounded label="Data Output Formats"
                                            addButtonLabel="Data Output Format"
                                            placeholder="Data Output Format"
                                            path="dataOutputFormats"
                                            specifier="data-output-format"
                                            isRequired="${false}"
                                            tagName="string"
                                            cardText="The entities resulting from applying the activity."
                                            listItems="${digitalObject.dataOutputFormats}">
                </myTags:editMasterUnbounded>
                <myTags:editNonZeroLengthString path="sourceCodeRelease"
                                                string="${digitalObject.sourceCodeRelease}"
                                                specifier="soure-code-release"
                                                placeholder="Source Code Release"
                                                isRequired="${false}"
                                                isUnboundedList="${false}"
                                                isInputGroup="${true}"
                                                id="source-code-release"
                                                label="Source Code Release">
                </myTags:editNonZeroLengthString>
                <myTags:editMasterUnbounded label="Web Applications"
                                            addButtonLabel="Web Application"
                                            placeholder="Web Application"
                                            path="webApplication"
                                            specifier="web-application"
                                            isRequired="${false}"
                                            cardText="Web applications associated with the entity."
                                            tagName="string"
                                            listItems="${digitalObject.webApplication}">
                </myTags:editMasterUnbounded>


            <div class="row " id="entryFormContent-card-row"></div>

            <input hidden id="categoryID" name="categoryID" value="${categoryID}" type="number">
            <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next"
                   onclick="window.onbeforeunload = null;"/>
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