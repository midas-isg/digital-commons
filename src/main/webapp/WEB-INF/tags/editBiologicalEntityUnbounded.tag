<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="entityList" required="false"
              type="java.util.List" %>
<%--
    changed name to label
--%>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>



<div class="form-group edit-form-group">
    <label>${label}</label>
    <button class="btn btn-success ${specifier}-add-entity" type="button"><i
            class="glyphicon glyphicon-plus"></i> Add
        ${label}
    </button>
    <c:set var="entityCount" value="0"/>

    <c:forEach items="${entityList}" var="entity" varStatus="varStatus">
        <c:if test="${not function:isObjectEmpty(entity)}">

            <myTags:editBiologicalEntity label="${label}"
                                         specifier="${specifier}-${varStatus.count-1}"
                                         path="${path}[${varStatus.count-1}]"
                                         entity="${entity}"
                                         isUnboundedList="true">
            </myTags:editBiologicalEntity>

            <c:set var="entityCount" scope="page" value="${varStatus.count}"/>
        </c:if>

    </c:forEach>
    <div class="${specifier}-entity-add-more">
    </div>
</div>

<myTags:editBiologicalEntity label="${label}"
                             specifier="${specifier}-0"
                             path="${path}[0]"
                             id="${specifier}-copy-tag"
                             isUnboundedList="true">
</myTags:editBiologicalEntity>


<script type="text/javascript">
    $(document).ready(function () {

        var entityCount = ${entityCount};
        //Show/Hide Values
        $("body").on("click", ".${specifier}-add-entity", function (e) {
            e.stopImmediatePropagation();

            var specifier = "${specifier}";
            var path = "${path}";
            var html = $("#${specifier}-copy-tag").html();
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}['+ entityCount + ']')
                .replace(regexSpecifier,'${specifier}-' + entityCount + '-')
                .replace("hide", "");
            entityCount += 1;

            $(".${specifier}-entity-add-more").before(html);
        });
        $("body").on("click", ".entity-remove", function () {
            clearAndHideEditControlGroup(this);
        });


    });
</script>
<%--
<c:choose>
    &lt;%&ndash;<c:when test="${not empty entities and not empty entities[0].name}">&ndash;%&gt;
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
                        <myTags:editNonZeroLengthString string="${entity.description}"
                                                        path="${path}[${varStatus.count-1}].description"
                                                        label="Description"
                                                        placeholder="Description"
                                                        specifier="${specifier}-${varStatus.count-1}">
                        </myTags:editNonZeroLengthString>
                    </div>

                    <div class="form-group">
                        <myTags:editIdentifierUnbounded identifier="${entity.identifier}"
                                                        path="${path}[${varStatus.count-1}].identifier"
                                                        specifier="${specifier}-${varStatus.count-1}"
                                                        label="Identifier">
                        </myTags:editIdentifierUnbounded>
                    </div>

                    <div class="form-group">
                        <myTags:editIdentifierUnbounded path="${path}[${varStatus.count-1}].alternateIdentifiers"
                                                        unbounded="${true}"
                                                        specifier="${specifier}-alternate-${varStatus.count-1}"
                                                        identifiers="${entity.alternateIdentifiers}"
                                                        label="Alternate Identifier">
                        </myTags:editIdentifierUnbounded>
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
            <myTags:editNonZeroLengthString path="${path}[0].description"
                                            label="Description"
                                            placeholder="Description"
                                            specifier="${specifier}-null">
            </myTags:editNonZeroLengthString>
        </div>

        <div class="form-group">
            <myTags:editIdentifierUnbounded path="${path}[0].identifier"
                                            specifier="${specifier}-null"
                                            label="Identifier">
            </myTags:editIdentifierUnbounded>
        </div>

        <div class="form-group">
            <myTags:editIdentifierUnbounded path="${path}[0].alternateIdentifiers"
                                            unbounded="${true}"
                                            specifier="${specifier}-null-alternate"
                                            label="Alternate Identifier">
            </myTags:editIdentifierUnbounded>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var count = ${entityCount};
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
            clearAndHideEditControlGroup(this);
            // $(this).parents(".control-group").remove();
        });

    });
</script>
--%>
