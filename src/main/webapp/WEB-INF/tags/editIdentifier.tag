<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="singleIdentifier" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Identifier" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>


<div id="${id}" class="form-group <c:if test="${not isUnboundedList}">edit-form-group</c:if> <c:if test="${isUnboundedList and function:isObjectEmpty(singleIdentifier)}">hide</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <div id="${specifier}-add-input-button" class="input-group control-group <c:if test="${not function:isObjectEmpty(singleIdentifier)}">hide</c:if>">
            <div class="input-group-btn">
                <button class="btn btn-success ${specifier}-add-identifier" type="button"><i
                        class="fa fa-plus-circle"></i> Add
                        ${label}
                </button>
            </div>
        </div>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(singleIdentifier) and not isUnboundedList}">hide</c:if>">
        <button class="btn btn-danger ${specifier}-identifier-remove" type="button"><i
                class="fa fa-minus-circle"></i>
            Remove
        </button>
        <myTags:editNonZeroLengthString path="${path}.identifier" specifier="${specifier}-identifier"
                                        placeholder="A code uniquely identifying an entity locally to a system or globally."
                                        isRequired="${true}" label="Identifier"
                                        string="${singleIdentifier.identifier}"></myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString path="${path}.identifierSource" specifier="${specifier}-identifierSource"
                                        placeholder="The identifier source represents information about the organisation/namespace responsible for minting the identifiers. It must be provided if the identifier is provided."
                                        isRequired="${true}" label="Identifier Source"
                                        string="${singleIdentifier.identifierSource}"></myTags:editNonZeroLengthString>

    </div>

    <script type="text/javascript">

        $(document).ready(function () {
            $("body").on("click", ".${specifier}-add-identifier", function (e) {
                e.stopImmediatePropagation();

                $("#${specifier}-input-block").removeClass("hide");
                $("#${specifier}-add-input-button").addClass("hide");

            });

            //Remove section
            $("body").on("click", ".${specifier}-identifier-remove", function () {
                clearAndHideEditControlGroup(this);
                $("#${specifier}-input-block").addClass("hide");
                $("#${specifier}-add-input-button").removeClass("hide");
            });
        });

    </script>
</div>
