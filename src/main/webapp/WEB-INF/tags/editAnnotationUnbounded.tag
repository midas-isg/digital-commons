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
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="annotations" required="false"
              type="java.util.List" %>


<div class="form-group edit-form-group">
    <label>${label}</label>
    <div id="${specifier}-add-input-button" class="form-group ${specifier}-annotation-add-more-button">
        <button class="btn btn-success ${specifier}-add-annotation" type="button"><i
                class="glyphicon glyphicon-plus"></i> Add
            ${label}
        </button>
    </div>
    <c:set var="annotationCount" scope="page" value="0"/>


    <c:forEach items="${annotations}" varStatus="varStatus" var="annotation">
        <div id="${specifier}-${varStatus.count-1}-tag" class="form-group">
            <c:if test="${not function:isObjectEmpty(annotation)}">
                <myTags:editAnnotation annotation="${annotation}"
                                       specifier="${specifier}-${varStatus.count-1}"
                                       label="${label}"
                                       isUnboundedList="true"
                                       id="${specifier}-${varStatus.count-1}"
                                       path="${path}[${varStatus.count-1}]">
                </myTags:editAnnotation>
            </c:if>
            <c:set var="annotationCount" scope="page" value="${varStatus.count}"/>
        </div>
    </c:forEach>
    <div class="${specifier}-annotation-add-more"></div>
</div>

<myTags:editAnnotation specifier="${specifier}-0"
                       label="${label}"
                       isUnboundedList="true"
                       id="${specifier}-copy-tag"
                       path="${path}[0]">
</myTags:editAnnotation>

<script type="text/javascript">
    $(document).ready(function () {
        var annotationCount = ${annotationCount};
        //Show/Hide Formats
        $("body").on("click", ".${specifier}-add-annotation", function () {
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $("#" + specifier + "-copy-tag").html();
            <%--var html = $("#${specifier}-0-tag").html();--%>
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}[' + annotationCount + ']').replace(regexSpecifier, '${specifier}-' + annotationCount).replace("hide", "");

            $(".${specifier}-annotation-add-more").before(html);
            annotationCount += 1;
        });


    });
</script>
