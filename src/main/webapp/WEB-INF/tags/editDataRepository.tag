<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="name" required="false"
              type="java.lang.String" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@attribute name="dataRepository" required="false"
             type="edu.pitt.isg.mdc.dats2_2.DataRepository" %>

<c:choose>
    <c:when test="${not function:isObjectEmpty(dataRepository)}">
        <div class="form-group edit-form-group">
            <label>${name}</label>
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

                <myTags:editUnboundedIdentifier path="${path}.identifier"
                                                identifier="${dataRepository.identifier}"
                                                specifier="${specifier}-identifier"
                                                label="Identifier">
                </myTags:editUnboundedIdentifier>
                <myTags:editUnboundedIdentifier specifier="${specifier}-alternateIdentifiers"
                                                label="Alternate Identifiers"
                                                path="${path}.alternateIdentifiers"
                                                identifiers="${dataRepository.alternateIdentifiers}"
                                                unbounded="true">
                </myTags:editUnboundedIdentifier>
                <myTags:editRequiredNonZeroLengthString placeholder=" The name of the data repository."
                                                        label="Name"
                                                        string="${dataRepository.name}"
                                                        path="${path}.name">
                </myTags:editRequiredNonZeroLengthString>
                <myTags:editNonRequiredNonZeroLengthStringTextArea path="${path}.description"
                                                                   string="${dataRepository.description}"
                                                                   specifier="${specifier}-description"
                                                                   placeholder=" A textual narrative comprised of one or more statements describing the data repository."
                                                                   label="Description">
                </myTags:editNonRequiredNonZeroLengthStringTextArea>
                <myTags:editAnnotationUnbounded path="${path}.scopes"
                                                specifier="${specifier}-scopes"
                                                annotations="${dataRepository.scopes}"
                                                label="Scopes">
                </myTags:editAnnotationUnbounded>
                <myTags:editAnnotationUnbounded path="${path}.types"
                                                specifier="${specifier}-types"
                                                annotations="${dataRepository.types}"
                                                label="Types" >
                </myTags:editAnnotationUnbounded>
                <myTags:editLicense path="${path}.licenses"
                                    licenses="${dataRepository.licenses}"
                                    label="License"
                                    specifier="${specifier}-licenses">
                </myTags:editLicense>
                <myTags:editNonZeroLengthString label="Version" placeholder=" A release point for the dataset when applicable."
                                                specifier="${specifier}-version"
                                                string="${dataRepository.version}"
                                                path="${path}.version">
                </myTags:editNonZeroLengthString>
                <myTags:editPersonComprisedEntity path="${path}.publishers"
                                                  specifier="${specifier}-publishers"
                                                  label="Publisher"
                                                  personComprisedEntities="${dataRepository.publishers}"
                                                  isFirstRequired="false"
                                                  showAddPersonButton="true"
                                                  showAddOrganizationButton="true">
                </myTags:editPersonComprisedEntity>
                <myTags:editAccessUnbounded path="${path}.access"
                                            specifier="${specifier}-access"
                                            accessList="${dataRepository.access}"
                                            label="Access">
                </myTags:editAccessUnbounded>
            </div>
        </div>

    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label path="${path}">${name}</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-data-repository" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${name}
                </button>
            </div>
        </div>
        <%--<c:set var="dataRepositoryTypesCount" scope="page" value="1"/>--%>

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
        <myTags:editUnboundedIdentifier path="${path}.identifier"
                                        specifier="${specifier}-identifier"
                                        label="Identifier">
        </myTags:editUnboundedIdentifier>
        <myTags:editUnboundedIdentifier specifier="${specifier}-alternateIdentifiers"
                                        label="Alternate Identifiers"
                                        path="${path}.alternateIdentifiers"
                                        unbounded="${true}">
        </myTags:editUnboundedIdentifier>
        <myTags:editRequiredNonZeroLengthString placeholder=" Name"
                                                label="Name"
                                                path="${path}.name">
        </myTags:editRequiredNonZeroLengthString>
        <myTags:editNonRequiredNonZeroLengthStringTextArea path="${path}.description"
                                                           specifier="${specifier}-description"
                                                           placeholder=" A textual narrative comprised of one or more statements describing the data repository."
                                                           label="Description">
        </myTags:editNonRequiredNonZeroLengthStringTextArea>
        <myTags:editAnnotationUnbounded path="${path}.scopes"
                                        specifier="${specifier}-scopes"
                                        annotations="${dataRepository.scopes}"
                                        label="Scopes">
        </myTags:editAnnotationUnbounded>
        <myTags:editAnnotationUnbounded path="${path}.types"
                                        specifier="${specifier}-types"
                                        label="Types" >
        </myTags:editAnnotationUnbounded>
        <myTags:editLicense path="${path}.licenses"
                            label="License"
                            specifier="${specifier}-licenses">
        </myTags:editLicense>
        <myTags:editNonZeroLengthString label="Version" placeholder=" Version"
                                        specifier="${specifier}-version"
                                        path="${path}.version">
        </myTags:editNonZeroLengthString>
        <myTags:editPersonComprisedEntity path="${path}.publishers"
                                          specifier="${specifier}-publishers"
                                          label="Publisher"
                                          isFirstRequired="false"
                                          showAddPersonButton="true"
                                          showAddOrganizationButton="true">
        </myTags:editPersonComprisedEntity>
        <myTags:editAccessUnbounded path="${path}.access"
                                    specifier="${specifier}-access"
                                    label="Access">
        </myTags:editAccessUnbounded>
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
            clearAndHideEditControlGroup(this);
            // $(this).parent(".control-group").remove();
            $(".${specifier}-add-data-repository").show();
        });

        <%--var dataRepositoryTypesCount = ${dataRepositoryTypesCount};--%>

    });
</script>