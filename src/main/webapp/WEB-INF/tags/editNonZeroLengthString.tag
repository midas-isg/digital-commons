<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="string" required="false"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>
<%@ attribute name="isTextArea" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>


<%--
<div id="${id}"
     class="form-group <c:if test="${not isUnboundedList}">edit-form-group</c:if> <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${not isRequired and isUnboundedList and empty string}">hide</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <c:if test="${not isRequired}">
            <div id="${specifier}-add-input-button"
                 class="input-group control-group ${specifier}-string-add-more <c:if test="${not empty string}">hide</c:if>">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-string" type="button"><i
                            class="fa fa-plus-circle"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
        </c:if>
    </c:if>
    <div id="${specifier}-input-block"
         class="input-group control-group full-width <c:if test="${empty string and not isUnboundedList and not isRequired}">hide</c:if>">
--%>

        <myTags:editMasterElementWrapper path="${path}"
                                         specifier="${specifier}"
                                         object="${string}"
                                         label="${label}"
                                         id="${id}"
                                         isUnboundedList="${isUnboundedList}"
                                         isInputGroup="${true}"
                                         isRequired="${isRequired}"
                                         tagName="string"
                                         showTopOrBottom="top">
        </myTags:editMasterElementWrapper>
        <myTags:editInputBlock path="${path}"
                               specifier="${specifier}-string"
                               string="${string}"
                               isTextArea="${isTextArea}"
                               placeholder="${placeholder}">
        </myTags:editInputBlock>
<%--
        <c:choose>
            <c:when test="${isTextArea}">
                <textarea name="${path}" id="${specifier}-string" type="text" class="form-control" rows="5"
                          placeholder="${placeholder}">${fn:escapeXml(string)}</textarea>
            </c:when>
            <c:otherwise>
                <input type="text" class="form-control" value="${fn:escapeXml(string)}" name="${path}"
                       id="${specifier}-string" placeholder="${placeholder}"/>
            </c:otherwise>
        </c:choose>
--%>
        <myTags:editMasterElementWrapper path="${path}"
                                         specifier="${specifier}"
                                         object="${string}"
                                         label="${label}"
                                         id="${id}"
                                         isUnboundedList="${isUnboundedList}"
                                         isInputGroup="${true}"
                                         isRequired="${isRequired}"
                                         tagName="string"
                                         showTopOrBottom="bottom">
        </myTags:editMasterElementWrapper>

<%--
        <c:if test="${not isRequired}">
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-string-remove" type="button"><i
                        class="fa fa-minus-circle"></i>
                    Remove
                </button>
            </div>
        </c:if>
    </div>
    <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
        <span class="error-color">${message.text}</span>
    </c:forEach>

    <c:if test="${not isRequired}">
        <script type="text/javascript">
            $(document).ready(function () {
                $("body").on("click", ".${specifier}-add-string", function (e) {
                    e.stopImmediatePropagation();

                    $("#${specifier}-input-block").removeClass("hide");
                    <c:if test="${isUnboundedList or not isRequired}">
                    $("#${specifier}-add-input-button").addClass("hide");
                    </c:if>

                    //Add section
                    $("#${specifier}-string").val("");
                });

                //Remove section
                $("body").on("click", ".${specifier}-string-remove", function (e) {
                    e.stopImmediatePropagation();

                    clearAndHideEditControlGroup(this);
                    $("#${specifier}-add-input-button").removeClass("hide");
                    $("#${specifier}-input-block").addClass("hide");
                });
            });

        </script>
    </c:if>

</div>
--%>
