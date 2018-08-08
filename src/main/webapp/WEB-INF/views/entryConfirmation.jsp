<!DOCTYPE HTML>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>

<myTags:head title="MIDAS Digital Commons"/>

<body>
<div class="container-fluid">
    <myTags:header
            pageTitle="MIDAS Digital Commons"
            loggedIn="${loggedIn}" addEntry="${true}"/>
    <div class="row">
        <div class="col-md-12">
            <br>
            <button type="button" class="btn btn-default">
                <a href="${pageContext.request.contextPath}/main">
                    <icon class="fa fa-chevron-left"></icon>
                    Home
                </a>
            </button>

            <button type="button" class="btn btn-default pull-right">
                <a href="${pageContext.request.contextPath}/add/review">
                    Review Submissions
                    <icon class="fa fa-chevron-right"></icon>
                </a>
            </button>

            <br>
            <h3 class="text-center">Your entry has been successfully added. An email request has been sent to the
                administrator. Approval is pending.</h3>

        </div>
    </div>
</div>

</body>
</html>


