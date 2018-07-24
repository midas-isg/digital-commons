<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="name" required="true"
              type="java.lang.String" %>
<%@ attribute name="eventId" required="true"
              type="java.lang.String" %>

<div class="form-group edit-form-group">
    <label>${name}</label>
    <div class="form-group">
        <input type="submit" name="_eventId_${eventId}" class="btn btn-success" value="Add ${name}"/>

    </div>
</div>