<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="grant" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Grant" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>


<div id="${id}"
     class="form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${isUnboundedList and function:isObjectEmpty(grant)}">hide</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <div id="${specifier}-add-input-button"
             class="input-group control-group ${specifier}-grant-add-more <c:if test="${not function:isObjectEmpty(grant)}">hide</c:if>">
            <div class="input-group-btn">
                <button class="btn btn-success ${specifier}-add-grant" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${label}
                </button>
            </div>
        </div>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(grant) and not isUnboundedList}">hide</c:if>">
        <c:if test="${isUnboundedList}">
            <label>${label}</label>
        </c:if>
        <button class="btn btn-danger ${specifier}-grant-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <myTags:editIdentifier path="${path}.identifier"
                               singleIdentifier="${grant.identifier}"
                               isUnboundedList="${false}"
                               specifier="${specifier}-identifier"
                               label="Identifier">
        </myTags:editIdentifier>
        <myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                                    label="Alternate Identifiers"
                                    path="${path}.alternateIdentifiers"
                                    tagName="identifier"
                                    listItems="${grant.alternateIdentifiers}">
        </myTags:editMasterUnbounded>
        <myTags:editNonZeroLengthString placeholder=" The name of the grant and its funding program."
                                        label="Name"
                                        string="${grant.name}"
                                        isUnboundedList="${false}"
                                        specifier="${specifier}-name"
                                        id="${specifier}-name"
                                        isRequired="${true}"
                                        path="${path}.name">
        </myTags:editNonZeroLengthString>
        <myTags:editPersonComprisedEntity path="${path}.funders"
                                          specifier="${specifier}-funders"
                                          label="Funder"
                                          personComprisedEntities="${grant.funders}"
                                          createPersonOrganizationTags="${true}"
                                          isFirstRequired="true"
                                          showAddPersonButton="true"
                                          showAddOrganizationButton="true">
        </myTags:editPersonComprisedEntity>
        <myTags:editPersonComprisedEntity path="${path}.awardees"
                                          specifier="${specifier}-awardees"
                                          label="Awardee"
                                          personComprisedEntities="${grant.awardees}"
                                          createPersonOrganizationTags="${true}"
                                          isFirstRequired="false"
                                          showAddPersonButton="true"
                                          showAddOrganizationButton="true">
        </myTags:editPersonComprisedEntity>

        <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </c:if>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-add-grant", function (e) {
                e.stopImmediatePropagation();

                $("#${specifier}-input-block").removeClass("hide");
                $("#${specifier}-add-input-button").addClass("hide");

                //Add section
                $("#${specifier}-grant").val("");
            });

            //Remove section
            $("body").on("click", ".${specifier}-grant-remove", function (e) {
                e.stopImmediatePropagation();

                clearAndHideEditControlGroup(this);
                $("#${specifier}-add-input-button").removeClass("hide");
                $("#${specifier}-input-block").addClass("hide");
            });
        });

    </script>

</div>

