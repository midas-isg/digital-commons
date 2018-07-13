<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entities" required="false"
              type="java.util.List" %>
<%@ attribute name="name" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>

<c:choose>
    <%--<c:when test="${not empty entities and not empty entities[0].name}">--%>
    <c:when test="${not empty entities}">
        <div class="form-group edit-form-group">
            <label>${name}</label>
        <c:forEach items="${entities}" var="entity" varStatus="varStatus">
            <c:choose>
                <c:when test="${varStatus.first}">
                    <div class="form-group control-group">
                        <button class="btn btn-success ${specifier}-add-biological-entity" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add ${name}
                        </button>
                    </div>
                </c:when>
            </c:choose>
            <div class="form-group control-group">
                <button class="btn btn-danger  ${specifier}-biological-entity-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            <div class="form-group control-group edit-form-group">
                <c:choose>
                    <c:when test="${not empty entity.name}">
                        <myTags:editRequiredNonZeroLengthString placeholder=" Name"
                                                                label="Name"
                                                                string="${entity.name}"
                                                                path="${path}[${varStatus.count-1}].name">
                        </myTags:editRequiredNonZeroLengthString>
                    </c:when>
                    <c:otherwise>
                        <myTags:editRequiredNonZeroLengthString placeholder=" Name"
                                                                label="Name"
                                                                path="${path}[${varStatus.count-1}].name">
                        </myTags:editRequiredNonZeroLengthString>
                    </c:otherwise>
                </c:choose>
                    <div class="form-group">
                        <myTags:editNonRequiredNonZeroLengthString string="${entity.description}"
                                                                   path="${path}[${varStatus.count-1}].description"
                                                                   label="Description"
                                                                   placeholder="Description"
                                                                   specifier="${specifier}-${varStatus.count-1}">
                        </myTags:editNonRequiredNonZeroLengthString>
                    </div>

                    <div class="form-group">
                        <myTags:editIdentifier identifier="${entity.identifier}"
                                               path="${path}[${varStatus.count-1}].identifier"
                                               specifier="${specifier}-${varStatus.count-1}"
                                               label="Identifier">
                        </myTags:editIdentifier>
                    </div>

                    <div class="form-group">
                        <myTags:editIdentifier path="${path}[${varStatus.count-1}].alternateIdentifiers"
                                               unbounded="${true}"
                                               specifier="${specifier}-alternate-${varStatus.count-1}"
                                               identifiers="${entity.alternateIdentifiers}"
                                               label="Alternate Identifier">
                        </myTags:editIdentifier>
                    </div>
                </div>
            </div>
            <c:set var = "count" scope = "page" value = "${varStatus.count}"/>
        </c:forEach>
            <div class="${specifier}-biological-entity-add-more">
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${name}</label>
            <br>
            <button class="btn btn-success ${specifier}-add-biological-entity" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add ${name}
            </button>
            <div class="${specifier}-biological-entity-add-more">
            </div>
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
            <myTags:editRequiredNonZeroLengthString placeholder="Name"
                                                    label="Name"
                                                    path="${path}[0].name">
            </myTags:editRequiredNonZeroLengthString>
        <div class="form-group">
            <myTags:editNonRequiredNonZeroLengthString path="${path}[0].description"
                                                       label="Description"
                                                       placeholder="Description"
                                                       specifier="${specifier}-null">
            </myTags:editNonRequiredNonZeroLengthString>
        </div>

        <div class="form-group">
            <myTags:editIdentifier path="${path}[0].identifier"
                                   specifier="${specifier}-null"
                                   label="Identifier">
            </myTags:editIdentifier>
        </div>

        <div class="form-group">
            <myTags:editIdentifier path="${path}[0].alternateIdentifiers"
                                   unbounded="${true}"
                                   specifier="${specifier}-null-alternate"
                                   label="Alternate Identifier">
            </myTags:editIdentifier>
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
            regex = new RegExp(specifier + '-null', "g");
            html = html.replace(regex, specifier + '-' + count);
            <%--$(".${specifier}-biological-entity-add-more").after(html);--%>
            $(".${specifier}-biological-entity-add-more").before(html);
            count += 1;
        });

        //Remove section
        $("body").on("click", ".${specifier}-biological-entity-remove", function () {
            $(this).parents(".control-group").remove();
        });

    });
</script>