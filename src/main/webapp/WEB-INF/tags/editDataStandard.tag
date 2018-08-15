<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="label" required="false"
              type="java.lang.String" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="dataStandard" required="false"
              type="edu.pitt.isg.mdc.dats2_2.DataStandard" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>


<div id="${id}"
     class="form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${isUnboundedList and function:isObjectEmpty(dataStandard)}">hide</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <div id="${specifier}-add-input-button"
             class="input-group control-group ${specifier}-dataStandard-add-more <c:if test="${not function:isObjectEmpty(dataStandard)}">hide</c:if>">
            <div class="input-group-btn">
                <button class="btn btn-success ${specifier}-add-dataStandard" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${label}
                </button>
            </div>
        </div>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(dataStandard) and not isUnboundedList}">hide</c:if>">
        <c:if test="${isUnboundedList}">
            <label>${label}</label>
        </c:if>
        <button class="btn btn-danger ${specifier}-dataStandard-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <myTags:editIdentifier singleIdentifier="${dataStandard.identifier}"
                               label="Identifier"
                               specifier="${specifier}-identifier"
                               id="${specifier}-identifier"
                               isUnboundedList="${false}"
                               path="${path}.identifier">
        </myTags:editIdentifier>
        <myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                                    label="Alternate Identifiers"
                                    path="${path}.alternateIdentifiers"
                                    listItems="${dataStandard.alternateIdentifiers}"
                                    isRequired="${false}"
                                    tagName="identifier">
        </myTags:editMasterUnbounded>
        <myTags:editNonZeroLengthString placeholder=" Name"
                                        label="Name"
                                        string="${dataStandard.name}"
                                        specifier="${specifier}-name"
                                        id="${specifier}-name"
                                        isRequired="${true}"
                                        isUnboundedList="${false}"
                                        path="${path}.name">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString specifier="${specifier}-description"
                                         id="${specifier}-description"
                                         string="${dataStandard.description}"
                                         path="${path}.description"
                                         label="Description"
                                         isTextArea="${true}"
                                         isRequired="${false}"
                                         placeholder="Description">
        </myTags:editNonZeroLengthString>
        <myTags:editAnnotation annotation="${dataStandard.type}"
                               isRequired="${true}"
                               path="${path}.type"
                               specifier="${specifier}-type"
                               id="${specifier}-type"
                               isUnboundedList="${false}"
                               label="Type">
        </myTags:editAnnotation>
        <myTags:editMasterUnbounded listItems="${dataStandard.licenses}"
                                    tagName="license"
                                    specifier="${specifier}-licenses"
                                    isRequired="${false}"
                                    label="License"
                                    path="${path}.licenses">
        </myTags:editMasterUnbounded>
        <myTags:editNonZeroLengthString label="Version"
                                        placeholder=" Version"
                                        specifier="${specifier}-version"
                                        id="${specifier}-version"
                                        string="${dataStandard.version}"
                                        isUnboundedList="${false}"
                                        isRequired="${false}"
                                        path="${path}.version">
        </myTags:editNonZeroLengthString>
        <myTags:editMasterUnbounded listItems="${dataStandard.extraProperties}"
                                    tagName="categoryValuePair"
                                    isRequired="${false}"
                                    specifier="${specifier}-extraProperties"
                                    path="${path}.extraProperties"
                                    label="Extra Properties">
        </myTags:editMasterUnbounded>

        <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </c:if>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-add-dataStandard", function (e) {
                e.stopImmediatePropagation();

                $("#${specifier}-input-block").removeClass("hide");
                <c:if test="${isUnboundedList or not isRequired}">
                $("#${specifier}-add-input-button").addClass("hide");
                </c:if>

                //Add section
                $("#${specifier}-dataStandard").val("");
            });

            //Remove section
            $("body").on("click", ".${specifier}-dataStandard-remove", function (e) {
                e.stopImmediatePropagation();

                clearAndHideEditControlGroup(this);
                $("#${specifier}-add-input-button").removeClass("hide");
                $("#${specifier}-input-block").addClass("hide");
            });
        });

    </script>

</div>
