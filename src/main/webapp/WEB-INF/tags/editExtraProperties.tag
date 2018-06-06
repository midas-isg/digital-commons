<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="categoryValuePairs" required="false" type="java.util.ArrayList" %>

<c:choose>
    <c:when test="${not empty categoryValuePairs}">
        <c:forEach items="${categoryValuePairs}" var="categoryValuePair" varStatus="varStatus">
            <c:if test="${varStatus.first}">
                <div class="form-group edit-form-group">
                    <label>Extra Properties</label>
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            Extra Properties
                        </button>
                    </div>
                </div>
            </c:if>
            <div class="form-group control-group edit-form-group">
                <label>Extra Properties</label>
                <div class="form-group">
                    <button class="btn btn-danger ${specifier}-${varStatus.count}-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                </div>
                <c:choose>
                    <c:when test="${not empty categoryValuePair.category}">
                        <div>
                            <button class="btn btn-success ${specifier}-add-category " style="display: none"
                                    id="${specifier}-${varStatus.count-1}-add-category"
                                    type="button">
                                <i
                                        class="glyphicon glyphicon-plus"></i> Add
                                Category
                            </button>
                            <div>
                                <div class="input-group control-group edit-form-group full-width">
                                    <label>Category</label>
                                    <div class="input-group">
                                        <input name="${path}[${varStatus.count-1}].Category"
                                               value="${categoryValuePair.category}"
                                               type="text" class="form-control" placeholder="Category">
                                        <div class="input-group-btn">
                                            <button class="btn btn-danger ${specifier}-category-remove"
                                                    id="${specifier}-${varStatus.count-1}-category-remove"
                                                    type="button"><i
                                                    class="glyphicon glyphicon-remove"></i>
                                                Remove
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-success ${specifier}-add-category "
                                id="${specifier}-${varStatus.count-1}-add-category"
                                type="button">
                            <i
                                    class="glyphicon glyphicon-plus"></i> Add
                            Category
                        </button>
                    </c:otherwise>
                </c:choose>
                <br>
                <c:choose>
                    <c:when test="${not empty categoryValuePair.categoryIRI}">
                        <div>
                            <button class="btn btn-success ${specifier}-add-categoryIRI " style="display: none"
                                    id="${specifier}-${varStatus.count-1}-add-categoryIRI"
                                    type="button">
                                <i
                                        class="glyphicon glyphicon-plus"></i> Add
                                Category IRI
                            </button>
                            <div>
                                <div class="input-group control-group edit-form-group full-width">
                                    <label>Category IRI</label>
                                    <div class="input-group">
                                        <input name="${path}[${varStatus.count-1}].categoryIRI"
                                               value="${categoryValuePair.categoryIRI}"
                                               type="text" class="form-control" placeholder="Category IRI">
                                        <div class="input-group-btn">
                                            <button class="btn btn-danger ${specifier}-categoryIRI-remove"
                                                    id="${specifier}-${varStatus.count-1}-categoryIRI-remove"
                                                    type="button"><i
                                                    class="glyphicon glyphicon-remove"></i>
                                                Remove
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-success ${specifier}-add-categoryIRI "
                                id="${specifier}-${varStatus.count-1}-add-categoryIRI"
                                type="button">
                            <i
                                    class="glyphicon glyphicon-plus"></i> Add
                            Category IRI
                        </button>
                    </c:otherwise>
                </c:choose>
                <br><br>

                <div>
                    <button class="btn btn-success ${specifier}-add-values" id="${specifier}-${varStatus.count-1}-add-values"
                            type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Value
                    </button>
                </div>
                <c:if test="${not empty categoryValuePair.values}">
                    <c:forEach items="${categoryValuePair.values}" var="value" varStatus="valueStatus">
                        <div>
                            <div class="form-group control-group full-width">
                                <div class="form-group edit-form-group">
                                    <label>Value</label>
                                    <div class="input-group-btn">
                                        <button class="btn btn-danger ${specifier}-values-remove"
                                                id="${specifier}-${varStatus.count-1}-values-${valueStatus.count-1}-remove"
                                                type="button"><i
                                                class="glyphicon glyphicon-remove"></i>
                                            Remove
                                        </button>
                                    </div>
                                    <myTags:editAnnotation annotation="${value}"
                                                           path="${path}[${varStatus.count-1}].values[${valueStatus.count-1}]."></myTags:editAnnotation>
                                </div>
                            </div>
                        </div>
                        <c:set var="valuesCount" scope="page" value="${valueStatus.count}"/>

                    </c:forEach>
                </c:if>
            </div>
            <c:set var="extraPropertiesCount" scope="page" value="${varStatus.count}"/>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>Extra Properties</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Extra Properties
                </button>
            </div>
        </div>
        <c:set var="extraPropertiesCount" scope="page" value="0"/>
        <c:set var="valuesCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>

