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
            <%--<myTags:editCategory selectedID="${categoryID}"--%>
                                 <%--isDisabled="${true}"--%>
                                 <%--categoryPaths="${categoryPaths}">--%>
            <%--</myTags:editCategory>--%>
                <myTags:categoryLineage lineage="${categoryName}"/>
            <myTags:editNonZeroLengthString path="product"
                                            string="${digitalObject.product}"
                                            isRequired="${false}"
                                            isUnboundedList="${false}"
                                            id="product"
                                            specifier="product"
                                            placeholder="Product Name"
                                            label="Product Name">
            </myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString label="Title"
                                            placeholder="Title"
                                            path="title"
                                            isRequired="${true}"
                                            isUnboundedList="${false}"
                                            id="title"
                                            specifier="title"
                                            string="${digitalObject.title}">
            </myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString label="Human Readable Synopsis"
                                            placeholder="Human Readable Synopsis"
                                            path="humanReadableSynopsis"
                                            isRequired="${true}"
                                            isTextArea="${true}"
                                            specifier="humanReadableSynopsis"
                                            isUnboundedList="${false}"
                                            id="humanReadableSynopsis"
                                            string="${digitalObject.humanReadableSynopsis}">
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
                                        placeholder="Data Input Format"
                                        path="dataInputFormats"
                                        specifier="dataInputFormats"
                                        isRequired="${false}"
                                        listItems="${digitalObject.dataInputFormats}"
                                        tagName="string">
            </myTags:editMasterUnbounded>
            <myTags:editMasterUnbounded label="Data Output Formats"
                                        placeholder="Data Output Format"
                                        path="dataOutputFormats"
                                        specifier="data-output-format"
                                        isRequired="${false}"
                                        tagName="string"
                                        listItems="${digitalObject.dataOutputFormats}">
            </myTags:editMasterUnbounded>
            <myTags:editNonZeroLengthString path="sourceCodeRelease"
                                            string="${digitalObject.sourceCodeRelease}"
                                            specifier="soure-code-release"
                                            placeholder="Source Code Release"
                                            isRequired="${false}"
                                            isUnboundedList="${false}"
                                            id="source-code-release"
                                            label="Source Code Release">
            </myTags:editNonZeroLengthString>
            <myTags:editMasterUnbounded label="Web Applications"
                                        placeholder="Web Application"
                                        path="webApplication"
                                        specifier="web-application"
                                        isRequired="${false}"
                                        tagName="string"
                                        listItems="${digitalObject.webApplication}">
            </myTags:editMasterUnbounded>

            <%--
                            <myTags:editCategory selectedID="${categoryID}"
                                                 categoryPaths="${categoryPaths}">
                            </myTags:editCategory>
                            <myTags:editNonZeroLengthString path="product"
                                                            string="${digitalObject.product}"
                                                            specifier="product"
                                                            placeholder="Product Name"
                                                            label="Product Name">
                            </myTags:editNonZeroLengthString>
                            <myTags:editRequiredNonZeroLengthString label="Title"
                                                                    placeholder="Title"
                                                                    path="title"
                                                                    string="${digitalObject.title}">
                            </myTags:editRequiredNonZeroLengthString>
                            <myTags:editRequiredNonZeroLengthStringTextArea label="Human Readable Synopsis"
                                                                            placeholder="Human Readable Synopsis"
                                                                            path="humanReadableSynopsis"
                                                                            string="${digitalObject.humanReadableSynopsis}">
                            </myTags:editRequiredNonZeroLengthStringTextArea>
                            <myTags:editSoftwareIdentifier identifier="${digitalObject.identifier}"
                                                           specifier="identifier"
                                                           path="identifier"
                                                           label="Identifier">
                            </myTags:editSoftwareIdentifier>
                            <myTags:editNonZeroLengthStringUnbounded label="Data Input Formats"
                                                                     placeholder="Data Input Format"
                                                                     path="dataInputFormats"
                                                                     specifier="data-input-format"
                                                                     formats="${digitalObject.dataInputFormats}">
                            </myTags:editNonZeroLengthStringUnbounded>
                            <myTags:editNonZeroLengthStringUnbounded label="Data Output Formats"
                                                                     placeholder="Data Output Format"
                                                                     path="dataOutputFormats"
                                                                     specifier="data-output-format"
                                                                     formats="${digitalObject.dataOutputFormats}">
                            </myTags:editNonZeroLengthStringUnbounded>
                            <myTags:editNonZeroLengthString path="sourceCodeRelease"
                                                            string="${digitalObject.sourceCodeRelease}"
                                                            specifier="soure-code-release"
                                                            placeholder="Source Code Release"
                                                            label="Source Code Release">
                            </myTags:editNonZeroLengthString>
                            <myTags:editNonZeroLengthStringUnbounded label="Web Applications"
                                                                     placeholder="Web Application"
                                                                     path="webApplication"
                                                                     specifier="web-application"
                                                                     formats="${digitalObject.webApplication}">
                            </myTags:editNonZeroLengthStringUnbounded>
                            <myTags:editNonZeroLengthString path="license"
                                                            string="${digitalObject.license}"
                                                            specifier="license"
                                                            placeholder="License"
                                                            label="License">
                            </myTags:editNonZeroLengthString>
                            <myTags:editNonZeroLengthString path="source"
                                                            string="${digitalObject.source}"
                                                            specifier="source"
                                                            placeholder="Source"
                                                            label="Source">
                            </myTags:editNonZeroLengthString>
                            <myTags:editNonZeroLengthStringUnbounded label="Developers"
                                                                     placeholder="Developer"
                                                                     path="developers"
                                                                     specifier="developers"
                                                                     formats="${digitalObject.developers}">
                            </myTags:editNonZeroLengthStringUnbounded>
                            <myTags:editNonZeroLengthString path="website"
                                                            string="${digitalObject.website}"
                                                            specifier="website"
                                                            placeholder="Website"
                                                            label="Website">
                            </myTags:editNonZeroLengthString>
                            <myTags:editNonZeroLengthString path="documentation"
                                                            string="${digitalObject.documentation}"
                                                            specifier="documentation"
                                                            placeholder="Documentation"
                                                            label="Documentation">
                            </myTags:editNonZeroLengthString>
                            <myTags:editNonZeroLengthStringUnbounded label="Publications That Used Release"
                                                                     placeholder="Publication That Used Release"
                                                                     path="publicationsThatUsedRelease"
                                                                     specifier="publications-that-used-release"
                                                                     formats="${digitalObject.publicationsThatUsedRelease}">
                            </myTags:editNonZeroLengthStringUnbounded>
                            <myTags:editNonZeroLengthStringUnbounded label="Executables"
                                                                     placeholder="Executable"
                                                                     path="executables"
                                                                     specifier="executables"
                                                                     formats="${digitalObject.executables}">
                            </myTags:editNonZeroLengthStringUnbounded>
                            <myTags:editNonZeroLengthStringUnbounded label="Version"
                                                                     placeholder="Version"
                                                                     path="version"
                                                                     specifier="version"
                                                                     formats="${digitalObject.version}">
                            </myTags:editNonZeroLengthStringUnbounded>
                            <myTags:editNonZeroLengthStringUnbounded label="Publications About Release"
                                                                     placeholder="Publication About Release"
                                                                     path="publicationsAboutRelease"
                                                                     specifier="publications-about-release"
                                                                     formats="${digitalObject.publicationsAboutRelease}">
                            </myTags:editNonZeroLengthStringUnbounded>
                            <myTags:editNonZeroLengthStringUnbounded label="Grant"
                                                                     placeholder="Grant"
                                                                     path="grants"
                                                                     specifier="grants"
                                                                     formats="${digitalObject.grants}">
                            </myTags:editNonZeroLengthStringUnbounded>
                            <myTags:editNestedIdentifier label="Location Coverages"
                                                         placeholder="Location Coverage"
                                                         path="locationCoverage"
                                                         specifier="location-coverage"
                                                         identifiers="${digitalObject.locationCoverage}">
                            </myTags:editNestedIdentifier>
                            <myTags:editCheckbox label="Available on Olumpus"
                                                 path="availableOnOlympus"
                                                 checked="${digitalObject.availableOnOlympus}">
                            </myTags:editCheckbox>
                            <myTags:editCheckbox label="Available on UIDS"
                                                 path="availableOnUIDS"
                                                 checked="${digitalObject.availableOnUIDS}">
                            </myTags:editCheckbox>
                            <myTags:editCheckbox label="Sign In Required"
                                                 path="signInRequired"
                                                 checked="${digitalObject.signInRequired}">
                            </myTags:editCheckbox>
            --%>
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