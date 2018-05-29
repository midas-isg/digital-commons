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

<div class="form-group edit-form-group formats-add-more">
    <label>Formats</label>
        <button class="btn btn-success ${specifier}-add-formats" type="button"><i
                class="glyphicon glyphicon-plus"></i> Add
            Formats
        </button>
</div>


<div class="${specifier}-copy-formats hide">
    <div class="input-group control-group full-width">
        <input type="text" class="form-control" name="${path}[0]" id="${specifier}-0" placeholder="Format"/>
        <div class="input-group-btn">
            <button class="btn btn-danger ${specifier}-0-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            //Hide Formats
            $("body").on("click", ".${specifier}-0-remove", function () {
                $(this).closest(".control-group").remove();
                //$(".${specifier}-add-formats").show();
            });

        });
    </script>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var formatsCount = 0;
        //Show/Hide Formats
        $("body").on("click", ".${specifier}-add-formats", function () {
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $(".${specifier}-copy-formats").html();
            var regexEscapeOpenBracket = new RegExp('\\[',"g");
            var regexEscapeClosedBracket = new RegExp('\\]',"g");
            path = path.replace(regexEscapeOpenBracket,'\\[').replace(regexEscapeClosedBracket,'\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}['+ formatsCount + ']').replace(regexSpecifier,'${specifier}-' + formatsCount);

            $(this).after(html);
            formatsCount += 1;
            //$(this).hide();
            //e.stopImmediatePropagation()
        });
    });
</script>