<div class="${specifier}-copy hide">
    <div class="form-group control-group edit-form-group">
        <label>Extra Properties</label>
        <div class="form-group">
            <button class="btn btn-danger ${specifier}-remove" id="${specifier}-0-remove" type="button"><i
                    class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
        <br>
        <div>
            <button class="btn btn-success ${specifier}-add-category" id="${specifier}-0-add-category" type="button">
                <i
                        class="glyphicon glyphicon-plus"></i> Add
                Category
            </button>
        </div>
        <br>
        <div>
            <button class="btn btn-success ${specifier}-add-categoryIRI" id="${specifier}-0-add-categoryIRI"
                    type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Category IRI
            </button>
        </div>
        <br>
        <div>
            <button class="btn btn-success ${specifier}-add-values" id="${specifier}-0-add-values" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Value
            </button>
        </div>
        <br>
    </div>
</div>

<div class="${specifier}-copy-category hide">
    <div class="input-group control-group edit-form-group full-width">
        <label>Category</label>
        <div class="input-group">
            <input name="pathcategory" type="text" class="form-control" placeholder="Category">
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-category-remove" id="${specifier}-0-category-remove"
                        type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
        </div>
    </div>
</div>


<div class="${specifier}-copy-categoryIRI hide">
    <div class="input-group control-group edit-form-group full-width">
        <label>Category IRI</label>
        <div class="input-group">
            <input name="pathcategoryIRI" type="text" class="form-control" placeholder="Category IRI">
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-categoryIRI-remove"
                        id="${specifier}-0-categoryIRI-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
        </div>
    </div>
</div>

<div class="${specifier}-copy-values hide">
    <div class="form-group control-group full-width">
        <div class="form-group edit-form-group">
            <label>Value</label>
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-values-remove" id="${specifier}-0-values-0-remove"
                        type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
            <myTags:editAnnotation path="extraPropertiesPath"></myTags:editAnnotation>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        var extraPropertiesCount = ${extraPropertiesCount};
        //Show/Hide categoryValuePair
        $("body").on("click", ".${specifier}-add", function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            //console.log(path);
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            //console.log(path);
            var html = $(".${specifier}-copy").html();
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}['+ extraPropertiesCount + ']').replace(regexSpecifier,'${specifier}-' + extraPropertiesCount);

            //console.log($(this));
            $(this).after(html);
            //$(this).hide();
            extraPropertiesCount += 1;
            e.stopImmediatePropagation()
        });
        $("body").on("click", ".${specifier}-remove", function () {
            var id = event.target.id;
            $(this).closest(".control-group").remove();
            //$(".${specifier}-0-add").show();
        });

        //Show/hide category
        $("body").on("click", ".${specifier}-add-category", function (e) {
            e.stopImmediatePropagation();

            var id = event.target.id;
            var count = id.split("${specifier}-")[1].split('-')[0];
            var html = $(".${specifier}-copy-category").html();
            console.log(html);
            html = html.replace(/name="path/g, 'name="${path}[' + count + '].').replace("${specifier}-0", "${specifier}-" + count);

            $(this).after(html);
            $(this).hide();
        });

        $("body").on("click", ".${specifier}-category-remove", function () {
            var id = event.target.id;
            var count = id.split("${specifier}-")[1].split('-')[0];
            if (count != undefined) {
                $(this).parents(".control-group")[0].remove();
                $("#${specifier}-" + count + "-add-category").show();
            }
        });


        //Show/hide categoryIRI
        $("body").on("click", ".${specifier}-add-categoryIRI", function (e) {
            e.stopImmediatePropagation();

            var id = event.target.id;
            var count = id.split("${specifier}-")[1].split('-')[0];
            var html = $(".${specifier}-copy-categoryIRI").html();
            html = html.replace(/name="path/g, 'name="${path}[' + count + '].').replace("${specifier}-0", "${specifier}-" + count);

            $(this).after(html);
            $(this).hide();
        });

        $("body").on("click", ".${specifier}-categoryIRI-remove", function () {
            var id = event.target.id;
            var count = id.split("${specifier}-")[1].split('-')[0];
            if (count != undefined) {
                $(this).parents(".control-group")[0].remove();
                $("#${specifier}-" + count + "-add-categoryIRI").show();
            }
        });

        var valuesCount = ${valuesCount};
        //Show/Hide Values
        $("body").on("click", ".${specifier}-add-values", function (e) {
            e.stopImmediatePropagation();

            var id = event.target.id;
            var count = id.split("-")[1];
            var specifier = "${specifier}-values";
            var path = "${path}.values";
            var html = $(".${specifier}-copy-values").html();
            //console.log(html);
            html = html.replace(/name="extraPropertiesPath/g, 'name="${path}[' + count + '].values[' + valuesCount + '].');

            $(this).after(html);
            valuesCount += 1;
            //$(this).hide();
        });
        $("body").on("click", ".${specifier}-values-remove", function () {
            $(this).parents(".control-group")[0].remove();
            //$(".${specifier}-add-values").show();
        });


    });
</script>