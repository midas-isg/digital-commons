<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@attribute name="dataRepository" required="false"
             type="edu.pitt.isg.mdc.dats2_2.DataRepository" %>


<div id="${id}" class="form-group edit-form-group">
    <label>${label}</label>
    <div id="${specifier}-add-input-button"
         class="input-group control-group <c:if test="${not function:isObjectEmpty(dataRepository)}">hide</c:if>">
        <div class="input-group-btn">
            <button class="btn btn-success ${specifier}-add-dataRepository" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                ${label}
            </button>
        </div>
    </div>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(dataRepository)}">hide</c:if>">
        <button class="btn btn-danger ${specifier}-dataRepository-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <myTags:editIdentifier path="${path}.identifier"
                               singleIdentifier="${dataRepository.identifier}"
                               specifier="${specifier}-identifier"
                               label="Identifier">
        </myTags:editIdentifier>
        <myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                                    label="Alternate Identifiers"
                                    path="${path}.alternateIdentifiers"
                                    tagName="identifier"
                                    listItems="${dataRepository.alternateIdentifiers}">
        </myTags:editMasterUnbounded>
        <myTags:editNonZeroLengthString placeholder=" The name of the data repository."
                                        specifier="${specifier}-name"
                                        label="Name"
                                        string="${dataRepository.name}"
                                        path="${path}.name"
                                        isRequired="${true}">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString path="${path}.description"
                                        string="${dataRepository.description}"
                                        specifier="${specifier}-description"
                                        isTextArea="${true}"
                                        placeholder=" A textual narrative comprised of one or more statements describing the data repository."
                                        label="Description">
        </myTags:editNonZeroLengthString>
        <myTags:editMasterUnbounded path="${path}.scopes"
                                    specifier="${specifier}-scopes"
                                    listItems="${dataRepository.scopes}"
                                    tagName="annotation"
                                    label="Scopes">
        </myTags:editMasterUnbounded>
        <myTags:editMasterUnbounded path="${path}.types"
                                    specifier="${specifier}-types"
                                    listItems="${dataRepository.types}"
                                    tagName="annotation"
                                    label="Types">
        </myTags:editMasterUnbounded>
        <myTags:editMasterUnbounded path="${path}.licenses"
                                    listItems="${dataRepository.licenses}"
                                    label="License"
                                    tagName="license"
                                    specifier="${specifier}-licenses">
        </myTags:editMasterUnbounded>
        <myTags:editNonZeroLengthString label="Version"
                                        placeholder=" A release point for the dataset when applicable."
                                        specifier="${specifier}-version"
                                        string="${dataRepository.version}"
                                        path="${path}.version">
        </myTags:editNonZeroLengthString>
        <myTags:editPersonComprisedEntity path="${path}.publishers"
                                          specifier="${specifier}-publishers"
                                          label="Publisher"
                                          personComprisedEntities="${dataRepository.publishers}"
                                          isFirstRequired="false"
                                          createPersonOrganizationTags="true"
                                          showAddPersonButton="true"
                                          showAddOrganizationButton="true">
        </myTags:editPersonComprisedEntity>
        <myTags:editMasterUnbounded path="${path}.access"
                                    specifier="${specifier}-access"
                                    listItems="${dataRepository.access}"
                                    tagName="access"
                                    isRequired="${false}"
                                    label="Access">
        </myTags:editMasterUnbounded>

    </div>

    <script type="text/javascript">

        $(document).ready(function () {
            $("body").on("click", ".${specifier}-add-dataRepository", function (e) {
                e.stopImmediatePropagation();

                $("#${specifier}-input-block").removeClass("hide");
                $("#${specifier}-add-input-button").addClass("hide");

            });

            //Remove section
            $("body").on("click", ".${specifier}-dataRepository-remove", function () {
                clearAndHideEditControlGroup(this);
                $("#${specifier}-input-block").addClass("hide");
                $("#${specifier}-add-input-button").removeClass("hide");
            });
        });

    </script>
</div>


<%--
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

&lt;%&ndash;
                <myTags:editIdentifierUnbounded path="${path}.identifier"
                                                identifier="${dataRepository.identifier}"
                                                specifier="${specifier}-identifier"
                                                label="Identifier">
                </myTags:editIdentifierUnbounded>
                <myTags:editIdentifierUnbounded specifier="${specifier}-alternateIdentifiers"
                                                label="Alternate Identifiers"
                                                path="${path}.alternateIdentifiers"
                                                identifiers="${dataRepository.alternateIdentifiers}"
                                                unbounded="true">
                </myTags:editIdentifierUnbounded>
                &ndash;%&gt;
                <myTags:editNonZeroLengthString placeholder=" The name of the data repository."
                                                specifier="${specifier}-name"
                                                label="Name"
                                                string="${dataRepository.name}"
                                                path="${path}.name"
                                                isRequired="${true}">
                </myTags:editNonZeroLengthString>
                    &lt;%&ndash;
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
    &ndash;%&gt;
                <myTags:editPersonComprisedEntity path="${path}.publishers"
                                                  specifier="${specifier}-publishers"
                                                  label="Publisher"
                                                  personComprisedEntities="${dataRepository.publishers}"
                                                  isFirstRequired="false"
                                                  createPersonOrganizationTags="true"
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
        &lt;%&ndash;<c:set var="dataRepositoryTypesCount" scope="page" value="1"/>&ndash;%&gt;

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
&lt;%&ndash;
        <myTags:editIdentifierUnbounded path="${path}.identifier"
                                        specifier="${specifier}-identifier"
                                        label="Identifier">
        </myTags:editIdentifierUnbounded>
        <myTags:editIdentifierUnbounded specifier="${specifier}-alternateIdentifiers"
                                        label="Alternate Identifiers"
                                        path="${path}.alternateIdentifiers"
                                        unbounded="${true}">
        </myTags:editIdentifierUnbounded>
        &ndash;%&gt;
        <myTags:editNonZeroLengthString placeholder=" The name of the data repository."
                                        specifier="${specifier}-name"
                                        label="Name"
                                        path="${path}.name"
                                        isRequired="${true}">
        </myTags:editNonZeroLengthString>
        &lt;%&ndash;
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
&ndash;%&gt;
        <myTags:editPersonComprisedEntity path="${path}.publishers"
                                          specifier="${specifier}-publishers"
                                          label="Publisher"
                                          isFirstRequired="false"
                                          createPersonOrganizationTags="true"
                                          showAddPersonButton="true"
                                          showAddOrganizationButton="true">
        </myTags:editPersonComprisedEntity>
        <myTags:editMasterUnbounded path="${path}.access"
                                    specifier="${specifier}-access"
                                    tagName="accessRequired"
                                    label="Access">
        </myTags:editMasterUnbounded>
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

        &lt;%&ndash;var dataRepositoryTypesCount = ${dataRepositoryTypesCount};&ndash;%&gt;

    });
</script>
--%>
