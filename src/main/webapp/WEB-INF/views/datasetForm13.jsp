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
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-xs-12">
            <myTags:datasetIndex active="extra"></myTags:datasetIndex>

            <form method="post" id="entry-form" action="${flowExecutionUrl}">
                    <myTags:editNonRequiredNonZeroLengthString path="version"
                                                               string="${dataset.version}"
                                                               specifier="version"
                                                               placeholder=" A release point for the dataset when applicable."
                                                               label="Version">
                    </myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editCategoryValuePair categoryValuePairs="${dataset.extraProperties}"
                                                  specifier="extraProperties"
                                                  label="Extra Properties"
                                                  path="extraProperties">
                    </myTags:editCategoryValuePair>
                <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"/>
                <input type="submit" name="_eventId_submit" class="btn btn-default pull-right" value="Submit"/>
            </form>
        </div>
    </div>
</div>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>