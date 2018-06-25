<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="unit" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Annotation" %>


<c:choose>
    <c:when test="${not empty unit}">
        <div class="form-group edit-form-group">
            <form:label path="${path}">Unit</form:label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-unit" style="display:none;" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Unit
                </button>
            </div>

            <div class="form-group control-group edit-form-group">
                <label>Unit</label>
                <br>
                <button class="btn btn-danger ${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
                <br><br>
                <myTags:editAnnotation annotation="${unit}" path="${path}." supportError="${true}"></myTags:editAnnotation>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <form:label path="${path}">Unit</form:label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-unit" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Unit
                </button>
            </div>
        </div>
    </c:otherwise>
</c:choose>


<div class="${specifier}-copy-unit hide">
    <div class="form-group control-group edit-form-group">
        <label>Unit</label>
        <br>
        <button class="btn btn-danger ${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <myTags:editAnnotation path="${path}."></myTags:editAnnotation>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        //Show/Hide Location
        $("body").on("click", ".${specifier}-add-unit", function (e) {
            e.stopImmediatePropagation();
            var html = $(".${specifier}-copy-unit").html();

            $(this).after(html);
            $(this).hide();
            //e.stopImmediatePropagation()
        });
        $("body").on("click", ".${specifier}-remove", function () {
            $(this).parent(".control-group").remove();
            $(".${specifier}-add-unit").show();
        });

    });
</script>