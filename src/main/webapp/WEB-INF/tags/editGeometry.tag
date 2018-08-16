<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="geometry" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Geometry" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>


<div class="form-group edit-form-group">
    <label>Geometry</label>
    <button class="btn btn-success ${specifier}-geometry-add <c:if test="${not function:isObjectEmpty(geometry)}">hide</c:if>"
            id="${specifier}-geometry-add" type="button"><i
            class="fa fa-plus-circle"></i> Add Geometry
    </button>
    <%--TODO: fix clear of select (geometry)--%>
    <div id="${specifier}-geometry-input-group"
         class="form-group control-group edit-form-group ${specifier}-geometry <c:if test="${empty geometry}">hide</c:if>">
        <label>Geometry</label>
        <div class="input-group">

            <select class="custom-select" name="${path}" id="${specifier}-geometry-select"
                    title="${specifier}-geometry">
                <option value="">Please Select...</option>
                <c:forEach items="${geometryEnums}" var="geometryEnum" varStatus="status">
                    <option
                            <c:if test="${geometry == geometryEnum}">selected="selected"</c:if>
                            value="${geometryEnum}">
                            ${geometryEnum}</option>
                </c:forEach>
            </select>
            <div class="input-group-append">
                <button class="btn btn-danger ${specifier}-geometry-remove" id="${specifier}-geometry-remove"
                        type="button"><i class="fa fa-minus-circle"></i>
                    Remove
                </button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        //Remove section
        $("body").on("click", ".${specifier}-geometry-remove", function () {
            clearAndHideEditControlGroup(this);
            <%--document.getElementById("${specifier}-geometry-select").value = "";--%>

            $("#${specifier}-geometry-input-group").addClass("hide");
            $("#${specifier}-geometry-add").removeClass("hide");
        });


        //Add section
        $("body").on("click", ".${specifier}-geometry-add", function (e) {
            $("#${specifier}-geometry-input-group").removeClass("hide");
            $("#${specifier}-geometry-add").addClass("hide");
        });


    });
</script>