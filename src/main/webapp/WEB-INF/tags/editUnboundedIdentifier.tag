<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="identifiers" required="false"
              type="java.util.List" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>


<div class="form-group edit-form-group">
    <label>${label}</label>
    <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
            class="glyphicon glyphicon-plus"></i> Add
        ${label}
    </button>
    <c:set var="identifierCount" value="0"/>

    <c:forEach items="${identifiers}" var="singleIdentifier" varStatus="varStatus">
        <c:if test="${not function:isObjectEmpty(singleIdentifier)}">

            <myTags:editIdentifier singleIdentifier="${singleIdentifier}"
                                   specifier="${specifier}-${varStatus.count-1}"
                                   isUnboundedList="true"
                                   path="${path}[${varStatus.count-1}]">
            </myTags:editIdentifier>

            <c:set var="identifierCount" scope="page" value="${varStatus.count}"/>
        </c:if>

    </c:forEach>
    <div class="${specifier}-identifier-add-more">
    </div>
</div>

<myTags:editIdentifier specifier="${specifier}-0"
                       isUnboundedList="true"
                       id="${specifier}-copy-tag"
                       path="${path}[0]">
</myTags:editIdentifier>


<script type="text/javascript">

    $(document).ready(function () {
        var identifierCount = ${identifierCount};

        //Add section
        $("body").on("click", ".${specifier}-add-identifier", function () {
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $("#" + specifier + "-copy-tag").html();
            <%--var html = $("#${specifier}-0-tag").html();--%>
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}[' + identifierCount + ']').replace(regexSpecifier, '${specifier}-' + identifierCount).replace("hide", "");

            $(".${specifier}-identifier-add-more").before(html);
            identifierCount += 1;

        });
    });

</script>