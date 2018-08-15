<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="study" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Study" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>


<div id="${id}"
     class="form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if>">
    <label>${label}</label>
    <div id="${specifier}-add-input-button"
         class="input-group control-group ${specifier}-study-add-more <c:if test="${not function:isObjectEmpty(study)}">hide</c:if>">
        <div class="input-group-btn">
            <button class="btn btn-success ${specifier}-add-study" type="button"><i
                    class="fa fa-plus-circle"></i> Add
                ${label}
            </button>
        </div>
    </div>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(study) and not isUnboundedList}">hide</c:if>">
        <c:if test="${isUnboundedList}">
            <label>${label}</label>
        </c:if>
        <button class="btn btn-danger ${specifier}-study-remove" type="button"><i
                class="fa fa-minus-circle"></i>
            Remove
        </button>
        <myTags:editNonZeroLengthString
                placeholder=" The name of the activity, usually one sentece or short description of the study."
                label="Name"
                string="${study.name}"
                specifier="${specifier}-name"
                isUnboundedList="${false}"
                id="${specifier}-name"
                isRequired="${true}"
                path="${path}.name">
        </myTags:editNonZeroLengthString>
        <myTags:editDates label="Start Date"
                          path="${path}.startDate"
                          specifier="${specifier}-startDate"
                          id="${specifier}-startDate"
                          isUnboundedList="${false}"
                          isRequired="${false}"
                          showEditFormGroup="${true}"
                          date="${study.startDate}">
        </myTags:editDates>
        <myTags:editDates label="End Date"
                          path="${path}.endDate"
                          specifier="${specifier}-endDate"
                          id="${specifier}-startDate"
                          isUnboundedList="${false}"
                          isRequired="${false}"
                          showEditFormGroup="${true}"
                          date="${study.endDate}">
        </myTags:editDates>
        <myTags:editPlace path="${path}.location"
                          specifier="${specifier}-location"
                          id="${specifier}-location"
                          place="${study.location}"
                          isUnboundedList="${false}"
                          label="Location">
        </myTags:editPlace>


        <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </c:if>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-add-study", function (e) {
                e.stopImmediatePropagation();

                $("#${specifier}-input-block").removeClass("hide");
                <c:if test="${isUnboundedList or not isRequired}">
                $("#${specifier}-add-input-button").addClass("hide");
                </c:if>

                //Add section
                $("#${specifier}-study").val("");
            });

            //Remove section
            $("body").on("click", ".${specifier}-study-remove", function (e) {
                e.stopImmediatePropagation();

                clearAndHideEditControlGroup(this);
                $("#${specifier}-add-input-button").removeClass("hide");
                $("#${specifier}-input-block").addClass("hide");
            });
        });

    </script>

</div>
