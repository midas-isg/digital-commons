<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <myTags:head title="MIDAS Digital Commons"/>

    <myTags:header pageTitle="Forgot password" addEntry="true"></myTags:header>
    <meta charset="utf-8">
</head>

<body>
<div class="modal" id="myModal">
    <div class="modal-dialog">
        <div class="modal-content">

            <!-- Modal Header -->
            <div class="modal-header">
                <h4 class="modal-title">${successMessage}</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>

        </div>
    </div>
</div>
<div class="container">
    <form method="POST" action="${contextPath}/forgot" class="form-forgot-password">
        <h2 class="form-heading">Forgot Password</h2>

        <div class="form-group ${errorMessage != null ? 'has-error' : ''}">
            <div class="form-group">

                <span>${errorMessage}</span>
                <input name="email" type="text" class="form-control" placeholder="Email address"
                       autofocus="true"/>
            </div>

            <button class="btn btn-lg btn-primary btn-block" type="submit">Submit</button>
        </div>
    </form>
</div>


<script>
    $(document).ready(function () {
        if ("${successMessage}" != "") {
            $("#myModal").modal('show');
        }
    });
</script>
<myTags:analytics/>

</body>
<myTags:footer/>

</html>