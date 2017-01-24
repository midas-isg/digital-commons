<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>


<c:set var="urlLevel" value="${pageContext.request.contextPath}/logout"/>
<form class="navbar-form" action="${urlLevel}" method="GET">
    <button type="submit" class="btn btn-primary navbar-btn" value="Logout">Logout</button>
</form>
