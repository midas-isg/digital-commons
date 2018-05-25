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

<div class="form-group edit-form-group dataStandard-add-more">
    <label>Conforms To</label>
        <button class="btn btn-success ${specifier}-add-dataStandard" type="button"><i
                class="glyphicon glyphicon-plus"></i> Add
            Conforms To
        </button>
</div>

<div class="${specifier}-copy-dataStandard hide">
    <div class="form-group control-group edit-form-group">
        <label>Conforms To</label>
        <br>
        <button class="btn btn-danger ${specifier}[0]-dataStandard-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <div class="form-group">
            <myTags:editIdentifier name="Identifier" specifier="${specifier}-" path="${path}[0].identifier" unbounded="False"></myTags:editIdentifier>
        </div>
        <div class="form-group edit-form-group">
            <label>Name</label>
            <input name="${path}[0].name" type="text" class="form-control" placeholder="Name">
        </div>
        <div class="form-group">
            <myTags:editDescription specifier="${specifier}" path="${path}[0].description"></myTags:editDescription>
        </div>
        <%--<div class="form-group">--%>
            <%--<myTags:editType specifier="${specifier}-type" path="${path}[0].type"></myTags:editType>--%>
        <%--</div>--%>
        <div class="form-group">
            <myTags:editLicense specifier="${specifier}-licenses" path="${path}[0].licenses"></myTags:editLicense>
        </div>
        <div class="form-group">
            <myTags:editExtraProperties specifier="${specifier}-0-extraProperties" path="${path}[0].extraProperties"></myTags:editExtraProperties>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-dataStandard-remove", function () {
                $(this).parent(".control-group").remove();
                $(".${specifier}-add-dataStandard").show();
            });
        });
    </script>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var dataStandardCount = 0;
        //Show/Hide Location
        $("body").on("click", ".${specifier}-add-dataStandard", function () {
            var specifier = "${specifier}-dataStandard";
            var path = "${path}.dataStandard";
            var html = $(".${specifier}-copy-dataStandard").html();
            var regexEscapeOpenBracket = new RegExp('\\[',"g");
            var regexEscapeClosedBracket = new RegExp('\\]',"g");
            path = path.replace(regexEscapeOpenBracket,'\\[').replace(regexEscapeClosedBracket,'\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}.dataStandard['+ dataStandardCount + ']').replace(regexSpecifier,'${specifier}-dataStandard-' + dataStandardCount);

            $(this).after(html);
            //$(this).hide();
            //e.stopImmediatePropagation()
        });
    });
</script>
