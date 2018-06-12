<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="strings" required="false"
              type="java.util.ArrayList" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>

<c:choose>
    <c:when test="${not empty strings}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group ${specifier}-formats-add-more">
                <button class="btn btn-success ${specifier}-add-formats" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${placeholder}
                </button>

                <c:forEach items="${strings}" varStatus="varStatus" var="format">
                <spring:bind path="${path}[${varStatus.count-1}]">

                    <div class="form-group  ${status.error ? 'has-error' : ''}">
                        <div class="input-group control-group full-width">
                            <c:choose>
                                <c:when test="${varStatus.first}">
                                    <br>
                                    <input type="text" value="${format}" class="form-control"
                                           name="${path}[${varStatus.count-1}]"
                                           id="${specifier}-${varStatus.count-1}" placeholder="${placeholder}"/>
                                </c:when>
                                <c:otherwise>
                                    <input type="text" value="${format}" class="form-control"
                                           name="${path}[${varStatus.count-1}]"
                                           id="${specifier}-${varStatus.count-1}" placeholder="${placeholder}"/>
                                    <div class="input-group-btn">
                                        <button class="btn btn-danger ${specifier}-remove"
                                                id="${specifier}-${varStatus.count-1}-remove"
                                                type="button"><i
                                                class="glyphicon glyphicon-remove"></i>
                                            Remove
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <form:errors path="${path}[${varStatus.count-1}]" class="error-color"/>
                </spring:bind>
                    <c:set var="formatsCount" scope="page" value="${varStatus.count}"/>
                </c:forEach>
            </div>

        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group ${specifier}-formats-add-more">
                <button class="btn btn-success ${specifier}-add-formats" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${placeholder}
                </button>
                <br><br>
                <spring:bind path="${path}[0]">

                    <div class="form-group  ${status.error ? 'has-error' : ''}">
                        <input type="text" class="form-control" name="${path}[0]" id="${specifier}-0"
                               placeholder="${placeholder}"/>
                    </div>
                    <form:errors path="${path}[0]" class="error-color"/>

                </spring:bind>
            </div>
        </div>
        <c:set var="formatsCount" scope="page" value="1"/>

    </c:otherwise>
</c:choose>


<div class="${specifier}-copy-formats hide">
    <div class="form-group">
        <div class="input-group control-group full-width">
            <input type="text" class="form-control" name="${path}[0]" id="${specifier}-0" placeholder="${placeholder}"/>
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-remove" id="${specifier}-0-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var formatsCount = ${formatsCount};
        //Show/Hide Formats
        $("body").on("click", ".${specifier}-add-formats", function () {
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $(".${specifier}-copy-formats").html();
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}[' + formatsCount + ']').replace(regexSpecifier, '${specifier}-' + formatsCount);

            $(".${specifier}-formats-add-more").after(html);
            formatsCount += 1;
            //$(this).hide();
            //e.stopImmediatePropagation()
        });


        //Hide Formats
        $("body").on("click", ".${specifier}-remove", function () {
            $(this).closest(".control-group").remove();
            //$(".${specifier}-add-formats").show();
        });
    });
</script>
