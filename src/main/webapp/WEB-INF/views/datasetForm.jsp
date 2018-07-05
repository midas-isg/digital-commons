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
            <form:form id="entry-form" action="${pageContext.request.contextPath}/addDataset/${categoryID}?entryId=${entryId}&revisionId=${revisionId}"
                       modelAttribute="dataset">
                <div class="form-group edit-form-group">
                    <label>Dataset</label>
                    <myTags:editCategory selectedID="${categoryID}"
                                         categoryPaths="${categoryPaths}"></myTags:editCategory>
                    <myTags:editRequiredNonZeroLengthString label="Title" path="title" placeholder=" The name of the dataset, usually one sentece or short description of the dataset."
                                                            string="${dataset.title}"></myTags:editRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString path="description" string="${dataset.description}"
                                                               specifier="description" placeholder=" A textual narrative comprised of one or more statements describing the dataset."
                                                               label="Description"></myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editIdentifier identifier="${dataset.identifier}" specifier="identifier" path="identifier"
                                           label="Identifier"></myTags:editIdentifier>
                    <%--<myTags:editPerson people="${dataset.creators}" label="Creators"--%>
                                       <%--path="creators" specifier="creators"--%>
                                       <%--isFirstRequired="true"></myTags:editPerson>--%>
                    <myTags:editPersonComprisedEntity personComprisedEntities="${dataset.creators}" label="Creator"
                                       path="creators" specifier="creators" showAddPersonButton="true" showAddOrganizationButton="true"
                                       isFirstRequired="true"></myTags:editPersonComprisedEntity>
                    <myTags:editType path="types" types="${dataset.types}"></myTags:editType>
                    <%--<myTags:editBiologicalEntity path="isAbout" entities="${dataset.isAbout}" specifier="isAbout"--%>
                                                 <%--name="Is About"></myTags:editBiologicalEntity>--%>
                    <%--<myTags:editBiologicalEntity path="spatialCoverage" entities="${dataset.spatialCoverage}"--%>
                                                 <%--specifier="spatialCoverage"--%>
                                                 <%--name="Spatial Coverage"></myTags:editBiologicalEntity>--%>
                    <myTags:editStudy study="${dataset.producedBy}" specifier="producedBy"
                                      path="producedBy" label="Produced By"></myTags:editStudy>
                    <myTags:editDistributions distributions="${dataset.distributions}" specifier="distributions"
                                              path="distributions"></myTags:editDistributions>
                    <myTags:editCategoryValuePair categoryValuePairs="${dataset.extraProperties}"
                                                  specifier="extraProperties" label="Extra Properties"
                                                  path="extraProperties"></myTags:editCategoryValuePair>
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
            $("#entry-form").attr("action", "${pageContext.request.contextPath}/addDataset/" + action + "?entryId=${entryId}&revisionId=${revisionId}");
        });

    });
</script>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>