<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="name" required="false"
              type="java.lang.String" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>

<div class="form-group edit-form-group">
    <form:label path="${path}">${name}</form:label>
    <div class="form-group">
        <button class="btn btn-success ${specifier}-add-dataStandard" type="button"><i
                class="glyphicon glyphicon-plus"></i> Add
            ${name}
        </button>
    </div>
</div>

<div class="${specifier}-copy-dataStandard hide">
    <div class="form-group control-group edit-form-group">
        <label></label>
        <br>
        <button class="btn btn-danger ${specifier}-0-dataStandard-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <div class="form-group">
            <myTags:editIdentifier label="Identifier" specifier="${specifier}-" path="${path}[0].identifier" unbounded="False"></myTags:editIdentifier>
        </div>
        <div class="form-group edit-form-group">
            <label>Name</label>
            <input name="${path}[0].name" type="text" class="form-control" placeholder="Name">
        </div>
        <div class="form-group">
            <myTags:editDescription specifier="${specifier}" path="${path}[0].description"></myTags:editDescription>
        </div>
        <div class="form-group edit-form-group">
            <label>Types</label>
            <myTags:editAnnotation path="${path}[0].type."></myTags:editAnnotation>
        </div>
        <div class="form-group">
            <myTags:editLicense specifier="${specifier}-licenses" path="${path}[0].licenses"></myTags:editLicense>
        </div>
        <div class="form-group edit-form-group">
            <label>Version</label>
            <button class="btn btn-success ${specifier}-0-add-version" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Version
            </button>
        </div>
        <div class="form-group">
            <myTags:editExtraProperties specifier="${specifier}-0-extraProperties" path="${path}[0].extraProperties"></myTags:editExtraProperties>
        </div>
    </div>

    <div class="${specifier}-0-copy-version hide">
        <div class="input-group control-group edit-form-group full-width">
            <input type="text" class="form-control" name="${path}[0].version" id="${specifier}-0-version" placeholder="Version"/>
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-0-version-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                //Hide Version
                $("body").on("click", ".${specifier}-0-version-remove", function () {
                    $(this).closest(".control-group").remove();
                    $(".${specifier}-0-add-version").show();
                });

            });
        </script>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-0-dataStandard-remove", function () {
                $(this).parent(".control-group").remove();
                $(".${specifier}-add-dataStandard").show();
            });

            //Show/Hide Version
            $("body").on("click", ".${specifier}-0-add-version", function (e) {
                var html = $(".${specifier}-0-copy-version").html();

                $(this).after(html);
                $(this).hide();
                e.stopImmediatePropagation()
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
            dataStandardCount += 1;
            //$(this).hide();
            //e.stopImmediatePropagation()
        });
    });
</script>
