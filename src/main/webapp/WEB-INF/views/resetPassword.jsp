<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="Reset password" addEntry="true"></myTags:header>
    <meta charset="utf-8">
</head>

<body>

<div class="container">
    <form method="POST" action="${contextPath}/reset" class="form-reset-password">
        <h2 class="form-heading">Reset Password</h2>

        <div class="form-group ${errorMessage != null ? 'has-error' : ''}">
            <span>${errorMessage}</span>
            <input name="password" type="password" class="form-control" placeholder="Password"
                   autofocus="true"/>

            <input name="confirmPassword" type="password" class="form-control" placeholder="Confirm password">

            <input type="hidden" name="resetToken" value="${resetToken}"/>

            <button class="btn btn-lg btn-primary btn-block" type="submit">Submit</button>
        </div>
    </form>
</div>
<myTags:analytics/>

</body>
<myTags:footer/>

</html>