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
<div class="container">
    <div class="row">
        <div class="col-xs-12">
<%--
            <myTags:datasetIndex active="basic"></myTags:datasetIndex>
--%>

            <form id="entry-form" method="post" action="${flowExecutionUrl}">
                <myTags:editCategory selectedID="${categoryID}"
                                     categoryPaths="${categoryPaths}">
                </myTags:editCategory>
                <myTags:editNonZeroLengthString path="product"
                                                string="${software.product}"
                                                specifier="product"
                                                placeholder="Product Name"
                                                label="Product Name">
                </myTags:editNonZeroLengthString>
                <myTags:editRequiredNonZeroLengthString label="Title"
                                                        placeholder="Title"
                                                        path="title"
                                                        string="${software.title}">
                </myTags:editRequiredNonZeroLengthString>
                <myTags:editRequiredNonZeroLengthStringTextArea label="Human Readable Synopsis"
                                                                placeholder="Human Readable Synopsis"
                                                                path="humanReadableSynopsis"
                                                                string="${software.humanReadableSynopsis}">
                </myTags:editRequiredNonZeroLengthStringTextArea>
                <myTags:editSoftwareIdentifier identifier="${software.identifier}"
                                               specifier="identifier"
                                               path="identifier"
                                               label="Identifier">
                </myTags:editSoftwareIdentifier>
                <myTags:editNonZeroLengthStringUnbounded label="Data Input Formats"
                                                         placeholder="Data Input Format"
                                                         path="dataInputFormats"
                                                         specifier="data-input-format"
                                                         formats="${software.dataInputFormats}">
                </myTags:editNonZeroLengthStringUnbounded>
                <myTags:editNonZeroLengthStringUnbounded label="Data Output Formats"
                                                         placeholder="Data Output Format"
                                                         path="dataOutputFormats"
                                                         specifier="data-output-format"
                                                         formats="${software.dataOutputFormats}">
                </myTags:editNonZeroLengthStringUnbounded>
                <myTags:editNonZeroLengthString path="sourceCodeRelease"
                                                string="${software.sourceCodeRelease}"
                                                specifier="soure-code-release"
                                                placeholder="Source Code Release"
                                                label="Source Code Release">
                </myTags:editNonZeroLengthString>
                <myTags:editNonZeroLengthStringUnbounded label="Web Applications"
                                                         placeholder="Web Application"
                                                         path="webApplication"
                                                         specifier="web-application"
                                                         formats="${software.webApplication}">
                </myTags:editNonZeroLengthStringUnbounded>
                <myTags:editNonZeroLengthString path="license"
                                                string="${software.license}"
                                                specifier="license"
                                                placeholder="License"
                                                label="License">
                </myTags:editNonZeroLengthString>
                <myTags:editNonZeroLengthString path="source"
                                                string="${software.source}"
                                                specifier="source"
                                                placeholder="Source"
                                                label="Source">
                </myTags:editNonZeroLengthString>
                <myTags:editNonZeroLengthStringUnbounded label="Developers"
                                                         placeholder="Developer"
                                                         path="developers"
                                                         specifier="developers"
                                                         formats="${software.developers}">
                </myTags:editNonZeroLengthStringUnbounded>
                <myTags:editNonZeroLengthString path="website"
                                                string="${software.website}"
                                                specifier="website"
                                                placeholder="Website"
                                                label="Website">
                </myTags:editNonZeroLengthString>
                <myTags:editNonZeroLengthString path="documentation"
                                                string="${software.documentation}"
                                                specifier="documentation"
                                                placeholder="Documentation"
                                                label="Documentation">
                </myTags:editNonZeroLengthString>
                <myTags:editNonZeroLengthStringUnbounded label="Publications That Used Release"
                                                         placeholder="Publication That Used Release"
                                                         path="publicationsThatUsedRelease"
                                                         specifier="publications-that-used-release"
                                                         formats="${software.publicationsThatUsedRelease}">
                </myTags:editNonZeroLengthStringUnbounded>
                <myTags:editNonZeroLengthStringUnbounded label="Executables"
                                                         placeholder="Executable"
                                                         path="executables"
                                                         specifier="executables"
                                                         formats="${software.executables}">
                </myTags:editNonZeroLengthStringUnbounded>
                <myTags:editNonZeroLengthStringUnbounded label="Version"
                                                         placeholder="Version"
                                                         path="version"
                                                         specifier="version"
                                                         formats="${software.version}">
                </myTags:editNonZeroLengthStringUnbounded>
                <myTags:editNonZeroLengthStringUnbounded label="Publications About Release"
                                                         placeholder="Publication About Release"
                                                         path="publicationsAboutRelease"
                                                         specifier="publications-about-release"
                                                         formats="${software.publicationsAboutRelease}">
                </myTags:editNonZeroLengthStringUnbounded>
                <myTags:editNonZeroLengthStringUnbounded label="Grant"
                                                         placeholder="Grant"
                                                         path="grants"
                                                         specifier="grants"
                                                         formats="${software.grants}">
                </myTags:editNonZeroLengthStringUnbounded>
                <myTags:editNestedIdentifier label="Location Coverages"
                                             placeholder="Location Coverage"
                                             path="locationCoverage"
                                             specifier="location-coverage"
                                             identifiers="${software.locationCoverage}">
                </myTags:editNestedIdentifier>
                <myTags:editCheckbox label="Available on Olumpus"
                                     path="availableOnOlympus"
                                     checked="${software.availableOnOlympus}">
                </myTags:editCheckbox>
                <myTags:editCheckbox label="Available on UIDS"
                                     path="availableOnUIDS"
                                     checked="${software.availableOnUIDS}">
                </myTags:editCheckbox>
                <myTags:editCheckbox label="Sign In Required"
                                     path="signInRequired"
                                     checked="${software.signInRequired}">
                </myTags:editCheckbox>
                <input hidden id="categoryID" name="categoryID" value="${categoryID}" type="number">
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
</div>

<script>
    $(document).ready(function () {
        $("#categoryValue").change(function() {
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