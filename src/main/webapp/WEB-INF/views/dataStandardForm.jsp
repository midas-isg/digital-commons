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
    <myTags:dataStandardIndex active="basic"></myTags:dataStandardIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}" wantLoader="${true}"></myTags:wizardHeader>

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
                                            isRequired="${true}"
                                            placeholder="Description">
            </myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString label="Version"
                                            placeholder=" Version"
                                            specifier="version"
                                            id="version"
                                            string="${digitalObject.version}"
                                            isUnboundedList="${false}"
                                            isRequired="${true}"
                                            isInputGroup="${true}"
                                            path="version">
            </myTags:editNonZeroLengthString>

            <fmt:message key="dataStandard.type" var="typePlaceHolder" />
            <myTags:editAnnotation annotation="${digitalObject.type}"
                                   isRequired="${true}"
                                   path="type"
                                   specifier="type"
                                   id="type"
                                   cardText="${typePlaceHolder}"
                                   isUnboundedList="${false}"
                                   label="Type">
            </myTags:editAnnotation>

            <myTags:editIdentifier singleIdentifier="${digitalObject.identifier}"
                                   label="Identifier"
                                   isRequired="${true}"
                                   specifier="identifier"
                                   id="identifier"
                                   isUnboundedList="${false}"
                                   path="identifier">
            </myTags:editIdentifier>

            <fmt:message key="dataset.alternateIdentifier" var="alternateIdentifierPlaceHolder" />
            <myTags:editMasterUnbounded specifier="alternateIdentifiers"
                                        label="Alternate Identifiers"
                                        addButtonLabel="Alternate Identifier"
                                        path="alternateIdentifiers"
                                        listItems="${digitalObject.alternateIdentifiers}"
                                        cardIcon="fa fa-id-card"
                                        cardText="${alternateIdentifierPlaceHolder}"
                                        isRequired="${false}"
                                        tagName="identifier">
            </myTags:editMasterUnbounded>

            <fmt:message key="dataStandard.license" var="licensePlaceHolder" />
            <myTags:editMasterUnbounded listItems="${digitalObject.licenses}"
                                        tagName="license"
                                        specifier="licenses"
                                        isRequired="${false}"
                                        label="Licenses"
                                        cardIcon="fab fa-creative-commons"
                                        addButtonLabel="License"
                                        cardText="${licensePlaceHolder}"
                                        path="licenses">
            </myTags:editMasterUnbounded>

            <fmt:message key="dataStandard.extraProperties" var="extraPropertiesPlaceHolder" />
            <myTags:editMasterUnbounded listItems="${digitalObject.extraProperties}"
                                        tagName="categoryValuePair"
                                        isRequired="${false}"
                                        specifier="extraProperties"
                                        cardText="${extraPropertiesPlaceHolder}"
                                        cardIcon="fas fa-plus"
                                        path="extraProperties"
                                        addButtonLabel="Extra Property"
                                        label="Extra Properties">
            </myTags:editMasterUnbounded>

            <div class="row " id="entryFormContent-card-row"></div>

            <input hidden id="categoryID" name="categoryID" value="${categoryID}" type="number">
            <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit" onclick="window.onbeforeunload = null;"/>
        </form>
    </div>
</div>

<script>
    $(document).ready(function () {
        toggleLoadingScreen();

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