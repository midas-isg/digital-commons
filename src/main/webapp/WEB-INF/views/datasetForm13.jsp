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
    <myTags:datasetIndex active="extra"></myTags:datasetIndex>
    <div id="entryFormContent">

        <form method="post" id="entry-form" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <div id="version">
                <fmt:message key="dataset.version" var="versionPlaceHolder" />
                <myTags:editNonZeroLengthString path="version"
                                                string="${digitalObject.version}"
                                                specifier="version"
                                                id="version"
                                                placeholder="${versionPlaceHolder}"
                                                isUnboundedList="${false}"
                                                isRequired="${true}"
                                                isInputGroup="${true}"
                                                label="Version">
                </myTags:editNonZeroLengthString>
            </div>
            <div id="extraProperties">
                <fmt:message key="dataset.extraProperties" var="extraPropertiesPlaceHolder" />
                <myTags:editMasterUnbounded listItems="${digitalObject.extraProperties}"
                                            tagName="categoryValuePair"
                                            specifier="extraProperties"
                                            label="Extra Properties"
                                            addButtonLabel="Extra Property"
                                            cardText="${extraPropertiesPlaceHolder}"
                                            cardIcon="fas fa-plus"
                                            path="extraProperties">
                </myTags:editMasterUnbounded>
            </div>
            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"
                   onclick="window.onbeforeunload = null;"/>
            <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit"
                   onclick="window.onbeforeunload = null;"/>
        </form>
    </div>
</div>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>