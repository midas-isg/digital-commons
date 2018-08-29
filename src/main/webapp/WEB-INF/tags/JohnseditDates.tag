<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="date" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Date" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${date}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isInputGroup="${false}"
                                 isRequired="${isRequired}"
                                 tagName="date"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editInputBlock path="${path}.date"
                       specifier="${specifier}-date-picker"
                       date="${date}"
                       isDate="${true}"
                       placeholder="">
</myTags:editInputBlock>

<<<<<<< HEAD
<div id="${id}"
     class="card form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${not isRequired and isUnboundedList and function:isObjectEmpty(date)}">d-none</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <c:if test="${not isRequired}">
            <div id="${specifier}-add-input-button
                 class="input-group control-group ${specifier}-date-add-more <c:if test="${not function:isObjectEmpty(date)}">d-none</c:if>">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-date" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
        </c:if>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(date) and not isUnboundedList and not isRequired}">d-none</c:if>">
       <%-- <button class="btn btn-danger ${specifier}-date-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i>
            Remove
        </button>--%>
        <div class="form-group edit-form-group">
            <label>Date</label>
            <input type="text" class="form-control date" value="${date.date}" name="${path}.date"
                   id="${specifier}-date-picker">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(datePath)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
            <myTags:editAnnotation id="${}"
                                   path="${path}.type"
                                   annotation="${date.type}"
                                   isRequired="false"
                                   label="Annotation"
                                   specifier="${specifier}-date">
            </myTags:editAnnotation>
        </div>
    </div>

    <c:if test="${not isRequired}">
        <script type="text/javascript">
            $(document).ready(function () {
                $("body").on("click", ".${specifier}-add-date", function (e) {
                    e.stopImmediatePropagation();

                    $("#${specifier}-input-block").removeClass("d-none");
                    <c:if test="${isUnboundedList or not isRequired}">
                    $("#${specifier}-add-input-button").addClass("d-none");
                    </c:if>

                    //Add section
                    $("#${specifier}-date").val("");
                });

                //Remove section
                $("body").on("click", ".${specifier}-date-remove", function (e) {
                    e.stopImmediatePropagation();

                    clearAndHideEditControlGroup(this);
                    $("#${specifier}-add-input-button").removeClass("d-none");
                    $("#${specifier}-input-block").addClass("d-none");
                });
            });

            $(document).on("focus", "input.date:not(.hasDatepicker)", function () {
                $(this).datepicker({
                    constrainInput: false,
                    changeMonth: true,
                    changeYear: true
                });
            });
        </script>
    </c:if>

</div>

<%--
<script>
    $(document).on("focus", "input.date:not(.hasDatepicker)", function () {
        &lt;%&ndash;$("#${specifier}-date-picker").live("click", function () {&ndash;%&gt;
        $(this).datepicker({
            constrainInput: false,
            changeMonth: true,
            changeYear: true
            --%>
=======
<c:set var="datePath" value="${path}.date"/>
<c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(datePath)}" var="message">
    <span class="error-color">${message.text}</span>
</c:forEach>
<myTags:editAnnotation path="${path}.type"
                       annotation="${date.type}"
                       isRequired="false"
                       label="Annotation"
                       id="${specifier}-date"
                       isUnboundedList="${false}"
                       specifier="${specifier}-date">
</myTags:editAnnotation>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${date}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isInputGroup="${false}"
                                 isRequired="${isRequired}"
                                 tagName="date"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
<script type="text/javascript">
    $(document).ready(function () {
        <c:if test="${not empty date.date}">
        $("#${specifier}-date-picker").datepicker({
            todayHighlight: true,
            format: 'yyyy-mm-dd',
            uiLibrary: 'bootstrap4'
>>>>>>> b30f1a74d0bba7421ff8c16072b132696b14e89f
        });
        </c:if>
    });

</script>
