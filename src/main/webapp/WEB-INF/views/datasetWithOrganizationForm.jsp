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
<div class="container">
    <div class="row">
        <div class="col-12">
            <form:form id="entry-form"
                       action="${pageContext.request.contextPath}/addDatasetWithOrganization/${categoryID}?entryId=${entryId}&revisionId=${revisionId}"
                       modelAttribute="datasetWithOrganization">
                <div class="form-group edit-form-group">
                    <label>Dataset with Organization</label>
                    <myTags:editCategory selectedID="${categoryID}"
                                         categoryPaths="${categoryPaths}"></myTags:editCategory>
                    <myTags:editRequiredNonZeroLengthString label="Title" placeholder=" The name of the dataset, usually one sentece or short description of the dataset."
                                                            path="title"
                                                            string="${datasetWithOrganization.title}"></myTags:editRequiredNonZeroLengthString>
                    <myTags:editNonZeroLengthString path="description"
                                                    string="${datasetWithOrganization.description}"
                                                    specifier="description" placeholder=" A textual narrative comprised of one or more statements describing the dataset."
                                                    label="Description"></myTags:editNonZeroLengthString>
                    <myTags:editIdentifierUnbounded identifier="${datasetWithOrganization.identifier}" specifier="identifier"
                                                    path="identifier" label="Identifier"></myTags:editIdentifierUnbounded>
                        <%--<myTags:editCreators creators="${dataset.creators}"></myTags:editCreators>--%>
                    <myTags:editOrganization organizations="${datasetWithOrganization.creators}"
                                             label="Creators" path="creators"
                                             specifier="creators" isFirstRequired="true"></myTags:editOrganization>
                    <myTags:editType path="types" types="${datasetWithOrganization.types}" specifier="type"></myTags:editType>
                    <myTags:editBiologicalEntityUnbounded path="isAbout" entities="${datasetWithOrganization.isAbout}"
                                                          specifier="isAbout" name="Is About"></myTags:editBiologicalEntityUnbounded>
                    <myTags:editBiologicalEntityUnbounded path="spatialCoverage"
                                                          entities="${datasetWithOrganization.spatialCoverage}"
                                                          specifier="spatialCoverage"
                                                          name="Spatial Coverage"></myTags:editBiologicalEntityUnbounded>
                    <myTags:editStudy study="${datasetWithOrganization.producedBy}" specifier="producedBy"
                                      path="producedBy" label="Produced By"></myTags:editStudy>
                    <myTags:editDistributions distributions="${datasetWithOrganization.distributions}"
                                              specifier="distributions" path="distributions"></myTags:editDistributions>
                    <myTags:editCategoryValuePair categoryValuePairs="${datasetWithOrganization.extraProperties}"
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
        $("#categoryValue").change(function () {
            var action = $(this).val()
            $("#entry-form").attr("action", "${pageContext.request.contextPath}/addDatasetWithOrganization/" + action + "?entryId=${entryId}&revisionId=${revisionId}");
        });

    });
</script>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>