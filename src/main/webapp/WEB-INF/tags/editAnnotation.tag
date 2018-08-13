<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="annotation" required="false"
              type="edu.pitt.isg.mdc.dats2_2.IsAbout" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>


<div id="${id}"
     class="form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${not isRequired and isUnboundedList and function:isObjectEmpty(annotation)}">hide</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <c:if test="${not isRequired}">
            <div id="${specifier}-add-input-button"
                 class="input-group control-group ${specifier}-annotation-add-more <c:if test="${not function:isObjectEmpty(annotation)}">hide</c:if>">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-annotation" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
        </c:if>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(annotation) and not isUnboundedList and not isRequired}">hide</c:if>">
        <button class="btn btn-danger ${specifier}-annotation-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <div class="form-group edit-form-group">
            <label>Value</label>
            <input type="text" class="form-control" value="${annotation.value}" name="${path}.value"
                   placeholder="Value">
        </div>

        <c:set var="valueIRIPath" value="${path}.valueIRI"/>
        <div class="form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(valueIRIPath)}">has-error</c:if>">
            <label>Value IRI</label>
            <input type="text" class="form-control" value="${annotation.valueIRI}" name="${valueIRIPath}"
                   placeholder="Value IRI">

            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(valueIRIPath)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </div>

        <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </c:if>
    </div>

    <c:if test="${not isRequired}">
        <script type="text/javascript">
            $(document).ready(function () {
                $("body").on("click", ".${specifier}-add-annotation", function (e) {
                    e.stopImmediatePropagation();

                    $("#${specifier}-input-block").removeClass("hide");
                    <c:if test="${isUnboundedList or not isRequired}">
                    $("#${specifier}-add-input-button").addClass("hide");
                    </c:if>

                    //Add section
                    $("#${specifier}-annotation").val("");
                });

                //Remove section
                $("body").on("click", ".${specifier}-annotation-remove", function (e) {
                    e.stopImmediatePropagation();

                    clearAndHideEditControlGroup(this);
                    $("#${specifier}-add-input-button").removeClass("hide");
                    $("#${specifier}-input-block").addClass("hide");
                });
            });

        </script>
    </c:if>

</div>
