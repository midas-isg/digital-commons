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
<%@attribute name="dataRepository" required="false"
             type="edu.pitt.isg.mdc.dats2_2.DataRepository" %>

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

                <myTags:editRequiredNonZeroLengthString placeholder=" Name" label="Name"
                                                        string="${dataRepository.name}"
                                                        path="${path}.name"></myTags:editRequiredNonZeroLengthString>
                <myTags:editIdentifier path="${path}.identifier" identifier="${dataRepository.identifier}"
                                       specifier="${specifier}-identifier"
                                       label="Identifier"></myTags:editIdentifier>
                <myTags:editLicense path="${path}.licenses" licenses="${dataRepository.licenses}"
                                    label="License"
                                    specifier="${specifier}-licenses"></myTags:editLicense>
                <myTags:editAnnotationUnbounded path="${path}.types"
                                                specifier="${specifier}-types"
                                                annotations="${dataRepository.types}"
                                                label="Types" ></myTags:editAnnotationUnbounded>
                <myTags:editNonRequiredNonZeroLengthString label="Version" placeholder=" Version"
                                                           specifier="${specifier}-version"
                                                           string="${dataRepository.version}"
                                                           path="${path}.version"></myTags:editNonRequiredNonZeroLengthString>

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
        <myTags:editRequiredNonZeroLengthString placeholder=" Name" label="Name"
                                                path="${path}.name"></myTags:editRequiredNonZeroLengthString>
        <myTags:editIdentifier path="${path}.identifier"
                               specifier="${specifier}-identifier"
                               label="Identifier"></myTags:editIdentifier>
        <myTags:editLicense path="${path}.licenses"
                            label="License"
                            specifier="${specifier}-licenses"></myTags:editLicense>
        <myTags:editAnnotationUnbounded path="${path}.types"
                                        specifier="${specifier}-types"
                                        label="Types" ></myTags:editAnnotationUnbounded>
        <myTags:editNonRequiredNonZeroLengthString label="Version" placeholder=" Version"
                                                   specifier="${specifier}-version"
                                                   path="${path}.version"></myTags:editNonRequiredNonZeroLengthString>
    </div>
</div>



<script type="text/javascript">
    $(document).ready(function () {

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

    });
</script>