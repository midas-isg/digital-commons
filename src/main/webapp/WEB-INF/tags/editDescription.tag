<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="description" required="false"
              type="java.lang.String" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>

<div class="form-group edit-form-group">
    <label>Description</label>
    <div class="input-group control-group ${specifier}-description-add-more">
        <div class="input-group-btn">
            <button class="btn btn-success ${specifier}-add-description" type="button"><i class="glyphicon glyphicon-plus"></i> Add
                Description
            </button>
        </div>
    </div>
</div>

<div class="copy-description hide">
    <div class="input-group control-group full-width">
        <input type="text" class="form-control" value="${description}" name="" placeholder="Description"/>
        <div class="input-group-btn">
            <button class="btn btn-danger description-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
            </button>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $("body").on("click", ".${specifier}-add-description", function (e) {
            e.stopImmediatePropagation();

            var html = $(".copy-description").html();
            html = html.replace('name=""', 'name="${path}"').replace('description-remove', '${specifier}-description-remove');

            //Add section
            $(".${specifier}-description-add-more").after(html);
            $(".${specifier}-description-add-more").hide();
        });
        //Remove section
        $("body").on("click", ".${specifier}-description-remove", function (e) {
            e.stopImmediatePropagation();

            $(this).parents(".control-group").remove();
            $(".${specifier}-description-add-more").show();
        });

        <c:if test="${not empty description}">
        var html = $(".copy-description").html();
        html = html.replace('name=""', 'name="${path}"').replace('description-remove', '${specifier}-description-remove');

        //Add section
        $(".${specifier}-description-add-more").after(html);
        $(".${specifier}-description-add-more").hide();
        </c:if>
    });

</script>