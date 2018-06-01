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
<%@ attribute name="size" required="false"
              type="java.lang.Integer" %>

<c:choose>
    <c:when test="${not empty size}">
        <div class="form-group edit-form-group">
            <form:label path="${path}">Size</form:label>
            <div class="input-group control-group ${specifier}-size-add-more">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-size" style="display: none" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Size
                    </button>
                </div>
            </div>
            <div class="input-group control-group full-width">
                <input type="number" class="form-control" value="${size}" name="${path}"
                       id="${specifier}-size" placeholder="Size"/>
                <div class="input-group-btn">
                    <button class="btn btn-danger ${specifier}-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <form:label path="${path}">Size</form:label>
            <div class="input-group control-group ${specifier}-size-add-more">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-size" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Size
                    </button>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>


<div class="${specifier}-copy-size hide">
    <div class="input-group control-group full-width">
        <input type="number" class="form-control" name="${path}" placeholder="Size"/>
        <div class="input-group-btn">
            <button class="btn btn-danger ${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
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
        $("body").on("click", ".${specifier}-remove", function (e) {
            e.stopImmediatePropagation();

            $(this).parents(".control-group")[0].remove();
            $(".${specifier}-add-size").show();
        });

    });
</script>