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
                <myTags:editIdentifier identifier="${dataStandard.identifier}"
                                       label="Identifier"
                                       specifier="${specifier}-"
                                       path="${path}[${varStatus.count-1}].identifier"
                                       unbounded="False">
                </myTags:editIdentifier>
                <myTags:editIdentifier specifier="${specifier}-alternateIdentifiers"
                                       label="Alternate Identifiers"
                                       path="${path}.alternateIdentifiers"
                                       identifiers="${dataStandard.alternateIdentifiers}"
                                       unbounded="${true}">
                </myTags:editIdentifier>
                <myTags:editRequiredNonZeroLengthString placeholder=" Name"
                                                        label="Name"
                                                        string="${dataStandard.name}"
                                                        path="${path}[${varStatus.count-1}].name">
                </myTags:editRequiredNonZeroLengthString>
                <myTags:editNonRequiredNonZeroLengthString specifier="${specifier}-description"
                                                           string="${dataStandard.description}"
                                                           path="${path}[${varStatus.count-1}].description"
                                                           label="Description"
                                                           placeholder="Description">
\                </myTags:editNonRequiredNonZeroLengthString>
                <myTags:editAnnotationRequired annotation="${dataStandard.type}"
                                               path="${path}[${varStatus.count-1}].type"
                                               label="Type"
                                               supportError="${true}">
                </myTags:editAnnotationRequired>
                <myTags:editLicense licenses="${dataStandard.licenses}"
                                    specifier="${specifier}-licenses"
                                    label="License"
                                    path="${path}[${varStatus.count-1}].licenses">
                </myTags:editLicense>
                <myTags:editNonRequiredNonZeroLengthString label="Version"
                                                           placeholder=" Version"
                                                           specifier="${specifier}-${varStatus.count-1}-version"
                                                           string="${dataStandard.version}"
                                                           path="${path}[${varStatus.count-1}].version">
                </myTags:editNonRequiredNonZeroLengthString>
                <myTags:editCategoryValuePair categoryValuePairs="${dataStandard.extraProperties}"
                                              specifier="${specifier}-${varStatus.count-1}-extraProperties"
                                              path="${path}[${varStatus.count-1}].extraProperties"
                                              label="Extra Properties">
                </myTags:editCategoryValuePair>
            </div>

            <c:set var="dataStandardCount" scope="page" value="${varStatus.count}"/>

        </c:forEach>
        <div class="${specifier}-dataStandard-add-more"></div>
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
        <div class="${specifier}-dataStandard-add-more"></div>
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
        <myTags:editIdentifier label="Identifier"
                               specifier="${specifier}-"
                               path="${path}[0].identifier"
                               unbounded="False">
        </myTags:editIdentifier>
        <myTags:editIdentifier specifier="${specifier}-alternateIdentifiers"
                               label="Alternate Identifiers"
                               path="${path}.alternateIdentifiers"
                               unbounded="${true}">
        </myTags:editIdentifier>
        <myTags:editRequiredNonZeroLengthString placeholder=" Name"
                                                label="Name"
                                                path="${path}[0].name">
        </myTags:editRequiredNonZeroLengthString>
        <myTags:editNonRequiredNonZeroLengthString specifier="${specifier}-0-description"
                                                   path="${path}[0].description"
                                                   label="Description"
                                                   placeholder="Description">
        </myTags:editNonRequiredNonZeroLengthString>
        <myTags:editAnnotationRequired path="${path}[0].type."
                                       label="Type">
        </myTags:editAnnotationRequired>
        <myTags:editLicense specifier="${specifier}-0-licenses"
                            label="License"
                            path="${path}[0].licenses">
        </myTags:editLicense>
        <myTags:editNonRequiredNonZeroLengthString label="Version"
                                                   placeholder=" Version"
                                                   specifier="${specifier}-0-version"
                                                   path="${path}[0].version">
        </myTags:editNonRequiredNonZeroLengthString>
        <myTags:editCategoryValuePair specifier="${specifier}-0-extraProperties"
                                      label="Extra Properties"
                                      path="${path}[0].extraProperties">
        </myTags:editCategoryValuePair>
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

            //$(this).after(html);
            $(".${specifier}-dataStandard-add-more").before(html);
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
