<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="identifier" required="false"
              type="edu.pitt.isg.mdc.v1_0.Identifier" %>
<%@ attribute name="identifiers" required="false"
              type="java.util.ArrayList" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>
<%@ attribute name="unbounded" required="false"
              type="java.lang.Boolean" %>

<c:choose>
    <c:when test="${not empty identifiers}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <c:forEach items="${identifiers}" var="singleIdentifier" varStatus="varStatus">
                <div class="form-group control-group ${specifier}-identifier-add-more">
                    <c:choose>
                        <c:when test="${varStatus.first}">
                            <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add
                                    ${label}
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-danger ${specifier}-identifier-remove" type="button"><i
                                    class="glyphicon glyphicon-remove"></i>
                                Remove
                            </button>
                        </c:otherwise>
                    </c:choose>

                    <div class="form-group edit-form-group">
                        <label>Identifier</label>
                        <input type="text" class="form-control" value="${singleIdentifier.identifier}"
                               name="${path}[${varStatus.count-1}].identifier" placeholder="Identifier">
                    </div>

                    <div class="form-group edit-form-group">
                        <label>Identifier Source</label>
                        <input type="text" class="form-control" value="${singleIdentifier.identifierSource}"
                               name="${path}[${varStatus.count-1}].identifierSource" placeholder="Identifier Source">
                    </div>

                    <div class="form-group edit-form-group">
                        <label>Identifier Description</label>
                        <input type="text" class="form-control" value="${singleIdentifier.identifierDescription}"
                               name="${path}[${varStatus.count-1}].identifierDescription" placeholder="Identifier Description">
                    </div>

                </div>
                <c:set var="identifierCount" scope="page" value="${varStatus.count}"/>

            </c:forEach>
        </div>
    </c:when>
    <c:when test="${not empty identifier}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="input-group control-group ${specifier}-identifier-add-more" style="display: none;">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
            <div class="form-group control-group">
                <button class="btn btn-danger ${specifier}-identifier-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>

                <div class="form-group edit-form-group">
                    <label>Identifier</label>
                    <input type="text" class="form-control" value="${identifier.identifier}"
                           name="${path}.identifier"
                           placeholder="Identifier">
                </div>

                <div class="form-group edit-form-group">
                    <label>Identifier Source</label>
                    <input type="text" class="form-control" value="${identifier.identifierSource}"
                           name="${path}.identifierSource" placeholder="Identifier Source">
                </div>

                <div class="form-group edit-form-group">
                    <label>Identifier Description</label>
                    <input type="text" class="form-control" value="${identifier.identifierDescription}"
                           name="${path}.identifierDescription" placeholder="Identifier Description">
                </div>
            </div>
        </div>
        <c:set var="identifierCount" scope="page" value="0"/>

    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="input-group control-group ${specifier}-identifier-add-more">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
        </div>
        <c:set var="identifierCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>


<div class="${specifier}-copy-identifier hide">
    <div class="form-group control-group">
        <button class="btn btn-danger identifier-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>

        <div class="form-group edit-form-group">
            <label>Identifier</label>
            <input type="text" class="form-control" name="${path}.identifier"
                   placeholder="Identifier">
        </div>

        <div class="form-group edit-form-group">
            <label>Identifier Source</label>
            <input type="text" class="form-control"
                   name="${path}.identifierSource"
                   placeholder="Identifier Source">
        </div>

        <div class="form-group edit-form-group">
            <label>Identifier Description</label>
            <input type="text" class="form-control"
                   name="${path}.identifierDescription"
                   placeholder="Identifier Description">
        </div>

    </div>
</div>


<script type="text/javascript">

    $(document).ready(function () {
        var identifierCount = ${identifierCount};
        $("body").on("click", ".${specifier}-add-identifier", function (e) {
            var html = $(".${specifier}-copy-identifier").html();
            //Add section
            <c:choose>
            <c:when test="${unbounded}">
            html = html.replace("identifier-remove", "${specifier}-identifier-remove");
            $(".${specifier}-identifier-add-more").after(html);
            identifierCount += 1;
            </c:when>
            <c:otherwise>
            html = html.replace("identifier-remove", "${specifier}-identifier-remove");
            $(".${specifier}-identifier-add-more").after(html);
            $(".${specifier}-identifier-add-more").hide();
            </c:otherwise>
            </c:choose>
            e.stopImmediatePropagation();
        });
        //Remove section
        $("body").on("click", ".${specifier}-identifier-remove", function () {
            $(this).parents(".control-group")[0].remove();
            $(".${specifier}-identifier-add-more").show();
        });
    });

</script>