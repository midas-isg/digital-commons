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

<c:choose>
    <c:when test="${not function:isObjectEmpty(annotations)}">
        <c:forEach items="${annotations}" var="annotation" varStatus="varStatus">
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
            <c:if test="${not function:isObjectEmpty(annotation)}">
                <div class="form-group control-group edit-form-group">
                    <myTags:editAnnotation annotation="${annotation}"
                                           supportError="${true}"
                                           specifier="${specifier}-${varStatus.count-1}"
                                           label="${label}"
                                           showRemoveButton="true"
                                           path="${path}[${varStatus.count-1}]">
                    </myTags:editAnnotation>
                </div>
                <c:set var="annotationCount" scope="page" value="${varStatus.count}"/>
            </c:if>
        </c:forEach>
        <div class="${specifier}-annotation-add-more">
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    ${label}
                </button>
            </div>
            <div class="${specifier}-annotation-add-more">
            </div>
        </div>
        <c:set var="annotationCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>


<div class="${specifier}-copy hide">
    <div class="form-group control-group edit-form-group">
        <myTags:editAnnotation path="${path}[0]"
                               specifier="${specifier}-0"
                               label="${label}"
                               showRemoveButton="true">
        </myTags:editAnnotation>
    </div>
</div>



<script type="text/javascript">
    $(document).ready(function () {

        var annotationCount = ${annotationCount};
        //Show/Hide Values
        $("body").on("click", ".${specifier}-add", function (e) {
            e.stopImmediatePropagation();

            var specifier = "${specifier}";
            var path = "${path}";
            var html = $(".${specifier}-copy").html();
            // path = path.replace('[','\\[').replace(']','\\]');
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}['+ annotationCount + ']')
                .replace(regexSpecifier,'${specifier}-' + annotationCount + '-');
            annotationCount += 1;

            // $(this).after(html);
            $(".${specifier}-annotation-add-more").before(html);
        });

    });
</script>