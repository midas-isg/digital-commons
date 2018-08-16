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
<%@ attribute name="license" required="false"
              type="edu.pitt.isg.mdc.dats2_2.License" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>


<%--
<div id="${id}"
     class="form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${isUnboundedList and function:isObjectEmpty(license)}">hide</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <div id="${specifier}-add-input-button"
             class="input-group control-group ${specifier}-license-add-more <c:if test="${not function:isObjectEmpty(license)}">hide</c:if>">
            <div class="input-group-btn">
                <button class="btn btn-success ${specifier}-add-license" type="button"><i
                        class="fa fa-plus-circle"></i> Add
                        ${label}
                </button>
            </div>
        </div>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(license) and not isUnboundedList}">hide</c:if>">
        <c:if test="${isUnboundedList}">
            <label>${label}</label>
        </c:if>
        <button class="btn btn-danger ${specifier}-license-remove" type="button"><i
                class="fa fa-minus-circle"></i>
            Remove
        </button>
--%>

        <myTags:editMasterElementWrapper path="${path}"
                                         specifier="${specifier}"
                                         object="${license}"
                                         label="${label}"
                                         id="${id}"
                                         isUnboundedList="${isUnboundedList}"
                                         tagName="${tagName}"
                                         showTopOrBottom="top">
        </myTags:editMasterElementWrapper>
        <myTags:editIdentifier label="Identifier"
                               path="${path}.identifier"
                               isUnboundedList="${false}"
                               id="${specifier}-identifier"
                               singleIdentifier="${license.identifier}"
                               specifier="${specifier}-identifier">
        </myTags:editIdentifier>
        <myTags:editNonZeroLengthString path="${path}.name"
                                        placeholder=" Name of License"
                                        string="${license.name}"
                                        specifier="${specifier}-name"
                                        id="${specifier}-name"
                                        isRequired="${true}"
                                        isUnboundedList="${false}"
                                        label="Name">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString label="Version"
                                        placeholder=" Version"
                                        specifier="${specifier}-version"
                                        id="${specifier}-version"
                                        string="${license.version}"
                                        isRequired="${false}"
                                        isUnboundedList="${false}"
                                        path="${path}.version">
        </myTags:editNonZeroLengthString>
        <myTags:editPersonComprisedEntity path="${path}.creators"
                                          specifier="${specifier}-creators"
                                          label="Creator"
                                          createPersonOrganizationTags="${true}"
                                          personComprisedEntities="${license.creators}"
                                          isFirstRequired="false"
                                          showAddPersonButton="true"
                                          showAddOrganizationButton="true">
        </myTags:editPersonComprisedEntity>
        <myTags:editMasterElementWrapper path="${path}"
                                         specifier="${specifier}"
                                         object="${license}"
                                         label="${label}"
                                         id="${id}"
                                         isUnboundedList="${isUnboundedList}"
                                         tagName="${tagName}"
                                         showTopOrBottom="bottom">
        </myTags:editMasterElementWrapper>

<%--
        <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </c:if>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-add-license", function (e) {
                e.stopImmediatePropagation();

                $("#${specifier}-input-block").removeClass("hide");
                <c:if test="${isUnboundedList or not isRequired}">
                $("#${specifier}-add-input-button").addClass("hide");
                </c:if>

                //Add section
                $("#${specifier}-license").val("");
            });

            //Remove section
            $("body").on("click", ".${specifier}-license-remove", function (e) {
                e.stopImmediatePropagation();

                clearAndHideEditControlGroup(this);
                $("#${specifier}-add-input-button").removeClass("hide");
                $("#${specifier}-input-block").addClass("hide");
            });
        });

    </script>

</div>
--%>
