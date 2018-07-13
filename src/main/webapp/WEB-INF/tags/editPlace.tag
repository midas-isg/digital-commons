<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="place" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Place" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%--<%@ attribute name="placeholder" required="true"--%>
              <%--type="java.lang.String" %>--%>


<c:choose>
    <c:when test="${not empty place.name or not empty place.description or not empty place.postalAddress}">
        <div class=" ${status.error ? 'has-error' : ''}">
            <div class="form-group control-group edit-form-group">
                <label>${label}</label>
                <button class="btn btn-success add-${specifier}" style="display: none" id="${specifier}-add" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add ${label}
                </button>
                <div class="form group control-group">
                    <div class="input-group-btn">
                        <button class="btn btn-danger ${specifier}-remove" id="${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                            Remove
                        </button>
                    </div>
                    <myTags:editIdentifier specifier="${specifier}-identifier"
                                           label="Identifier"
                                           path="${path}.identifier"
                                           identifier="${place.identifier}"
                                           unbounded="${false}">
                    </myTags:editIdentifier>
                    <myTags:editRequiredNonZeroLengthString path="${path}.name"
                                                            placeholder=" The name of the place."
                                                            string="${place.name}"
                                                            label=" Name">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString path="${path}.description"
                                                               specifier="${specifier}-description"
                                                               string="${place.description}"
                                                               placeholder=" A textual narrative comprised of one or more statements describing the place."
                                                               label="Description">
                    </myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString path="${path}.postalAddress"
                                                               specifier="${specifier}-postalAddress"
                                                               string="${place.postalAddress}"
                                                               placeholder=" A physical street address."
                                                               label="Postal Address">
                    </myTags:editNonRequiredNonZeroLengthString>
                    <div class="form-group edit-form-group">
                        <label>Geometry</label>
                        <c:choose>
                            <c:when test="${not empty place.geometry}">
                                <div class="form-group control-group edit-form-group ${specifier}-geometry-add">
                                    <label>Geometry</label>
                                    <form:select path="${path}.geometry" id="${specifier}-geometry">
                                        <form:options itemValue="${place.geometry}" itemLabel="Geometry"></form:options>
                                        <form:option value="POINT" />
                                        <form:option value="MULTIPOINT" />
                                        <form:option value="LINESTRING" />
                                        <form:option value="MULTILINESTRING" />
                                        <form:option value="POLYGON" />
                                        <form:option value="MULTIPOLYGON" />
                                        <form:option value="GEOMETRYCOLLECTION" />
                                    </form:select>
                                    <button class="btn btn-danger ${specifier}-geometry-remove" id="${specifier}-geometry-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                                        Remove
                                    </button>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-success ${specifier}-geometry-add" id="${specifier}-geometry-add" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add Geometry
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <button class="btn btn-success add-${specifier}" id="${specifier}-add" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add ${label}
            </button>
        </div>
    </c:otherwise>
</c:choose>


<div class="copy-${specifier} hide">
    <div class="form-group control-group edit-form-group">
        <label>${label}</label>
        <div class="input-group-btn">
            <button class="btn btn-danger ${specifier}-remove" id="${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
        <myTags:editIdentifier specifier="${specifier}-identifier"
                               label="Identifier"
                               path="${path}.identifier"
                               unbounded="${false}">
        </myTags:editIdentifier>
        <myTags:editRequiredNonZeroLengthString path="${path}.name"
                                                placeholder=" The name of the place."
                                                label=" Name">
        </myTags:editRequiredNonZeroLengthString>
        <myTags:editNonRequiredNonZeroLengthString path="${path}.description"
                                                   specifier="${specifier}-description"
                                                   placeholder=" A textual narrative comprised of one or more statements describing the place."
                                                   label="Description">
        </myTags:editNonRequiredNonZeroLengthString>
        <myTags:editNonRequiredNonZeroLengthString path="${path}.postalAddress"
                                                   specifier="${specifier}-postalAddress"
                                                   placeholder=" A physical street address."
                                                   label="Postal Address">
        </myTags:editNonRequiredNonZeroLengthString>
        <div class="form-group edit-form-group">
            <label>Geometry</label>
            <button class="btn btn-success ${specifier}-geometry-add" id="${specifier}-geometry-add" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add Geometry
            </button>
        </div>
    </div>
</div>

<div class="copy-${specifier}-geometry hide">
    <div class="form-group control-group edit-form-group">
        <label>Geometry</label>
        <form:select path="${path}.geometry" id="${specifier}-geometry">
            <form:option value="POINT" />
            <form:option value="MULTIPOINT" />
            <form:option value="LINESTRING" />
            <form:option value="MULTILINESTRING" />
            <form:option value="POLYGON" />
            <form:option value="MULTIPOLYGON" />
            <form:option value="GEOMETRYCOLLECTION" />
        </form:select>
        <button class="btn btn-danger ${specifier}-geometry-remove" id="${specifier}-geometry-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
    </div>
</div>



<script type="text/javascript">
    $(document).ready(function () {

        //Remove section
        $("body").on("click", ".${specifier}-remove", function () {
            $(this).closest(".control-group").remove();
            $("#${specifier}-add").show();
        });
        $("body").on("click", ".${specifier}-geometry-remove", function () {
            $(this).closest(".control-group").remove();
            $("#${specifier}-geometry-add").show();
        });


        //Add section
        $("body").on("click",".add-${specifier}", function (e) {
            var html = $(".copy-${specifier}").html();
            $(this).after(html);
            e.stopImmediatePropagation();
            $(this).hide();
        });

        $("body").on("click",".${specifier}-geometry-add", function (e) {
            var html = $(".copy-${specifier}-geometry").html();
            $(this).after(html);
            e.stopImmediatePropagation();
            $(this).hide();
        });


    });
</script>