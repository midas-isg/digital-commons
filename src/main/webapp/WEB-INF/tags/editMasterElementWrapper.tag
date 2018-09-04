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
<%@ attribute name="isInputGroup" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="cardText" required="true"
              type="java.lang.String" %>

<c:choose>
    <c:when test="${showTopOrBottom == 'top'}">
        <c:if test="${not isUnboundedList and not isRequired}">
            <div class="col card-button <c:if test="${not function:isObjectEmpty(object)}">hide</c:if>"  id="${specifier}-add-input-button">
                <div class="card mx-auto input-group control-group ${specifier}-${tagName}-add-more "
                     style="width: 18rem;">
                    <div class="card-body">
                        <h5 class="card-title">${label}</h5>
                        <%--<h6 class="card-subtitle mb-2 text-muted">Card subtitle</h6>--%>
                        <p class="card-text">${cardText}</p>
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" type="button">Add
                                ${label}
                        </button>
                    </div>
                </div>
            </div>
        </c:if>

        <div id="${id}"
        class="form-group <c:if test="${not isInputGroup}">card</c:if>
        <c:if test="${isInputGroup}">row</c:if>
        <c:if test="${not isUnboundedList}">edit-form-group </c:if> <c:if
            test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if
            test="${(isUnboundedList and function:isObjectEmpty(object)) or (not isRequired and not isUnboundedList)}">hide</c:if>">
        <c:if test="${not isUnboundedList}">
            <c:if test="${not isInputGroup}"> <div class="card-header"></c:if>
            <h6 class="<c:if test="${not isInputGroup}">card-title</c:if> col-2">${label}</h6>


            <c:if test="${not isRequired}">
                <div class="heading-elements">
                    <ul class="list-inline mb-0">
                        <li><a data-action="collapse"><i class="ft-minus"></i></a></li>
                        <li><a data-action="expand"><i class="ft-maximize"></i></a></li>
                        <li><a data-action="close"><i for="${specifier}-input-block"
                                                      class="ft-x ${specifier}-${tagName}-remove"></i></a></li>
                    </ul>
                </div>
                <%--<div id="${specifier}-add-input-button"--%>
                <%--class="input-group control-group ${specifier}-${tagName}-add-more <c:if test="${not function:isObjectEmpty(object)}">hide</c:if>">--%>
                <%--<div class="input-group-btn">--%>
                <%--<button class="btn btn-success ${specifier}-add-${tagName}" type="button"><i--%>
                <%--class="fa fa-plus-circle"></i> Add--%>
                <%--${label}--%>
                <%--</button>--%>
                <%--</div>--%>
                <%--</div>--%>
            </c:if>
            <c:if test="${not isInputGroup}"></div></c:if>
        </c:if>
        <%--<div class="<c:if test="${not isInputGroup}">card-content</c:if> <c:if test="${isInputGroup}">col-9</c:if>">--%>
        <div id="${specifier}-input-block"
        class="<c:if test="${not isInputGroup}">card-content</c:if> <c:if test="${isInputGroup}">col-10</c:if> <c:if
            test="${not isInputGroup}">form-group edit-form-group</c:if> <c:if
            test="${isInputGroup}">input-group full-width</c:if> control-group <c:if
            test="${function:isObjectEmpty(object) and not isUnboundedList and not isRequired}">hide</c:if>">
        <%--<c:if test="${isUnboundedList}">--%>
            <%--<label>${label}</label>--%>
        <%--</c:if>--%>

    </c:when>


    <c:when test="${showTopOrBottom == 'bottom'}">
        <div class="row no-margin" id="${specifier}-input-block-card-row"></div>

        </div>

        <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </c:if>
        <%--</div>  <!-- card-content -->--%>

        <script type="text/javascript">
            $(document).ready(function () {
                rearrangeCards("${specifier}-input-block");

                $("body").on("click", ".${specifier}-add-${tagName}", function (e) {
                    debugger;
                    e.stopImmediatePropagation();
                    $("#${id}").removeClass("hide");
                    $(this).closest('.card').children('.card-content').removeClass('collapse');
                    $("#${specifier}-input-block").removeClass("hide");
                    $("#${specifier}-input-block").addClass("collapse");
                    $("#${specifier}-input-block").addClass("show");

                    $("#${specifier}-input-block").show();

                    <c:if test="${isUnboundedList or not isRequired}">
                    $("#${specifier}-add-input-button").addClass("hide");
                    </c:if>
                    $("#${specifier}-date-picker").datepicker({
                        forceParse: false,
                        orientation: 'top auto',
                        todayHighlight: true,
                        format: 'yyyy-mm-dd',
                        uiLibrary: 'bootstrap4',
                    });

                    //Add section
                    $("#${specifier}-${tagName}").val("");
                });

                //Remove section
                $("body").on("click", ".${specifier}-${tagName}-remove", function (e) {
                    e.stopImmediatePropagation();
                    $("#${specifier}-add-input-button").removeClass("hide");

                    clearAndHideEditControlGroup($(e.target).attr("for"));
                    $(this).closest('.card').addClass("hide").slideUp('fast');

                    $("#${specifier}-input-block").addClass("hide");
                });
            });

        </script>

        </div>
    </c:when>
</c:choose>

