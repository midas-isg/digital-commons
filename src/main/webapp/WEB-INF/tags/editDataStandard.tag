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
<%@ attribute name="dataStandards" required="false"
              type="java.util.ArrayList" %>

<c:choose>
    <c:when test="${not empty dataStandards}">
        <c:forEach items="${dataStandards}" var="dataStandard" varStatus="varStatus">
            <c:if test="${varStatus.first}">
                <div class="form-group edit-form-group">
                    <form:label path="${path}">${name}</form:label>
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add-dataStandard" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                                ${name}
                        </button>
                    </div>
                </div>
            </c:if>


            <div class="form-group control-group edit-form-group">
                <label>${name}</label>
                <br>
                <button class="btn btn-danger ${specifier}-${varStatus.count-1}-dataStandard-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
                <br><br>

                <div class="form-group">
                    <myTags:editIdentifier identifier="${dataStandard.identifier}" label="Identifier" specifier="${specifier}-" path="${path}[${varStatus.count-1}].identifier"
                                           unbounded="False"></myTags:editIdentifier>
                </div>


                <div class="form-group edit-form-group">
                    <label>Name</label>
                    <input name="${path}[${varStatus.count-1}].name" value="${dataStandard.name}" type="text" class="form-control" placeholder="Name">
                </div>


                <div class="form-group">
                    <myTags:editNonRequiredNonZeroLengthString specifier="${specifier}" string="${dataStandard.description}"
                                                               path="${path}[${varStatus.count-1}].description" label="Description" placeholder="Description"></myTags:editNonRequiredNonZeroLengthString>
                </div>

                <div class="form-group edit-form-group">
                    <label>Type</label>
                    <myTags:editAnnotation annotation="${dataStandard.type}" path="${path}[${varStatus.count-1}].type." supportError="${true}"></myTags:editAnnotation>
                </div>

                <div class="form-group">
                    <myTags:editLicense licenses="${dataStandard.licenses}" specifier="${specifier}-licenses"
                                        path="${path}[${varStatus.count-1}].licenses"></myTags:editLicense>
                </div>

                <div class="form-group edit-form-group">
                    <label>Version</label>
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-${varStatus.count-1}-add-version" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            Version
                        </button>
                    </div>
                </div>

                <div class="form-group">
                    <myTags:editExtraProperties categoryValuePairs="${dataStandard.extraProperties}"
                                                specifier="${specifier}-${varStatus.count-1}-extraProperties"
                                                path="${path}[${varStatus.count-1}].extraProperties"
                                                label="Extra Properties"></myTags:editExtraProperties>
                </div>
            </div>

            <c:set var="dataStandardCount" scope="page" value="${varStatus.count}"/>

        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <form:label path="${path}">${name}</form:label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-dataStandard" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${name}
                </button>
            </div>
        </div>
        <c:set var="dataStandardCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>


<div class="${specifier}-copy-dataStandard hide">
    <div class="form-group control-group edit-form-group">
        <label>${name}</label>
        <br>
        <button class="btn btn-danger ${specifier}-0-dataStandard-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <div class="form-group">
            <myTags:editIdentifier label="Identifier" specifier="${specifier}-" path="${path}[0].identifier"
                                   unbounded="False"></myTags:editIdentifier>
        </div>
        <div class="form-group edit-form-group">
            <label>Name</label>
            <input name="${path}[0].name" type="text" class="form-control" placeholder="Name">
        </div>
        <div class="form-group">
            <myTags:editNonRequiredNonZeroLengthString specifier="${specifier}" path="${path}[0].description" label="Description" placeholder="Description"></myTags:editNonRequiredNonZeroLengthString>
        </div>
        <div class="form-group edit-form-group">
            <label>Type</label>
            <myTags:editAnnotation path="${path}[0].type." ></myTags:editAnnotation>
        </div>
        <div class="form-group">
            <myTags:editLicense specifier="${specifier}-licenses" path="${path}[0].licenses"></myTags:editLicense>
        </div>
        <div class="form-group edit-form-group">
            <label>Version</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-0-add-version" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Version
                </button>
            </div>
        </div>
        <div class="form-group">
            <myTags:editExtraProperties specifier="${specifier}-0-extraProperties" label="Extra Properties"
                                        path="${path}[0].extraProperties"></myTags:editExtraProperties>
        </div>
    </div>

    <div class="${specifier}-0-copy-version hide">
        <div class="input-group control-group edit-form-group full-width">
            <input type="text" class="form-control" name="${path}[0].version" id="${specifier}-0-version"
                   placeholder="Version"/>
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-0-version-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                //Hide Version
                $("body").on("click", ".${specifier}-0-version-remove", function () {
                    $(this).closest(".control-group").remove();
                    $(".${specifier}-0-add-version").show();
                });

            });
        </script>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-0-dataStandard-remove", function () {
                $(this).parent(".control-group").remove();
                $(".${specifier}-add-dataStandard").show();
            });

            //Show/Hide Version
            $("body").on("click", ".${specifier}-0-add-version", function (e) {
                var html = $(".${specifier}-0-copy-version").html();

                $(this).after(html);
                $(this).hide();
                e.stopImmediatePropagation()
            });

        });
    </script>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var dataStandardCount = ${dataStandardCount};
        //Show/Hide Location
        $("body").on("click", ".${specifier}-add-dataStandard", function () {
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $(".${specifier}-copy-dataStandard").html();
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}[' + dataStandardCount + ']').replace(regexSpecifier, '${specifier}-' + dataStandardCount);

            $(this).after(html);
            dataStandardCount += 1;
            //$(this).hide();
            //e.stopImmediatePropagation()
        });
    });
</script>
