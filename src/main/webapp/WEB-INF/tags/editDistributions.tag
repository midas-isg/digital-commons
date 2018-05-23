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
            <myTags:editIdentifier name="Identifier" specifier="${specifier}-" path="${path}.identifier" unbounded="False"></myTags:editIdentifier>
        </div>
        <div class="form-group edit-form-group">
            <label>Dates</label>
            <div class="input-group control-group ${specifier}--date-add-more">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}--add-date" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Date
                    </button>
                </div>
            </div>
        </div>

        <div class="${specifier}--copy-date hide">
            <div class="form-group control-group edit-form-group">
                <label>Date</label>
                <br>
                <button class="btn btn-danger ${specifier}--date-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
                <myTags:editDates path="${path}.Date" specifier="${specifier}-date"></myTags:editDates>
            </div>
<script>
    //Show/Hide Date
    $("body").on("click", "${specifier}--add-date", function () {
        var htmlDate = $(".${specifier}--copy-date").html();

        $(this).after(htmlDate);
        $(this).hide();

        $(function() {
            $("#${specifier}--date-date-picker".datepicker({
                changeMonth:true,
                changeYear:true
            }));
        });
    });
    $("body").on("click", ".${specifier}--date-remove", function () {
        $(this).parent(".control-group").remove();
        $(".${specifier}--add-date").show();
    });
</script>
        </div>

    </div>
</div>



<script type="text/javascript">
    $(document).ready(function () {
        var distributionCount = 0;
        //Add section
        $(".add-distribution").click(function () {
            var html = $(".copy-distribution").html();
            html = html.replace(/${path}.identifier/g, '${path}['+ distributionCount + '].identifier').replace(/${specifier}--/g,'${specifier}-' + distributionCount + '-');
            html = html.replace(/${path}.date/g, '${path}['+ distributionCount + '].date');

            $(".distribution-add-more").after(html);
            distributionCount += 1;
        });

        //Remove section
        $("body").on("click", ".distribution-remove", function () {
            $(this).parents(".control-group").remove();
        });


    });
</script>