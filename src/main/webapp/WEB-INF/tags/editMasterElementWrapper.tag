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
<%@ attribute name="object" required="true"
              type="java.lang.Object" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="showTopOrBottom" required="true"
              type="java.lang.String" %>
<%@ attribute name="isFirstRequired" required="false"
              type="java.lang.Boolean" %>

<c:choose>
    <c:when test="${showTopOrBottom == 'top'}">
        <div id="${id}"
        class="form-group <c:if test="${not isUnboundedList}">edit-form-group</c:if> <c:if
            test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if
            test="${isUnboundedList and function:isObjectEmpty(object)}">hide</c:if>">
        <c:if test="${not isUnboundedList}">
            <label>${label}</label>
            <div id="${specifier}-add-input-button"
                 class="input-group control-group ${specifier}-${tagName}-add-more <c:if test="${not function:isObjectEmpty(object)}">hide</c:if>">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-${tagName}" type="button"><i
                            class="fa fa-plus-circle"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
        </c:if>
        <div id="${specifier}-input-block"
        class="form-group control-group edit-form-group <c:if
            test="${function:isObjectEmpty(object) and not isUnboundedList}">hide</c:if>">
        <c:if test="${isUnboundedList}">
            <label>${label}</label>
        </c:if>
        <c:if test="${not isFirstRequired}">
            <button class="btn btn-danger ${specifier}-${tagName}-remove" type="button"><i
                    class="fa fa-minus-circle"></i>
                Remove
            </button>
        </c:if>
    </c:when>


    <c:when test="${showTopOrBottom == 'bottom'}">
        </div>
        <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </c:if>

        <script type="text/javascript">
            $(document).ready(function () {
                $("body").on("click", ".${specifier}-add-${tagName}", function (e) {
                    e.stopImmediatePropagation();

                    $("#${specifier}-input-block").removeClass("hide");
                    <c:if test="${isUnboundedList or not isRequired}">
                    $("#${specifier}-add-input-button").addClass("hide");
                    </c:if>

                    //Add section
                    $("#${specifier}-${tagName}").val("");
                });

                //Remove section
                $("body").on("click", ".${specifier}-${tagName}-remove", function (e) {
                    e.stopImmediatePropagation();

                    clearAndHideEditControlGroup(this);
                    $("#${specifier}-add-input-button").removeClass("hide");
                    $("#${specifier}-input-block").addClass("hide");
                });
            });

        </script>

        </div>
    </c:when>
</c:choose>

