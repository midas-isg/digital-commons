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
<%@ attribute name="label" required="true"
              type="java.lang.String" %>


<div class="form-group edit-form-group">
    <label>${label}</label>
    <div id="${specifier}-add-input-button" class="form-group ${specifier}-date-add-more-button">
        <button class="btn btn-success ${specifier}-add-date" type="button"><i
                class="glyphicon glyphicon-plus"></i> Add
            ${label}
        </button>
    </div>
    <c:set var="dateCount" scope="page" value="0"/>


    <c:forEach items="${dates}" varStatus="varStatus" var="date">
        <div id="${specifier}-${varStatus.count-1}-tag" class="form-group">
            <c:if test="${not function:isObjectEmpty(date)}">
                <myTags:editDates date="${date}"
                                  specifier="${specifier}-${varStatus.count-1}"
                                  isUnboundedList="true"
                                  id="${specifier}-${varStatus.count-1}"
                                  path="${path}[${varStatus.count-1}]">
                </myTags:editDates>
            </c:if>
            <c:set var="dateCount" scope="page" value="${varStatus.count}"/>
        </div>
    </c:forEach>
    <div class="${specifier}-date-add-more"></div>
</div>

<myTags:editDates path="${path}[0]"
                  specifier="${specifier}-0"
                  isUnboundedList="true"
                  id="${specifier}-copy-tag">
</myTags:editDates>


<script type="text/javascript">
    $(document).ready(function () {
        var unboundedDateCount = ${dateCount};
        //Show/Hide Date
        $("body").on("click", ".${specifier}-add-date", function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $("#${specifier}-copy-tag").html();
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}[' + unboundedDateCount + ']').replace(regexSpecifier, '${specifier}-' + unboundedDateCount);

            $(".${specifier}-date-add-more").before(html);
            e.stopImmediatePropagation();

            unboundedDateCount += 1;
        });
    });
</script>
