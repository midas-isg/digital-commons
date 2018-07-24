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
            <myTags:datasetIndex active="storedIn"></myTags:datasetIndex>

            <form method="post" action="${flowExecutionUrl}">
                    <myTags:editDataRepository name="Stored In"
                                               path="storedIn"
                                               dataRepository="${dataset.storedIn}"
                                               specifier="storedIn">
                    </myTags:editDataRepository>

                        <%--<input type="text" class="form-control" name="spatialCoverage[0].alternateIdentifiers[0].identifier" value="1" placeholder=" A code uniquely identifying an entity locally to a system or globally.">--%>
                        <%--<input type="text" class="form-control" name="spatialCoverage[1].alternateIdentifiers[0].identifier" value="2" placeholder=" A code uniquely identifying an entity locally to a system or globally.">--%>

                        <%--<input type="text" class="form-control" value="alt id 0" name="storedIn.alternateIdentifiers[0].identifier" placeholder=" A code uniquely identifying an entity locally to a system or globally.">--%>
                        <%--<input type="text" class="form-control" value="alt id source 0" name="storedIn.alternateIdentifiers[0].identifierSource" placeholder=" A code uniquely identifying an entity locally to a system or globally.">--%>

                        <%--<input type="text" class="form-control" value="11111" name="storedIn.alternateIdentifiers[1].identifier" placeholder=" A code uniquely identifying an entity locally to a system or globally.">--%>
                        <%--<input type="text" class="form-control" value="11111" name="storedIn.alternateIdentifiers[1].identifierSource" placeholder=" A code uniquely identifying an entity locally to a system or globally.">--%>

                        <%--<input type="text" class="form-control" value="22222" name="storedIn.alternateIdentifiers[2].identifier" placeholder=" A code uniquely identifying an entity locally to a system or globally.">--%>
                        <%--<input type="text" class="form-control" value="22222" name="storedIn.alternateIdentifiers[2].identifierSource" placeholder=" A code uniquely identifying an entity locally to a system or globally.">--%>
                <input type="submit" name="_eventId_previous" class="btn btn-default" value="Previous"/>
                <input type="submit" name="_eventId_next" class="btn btn-default pull-right" value="Next"/>

            </form>
        </div>
    </div>
</div>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>