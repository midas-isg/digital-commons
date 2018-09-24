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
<%@ attribute name="cardIcon" required="false"
              type="java.lang.String" %>
<%@ attribute name="showCardFooter" required="false"
              type="java.lang.Boolean" %>

<c:choose>
    <c:when test="${showTopOrBottom == 'top'}">
        <c:if test="${not isUnboundedList and not isRequired}">
            <div class="col card-button d-flex align-items-stretch <c:if test="${not function:isObjectEmpty(object)}">hide</c:if>"  id="${specifier}-add-input-button">
                <div class="card mx-auto input-group control-group card-rounded ${specifier}-${tagName}-add-more "
                     style="width: 20rem;">
                    <div class="card-header card-button-header add-card-header">
                        <button class="btn btn-primary mt-auto btn-block ${specifier}-add-${tagName}" type="button"
                                onclick="showCard('${specifier}', '${tagName}', '${id}', '${isUnboundedList}', '${isRequired}')">
                            <i class="fa fa-plus-circle"></i> Add ${label}
                        </button>
                        <div class="d-flex justify-content-center align-items-center">
                            <div class="card-label">${label}</div>
                            <div class="card-icon"><i class="${cardIcon}"></i></div>
                        </div>
                    </div>
                    <div class="card-body card-button-body d-flex">
                        <p class="card-text">${cardText}</p>
                        <p class="card-text">
                            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                                <span class="error-color error offset-2">${message.text}</span>
                            </c:forEach>
                        </p>
                    </div>
                </div>
            </div>
        </c:if>

        <div id="${id}"
        class="<c:if test="${not isUnboundedList}">form-group </c:if> <c:if test="${not isInputGroup and not isUnboundedList}">card</c:if>
            <c:if test="${isUnboundedList}">card-content collapse show</c:if>
            <c:if test="${isInputGroup}">row</c:if>
            <c:if test="${not isUnboundedList}">edit-form-group </c:if>
            <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error </c:if>
            <c:if test="${not isUnboundedList and not empty flowRequestContext.messageContext.getMessagesByCriteria(function:getMessageCriteria(path))}">has-error-card </c:if>
            <c:if test="${(isUnboundedList and function:isObjectEmpty(object)) or (isUnboundedList and not function:isFirstInstance(specifier)) or (function:isObjectEmpty(object) and not isRequired and not isUnboundedList)}">hide</c:if>">

        <c:if test="${not isUnboundedList}">
            <c:if test="${not isInputGroup}"> <div class="card-header"></c:if>
            <h6 class="<c:if test="${not isInputGroup}">card-title</c:if> col-sm-2">${label}</h6>


            <c:if test="${not isInputGroup}">
                <div class="heading-elements">
                    <ul class="list-inline mb-0">
                        <li><a data-toggle="tooltip" data-placement="top" title="${cardText}"><i
                                class="ft-info ft-buttons"></i></a></li>
                        <li><a data-action="collapse"><i class="ft-minus"></i></a></li>
                        <li><a data-action="expand"><i class="ft-maximize"></i></a></li>
                        <c:if test="${not isRequired}">

                            <li><a data-action="close" onclick="removeSection('${specifier}', '${tagName}', event, false)"><i
                                    for="${specifier}-input-block"
                                    class="ft-x ${specifier}-${tagName}-remove"></i></a></li>
                        </c:if>

                    </ul>
                </div>
            </c:if>

            <c:if test="${not isInputGroup}"></div></c:if>
        </c:if>


        <%--<div class="<c:if test="${not isInputGroup}">card-content</c:if> <c:if test="${isInputGroup}">col-9</c:if>">--%>
        <div id="${specifier}-input-block"
        class="<c:if test="${not isInputGroup}">card-content collapse show form-group edit-form-group</c:if>
            <c:if test="${isInputGroup}">col-sm-10 input-group full-width</c:if>
            control-group
            <c:if test="${(function:isObjectEmpty(object) and not isUnboundedList and not isRequired) or (isUnboundedList and not function:isFirstInstance(specifier))}">hide</c:if>">
<%--
            <c:if test="${not isInputGroup}">form-group edit-form-group</c:if>
            <c:if test="${isInputGroup}">input-group full-width</c:if>
--%>
        <%--<c:if test="${isUnboundedList}">--%>
            <%--<label>${label}</label>--%>
        <%--</c:if>--%>

    </c:when>


    <c:when test="${showTopOrBottom == 'bottom'}">
        <div class="row no-margin" id="${specifier}-input-block-card-row"></div>

        </div>

        <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                <span class="error-color error offset-2">${message.text}</span>
            </c:forEach>
        </c:if>
        <%--</div>  <!-- card-content -->--%>

        <c:if test="${showCardFooter and not isUnboundedList and not isInputGroup}">
            <div class="card-footer">
                    ${label} <a class="color-white" onclick="scrollToAnchor('${specifier}');"><i class="fa fa-arrow-circle-o-up" aria-hidden="true"></i></a>

            </div>
        </c:if>

        <script type="text/javascript">
            $(document).ready(function () {
                <c:if test="${tagName == 'date' and isInputGroup}">
                $("#${specifier}").datepicker({
                    forceParse: false,
                    orientation: 'top auto',
                    todayHighlight: true,
                    format: 'yyyy-mm-dd',
                    uiLibrary: 'bootstrap4',
                });
                </c:if>
                rearrangeCards("${specifier}-input-block");
            });

        </script>
        </div>

    </c:when>
</c:choose>

