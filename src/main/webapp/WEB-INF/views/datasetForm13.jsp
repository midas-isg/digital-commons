<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>

</head>
<body>
<div class="wrapper">
    <myTags:datasetIndex active="extra"></myTags:datasetIndex>
    <div id="entryFormContent">
        <button type="button" id="sidebarCollapse"
                class="inline float-right btn btn-info btn-sm navbar-btn d-none d-sm-none d-md-block">
            <i class="glyphicon glyphicon-align-left"></i>
            <span>Toggle Sidebar</span>
        </button>
        <form method="post" id="entry-form" action="${flowExecutionUrl}">
            <myTags:editNonZeroLengthString path="version"
                                            string="${dataset.version}"
                                            specifier="version"
                                            id="version"
                                            placeholder=" A release point for the dataset when applicable."
                                            isUnboundedList="${false}"
                                            isRequired="${false}"
                                            label="Version">
            </myTags:editNonZeroLengthString>
            <myTags:editMasterUnbounded listItems="${dataset.extraProperties}"
                                        tagName="categoryValuePair"
                                        specifier="extraProperties"
                                        label="Extra Properties"
                                        path="extraProperties">
            </myTags:editMasterUnbounded>

            <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"/>
            <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit"/>
        </form>
    </div>
</div>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>