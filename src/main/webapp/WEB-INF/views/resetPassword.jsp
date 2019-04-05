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
    <h2 class="form-heading">Reset Password</h2>

    <form:form method="POST" modelAttribute="resetForm" class="form-reset">
        <spring:bind path="password">
            <div class="form-group ${status.error ? 'has-error' : ''}">
                <form:input type="password" path="password" class="form-control"
                            placeholder="Password"></form:input>
                <form:errors path="password"></form:errors>
            </div>
        </spring:bind>

        <spring:bind path="passwordConfirm">
            <div class="form-group ${status.error ? 'has-error' : ''}">
                <form:input type="password" path="passwordConfirm" class="form-control"
                            placeholder="Confirm your password"></form:input>
                <form:errors path="passwordConfirm"></form:errors>
            </div>
        </spring:bind>

        <input type="hidden" name="resetToken" value="${resetToken}"/>

        <button class="btn btn-lg btn-primary btn-block" type="submit">Submit</button>
    </form:form>


</div>
<myTags:analytics/>

</body>
<myTags:footer/>

</html>