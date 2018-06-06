<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="identifiers" required="false"
              type="java.util.ArrayList" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="false"
              type="java.lang.String" %>
<%@ attribute name="required" required="false"
              type="java.lang.Boolean" %>
<c:choose>
    <c:when test="${not empty identifiers}">
        <div class="form-group edit-form-group  ${status.error ? 'has-error' : ''}">
            <label>${label}</label>
            <button class="btn btn-success ${specifier}-add-nested-identifier" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add ${placeholder}
            </button>
            <br><br>
            <div class=" ${specifier}-nested-identifier-add-more">
                <c:forEach items="${identifiers}" var="identifier" varStatus="status">
                    <div class="form-group  control-group edit-form-group">
                        <label>${placeholder}</label>
                        <button class="btn btn-danger ${specifier}-nested-remove" type="button"><i
                                class="glyphicon glyphicon-remove"></i> Remove
                        </button>
                        <myTags:editSoftwareIdentifier label="Identifier" path="${path}[${status.count-1}].identifier"
                                                       identifier="${identifier.identifier}"
                                                       specifier="${specifier}-nested-identifier-${status.count-1}"></myTags:editSoftwareIdentifier>
                    </div>
                    <c:set var="nestedIdentifierCount" scope="page" value="${status.count}"/>
                </c:forEach>
            </div>
        </div>

    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <button class="btn btn-success ${specifier}-add-nested-identifier" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add ${placeholder}
            </button>
            <div class="form-group ${specifier}-nested-identifier-add-more">
            </div>
            <c:set var="nestedIdentifierCount" scope="page" value="0"/>
        </div>
    </c:otherwise>
</c:choose>

<div class="${specifier}-copy-nested-identifier hide">
    <div class="form-group  control-group edit-form-group">
        <label>${placeholder}</label>
        <button class="btn btn-danger ${specifier}-nested-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i> Remove
        </button>

        <myTags:editSoftwareIdentifier label="Identifier" path="${path}"
                                       specifier="${specifier}-nested-identifier"></myTags:editSoftwareIdentifier>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var nestedIdentifierCount = ${nestedIdentifierCount};

        $(".${specifier}-add-nested-identifier").click(function () {
            var html = $(".${specifier}-copy-nested-identifier").html();
            var regexSpecifier = new RegExp("${specifier}" + '-nested-identifier', "g");
            var regexPath = new RegExp("name=\"${path}", "g");
            html = html.replace(regexPath, 'name="${path}[' + nestedIdentifierCount + '].identifier').replace(regexSpecifier, '${specifier}-nested-identifier-' + nestedIdentifierCount);
            nestedIdentifierCount += 1;

            $(".${specifier}-nested-identifier-add-more").after(html);
        });

        //Remove section
        $("body").on("click", ".${specifier}-nested-remove", function () {
            $(this).parents(".control-group").remove();
        });

    })
</script>