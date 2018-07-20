<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="dates" required="false"
              type="java.util.List" %>

<c:choose>
    <c:when test="${not function:isObjectEmpty(dates)}">
        <c:forEach items="${dates}" var="date" varStatus="varStatus">
            <c:if test="${varStatus.first}">
                <div class="form-group edit-form-group">
                <label>Dates</label>
                <div class="form-group control-group ${specifier}-date-add-more-button">
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add-date" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            Date
                        </button>
                    </div>
                </div>
            </c:if>

            <c:if test="${not function:isObjectEmpty(dates[varStatus.count-1])}">
                <div class="form-group control-group edit-form-group">
                    <label>Date</label>
                    <button class="btn btn-danger ${specifier}-date--remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                    <br><br>
                    <myTags:editDates path="${path}[${varStatus.count-1}]"
                                      date="${date}"
                                      specifier="${specifier}-${varStatus.count-1}">
                    </myTags:editDates>
                </div>
                <c:set var="unboundedDateCount" scope="page" value="${varStatus.count}"/>
            </c:if>
        </c:forEach>
        <%--<c:set var="unboundedDateCount" scope="page" value="${varStatus.count}"/>--%>
        <div class="${specifier}-date-add-more"></div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>Dates</label>
            <div class="form-group control-group ${specifier}-date-add-more-button">
                <div class="form-group">
                    <button class="btn btn-success ${specifier}-add-date" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Date
                    </button>
                </div>
            </div>
            <div class="${specifier}-date-add-more"></div>
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
        <myTags:editDates path="${path}[0]"
                          specifier="${specifier}-">
        </myTags:editDates>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-date--remove", function () {
                // $(this).parent(".control-group").remove();
                clearAndHideEditControlGroup(this);
                //$(".${specifier}-add-date").show();
            });
        });
    </script>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var unbounded${specifier}DateCount = ${unboundedDateCount};
        //Show/Hide Date
        $("body").on("click", ".${specifier}-add-date", function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $(".${specifier}-copy-date").html();
            path = path.replace('[','\\[').replace(']','\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}['+ unbounded${specifier}DateCount + ']').replace(regexSpecifier,'${specifier}-' + unbounded${specifier}DateCount);

            //$(this).after(html);
            $(".${specifier}-date-add-more").before(html);
            e.stopImmediatePropagation();

            <%--$(function() {--%>
                <%--$("#${specifier}-date-" + unboundedDateCount + "-date-picker").datepicker({--%>
                    <%--changeMonth:true,--%>
                    <%--changeYear:true--%>
                <%--});--%>
            <%--});--%>

            unbounded${specifier}DateCount += 1;
        });
    });
</script>
