<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="formats" required="false"
              type="java.util.List" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>

<div class="form-group edit-form-group">
    <label>${label}</label>
    <div id="${specifier}-add-input-button" class="form-group ${specifier}-formats-add-more-button">
        <button class="btn btn-success ${specifier}-add-formats" type="button"><i
                class="glyphicon glyphicon-plus"></i> Add
            ${label}
        </button>
    </div>
    <c:set var="formatsCount" scope="page" value="0"/>


    <c:forEach items="${formats}" varStatus="varStatus" var="format">
        <div id="${specifier}-${varStatus.count-1}-tag" class="form-group">
            <c:if test="${not function:isObjectEmpty(format)}">
                <myTags:editNonZeroLengthString path="${path}[${varStatus.count-1}]"
                                                specifier="${specifier}-${varStatus.count-1}"
                                                placeholder="${placeholder}"
                                                string="${format}"
                                                isUnboundedList="true">
                </myTags:editNonZeroLengthString>
            </c:if>
            <c:set var="formatsCount" scope="page" value="${varStatus.count}"/>
        </div>
    </c:forEach>
    <div class="${specifier}-formats-add-more"></div>
</div>

<myTags:editNonZeroLengthString path="${path}[0]"
                                specifier="${specifier}-0"
                                placeholder="${placeholder}"
                                isUnboundedList="true"
                                id="${specifier}-copy-tag"
                                label="${label}">
</myTags:editNonZeroLengthString>

<script type="text/javascript">
    $(document).ready(function () {
        var formatsCount = ${formatsCount};
        //Show/Hide Formats
        $("body").on("click", ".${specifier}-add-formats", function () {
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $("#" + specifier + "-copy-tag").html();
            <%--var html = $("#${specifier}-0-tag").html();--%>
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}[' + formatsCount + ']').replace(regexSpecifier, '${specifier}-' + formatsCount).replace("hide", "");

            $(".${specifier}-formats-add-more").before(html);
            formatsCount += 1;
        });


    });
</script>
