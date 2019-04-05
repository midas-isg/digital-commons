<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="Log in" addEntry="true"></myTags:header>
    <meta charset="utf-8">
</head>

<body>

<div class="container">
    <form method="POST" action="${contextPath}/login" class="form-signin">
        <h2 class="form-heading">Log in</h2>

        <div class="form-group ${error != null ? 'has-error' : ''}">
            <span>${message}</span>
            <div class="form-group">

                <input name="username" type="text" class="form-control" placeholder="Username"
                       autofocus="true"/>
            </div>
            <div class="form-group">

                <input name="password" type="password" class="form-control" placeholder="Password"/>
                <span>${error}</span>
            </div>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <button class="btn btn-lg btn-primary btn-block" type="submit">Log In</button>
            <h4 class="text-center"><a href="${contextPath}/registration">Create an account</a></h4>
            <h4 class="text-center"><a href="${contextPath}/forgot">Forgot password?</a></h4>
        </div>
    </form>
</div>
<myTags:analytics/>

</body>
<myTags:footer/>

</html>