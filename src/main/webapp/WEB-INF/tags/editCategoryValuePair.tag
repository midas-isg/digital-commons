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
<%@ attribute name="categoryValuePairs" required="false"
              type="java.util.List" %>

<c:choose>
    <c:when test="${not function:isObjectEmpty(categoryValuePairs)}">

        <c:choose>
            <c:when test="${not empty flowRequestContext.messageContext.allMessages}">
                <div class="has-error">
                <c:forEach items="${flowRequestContext.messageContext.allMessages}" var="message">
                    <span class="error-color">${message.text}</span>
                </c:forEach>
                </div>
            </c:when>
        </c:choose>

        <c:forEach items="${categoryValuePairs}" var="categoryValuePair" varStatus="varStatus">
            <c:if test="${varStatus.first}">
                <div class="form-group edit-form-group">
                    <label>${label}</label>
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                        </button>
                    </div>
                </div>
            </c:if>
            <div class="form-group control-group edit-form-group">
                <label>${label}</label>
                <div class="form-group">
                    <button class="btn btn-danger categoryValuePair-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                </div>
                <myTags:editNonRequiredNonZeroLengthString label="Category" placeholder=" A characteristic or property about the entity this object is associated with."
                                                           specifier="${specifier}-${varStatus.count-1}-category"
                                                           path="${path}[${varStatus.count-1}].category"
                                                           string="${categoryValuePair.category}">
                </myTags:editNonRequiredNonZeroLengthString>
                <myTags:editNonRequiredNonZeroLengthString label="CategoryIRI" placeholder=" The IRI corresponding to the category, if associated with an ontology term."
                                                           specifier="${specifier}-${varStatus.count-1}-categoryIRI"
                                                           path="${path}[${varStatus.count-1}].categoryIRI"
                                                           string="${categoryValuePair.categoryIRI}">
                </myTags:editNonRequiredNonZeroLengthString>
                <myTags:editAnnotationUnbounded path="${path}[${varStatus.count-1}].values"
                                                specifier="${specifier}-${varStatus.count-1}-values"
                                                label="Value"
                                                annotations="${categoryValuePair.values}">
                </myTags:editAnnotationUnbounded>

            </div>
            <div class="${specifier}-categoryValuePair-add-more">
            </div>
            <c:set var="categoryValuePairCount" scope="page" value="${varStatus.count}"/>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Extra Properties
                </button>
            </div>
            <div class="${specifier}-categoryValuePair-add-more">
            </div>
        </div>
        <c:set var="categoryValuePairCount" scope="page" value="0"/>
    </c:otherwise>
</c:choose>

<div class="${specifier}-copy hide">
    <div class="form-group control-group edit-form-group">
        <label>${label}</label>
        <div class="form-group">
            <button class="btn btn-danger categoryValuePair-remove" id="${specifier}-0-remove" type="button"><i
                    class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
        <myTags:editNonRequiredNonZeroLengthString label="Category" placeholder=" A characteristic or property about the entity this object is associated with."
                                                   specifier="${specifier}-0-category"
                                                   path="${path}[0].category">
        </myTags:editNonRequiredNonZeroLengthString>
        <myTags:editNonRequiredNonZeroLengthString label="CategoryIRI" placeholder=" The IRI corresponding to the category, if associated with an ontology term."
                                                   specifier="${specifier}-0-categoryIRI"
                                                   path="${path}[0].categoryIRI">
        </myTags:editNonRequiredNonZeroLengthString>
        <myTags:editAnnotationUnbounded path="${path}[0].values"
                                        specifier="${specifier}-0-values"
                                        label="Value">
        </myTags:editAnnotationUnbounded>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {

        var categoryValuePairCount = ${categoryValuePairCount};
        //Show/Hide categoryValuePair
        $("body").on("click", ".${specifier}-add", function (e) {
            e.stopImmediatePropagation()

            var specifier = "${specifier}";
            var path = "${path}";
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var html = $(".${specifier}-copy").html();
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}['+ categoryValuePairCount + ']')
                .replace(regexSpecifier,'${specifier}-' + categoryValuePairCount);

            // $(this).after(html);
            $(".${specifier}-categoryValuePair-add-more").before(html);
            //$(this).hide();
            categoryValuePairCount += 1;
        });
        $("body").on("click", ".categoryValuePair-remove", function () {
            clearAndHideEditControlGroup(this);
            //$(".${specifier}-0-add").show();
        });

    });
</script>