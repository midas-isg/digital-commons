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


<%--
<div id="${id}" class="form-group edit-form-group">
    <label>${label}</label>
    <div id="${specifier}-add-input-button"
         class="input-group control-group <c:if test="${not function:isObjectEmpty(dataRepository)}">hide</c:if>">
        <div class="input-group-btn">
            <button class="btn btn-success ${specifier}-add-dataRepository" type="button"><i
                    class="fa fa-plus-circle"></i> Add
                ${label}
            </button>
        </div>
    </div>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(dataRepository)}">hide</c:if>">
        <button class="btn btn-danger ${specifier}-dataRepository-remove" type="button"><i
                class="fa fa-minus-circle"></i>
            Remove
        </button>
--%>
        <myTags:editMasterElementWrapper path="${path}"
                                         specifier="${specifier}"
                                         object="${dataRepository}"
                                         label="${label}"
                                         id="${specifier}"
                                         isUnboundedList="${false}"
                                         tagName="dataRepository"
                                         showTopOrBottom="top">
        </myTags:editMasterElementWrapper>
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
        <myTags:editMasterElementWrapper path="${path}"
                                         specifier="${specifier}"
                                         object="${dataRepository}"
                                         label="${label}"
                                         id="${specifier}"
                                         isUnboundedList="${false}"
                                         tagName="dataRepository"
                                         showTopOrBottom="bottom">
        </myTags:editMasterElementWrapper>
<%--

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
--%>
