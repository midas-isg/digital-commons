<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="identifier" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Identifier" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="name" required="false"
              type="java.lang.String" %>
<%@ attribute name="unbounded" required="false"
              type="java.lang.Boolean" %>

<c:choose>
    <c:when test="${not empty identifier}">
        <div class="form-group edit-form-group">
        <label>${name}</label>
        <c:choose>
            <c:when test="${unbounded}">
                <c:forEach items="${identifier}" var="singleIdentifier" varStatus="status">
                    <div class="form-group control-group ${specifier}-identifier-add-more">
                        <c:choose>
                            <c:when test="${status.first}">
                                <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                        ${name}
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
                                   name="${path}.identifier" placeholder="Identifier">
                        </div>

                        <div class="form-group edit-form-group">
                            <label>Identifier Source</label>
                            <input type="text" class="form-control" value="${singleIdentifier.identifierSource}"
                                   name="${path}.identifierSource" placeholder="Identifier Source">
                        </div>

                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="input-group control-group ${specifier}-identifier-add-more" style="display: none;">
                    <div class="input-group-btn">
                        <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                                ${name}
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
            </c:otherwise>
        </c:choose>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${name}</label>
            <div class="input-group control-group ${specifier}-identifier-add-more">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                            ${name}
                    </button>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>


<div class="copy-identifier hide">
    <div class="form-group control-group">
        <button class="btn btn-danger identifier-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>

        <div class="form-group edit-form-group">
            <label>Identifier</label>
            <input type="text" class="form-control" value="${identifier.identifier}" name="identifier"
                   placeholder="Identifier">
        </div>

        <div class="form-group edit-form-group">
            <label>Identifier Source</label>
            <input type="text" class="form-control" value="${identifier.identifierSource}" name="identifierSource"
                   placeholder="Identifier Source">
        </div>

    </div>
</div>


<script type="text/javascript">

    $(document).ready(function () {
        var identifierCount = 0;
        $("body").on("click", ".${specifier}-add-identifier", function (e) {
            var html = $(".copy-identifier").html();
            //Add section
            <c:choose>
            <c:when test="${unbounded}">
            html = html.replace('name="identifier"', 'name="${path}[' + identifierCount + '].identifier"').replace('name="identifierSource"', 'name="${path}[' + identifierCount + '].identifierSource"').replace("identifier-remove", "${specifier}-identifier-remove");
            $(".${specifier}-identifier-add-more").after(html);
            identifierCount += 1;
            </c:when>
            <c:otherwise>
            html = html.replace('name="identifier"', 'name="${path}.identifier"').replace('name="identifierSource"', 'name="${path}.identifierSource"').replace("identifier-remove", "${specifier}-identifier-remove");
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