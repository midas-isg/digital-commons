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
        <select name="${path}.geometry" id="${specifier}-geometry-select" title="${specifier}-geometry">
            <option value="">Please Select...</option>
            <c:forEach items="${geometryEnums}" var="geometryEnum" varStatus="status">
                <option
                        <c:if test="${geometry == geometryEnum}">selected="selected"</c:if>
                        value="${geometryEnum}">
                        ${geometryEnum}</option>
            </c:forEach>
        </select>
        <%--
                        <select name="${path}.geometry" id="${specifier}-geometry-select" title="${specifier}-geometry">
                            <option value="null">Please Select...</option>
                            <option <c:if test="${place.geometry == 'POINT'}">selected="selected"</c:if> value="POINT">POINT</option>
                            <option <c:if test="${place.geometry == 'MULTIPOINT'}">selected="selected"</c:if> value="MULTIPOINT">MULTIPOINT</option>
                            <option <c:if test="${place.geometry == 'LINESTRING'}">selected="selected"</c:if> value="LINESTRING">LINESTRING</option>
                            <option <c:if test="${place.geometry == 'MULTILINESTRING'}">selected="selected"</c:if> value="MULTILINESTRING">MULTILINESTRING</option>
                            <option <c:if test="${place.geometry == 'POLYGON'}">selected="selected"</c:if> value="POLYGON">POLYGON</option>
                            <option <c:if test="${place.geometry == 'MULTIPOLYGON'}">selected="selected"</c:if> value="MULTIPOLYGON">MULTIPOLYGON</option>
                            <option <c:if test="${place.geometry == 'GEOMETRYCOLLECTION'}">selected="selected"</c:if> value="GEOMETRYCOLLECTION">GEOMETRYCOLLECTION</option>
                        </select>
        --%>
        <button class="btn btn-danger ${specifier}-geometry-remove" id="${specifier}-geometry-remove"
                type="button"><i class="fa fa-minus-circle"></i>
            Remove
        </button>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        //Remove section
        $("body").on("click", ".${specifier}-geometry-remove", function () {
            document.getElementById("${specifier}-geometry-select").value = "";

            <%--document.getElementById("${specifier} - geometry - select").value = "";--%>
            <%--$("#${specifier} - geometry - selectoption:selected").prop("selected",false);--%>
            <%--$("#${specifier} - geometry - select").selectedIndex = -1;--%>
            <%--$("#${specifier} - geometry - select").prop("selectedIndex",0);--%>

            <%--console.log(document.getElementById("${specifier}-geometry-select").valueOf());--%>
            <%--$("#${specifier}-geometry-select option:selected").prop("selected",false);--%>
            <%--$("#${specifier}-geometry-select:selected").val = " ";--%>
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