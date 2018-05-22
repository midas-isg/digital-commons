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
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-xs-12">
            <form:form id="entry-form" action="${pageContext.request.contextPath}/testAddDataset" modelAttribute="dataset">
                <div class="form-group edit-form-group">
                    <label>Dataset</label>
                    <myTags:editTitle></myTags:editTitle>
                    <myTags:editDescription path="description" description="${dataset.description}" specifier="description"></myTags:editDescription>
                    <myTags:editIdentifier identifier="${dataset.identifier}" specifier="identifier" path="identifier" name="Identifier"></myTags:editIdentifier>
                    <myTags:editCreators creators="${dataset.creators}"></myTags:editCreators>
                    <myTags:editType types="${dataset.types}"></myTags:editType>
                    <myTags:editBiologicalEntity specifier="isAbout" name="Is About"></myTags:editBiologicalEntity>
                    <myTags:editBiologicalEntity specifier="spatialCoverage" name="Spatial Coverage"></myTags:editBiologicalEntity>

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