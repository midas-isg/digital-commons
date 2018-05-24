<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<spring:bind path="title">
    <div class="form-group edit-form-group ${status.error ? 'has-error' : ''}">
        <form:label path="title">Title</form:label>
        <form:input path="title" type="text" class="form-control" placeholder="Title"></form:input>
        <form:errors path="title" class="error-color"/>
    </div>
</spring:bind>
