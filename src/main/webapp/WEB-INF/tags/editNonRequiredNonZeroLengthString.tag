<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="string" required="false"
              type="java.lang.String" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>
<c:choose>
    <c:when test="${not empty string}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="input-group control-group ${specifier}-string-add-more" style="display: none">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-string" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        ${label}
                    </button>
                </div>
            </div>
            <div class="input-group control-group full-width">
                <input type="text" class="form-control" value="${string}" name="${path}" id="${specifier}-string" placeholder="${placeholder}"/>
                <div class="input-group-btn">
                    <button class="btn btn-danger ${specifier}-string-remove" type="button"><i
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
            <div class="input-group control-group ${specifier}-string-add-more">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-string" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        ${label}
                    </button>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>


<div class="copy-string hide">
    <div class="input-group control-group full-width">
        <input type="text" class="form-control" name="" placeholder=""/>
        <div class="input-group-btn">
            <button class="btn btn-danger string-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $("body").on("click", ".${specifier}-add-string", function (e) {
            e.stopImmediatePropagation();

            var html = $(".copy-string").html();
            html = html.replace('name=""', 'name="${path}" id=${specifier}-string').replace('string-remove', '${specifier}-string-remove').replace('placeholder=""', 'placeholder="${placeholder}"');
            //Add section
            $(".${specifier}-string-add-more").after(html);
            $(".${specifier}-string-add-more").hide();
            $("#${specifier}-string").val("");

        });
        //Remove section
        $("body").on("click", ".${specifier}-string-remove", function (e) {
            e.stopImmediatePropagation();

            $(this).parents(".control-group")[0].remove();
            $(".${specifier}-string-add-more").show();
        });
    });

</script>