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
    <myTags:softwareIndex active="softwareForm2"></myTags:softwareIndex>
    <div id="entryFormContent">

        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:wizardHeader showCategories="${false}"></myTags:wizardHeader>

                <myTags:editNonZeroLengthString path="license" string="${digitalObject.license}"
                                                specifier="license" placeholder="License"
                                                isRequired="${false}"
                                                isUnboundedList="${false}"
                                                isInputGroup="${true}"
                                                cardText="The terms of use of the software."
                                                id="license"
                                                label="License"></myTags:editNonZeroLengthString>
                <myTags:editNonZeroLengthString path="source" string="${digitalObject.source}"
                                                specifier="source" placeholder="Source"
                                                isRequired="${false}"
                                                isUnboundedList="${false}"
                                                isInputGroup="${true}"
                                                id="source"
                                                label="Source"></myTags:editNonZeroLengthString>
                <myTags:editMasterUnbounded label="Developers"
                                            addButtonLabel="Developer"
                                            placeholder="Developer"
                                            path="developers"
                                            specifier="developers"
                                            cardText="The person or organisation that developed the software."
                                            isRequired="${false}"
                                            tagName="string"
                                            listItems="${digitalObject.developers}"></myTags:editMasterUnbounded>
                <myTags:editNonZeroLengthString path="website" string="${digitalObject.website}"
                                                specifier="website" placeholder="Website"
                                                isRequired="${false}"
                                                isUnboundedList="${false}"
                                                isInputGroup="${true}"
                                                id="website"
                                                label="Website"></myTags:editNonZeroLengthString>
                <myTags:editNonZeroLengthString path="documentation" string="${digitalObject.documentation}"
                                                specifier="documentation" placeholder="Documentation"
                                                isRequired="${false}"
                                                isUnboundedList="${false}"
                                                isInputGroup="${true}"
                                                id="documentation"
                                                label="Documentation"></myTags:editNonZeroLengthString>
                <myTags:editMasterUnbounded label="Publications That Used Release"
                                            addButtonLabel="Publication That Used Relase"
                                            placeholder="Publication That Used Release"
                                            path="publicationsThatUsedRelease"
                                            specifier="publications-that-used-release"
                                            isRequired="${false}"
                                            cardText="Some quick example text to build on the card title and make up the bulk of the card's content."
                                            tagName="string"
                                            listItems="${digitalObject.publicationsThatUsedRelease}"></myTags:editMasterUnbounded>
                <myTags:editMasterUnbounded label="Executables"
                                            addButtonLabel="Executable"
                                            placeholder="Executable"
                                            path="executables" specifier="executables"
                                            isRequired="${false}"
                                            tagName="string"
                                            cardText="Some quick example text to build on the card title and make up the bulk of the card's content."
                                            listItems="${digitalObject.executables}"></myTags:editMasterUnbounded>
                <myTags:editMasterUnbounded label="Versions"
                                            addButtonLabel="Version"
                                            placeholder="Version"
                                            path="version" specifier="version"
                                            isRequired="${false}"
                                            tagName="string"
                                            cardText="Some quick example text to build on the card title and make up the bulk of the card's content."
                                            listItems="${digitalObject.version}"></myTags:editMasterUnbounded>
                <myTags:editMasterUnbounded label="Publications About Release"
                                            addButtonLabel="Publication About Release"
                                            placeholder="Publication About Release"
                                            path="publicationsAboutRelease"
                                            specifier="publications-about-release"
                                            isRequired="${false}"
                                            tagName="string"
                                            cardText="Some quick example text to build on the card title and make up the bulk of the card's content."
                                            listItems="${digitalObject.publicationsAboutRelease}"></myTags:editMasterUnbounded>
                <myTags:editMasterUnbounded label="Grants"
                                            addButtonLabel="Grant"
                                            placeholder="Grant"
                                            path="grants" specifier="grants"
                                            isRequired="${false}"
                                            tagName="string"
                                            cardText="An allocated sum of funds given by a government or other organization for a particular purpose."
                                            listItems="${digitalObject.grants}">
                </myTags:editMasterUnbounded>
                <myTags:editMasterUnbounded label="Location Coverages"
                                            addButtonLabel="Location Coverage"
                                            placeholder="Location Coverage"
                                            path="locationCoverage"
                                            specifier="location-coverage"
                                            tagName="softwareIdentifier"
                                            cardText="Some quick example text to build on the card title and make up the bulk of the card's content."
                                            listItems="${digitalObject.locationCoverage}">
                </myTags:editMasterUnbounded>
                <myTags:editCheckbox label="Available on Olympus" path="availableOnOlympus" checked="${digitalObject.availableOnOlympus}"></myTags:editCheckbox>
                <myTags:editCheckbox label="Available on UIDS" path="availableOnUIDS" checked="${digitalObject.availableOnUIDS}"></myTags:editCheckbox>
                <myTags:editCheckbox label="Sign In Required" path="signInRequired" checked="${digitalObject.signInRequired}"></myTags:editCheckbox>

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