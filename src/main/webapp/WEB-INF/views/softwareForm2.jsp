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
    <myTags:softwareIndex active="softwareForm2"></myTags:softwareIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

            <fmt:message key="software.license" var="licensePlaceHolder" />
            <myTags:editNonZeroLengthString path="license" string="${digitalObject.license}"
                                            specifier="license"
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            placeholder="${licensePlaceHolder}"
                                            id="license"
                                            label="License"></myTags:editNonZeroLengthString>

            <fmt:message key="software.source" var="sourcePlaceHolder" />
            <myTags:editNonZeroLengthString path="source" string="${digitalObject.source}"
                                            specifier="source"
                                            placeholder="${sourcePlaceHolder}"
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            id="source"
                                            label="Source"></myTags:editNonZeroLengthString>

            <fmt:message key="software.website" var="websitePlaceHolder" />
            <myTags:editNonZeroLengthString path="website" string="${digitalObject.website}"
                                            specifier="website"
                                            placeholder="${websitePlaceHolder}"
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            id="website"
                                            label="Website"></myTags:editNonZeroLengthString>

            <fmt:message key="software.documentation" var="documentationPlaceHolder" />
            <myTags:editNonZeroLengthString path="documentation" string="${digitalObject.documentation}"
                                            specifier="documentation"
                                            placeholder="${documentationPlaceHolder}"
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            id="documentation"
                                            label="Documentation"></myTags:editNonZeroLengthString>

            <fmt:message key="software.developers" var="developersPlaceHolder" />
            <myTags:editMasterUnbounded label="Developers"
                                        addButtonLabel="Developer"
                                        placeholder="${developersPlaceHolder}"
                                        path="developers"
                                        specifier="developers"
                                        cardText="${developersPlaceHolder}"
                                        cardIcon="fas fa-users"
                                        isRequired="${false}"
                                        tagName="string"
                                        listItems="${digitalObject.developers}"></myTags:editMasterUnbounded>

            <fmt:message key="software.publicationsThatUsedRelease" var="publicationsThatUsedReleasePlaceHolder" />
            <myTags:editMasterUnbounded label="Publications That Used Release"
                                        addButtonLabel="Publication"
                                        placeholder="${publicationsThatUsedReleasePlaceHolder}"
                                        path="publicationsThatUsedRelease"
                                        specifier="publications-that-used-release"
                                        isRequired="${false}"
                                        cardText="${publicationsThatUsedReleasePlaceHolder}"
                                        cardIcon="fas fa-book-open"
                                        tagName="string"
                                        listItems="${digitalObject.publicationsThatUsedRelease}"></myTags:editMasterUnbounded>

            <fmt:message key="software.executables" var="executablesPlaceHolder" />
            <myTags:editMasterUnbounded label="Executables"
                                        addButtonLabel="Executable"
                                        placeholder="${executablesPlaceHolder}"
                                        path="executables" specifier="executables"
                                        isRequired="${false}"
                                        tagName="string"
                                        cardIcon="far fa-file-code"
                                        cardText="${executablesPlaceHolder}"
                                        listItems="${digitalObject.executables}"></myTags:editMasterUnbounded>

            <fmt:message key="software.version" var="versionPlaceHolder" />
            <myTags:editMasterUnbounded label="Versions"
                                        addButtonLabel="Version"
                                        placeholder="${versionPlaceHolder}"
                                        path="version" specifier="version"
                                        isRequired="${false}"
                                        tagName="string"
                                        cardIcon="fas fa-layer-group"
                                        cardText="${versionPlaceHolder}"
                                        listItems="${digitalObject.version}"></myTags:editMasterUnbounded>

            <fmt:message key="software.publicationsAboutRelease" var="publicationsAboutReleasePlaceHolder" />
            <myTags:editMasterUnbounded label="Publications About Release"
                                        addButtonLabel="Publication"
                                        placeholder="${publicationsAboutReleasePlaceHolder}"
                                        path="publicationsAboutRelease"
                                        specifier="publications-about-release"
                                        isRequired="${false}"
                                        tagName="string"
                                        cardIcon="far fa-newspaper"
                                        cardText="${publicationsAboutReleasePlaceHolder}"
                                        listItems="${digitalObject.publicationsAboutRelease}"></myTags:editMasterUnbounded>

            <fmt:message key="software.grant" var="grantPlaceHolder" />
            <myTags:editMasterUnbounded label="Grants"
                                        addButtonLabel="Grant"
                                        placeholder="${grantPlaceHolder}"
                                        path="grants" specifier="grants"
                                        isRequired="${false}"
                                        tagName="string"
                                        cardIcon="fas fa-university"
                                        cardText="${grantPlaceHolder}"
                                        listItems="${digitalObject.grants}">
            </myTags:editMasterUnbounded>

            <fmt:message key="software.locationCoverage" var="locationCoveragePlaceHolder" />
            <myTags:editMasterUnbounded label="Location Coverages"
                                        addButtonLabel="Location Coverage"
                                        placeholder="${locationCoveragePlaceHolder}"
                                        path="locationCoverage"
                                        specifier="location-coverage"
                                        tagName="softwareIdentifier"
                                        cardIcon="fas fa-globe-americas"
                                        cardText="${locationCoveragePlaceHolder}"
                                        listItems="${digitalObject.locationCoverage}">
            </myTags:editMasterUnbounded>
            <div class="row edit-form-group">
            <myTags:editCheckbox label="Available on Olympus" path="availableOnOlympus"
                                 checked="${digitalObject.availableOnOlympus}"></myTags:editCheckbox>
            <myTags:editCheckbox label="Available on UIDS" path="availableOnUIDS"
                                 checked="${digitalObject.availableOnUIDS}"></myTags:editCheckbox>
            <myTags:editCheckbox label="Sign In Required" path="signInRequired"
                                 checked="${digitalObject.signInRequired}"></myTags:editCheckbox>
            </div>
            <div class="row " id="entryFormContent-card-row"></div>

            <input hidden id="categoryID" name="categoryID" value="${categoryID}" type="number">
            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"
                   onclick="window.onbeforeunload = null;"/>
            <c:choose>
                <c:when test="${not function:onlyContainsSoftwareElements(digitalObject)}">
                    <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next"
                           onclick="window.onbeforeunload = null;"/>
                </c:when>
                <c:otherwise>
                    <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit"
                           onclick="window.onbeforeunload = null;"/>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
</div>

<script>
    $(document).ready(function () {
        rearrangeCards('entryFormContent');

    });
</script>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>