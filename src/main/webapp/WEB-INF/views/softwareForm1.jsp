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
    <fmt:setBundle basename="cardText" />

    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>

</head>
<body>
<div class="wrapper">
    <myTags:softwareIndex active="softwareForm1"></myTags:softwareIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <label class="bold">${copyMessage}</label>
            <fmt:message key="software.title" var="titlePlaceHolder" />
            <myTags:editNonZeroLengthString label="Title"
                                            placeholder="${titlePlaceHolder}"
                                            path="title"
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            id="title"
                                            specifier="title"
                                            string="${digitalObject.title}">
            </myTags:editNonZeroLengthString>

            <fmt:message key="software.humanReadableSynopsis" var="humanReadableSynopsisPlaceHolder" />
            <myTags:editNonZeroLengthString label="Human Readable Synopsis"
                                            placeholder="${humanReadableSynopsisPlaceHolder}"
                                            path="humanReadableSynopsis"
                                            isRequired="${true}"
                                            isTextArea="${true}"
                                            isInputGroup="${true}"
                                            specifier="humanReadableSynopsis"
                                            isUnboundedList="${false}"
                                            id="humanReadableSynopsis"
                                            string="${digitalObject.humanReadableSynopsis}">
            </myTags:editNonZeroLengthString>

            <fmt:message key="software.product" var="productPlaceHolder" />
            <myTags:editNonZeroLengthString path="product"
                                            string="${digitalObject.product}"
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            id="product"
                                            specifier="product"
                                            placeholder="${productPlaceHolder}"
                                            label="Product Name">
            </myTags:editNonZeroLengthString>

            <fmt:message key="software.sourceCodeRelease" var="sourceCodeReleasePlaceHolder" />
            <myTags:editNonZeroLengthString path="sourceCodeRelease"
                                            string="${digitalObject.sourceCodeRelease}"
                                            specifier="soure-code-release"
                                            placeholder="${sourceCodeReleasePlaceHolder}"
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            id="source-code-release"
                                            label="Source Code Release">
            </myTags:editNonZeroLengthString>
            <myTags:editSoftwareIdentifier identifier="${digitalObject.identifier}"
                                           specifier="identifier"
                                           path="identifier"
                                           isUnboundedList="${false}"
                                           tagName="identifier"
                                           id="identifier"
                                           label="Identifier">
            </myTags:editSoftwareIdentifier>

            <fmt:message key="software.dataInputFormats" var="dataInputFormatsPlaceHolder" />
            <myTags:editDataInputsWrapper path="inputs"
                                          specifier="inputs"
                                          label="Input Information"
                                          id="inputs"
                                          tagName="dataInputsWrapper"
                                          digitalObject="${digitalObject}"
                                          isUnboundedList="${false}">
            </myTags:editDataInputsWrapper>

            <fmt:message key="software.dataOutputFormats" var="dataOutputFormatsPlaceHolder" />
            <myTags:editDataOutputsWrapper path="outputs"
                                          specifier="outputs"
                                          label="Output Information"
                                          id="outputs"
                                          tagName="dataOutputsWrapper"
                                          digitalObject="${digitalObject}"
                                          isUnboundedList="${false}">
            </myTags:editDataOutputsWrapper>

            <fmt:message key="software.webApplication" var="webApplicationPlaceHolder" />
            <myTags:editMasterUnbounded label="Web Applications"
                                        addButtonLabel="Web Application"
                                        placeholder="${webApplicationPlaceHolder}"
                                        path="webApplication"
                                        specifier="web-application"
                                        isRequired="${false}"
                                        cardIcon="fas fa-globe"
                                        cardText="${webApplicationPlaceHolder}"
                                        tagName="string"
                                        listItems="${digitalObject.webApplication}">
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