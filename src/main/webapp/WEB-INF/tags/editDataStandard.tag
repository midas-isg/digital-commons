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
                <button class="btn btn-danger ${specifier}-dataStandard-remove" type="button"><i
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
                    <myTags:editNonRequiredNonZeroLengthString specifier="${specifier}-description" string="${dataStandard.description}"
                                                               path="${path}[${varStatus.count-1}].description" label="Description" placeholder="Description"></myTags:editNonRequiredNonZeroLengthString>
                </div>

                <div class="form-group edit-form-group">
                    <label>Type</label>
                    <myTags:editAnnotation annotation="${dataStandard.type}" path="${path}[${varStatus.count-1}].type." supportError="${true}"></myTags:editAnnotation>
                </div>

                <div class="form-group">
                    <myTags:editLicense licenses="${dataStandard.licenses}" specifier="${specifier}-licenses"
                                        label="License"
                                        path="${path}[${varStatus.count-1}].licenses"></myTags:editLicense>
                </div>

                <myTags:editNonRequiredNonZeroLengthString label="Version" placeholder=" Version"
                                                           specifier="${specifier}-${varStatus.count-1}-version"
                                                           string="${dataStandard.version}"
                                                           path="${path}[${varStatus.count-1}].version"></myTags:editNonRequiredNonZeroLengthString>

                <div class="form-group">
                    <myTags:editCategoryValuePair categoryValuePairs="${dataStandard.extraProperties}"
                                                  specifier="${specifier}-${varStatus.count-1}-extraProperties"
                                                  path="${path}[${varStatus.count-1}].extraProperties"
                                                  label="Extra Properties"></myTags:editCategoryValuePair>
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
        <button class="btn btn-danger ${specifier}-dataStandard-remove" type="button"><i
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
            <myTags:editNonRequiredNonZeroLengthString specifier="${specifier}-0-description" path="${path}[0].description" label="Description" placeholder="Description"></myTags:editNonRequiredNonZeroLengthString>
        </div>
        <div class="form-group edit-form-group">
            <label>Type</label>
            <myTags:editAnnotation path="${path}[0].type." ></myTags:editAnnotation>
        </div>
        <div class="form-group">
            <myTags:editLicense specifier="${specifier}-0-licenses"
                                label="License"
                                path="${path}[0].licenses"></myTags:editLicense>
        </div>
        <myTags:editNonRequiredNonZeroLengthString label="Version" placeholder=" Version"
                                                   specifier="${specifier}-0-version"
                                                   path="${path}[0].version"></myTags:editNonRequiredNonZeroLengthString>
        <div class="form-group">
            <myTags:editCategoryValuePair specifier="${specifier}-0-extraProperties" label="Extra Properties"
                                          path="${path}[0].extraProperties"></myTags:editCategoryValuePair>
        </div>
    </div>

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
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}[' + dataStandardCount + ']').replace(regexSpecifier, '${specifier}-' + dataStandardCount);

            $(this).after(html);
            dataStandardCount += 1;
            //$(this).hide();
            //e.stopImmediatePropagation()
        });

        $("body").on("click", ".${specifier}-dataStandard-remove", function () {
            $(this).closest(".control-group").remove();
            $(".${specifier}-add-dataStandard").show();
        });

    });
</script>
