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
            <form method="post" action="${flowExecutionUrl}">
                <div class="form-group edit-form-group">
                    <label>Dataset</label>
                    <myTags:editCategory selectedID="${categoryID}"
                                         categoryPaths="${categoryPaths}"></myTags:editCategory>
                    <myTags:editRequiredNonZeroLengthString label="Title" placeholder="Title" path="title"
                                                            string="${dataset.title}"></myTags:editRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString path="description" string="${dataset.description}"
                                                               specifier="description" placeholder="Description"
                                                               label="Description"></myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editIdentifier identifier="${dataset.identifier}" specifier="identifier" path="identifier"
                                           label="Identifier"></myTags:editIdentifier>

                </div>
                <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next"/>
            </form>
        </div>
    </div>
</div>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>