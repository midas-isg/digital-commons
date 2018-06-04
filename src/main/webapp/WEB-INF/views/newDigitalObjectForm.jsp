<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-xs-12">
            <form:form id="entry-form" action="${pageContext.request.contextPath}/testAddDataset" modelAttribute="dataset">
                <div class="form-group edit-form-group">
                    <label>Dataset</label>
                    <myTags:editCategory selectedID="${categoryID}" categoryPaths="${categoryPaths}"></myTags:editCategory>
                    <myTags:editRequiredNonZeroLengthString label="Title" placeholder="Title" path="title" string="${dataset.title}"></myTags:editRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString path="description" string="${dataset.description}" specifier="description" placeholder="Description" label="Description"></myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editIdentifier identifier="${dataset.identifier}" specifier="identifier" path="identifier" label="Identifier"></myTags:editIdentifier>
                    <myTags:editCreators creators="${dataset.creators}"></myTags:editCreators>
                    <myTags:editType path="types" types="${dataset.types}"></myTags:editType>
                    <myTags:editBiologicalEntity path="isAbout" entities="${dataset.isAbout}" specifier="isAbout" name="Is About"></myTags:editBiologicalEntity>
                    <myTags:editBiologicalEntity path="spatialCoverage" entities="${dataset.spatialCoverage}" specifier="spatialCoverage" name="Spatial Coverage"></myTags:editBiologicalEntity>
                    <myTags:editStudy study="${dataset.producedBy}" specifier="producedBy" path="producedBy"></myTags:editStudy>
                    <myTags:editDistributions distributions="${dataset.distributions}" specifier="distributions" path="distributions"></myTags:editDistributions>
                    <myTags:editExtraProperties categoryValuePairs="${dataset.extraProperties}" specifier="extraProperties" path="extraProperties"></myTags:editExtraProperties>
                </div>
                <button type="submit" class="btn btn-default pull-right">Submit</button>

            </form:form>
        </div>
    </div>
</div>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>