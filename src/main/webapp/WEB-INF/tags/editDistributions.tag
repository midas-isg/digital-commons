<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="types" required="false"
              type="java.util.ArrayList" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>


<div class="form-group edit-form-group distribution-add-more">
    <label>Distribution</label>
    <button class="btn btn-success add-distribution" type="button"><i class="glyphicon glyphicon-plus"></i> Add Distribution</button>
</div>

<div class="copy-distribution hide">
    <div class="form-group control-group edit-form-group">
        <label>Distribution</label>
        <button class="btn btn-danger distribution-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>
        <div class="form-group">
            <myTags:editIdentifier name="Identifier" specifier="${specifier}-0" path="${path}[0].identifier" unbounded="False"></myTags:editIdentifier>
        </div>
    </div>
</div>



<script type="text/javascript">
    $(document).ready(function () {
        var distributionCount = 0;
        //Add section
        $(".add-distribution").click(function () {
            var html = $(".copy-distribution").html();
            $(".distribution-add-more").after(html);
            html = html.replace('name="identifier"', 'name="distribution['+ distributionCount + '].identifier"');
            distributionCount += 1;
        });

        //Remove section
        $("body").on("click", ".distribution-remove", function () {
            $(this).parents(".control-group").remove();
        });

    });
</script>