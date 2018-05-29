<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entities" required="false"
              type="java.util.ArrayList" %>
<%@ attribute name="name" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>

<c:choose>
    <c:when test="${not empty entities and not empty entities[0].name}">
        <c:forEach items="${entities}" var="entity" varStatus="status">
                <c:choose>
                    <c:when test="${status.first}">
                        <div class="form-group control-group edit-form-group ${specifier}-biological-entity-add-more">
                        <label>${name}</label>
                        <br>
                        <button class="btn btn-success ${specifier}-add-biological-entity" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add ${name}
                        </button>
                    </c:when>
                    <c:otherwise>
                        <div class="form-group control-group edit-form-group">
                        <label>${name}</label>
                        <br>
                        <button class="btn btn-danger  ${specifier}-biological-entity-remove" type="button"><i
                                class="glyphicon glyphicon-remove"></i>
                            Remove
                        </button>
                    </c:otherwise>
                </c:choose>

                <div class="form-group control-group edit-form-group">
                    <div class="form-group edit-form-group">
                        <label>Name</label>
                        <input name="${specifier}[${status.count-1}].name" value="${entity.name}" type="text"
                               class="form-control" placeholder="Name">
                    </div>
                    <div class="form-group">
                        <myTags:editDescription description="${entity.description}"
                                                path="${path}[${status.count-1}].description"
                                                specifier="${specifier}-${status.count-1}"></myTags:editDescription>
                    </div>

                    <div class="form-group">
                        <myTags:editIdentifier identifier="${entity.identifier}"
                                               path="${path}[${status.count-1}].identifier"
                                               specifier="${specifier}-${status.count-1}"
                                               label="Identifier"></myTags:editIdentifier>
                    </div>

                    <div class="form-group">
                        <myTags:editIdentifier path="${path}[${status.count-1}].alternateIdentifiers"
                                               unbounded="${true}"
                                               specifier="${specifier}-alternate-${status.count-1}"
                                               label="Alternate Identifier"></myTags:editIdentifier>
                    </div>
                </div>
            </div>
            <c:set var = "count" scope = "page" value = "${status.count}"/>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group ${specifier}-biological-entity-add-more">
            <label>${name}</label>
            <br>
            <button class="btn btn-success ${specifier}-add-biological-entity" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add ${name}
            </button>
        </div>
        <c:set var = "count" scope = "page" value = "0"/>
    </c:otherwise>
</c:choose>


<div class="${specifier}-copy-biological-entity hide">
    <div class="form-group control-group edit-form-group">
        <label></label>
        <br>
        <button class="btn btn-danger biological-entity-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <div class="form-group edit-form-group">
            <label>Name</label>
            <input name="name" type="text" class="form-control" placeholder="Name">
        </div>
        <div class="form-group">
            <myTags:editDescription path="${path}[0].description"
                                    specifier="${specifier}-0"></myTags:editDescription>
        </div>

        <div class="form-group">
            <myTags:editIdentifier path="${path}[0].identifier"
                                   specifier="${specifier}-0"
                                   label="Identifier"></myTags:editIdentifier>
        </div>

        <div class="form-group">
            <myTags:editIdentifier path="${path}[0].alternateIdentifiers" unbounded="${true}"
                                   specifier="${specifier}-0-alternate"
                                   label="Alternate Identifier"></myTags:editIdentifier>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var count = ${count};
        var specifier = "${specifier}";

        //Add section
        $("body").on("click", ".${specifier}-add-biological-entity", function () {
            var html = $(".${specifier}-copy-biological-entity").html();
            html = html.replace('name="name"', 'name=${specifier}[' + count + '].name');
            var regex = new RegExp(specifier + '\\[0\\]', "g");
            html = html.replace('biological-entity-remove', '${specifier}-biological-entity-remove').replace("<label></label>", "<label>${name}</label>").replace(regex, specifier+'[' + count + ']');
            regex = new RegExp(specifier + '-0', "g");
            html = html.replace(regex, specifier + '-' + count);
            $(".${specifier}-biological-entity-add-more").after(html);
            count += 1;
        });

        //Remove section
        $("body").on("click", ".${specifier}-biological-entity-remove", function () {
            $(this).parents(".control-group").remove();
        });

    });
</script>