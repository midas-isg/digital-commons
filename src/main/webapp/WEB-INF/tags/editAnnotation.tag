<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="annotation" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Annotation" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>

<div class="form-group control-group edit-form-group">

    <div class="form-group edit-form-group">
        <label>Value</label>
        <input type="text" class="form-control" value="${annotation.value}" name="${path}value" placeholder="Value">
    </div>

    <div class="form-group edit-form-group">
        <label>Value IRI</label>
        <input type="text" class="form-control" value="${annotation.value}" name="${path}valueIRI" placeholder="Value IRI">
    </div>

</div>
