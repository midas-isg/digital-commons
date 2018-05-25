<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>



<div class="form-group edit-form-group">
    <label>Dates</label>
    <div class="input-group control-group ${specifier}-date-add-more">
        <div class="input-group-btn">
            <button class="btn btn-success ${specifier}-add-date" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Date
            </button>
        </div>
    </div>
</div>

<div class="${specifier}-copy-date hide">
    <div class="form-group control-group edit-form-group">
        <label>Date</label>
        <br>
        <button class="btn btn-danger ${specifier}-date--remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <div class="form-group">
            <myTags:editDates path="${path}.dates[0]" specifier="${specifier}-date-"></myTags:editDates>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-date--remove", function () {
                $(this).parent(".control-group").remove();
                //$(".${specifier}-add-date").show();
            });
        });
    </script>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var unboundedDateCount = 0;
        //Show/Hide Date
        $("body").on("click", ".${specifier}-add-date", function (e) {
            var specifier = "${specifier}-date";
            var path = "${path}.dates";
            var html = $(".${specifier}-copy-date").html();
            path = path.replace('[','\\[').replace(']','\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}.dates['+ unboundedDateCount + ']').replace(regexSpecifier,'${specifier}-date-' + unboundedDateCount);

            $(this).after(html);
            e.stopImmediatePropagation();

            $(function() {
                $("#${specifier}-date-" + unboundedDateCount + "-date-picker").datepicker({
                    changeMonth:true,
                    changeYear:true
                });
            });

            unboundedDateCount += 1;
        });
    });
</script>