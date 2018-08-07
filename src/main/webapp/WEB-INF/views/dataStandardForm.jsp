<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-12">
            <form:form id="entry-form" action="${pageContext.request.contextPath}/addDataStandard/${categoryID}?entryId=${entryId}&revisionId=${revisionId}"
                       modelAttribute="dataStandard">
                <div class="form-group edit-form-group">
                    <label>Data Format</label>
                    <myTags:editCategory selectedID="${categoryID}"
                                         categoryPaths="${categoryPaths}"></myTags:editCategory>
                    <spring:bind path="identifier">
                        <myTags:editIdentifier identifier="${dataStandard.identifier}" specifier="identifier"
                                               path="identifier" label="Identifier"></myTags:editIdentifier>
                        <form:errors path="identifier" class="error-color"/>
                    </spring:bind>

                    <myTags:editRequiredNonZeroLengthString placeholder="Name" label="Name" path="name"
                                                            string="${dataStandard.name}"></myTags:editRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString label="Description" placeholder="Description"
                                                               string="${dataStandard.description}" path="description"
                                                               specifier="description"></myTags:editNonRequiredNonZeroLengthString>

                    <spring:bind path="type">
                    <div class="form-group edit-form-group ${status.error ? 'has-error' : ''}">
                        <label>Type</label>
                        <myTags:editAnnotation path="type" annotation="${dataStandard.type}" specifier="type" label="Type" showRemoveButton="false"></myTags:editAnnotation>
                        <form:errors path="type" class="error-color"/>
                    </div>
                    </spring:bind>
                    <myTags:editLicense specifier="licenses" path="licenses" label="License"
                                        licenses="${dataStandard.licenses}">
                    </myTags:editLicense>
                    <myTags:editNonRequiredNonZeroLengthString label="Version" placeholder="Version" path="version"
                                                               specifier="version"
                                                               string="${dataStandard.version}"></myTags:editNonRequiredNonZeroLengthString>

                    <myTags:editCategoryValuePair categoryValuePairs="${dataStandard.extraProperties}"
                                                  specifier="extraProperties" label="Extra Properties"
                                                  path="extraProperties">
                    </myTags:editCategoryValuePair>


                </div>
                <button type="submit" class="btn btn-default pull-right">Submit</button>

            </form:form>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        $("#categoryValue").change(function() {
            var action = $(this).val()
            $("#entry-form").attr("action", "${pageContext.request.contextPath}/addDataStandard/" + action + "?entryId=${entryId}&revisionId=${revisionId}");
        });

    });
</script>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>