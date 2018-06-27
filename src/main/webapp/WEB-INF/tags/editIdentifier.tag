<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="identifier" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Identifier" %>
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
<%@ attribute name="identifierName" required="false"
              type="java.lang.String" %>
<%@ attribute name="identifierSource" required="false"
              type="java.lang.String" %>
<c:choose>
    <c:when test="${not empty identifiers}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <c:forEach items="${identifiers}" var="singleIdentifier" varStatus="varStatus">
                <div class="form-group control-group ${specifier}-identifier-add-more-button">
                    <c:choose>
                        <c:when test="${varStatus.first}">
                            <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add
                                    ${label}
                            </button>
                        </c:when>
                    </c:choose>
                </div>
                <div class="form-group control-group">
                    <button class="btn btn-danger ${specifier}-identifier-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
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

                </div>
                <c:set var="identifierCount" scope="page" value="${varStatus.count}"/>

            </c:forEach>
            <div class="${specifier}-identifier-add-more">
            </div>
        </div>
    </c:when>
    <c:when test="${not empty identifier}">
        <div class="form-group edit-form-group  ${status.error ? 'has-error' : ''}">
            <label>${label}</label>
            <div class="input-group control-group ${specifier}-identifier-add-more-button" style="display: none;">
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
            </div>
            <div class="${specifier}-identifier-add-more">
            </div>
        </div>
        <c:set var="identifierCount" scope="page" value="0"/>

    </c:when>
    <c:when test="${not empty identifierName or not empty identifierSource}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="input-group control-group ${specifier}-identifier-add-more-button" style="display: none;">
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
                    <input type="text" class="form-control" value="${identifierName}"
                           name="${path}.identifier"
                           placeholder="Identifier">
                </div>

                <div class="form-group edit-form-group">
                    <label>Identifier Source</label>
                    <input type="text" class="form-control" value="${identifierSource}"
                           name="${path}.identifierSource" placeholder="Identifier Source">
                </div>
            </div>
            <div class="${specifier}-identifier-add-more">
            </div>
        </div>
        <c:set var="identifierCount" scope="page" value="0"/>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group  ${status.error ? 'has-error' : ''}">
            <label>${label}</label>
            <div class="input-group control-group ${specifier}-identifier-add-more-button">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
            <br>
            <div class="${specifier}-identifier-add-more">
            </div>
        </div>
        <c:set var="identifierCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>


<div class="copy-identifier hide">
    <div class="form-group control-group">
        <%--<br>--%>
        <button class="btn btn-danger identifier-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>

        <div class="form-group edit-form-group">
            <label>Identifier</label>
            <input type="text" class="form-control" name="specifier-identifier"
                   placeholder="Identifier">
        </div>

        <div class="form-group edit-form-group">
            <label>Identifier Source</label>
            <input type="text" class="form-control"
                   name="specifier-identifierSource"
                   placeholder="Identifier Source">
        </div>

    </div>
</div>


<script type="text/javascript">

    $(document).ready(function () {
        var identifierCount = ${identifierCount};
        $("body").on("click", ".${specifier}-add-identifier", function (e) {
            var html = $(".copy-identifier").html();
            //Add section
            <c:choose>
            <c:when test="${unbounded}">
            html = html.replace('name="specifier-identifier"', 'name="${path}[' + identifierCount + '].identifier"').replace('name="specifier-identifierSource"', 'name="${path}[' + identifierCount + '].identifierSource"').replace("identifier-remove", "${specifier}-identifier-remove");
            <%--$(".${specifier}-identifier-add-more").after(html);--%>
            $(".${specifier}-identifier-add-more").before(html);
            identifierCount += 1;
            </c:when>
            <c:otherwise>
            html = html.replace('name="specifier-identifier"', 'name="${path}.identifier"').replace('name="specifier-identifierSource"', 'name="${path}.identifierSource"').replace("identifier-remove", "${specifier}-identifier-remove");
            <%--$(".${specifier}-identifier-add-more").after(html);--%>
            $(".${specifier}-identifier-add-more").before(html);
            $(".${specifier}-identifier-add-more-button").hide();
            </c:otherwise>
            </c:choose>
            e.stopImmediatePropagation();
        });
        //Remove section
        $("body").on("click", ".${specifier}-identifier-remove", function () {
            $(this).parents(".control-group")[0].remove();
            $(".${specifier}-identifier-add-more-button").show();
        });
    });

</script>