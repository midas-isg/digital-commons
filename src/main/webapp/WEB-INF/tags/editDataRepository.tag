<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="name" required="false"
              type="java.lang.String" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@attribute name="dataRepository" required="false" type="edu.pitt.isg.mdc.dats2_2.DataRepository" %>

<c:choose>
    <c:when test="${not empty dataRepository}">
        <div class="form-group edit-form-group">
            <form:label path="${path}">${name}</form:label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-data-repository" style="display: none" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${name}
                </button>
            </div>

            <div class="form-group control-group edit-form-group">
                <label>${name}</label>
                <br>
                <button class="btn btn-danger ${specifier}-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
                <br><br>

                <div class="form-group edit-form-group">
                    <label>Name</label>
                    <input name="${path}.name" value="${dataRepository.name}" type="text" class="form-control"
                           placeholder="Name">
                </div>

                <div class="form-group">
                    <myTags:editIdentifier path="${path}.identifier" identifier="${dataRepository.identifier}"
                                           specifier="${specifier}-identifier"
                                           label="Identifier"></myTags:editIdentifier>
                </div>

                <div class="form-group">
                    <myTags:editLicense path="${path}.licenses" licenses="${dataRepository.licenses}"
                                        specifier="${specifier}-licenses"></myTags:editLicense>
                </div>

                <div class="form-group edit-form-group">
                    <label>Types</label>
                    <button class="btn btn-success ${specifier}-add-types" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Types
                    </button>
                    <c:choose>
                        <c:when test="${not empty dataRepository.types}">
                            <c:forEach items="${dataRepository.types}" var="type" varStatus="varStatus">
                                <div class="form-group edit-form-group">
                                    <label>Type</label>
                                    <myTags:editAnnotation annotation="${type}"
                                                           path="${path}.types[${varStatus.count-1}]."></myTags:editAnnotation>
                                </div>
                                <c:set var="dataRepositoryTypesCount" scope="page" value="${varStatus.count}"/>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="form-group control-group edit-form-group full-width">
                                <label>Type</label>
                                <div class="form-group">
                                    <button class="btn btn-danger ${specifier}-types-0-remove" type="button"><i
                                            class="glyphicon glyphicon-remove"></i>
                                        Remove
                                    </button>
                                </div>
                                <myTags:editAnnotation path="${path}.types[0]."></myTags:editAnnotation>
                            </div>
                            <script type="text/javascript">
                                $(document).ready(function () {
                                    //Hide Types
                                    $("body").on("click", ".${specifier}-types-0-remove", function () {
                                        $(this).closest(".control-group").remove();
                                    });

                                });
                            </script>

                            <c:set var="dataRepositoryTypesCount" scope="page" value="1"/>

                        </c:otherwise>
                    </c:choose>


                </div>

                <c:choose>
                    <c:when test="${not empty dataRepository.version}">
                        <div class="form-group">
                            <label>Version</label>
                            <div class="form-group">
                                <button class="btn btn-success ${specifier}-add-version" style="display: none"
                                        type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    Version
                                </button>
                            </div>
                            <div class="input-group control-group edit-form-group full-width">
                                    <%--<label>Version</label>--%>
                                <input type="text" class="form-control" value="${dataRepository.version}"
                                       name="${path}.version" id="${specifier}-version"
                                       placeholder="Version"/>
                                <div class="input-group-btn">
                                    <button class="btn btn-danger ${specifier}-version-remove" type="button"><i
                                            class="glyphicon glyphicon-remove"></i>
                                        Remove
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="form-group">
                            <label>Version</label>
                            <div class="form-group">
                                <button class="btn btn-success ${specifier}-add-version" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    Version
                                </button>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>

    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <form:label path="${path}">${name}</form:label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-data-repository" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${name}
                </button>
            </div>
        </div>
        <c:set var="dataRepositoryTypesCount" scope="page" value="1"/>

    </c:otherwise>
</c:choose>

<div class="${specifier}-copy-data-repository hide">
    <div class="form-group control-group edit-form-group">
        <label>${name}</label>
        <br>
        <button class="btn btn-danger ${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <div class="form-group edit-form-group">
            <label>Name</label>
            <input name="${path}.name" type="text" class="form-control" placeholder="Name">
        </div>
        <div class="form-group">
            <myTags:editIdentifier path="${path}.identifier"
                                   specifier="${specifier}-identifier"
                                   label="Identifier"></myTags:editIdentifier>
        </div>
        <div class="form-group">
            <myTags:editLicense path="${path}.licenses"
                                specifier="${specifier}-licenses"></myTags:editLicense>
        </div>
        <div class="form-group edit-form-group">
            <label>Types</label>
            <button class="btn btn-success ${specifier}-add-types" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Types
            </button>
            <div class="form-group edit-form-group">
                <label>Type</label>
                <myTags:editAnnotation path="${path}.types[0]."></myTags:editAnnotation>
            </div>
        </div>
        <div class="form-group">
            <label>Version</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-version" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Version
                </button>
            </div>
        </div>
    </div>
</div>

<div class="${specifier}-copy-types hide">
    <div class="form-group control-group edit-form-group full-width">
        <label>Type</label>
        <div class="form-group">
            <button class="btn btn-danger ${specifier}-types-0-remove" type="button"><i
                    class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
        <myTags:editAnnotation path="${path}.types[0]."></myTags:editAnnotation>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            //Hide Types
            $("body").on("click", ".${specifier}-types-0-remove", function () {
                $(this).closest(".control-group").remove();
            });

        });
    </script>
</div>


<div class="${specifier}-copy-version hide">
    <div class="input-group control-group edit-form-group full-width">
        <%--<label>Version</label>--%>
        <input type="text" class="form-control" name="${path}.version" id="${specifier}-version" placeholder="Version"/>
        <div class="input-group-btn">
            <button class="btn btn-danger ${specifier}-version-remove" type="button"><i
                    class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            //Hide Version
            $("body").on("click", ".${specifier}-version-remove", function () {
                $(this).closest(".control-group").remove();
                $(".${specifier}-add-version").show();
            });

        });
    </script>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        //Show/Hide Data Version
        $("body").on("click", ".${specifier}-add-version", function () {
            var html = $(".${specifier}-copy-version").html();

            $(this).after(html);
            $(this).hide();
            //e.stopImmediatePropagation()
        });

        //Show/Hide Data Repository
        $("body").on("click", ".${specifier}-add-data-repository", function () {
            var html = $(".${specifier}-copy-data-repository").html();

            $(this).after(html);
            $(this).hide();
            //e.stopImmediatePropagation()
        });
        $("body").on("click", ".${specifier}-remove", function () {
            $(this).parent(".control-group").remove();
            $(".${specifier}-add-data-repository").show();
        });

        var dataRepositoryTypesCount = ${dataRepositoryTypesCount};
        //ShowHide Types
        $("body").on("click", ".${specifier}-add-types", function (e) {
            console.log(dataRepositoryTypesCount);
            var specifier = "${specifier}-types";
            var path = "${path}.types";
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var html = $(".${specifier}-copy-types").html();
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}.types[' + dataRepositoryTypesCount + ']').replace(regexSpecifier, '${specifier}-types-' + dataRepositoryTypesCount + '-');
            dataRepositoryTypesCount += 1;
            console.log(dataRepositoryTypesCount);

            $(this).after(html);
            e.stopImmediatePropagation()
        });

    });
</script>