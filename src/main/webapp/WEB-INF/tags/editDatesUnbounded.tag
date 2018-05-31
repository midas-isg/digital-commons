<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="dates" required="false"
              type="java.util.ArrayList" %>

<c:choose>
    <c:when test="${not empty dates}">
        <c:forEach items="${dates}" var="date" varStatus="status">
            <c:if test="${status.first}">
                <div class="form-group edit-form-group">
                <label>Dates</label>
                <div class="form-group control-group ${specifier}-date-add-more">
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add-date" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            Date
                        </button>
                    </div>
                </div>
            </c:if>

            <div class="form-group control-group edit-form-group">
                <label>Date</label>
                <button class="btn btn-danger ${specifier}-date--remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
                <br><br>
                <myTags:editDates path="${path}.dates[${status.count-1}]" date="${date}" specifier="${specifier}-date-"></myTags:editDates>
            </div>
            <c:set var="unboundedDateCount" scope="page" value="${status.count}"/>
        </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>Dates</label>
            <div class="form-group control-group ${specifier}-date-add-more">
                <div class="form-group">
                    <button class="btn btn-success ${specifier}-add-date" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Date
                    </button>
                </div>
            </div>
        </div>
        <c:set var="unboundedDateCount" scope="page" value="0"/>
    </c:otherwise>
</c:choose>


<div class="${specifier}-copy-date hide">
    <div class="form-group control-group edit-form-group">
        <label>Date</label>
        <button class="btn btn-danger ${specifier}-date--remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <myTags:editDates path="${path}.dates[0]" specifier="${specifier}-date-"></myTags:editDates>
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
        var unboundedDateCount = ${unboundedDateCount};
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
