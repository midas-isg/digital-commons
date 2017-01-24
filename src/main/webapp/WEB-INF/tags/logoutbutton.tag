<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>


<c:set var="urlLevel" value="${pageContext.request.contextPath}/logout"/>
<form action="${urlLevel}" method="GET" class="login-form">
    <!--<div class="row">-->
    <div class="submit_button">
        <input type="submit" class="btn btn-primary" value="Logout"/>
    </div>
    <!--</div>-->
</form>
