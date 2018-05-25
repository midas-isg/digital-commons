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

<div class="form-group edit-form-group">
    <form:label path="${path}">Size</form:label>
    <div class="input-group-btn">
        <button class="btn btn-success ${specifier}-add-size" type="button"><i
                class="glyphicon glyphicon-plus"></i> Add
            Size
        </button>
    </div>
</div>

<div class="${specifier}-copy-size hide">
    <div class="form-group control-group edit-form-group">
        <label></label>
        <br>
        <button class="btn btn-danger ${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <div class="form-group edit-form-group">
            <label>Size</label>
            <input name="${path}" type="text" class="form-control" placeholder="Size">
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        //Show/Hide Size
        $("body").on("click", ".${specifier}-add-size", function () {
            var html = $(".${specifier}-copy-size").html();

            $(this).after(html);
            $(this).hide();
            //e.stopImmediatePropagation()
        });
        $("body").on("click", ".${specifier}-remove", function () {
            $(this).parent(".control-group").remove();
            $(".${specifier}-add-size").show();
        });

    });
</script>