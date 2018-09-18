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
                                            specifier="license"
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            placeholder="A copyright license that is about the software and contains one or more conditional specifications that specify the use and redistribution of the software."
                                            cardText="A copyright license that is about the software and contains one or more conditional specifications that specify the use and redistribution of the software."
                                            id="license"
                                            label="License"></myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString path="source" string="${digitalObject.source}"
                                            specifier="source"
                                            placeholder="Where something is available or from where it originates."
                                            cardText="Where something is available or from where it originates."
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            id="source"
                                            label="Source"></myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString path="website" string="${digitalObject.website}"
                                            specifier="website"
                                            placeholder="A set of related web pages containing content such as text, images, video, audio, etc., prepared and maintained as a collection of information on the software."
                                            cardText="A set of related web pages containing content such as text, images, video, audio, etc., prepared and maintained as a collection of information on the software."
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            id="website"
                                            label="Website"></myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString path="documentation" string="${digitalObject.documentation}"
                                            specifier="documentation"
                                            placeholder="Material that provides official information or evidence or that serves as a record for the software."
                                            cardText="Material that provides official information or evidence or that serves as a record for the software."
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            isInputGroup="${true}"
                                            id="documentation"
                                            label="Documentation"></myTags:editNonZeroLengthString>
            <myTags:editMasterUnbounded label="Developers"
                                        addButtonLabel="Developer"
                                        placeholder="The person or organisation that developed and maintains the software."
                                        path="developers"
                                        specifier="developers"
                                        cardText="The person or organisation that developed and maintains the software."
                                        isRequired="${false}"
                                        tagName="string"
                                        listItems="${digitalObject.developers}"></myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded label="Publications That Used Release"
                                        addButtonLabel="Publication That Used Release"
                                        placeholder="Article, paper, journal or other work employing the release of the software."
                                        path="publicationsThatUsedRelease"
                                        specifier="publications-that-used-release"
                                        isRequired="${false}"
                                        cardText="Article, paper, journal or other work employing the release of the software."
                                        tagName="string"
                                        listItems="${digitalObject.publicationsThatUsedRelease}"></myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded label="Executables"
                                        addButtonLabel="Executable"
                                        placeholder="File or program able to run the software."
                                        path="executables" specifier="executables"
                                        isRequired="${false}"
                                        tagName="string"
                                        cardText="File or program able to run the software."
                                        listItems="${digitalObject.executables}"></myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded label="Versions"
                                        addButtonLabel="Version"
                                        placeholder="A version is an information content entity which is a sequence of characters borne by part of each of a class of manufactured products or its packaging and indicates its order within a set of other products having the same name."
                                        path="version" specifier="version"
                                        isRequired="${false}"
                                        tagName="string"
                                        cardText="A version is an information content entity which is a sequence of characters borne by part of each of a class of manufactured products or its packaging and indicates its order within a set of other products having the same name."
                                        listItems="${digitalObject.version}"></myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded label="Publications About Release"
                                        addButtonLabel="Publication About Release"
                                        placeholder="Article, paper, journal or other work referencing the release of the software."
                                        path="publicationsAboutRelease"
                                        specifier="publications-about-release"
                                        isRequired="${false}"
                                        tagName="string"
                                        cardText="Article, paper, journal or other work referencing the release of the software."
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
                                        placeholder="An information content entity that specifies a geographical region coveredby the software."
                                        path="locationCoverage"
                                        specifier="location-coverage"
                                        tagName="softwareIdentifier"
                                        cardText="An information content entity that specifies a geographical region coveredby the software."
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