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
        <button type="button" id="sidebarCollapse"
                class="inline float-right btn btn-info btn-sm navbar-btn d-none d-sm-none d-md-block">
            <i class="glyphicon glyphicon-align-left"></i>
            <span>Toggle Sidebar</span>
        </button>
        <form id="entry-form" method="post" action="${flowExecutionUrl}">
            <myTags:editNonZeroLengthString path="license" string="${software.license}"
                                            specifier="license" placeholder="License"
                                            isRequired="${false}"
                                            isUnboundedList="${false}"
                                            id="license"
                                            label="License"></myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString path="source" string="${software.source}"
                                            specifier="source" placeholder="Source"
                                            isRequired="${false}"
                                            isUnboundedList="${false}"
                                            id="source"
                                            label="Source"></myTags:editNonZeroLengthString>
            <myTags:editMasterUnbounded label="Developers" placeholder="Developer"
                                        path="developers" specifier="developers"
                                        isRequired="${false}"
                                        tagName="string"
                                        listItems="${software.developers}"></myTags:editMasterUnbounded>
            <myTags:editNonZeroLengthString path="website" string="${software.website}"
                                            specifier="website" placeholder="Website"
                                            isRequired="${false}"
                                            isUnboundedList="${false}"
                                            id="website"
                                            label="Website"></myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString path="documentation" string="${software.documentation}"
                                            specifier="documentation" placeholder="Documentation"
                                            isRequired="${false}"
                                            isUnboundedList="${false}"
                                            id="documentation"
                                            label="Documentation"></myTags:editNonZeroLengthString>
            <myTags:editMasterUnbounded label="Publications That Used Release"
                                        placeholder="Publication That Used Release"
                                        path="publicationsThatUsedRelease"
                                        specifier="publications-that-used-release"
                                        isRequired="${false}"
                                        tagName="string"
                                        listItems="${software.publicationsThatUsedRelease}"></myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded label="Executables" placeholder="Executable"
                                        path="executables" specifier="executables"
                                        isRequired="${false}"
                                        tagName="string"
                                        listItems="${software.executables}"></myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded label="Version" placeholder="Version"
                                        path="version" specifier="version"
                                        isRequired="${false}"
                                        tagName="string"
                                        listItems="${software.version}"></myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded label="Publications About Release"
                                        placeholder="Publication About Release"
                                        path="publicationsAboutRelease"
                                        specifier="publications-about-release"
                                        isRequired="${false}"
                                        tagName="string"
                                        listItems="${software.publicationsAboutRelease}"></myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded label="Grant" placeholder="Grant"
                                        path="grants" specifier="grants"
                                        isRequired="${false}"
                                        tagName="string"
                                        listItems="${software.grants}">
            </myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded label="Location Coverages"
                                        placeholder="Location Coverage"
                                        path="locationCoverage"
                                        specifier="location-coverage"
                                        tagName="softwareIdentifier"
                                        listItems="${software.locationCoverage}">
            </myTags:editMasterUnbounded>
            <%--
            <myTags:editNestedIdentifier label="Location Coverages" placeholder="Location Coverage"
                                         path="locationCoverage" specifier="location-coverage"
                                         identifiers="${software.locationCoverage}"></myTags:editNestedIdentifier>
            --%>
            <myTags:editCheckbox label="Available on Olympus" path="availableOnOlympus"></myTags:editCheckbox>
            <myTags:editCheckbox label="Available on UIDS" path="availableOnUIDS"></myTags:editCheckbox>
            <myTags:editCheckbox label="Sign In Required" path="signInRequired"></myTags:editCheckbox>

            <input hidden id="categoryID" name="categoryID" value="${categoryID}" type="number">
            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"/>
            <c:choose>
                <c:when test="${not function:onlyContainsSoftwareElements(software)}">
                    <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next"/>
                </c:when>
                <c:otherwise>
                    <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit"/>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
</div>


<myTags:analytics/>

</body>

<myTags:footer/>

</html>