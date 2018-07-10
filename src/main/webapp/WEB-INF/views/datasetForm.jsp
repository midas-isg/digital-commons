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

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true">
    </myTags:header>
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
                    <myTags:editIdentifier identifier="${dataset.identifier}"
                                           specifier="identifier"
                                           path="identifier"
                                           label="Identifier">
                    </myTags:editIdentifier>
                    <myTags:editCategory selectedID="${categoryID}"
                                         categoryPaths="${categoryPaths}">
                    </myTags:editCategory>
                    <myTags:editRequiredNonZeroLengthString label="Title"
                                                            path="title"
                                                            placeholder=" The name of the dataset, usually one sentece or short description of the dataset."
                                                            string="${dataset.title}">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthStringTextArea path="description"
                                                                       string="${dataset.description}"
                                                                       specifier="description"
                                                                       placeholder=" A textual narrative comprised of one or more statements describing the dataset."
                                                                       label="Description">
                    </myTags:editNonRequiredNonZeroLengthStringTextArea>
                    <myTags:editDatesUnbounded dates="${dataset.dates}"
                                               path="dates"
                                               specifier="dates">
                    </myTags:editDatesUnbounded>
                    <myTags:editDataRepository name="Stored In"
                                               path="storedIn"
                                               dataRepository="${dataset.storedIn}"
                                               specifier="storedIn">
                    </myTags:editDataRepository>
                    <myTags:editPersonComprisedEntity personComprisedEntities="${dataset.creators}"
                                                      label="Creator"
                                                      path="creators"
                                                      specifier="creators"
                                                      showAddPersonButton="true"
                                                      showAddOrganizationButton="true"
                                                      isFirstRequired="true">
                    </myTags:editPersonComprisedEntity>
                    <myTags:editType path="types"
                                     specifier="types"
                                     types="${dataset.types}">
                    </myTags:editType>
                    <myTags:editNonRequiredNonZeroLengthString path="availability"
                                                               string="${dataset.availability}"
                                                               specifier="availability"
                                                               placeholder=" A qualifier indicating the different types of availability for a dataset (available, unavailable, embargoed, available with restriction, information not available)."
                                                               label="Availability">
                    </myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString path="refinement"
                                                               string="${dataset.refinement}"
                                                               specifier="refinement"
                                                               placeholder=" A qualifier to describe the level of data processing of the dataset and its distributions."
                                                               label="Refinement">
                    </myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString path="aggregation"
                                                               string="${dataset.aggregation}"
                                                               specifier="aggregation"
                                                               placeholder=" A qualifier indicating if the entity represents an 'instance of dataset' or a 'collection of datasets'."
                                                               label="Aggregation">
                    </myTags:editNonRequiredNonZeroLengthString>
                    <%--<myTags:editBiologicalEntity path="isAbout" entities="${dataset.isAbout}" specifier="isAbout"--%>
                                                 <%--name="Is About"></myTags:editBiologicalEntity>--%>
                    <%--<myTags:editBiologicalEntity path="spatialCoverage" entities="${dataset.spatialCoverage}"--%>
                                                 <%--specifier="spatialCoverage"--%>
                                                 <%--name="Spatial Coverage"></myTags:editBiologicalEntity>--%>
                    <myTags:editStudy study="${dataset.producedBy}"
                                      specifier="producedBy"
                                      path="producedBy"
                                      label="Produced By">
                    </myTags:editStudy>
                    <myTags:editDistributions distributions="${dataset.distributions}"
                                              specifier="distributions"
                                              path="distributions">
                    </myTags:editDistributions>
                    <myTags:editPublication path="primaryPublications"
                                            specifier="primaryPublications"
                                            publications="${dataset.primaryPublications}"
                                            label="Primary Publications">
                    </myTags:editPublication>
                    <myTags:editPublication path="citations"
                                            specifier="citations"
                                            publications="${dataset.citations}"
                                            label="Citations">
                    </myTags:editPublication>
                    <myTags:editFloat path="citationCount"
                                      specifier="citationCount"
                                      number="${dataset.citationCount}"
                                      label="Citation Count"
                                      placeholder="The number of publications that cite this dataset (enumerated in the citations property)">
                    </myTags:editFloat>
                    <myTags:editLicense path="licenses"
                                        licenses="${dataset.licenses}"
                                        label="License"
                                        specifier="licenses">
                    </myTags:editLicense>
                    <myTags:editIsAbout path="isAbout"
                                        specifier="isAbout"
                                        isAboutList="${dataset.isAbout}"
                                        label="Is About"
                                        showAddAnnotationButton="true"
                                        showAddBiologicalEntityButton="true">
                    </myTags:editIsAbout>
                    <myTags:editGrant path="acknowledges"
                                      specifier="acknowledges"
                                      grants="${dataset.acknowledges}"
                                      label="Acknowledges">
                    </myTags:editGrant>
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
                </div>
                <button type="submit" class="btn btn-default pull-right">Submit</button>

            </form:form>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        $("#categoryValue").change(function() {
            var action = $(this).val();
            $("#entry-form").attr("action", "${pageContext.request.contextPath}/addDataset/" + action + "?entryId=${entryId}&revisionId=${revisionId}");
        });

    });
</script>
<myTags:analytics/>

</body>

<myTags:footer/>

</html>