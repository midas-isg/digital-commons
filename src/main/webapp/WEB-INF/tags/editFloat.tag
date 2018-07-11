<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="number" required="false"
              type="java.lang.Float" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>
<c:choose>
    <c:when test="${not empty number}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="input-group control-group ${specifier}-number-add-more" style="display: none">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-number" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
            <div class="input-group control-group full-width">
                <input type="number" step="any" class="form-control" value="${number}" name="${path}" id="${specifier}-number" placeholder="${placeholder}"/>
                <div class="input-group-btn">
                    <button class="btn btn-danger ${specifier}-number-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="input-group control-group ${specifier}-number-add-more">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-number" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>


<div class="${specifier}-copy-number hide">
    <div class="input-group control-group full-width">
        <input type="number" step="any" class="form-control" name="${path}" placeholder="${placeholder}" id="${specifier}-number"/>
        <div class="input-group-btn">
            <button class="btn btn-danger ${specifier}-number-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $("body").on("click", ".${specifier}-add-number", function (e) {
            e.stopImmediatePropagation();

            var html = $(".${specifier}-copy-number").html();
            <%--html = html.replace('name=""', 'name="${path}" id=${specifier}-string').replace('string-remove', '${specifier}-string-remove').replace('placeholder=""', 'placeholder="${placeholder}"');--%>
            //Add section
            $(".${specifier}-number-add-more").after(html);
            $(".${specifier}-number-add-more").hide();
            $("#${specifier}-number").val("");

        });
        //Remove section
        $("body").on("click", ".${specifier}-number-remove", function (e) {
            e.stopImmediatePropagation();

            // $(this).parents(".control-group")[0].remove();
            $(this).closest(".control-group").remove();
            $(".${specifier}-number-add-more").show();
        });
    });

</script>