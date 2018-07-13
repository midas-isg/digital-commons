<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>
<%@ attribute name="string" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>

<div class="form-group edit-form-group ${status.error ? 'has-error' : ''}">
    <label path="${path}">${label}</label>
    <textarea name="${path}" type="text" class="form-control" rows="5" placeholder="${placeholder}">${string}</textarea>
    <form:errors path="${path}" class="error-color"/>
</div>
