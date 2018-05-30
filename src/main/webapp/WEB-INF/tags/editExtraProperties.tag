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
    <label>Extra Properties</label>
    <div class="form-group">
        <button class="btn btn-success ${specifier}-add" type="button"><i
                class="glyphicon glyphicon-plus"></i> Add
            Extra Properties
        </button>
    </div>
</div>

<div class="${specifier}-copy hide">
    <div class="form-group control-group edit-form-group">
        <label>Extra Properties</label>
        <div class="form-group">
            <button class="btn btn-danger ${specifier}-0-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
        <br>
        <div>
            <button class="btn btn-success ${specifier}-0-add-category" id="${specifier}-0-add-category" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Category
            </button>
        </div>
        <br>
        <div>
            <button class="btn btn-success ${specifier}-0-add-categoryIRI" id="${specifier}-0-add-categoryIRI" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Category IRI
            </button>
        </div>
        <br>
        <div>
            <button class="btn btn-success ${specifier}-0-add-values" id="${specifier}-0-add-values" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Value
            </button>
        </div>
        <br>
    </div>

    <div class="${specifier}-0-copy-category hide">
        <div class="input-group control-group edit-form-group full-width">
            <label>Category</label>
            <div class="input-group">
                <input name="${path}[0].Category" type="text" class="form-control" placeholder="Category">
                <div class="input-group-btn">
                    <button class="btn btn-danger ${specifier}-0-category-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                </div>
            </div>
        </div>
    </div>


    <div class="${specifier}-0-copy-categoryIRI hide">
        <div class="input-group control-group edit-form-group full-width">
            <label>Category IRI</label>
            <div class="input-group">
                <input name="${path}[0].CategoryIRI" type="text" class="form-control" placeholder="Category IRI">
                <div class="input-group-btn">
                    <button class="btn btn-danger ${specifier}-0-categoryIRI-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="${specifier}-copy-values hide">
        <div class="form-group control-group full-width">
            <div class="form-group edit-form-group">
                <label>Value</label>
                <div class="input-group-btn">
                    <button class="btn btn-danger ${specifier}-0-values-0-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                </div>
                <myTags:editAnnotation path="${path}[0].values[0]."></myTags:editAnnotation>
                <%--<div class="form-group">--%>
                    <%--<myTags:editAnnotation path="${path}[0].values[0]."></myTags:editAnnotation>--%>
                <%--</div>--%>
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                //Hide Values
                $("body").on("click", ".${specifier}-0-values-0-remove", function () {
                    $(this).closest(".control-group").remove();
                    //$(".${specifier}-add-values").show();
                });

            });
        </script>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            //Show/Hide Category
            $("body").on("click", ".${specifier}-0-add-category", function (e) {
                var html = $(".${specifier}-0-copy-category").html();

                $(this).after(html);
                $(this).hide();
                e.stopImmediatePropagation()
            });
            $("body").on("click", ".${specifier}-0-category-remove", function () {
                $(this).closest(".control-group").remove();
                $(".${specifier}-0-add-category").show();
            });

            //Show/Hide CategoryIRI
            $("body").on("click", ".${specifier}-0-add-categoryIRI", function (e) {
                var html = $(".${specifier}-0-copy-categoryIRI").html();

                $(this).after(html);
                $(this).hide();
                e.stopImmediatePropagation()
            });
            $("body").on("click", ".${specifier}-0-categoryIRI-remove", function () {
                $(this).closest(".control-group").remove();
                //console.log($(this).parent(".control-group"));
                $(".${specifier}-0-add-categoryIRI").show();
            });

            var valuesCount = 0;
            //Show/Hide Values
            $("body").on("click", ".${specifier}-0-add-values", function (e) {
                var specifier = "${specifier}-values";
                var path = "${path}.values";
                var html = $(".${specifier}-copy-values").html();
                //console.log(html);
                var regexEscapeOpenBracket = new RegExp('\\[',"g");
                var regexEscapeClosedBracket = new RegExp('\\]',"g");
                path = path.replace(regexEscapeOpenBracket,'\\[').replace(regexEscapeClosedBracket,'\\]');
                var regexPath = new RegExp(path + '\\[0\\]', "g");
                var regexSpecifier = new RegExp(specifier + '\\-0', "g");
                html = html.replace(regexPath, '${path}['+ valuesCount + ']').replace(regexSpecifier,'${specifier}-' + valuesCount);

                $(this).after(html);
                valuesCount += 1;
                //$(this).hide();
                e.stopImmediatePropagation()
            });

            $("body").on("click", ".${specifier}-0-remove", function () {
                $(this).closest(".control-group").remove();
                //$(".${specifier}-0-add").show();
            });
        });
    </script>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        var extraPropertiesCount = 0;
        //Show/Hide Location
        $("body").on("click", ".${specifier}-add", function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            //console.log(path);
            var regexEscapeOpenBracket = new RegExp('\\[',"g");
            var regexEscapeClosedBracket = new RegExp('\\]',"g");
            path = path.replace(regexEscapeOpenBracket,'\\[').replace(regexEscapeClosedBracket,'\\]');
            //console.log(path);
            var html = $(".${specifier}-copy").html();
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}['+ extraPropertiesCount + ']').replace(regexSpecifier,'${specifier}-' + extraPropertiesCount);

            //console.log($(this));
            $(this).after(html);
            //$(this).hide();
            extraPropertiesCount += 1;
            e.stopImmediatePropagation()
        });

    });
</script>