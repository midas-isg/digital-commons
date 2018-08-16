<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%@ attribute name="number" required="false"
              type="java.lang.Float" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>


<div id="${id}"
     class="form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if>">
    <label>${label}</label>
    <div id="${specifier}-add-input-button"
         class="input-group control-group ${specifier}-number-add-more <c:if test="${not empty number}">hide</c:if>">
        <div class="input-group-btn">
            <button class="btn btn-success ${specifier}-add-number" type="button"><i
                    class="fa fa-plus-circle"></i> Add
                    ${label}
            </button>
        </div>
    </div>
    <div id="${specifier}-input-block"
         class="input-group control-group full-width <c:if test="${empty number}">hide</c:if>">
        <input type="number" step="any" class="form-control" value="${number}" name="${path}" id="${specifier}-number" placeholder="${placeholder}"/>
        <div class="input-group-btn">
            <button class="btn btn-danger ${specifier}-number-remove" type="button"><i
                    class="fa fa-minus-circle"></i>
                Remove
            </button>
        </div>
    </div>

    <c:if test="${not isRequired}">
        <script type="text/javascript">
            $(document).ready(function () {
                $("body").on("click", ".${specifier}-add-number", function (e) {
                    e.stopImmediatePropagation();

                    $("#${specifier}-input-block").removeClass("hide");
                    $("#${specifier}-add-input-button").addClass("hide");

                    //Add section
                    $("#${specifier}-number").val("");
                });

                //Remove section
                $("body").on("click", ".${specifier}-number-remove", function (e) {
                    e.stopImmediatePropagation();

                    clearAndHideEditControlGroup(this);
                    $("#${specifier}-add-input-button").removeClass("hide");
                    $("#${specifier}-input-block").addClass("hide");
                });
            });

        </script>
    </c:if>

</div>
