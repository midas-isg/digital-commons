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

    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>

</head>
<body>
<div class="wrapper">
    <myTags:dataStandardIndex active="basic"></myTags:dataStandardIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <myTags:editIdentifier singleIdentifier="${digitalObject.identifier}"
                                   label="Identifier"
                                   specifier="identifier"
                                   id="identifier"
                                   isUnboundedList="${false}"
                                   path="identifier">
            </myTags:editIdentifier>
            <myTags:editMasterUnbounded specifier="alternateIdentifiers"
                                        label="Alternate Identifiers"
                                        path="alternateIdentifiers"
                                        listItems="${digitalObject.alternateIdentifiers}"
                                        isRequired="${false}"
                                        isInputGroup="${true}"
                                        tagName="identifier">
            </myTags:editMasterUnbounded>
            <myTags:editNonZeroLengthString placeholder=" Name"
                                            label="Name"
                                            string="${digitalObject.name}"
                                            specifier="name"
                                            id="name"
                                            isRequired="${true}"
                                            isInputGroup="${true}"
                                            isUnboundedList="${false}"
                                            path="name">
            </myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString specifier="description"
                                            id="description"
                                            string="${digitalObject.description}"
                                            path="description"
                                            label="Description"
                                            isTextArea="${true}"
                                            isInputGroup="${true}"
                                            isRequired="${false}"
                                            placeholder="Description">
            </myTags:editNonZeroLengthString>
            <myTags:editAnnotation annotation="${digitalObject.type}"
                                   isRequired="${true}"
                                   path="type"
                                   specifier="type"
                                   id="type"
                                   cardText="Some quick example text to build on the card title and make up the bulk of the card's content."
                                   isUnboundedList="${false}"
                                   label="Type">
            </myTags:editAnnotation>
            <myTags:editMasterUnbounded listItems="${digitalObject.licenses}"
                                        tagName="license"
                                        specifier="licenses"
                                        isRequired="${false}"
                                        label="License"
                                        cardText="Some quick example text to build on the card title and make up the bulk of the card's content."
                                        path="licenses">
            </myTags:editMasterUnbounded>
            <myTags:editNonZeroLengthString label="Version"
                                            placeholder=" Version"
                                            specifier="version"
                                            id="version"
                                            string="${digitalObject.version}"
                                            isUnboundedList="${false}"
                                            isRequired="${false}"
                                            path="version">
            </myTags:editNonZeroLengthString>
            <myTags:editMasterUnbounded listItems="${digitalObject.extraProperties}"
                                        tagName="categoryValuePair"
                                        isRequired="${false}"
                                        specifier="extraProperties"
                                        cardText="Some quick example text to build on the card title and make up the bulk of the card's content."
                                        path="extraProperties"
                                        label="Extra Properties">
            </myTags:editMasterUnbounded>


            <input hidden id="categoryID" name="categoryID" value="${categoryID}" type="number">
            <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit" onclick="window.onbeforeunload = null;"/>
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