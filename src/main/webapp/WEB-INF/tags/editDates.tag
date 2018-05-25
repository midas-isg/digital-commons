<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="date" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Date" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>

<div class="form-group control-group edit-form-group">
    <div class="form-group edit-form-group">
        <label>Date</label>
        <input type="text" class="form-control date" value="${date.date}" name="${path}.date" id="${specifier}-date-picker">
    </div>
    <myTags:editAnnotation path="${path}.type." annotation="${date.type}"></myTags:editAnnotation>
</div>

<script>
    $( document ).on( "focus", "input.date:not(.hasDatepicker)", function() {
        <%--$("#${specifier}-date-picker").live("click", function () {--%>
            $(this).datepicker({
                changeMonth: true,
                changeYear: true
            });
//        });
    });
</script>