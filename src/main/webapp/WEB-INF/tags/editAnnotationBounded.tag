<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="annotation" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Annotation" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>


<c:choose>
    <c:when test="${not empty annotation}">
        <div class="form-group edit-form-group">
            <form:label path="${path}">${label}</form:label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-annotation" id="${specifier}-add-annotation" style="display:none;" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${label}
                </button>
            </div>

            <div class="form-group control-group edit-form-group">
                <%--<label>${label}</label>--%>
                <%--<br>--%>
                <%--<button class="btn btn-danger ${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>--%>
                    <%--Remove--%>
                <%--</button>--%>
                <%--<br><br>--%>
                <myTags:editAnnotation annotation="${annotation}"
                                       path="${path}"
                                       specifier="${specifier}"
                                       label="${label}"
                                       showRemoveButton="true"
                                       supportError="${true}">
                </myTags:editAnnotation>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <form:label path="${path}">${label}</form:label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-annotation" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${label}
                </button>
            </div>
        </div>
    </c:otherwise>
</c:choose>


<div class="${specifier}-copy-annotation hide">
    <div class="form-group control-group edit-form-group">
        <%--<label>${label}</label>--%>
        <%--<br>--%>
        <%--<button class="btn btn-danger ${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>--%>
            <%--Remove--%>
        <%--</button>--%>
        <%--<br><br>--%>
        <myTags:editAnnotation path="${path}"
                               specifier="${specifier}"
                               label="${label}"
                               showRemoveButton="true">
        </myTags:editAnnotation>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        //Show/Hide Location
        $("body").on("click", ".${specifier}-add-annotation", function (e) {
            e.stopImmediatePropagation();
            var html = $(".${specifier}-copy-annotation").html();

            $(this).after(html);
            $(this).hide();
            //e.stopImmediatePropagation()
        });
        <%--$("body").on("click", ".${specifier}-remove", function () {--%>
            <%--$(this).parent(".control-group").remove();--%>
            <%--$(".${specifier}-add-annotation").show();--%>
        <%--});--%>

    });
</script>