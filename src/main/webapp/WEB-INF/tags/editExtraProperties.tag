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
    <button class="btn btn-success ${specifier}-add" type="button"><i
            class="glyphicon glyphicon-plus"></i> Add
        Extra Properties
    </button>
</div>

<div class="${specifier}-copy hide">
    <div class="form-group control-group edit-form-group">
        <label>Extra Properties</label>
        <button class="btn btn-danger ${specifier}-0-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
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
        <%--<br>--%>
        <%--<div>--%>
            <%--<button class="btn btn-success ${specifier}-0-add-values" id="${specifier}-0-add-values" type="button"><i--%>
                    <%--class="glyphicon glyphicon-plus"></i> Add--%>
                <%--Value--%>
            <%--</button>--%>
        <%--</div>--%>
        <%--<br>--%>
    </div>

    <div class="${specifier}-0-copy-category hide">
        <div class="form-group control-group edit-form-group full-width">
            <label>Category</label>
            <input name="${path}[0].Category" type="text" class="form-control" placeholder="Category">
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-0-category-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
        </div>
    </div>


    <div class="${specifier}-0-copy-categoryIRI hide">
        <div class="form-group control-group edit-form-group full-width">
            <label>Category IRI</label>
            <input name="${path}[0].CategoryIRI" type="text" class="form-control" placeholder="Category IRI">
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-0-categoryIRI-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
        </div>
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
                $(this).parent(".control-group").remove();
                console.log($(this).parent());
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
                $(this).parent(".control-group").remove();
                console.log($(this).parent());
                $(".${specifier}-0-add-categoryIRI").show();
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
            html = html.replace(regexPath, '${path}['+ extraPropertiesCount + ']').replace(regexSpecifier,'${specifier}-' + extraPropertiesCount + '-');

            //console.log(html);
            $(this).after(html);
            //$(this).hide();
            extraPropertiesCount += 1;
            e.stopImmediatePropagation()
        });
        $("body").on("click", ".${specifier}-0-remove", function () {
            $(this).parent(".control-group").remove();
            $(".${specifier}-0-add").show();
        });

    });
</script>