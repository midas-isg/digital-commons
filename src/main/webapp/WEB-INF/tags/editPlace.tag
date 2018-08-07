<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="place" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Place" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="expanded" required="false" type="java.lang.Boolean" %>
<%--<%@ attribute name="placeholder" required="true"--%>
              <%--type="java.lang.String" %>--%>


<c:choose>
    <%--<c:when test="${not empty place.name or not empty place.description or not empty place.postalAddress}">--%>
    <c:when test="${not function:isObjectEmpty(place) or expanded}">
        <div class=" ${status.error ? 'has-error' : ''}">
            <div class="form-group control-group edit-form-group">
                <label>${label}</label>
                <c:if test="${expanded}">
                    <button class="btn btn-danger place-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                </c:if>
                <button class="btn btn-success add-${specifier}" style="display: none" id="${specifier}-add" type="button"><i
                        class="fa fa-plus-circle"></i> Add ${label}
                </button>
                <div class="form group control-group">
                    <div class="input-group-btn">
                        <c:if test="${expanded == null}">
                        <button class="btn btn-danger ${specifier}-remove" id="${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                            Remove
                        </button>
                        </c:if>
                    </div>
                    <myTags:editIdentifierUnbounded specifier="${specifier}-identifier"
                                                    label="Identifier"
                                                    path="${path}.identifier"
                                                    identifier="${place.identifier}"
                                                    unbounded="${false}">
                    </myTags:editIdentifierUnbounded>
                    <myTags:editIdentifierUnbounded specifier="${specifier}-alternateIdentifiers"
                                                    label="Alternate Identifiers"
                                                    path="${path}.alternateIdentifiers"
                                                    identifiers="${place.alternateIdentifiers}"
                                                    unbounded="${true}">
                    </myTags:editIdentifierUnbounded>
                    <myTags:editRequiredNonZeroLengthString path="${path}.name"
                                                            placeholder=" The name of the place."
                                                            string="${place.name}"
                                                            label=" Name">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthStringTextArea path="${path}.description"
                                                               specifier="${specifier}-description"
                                                               string="${place.description}"
                                                               placeholder=" A textual narrative comprised of one or more statements describing the place."
                                                               label="Description">
                    </myTags:editNonRequiredNonZeroLengthStringTextArea>
                    <myTags:editNonZeroLengthString path="${path}.postalAddress"
                                                    specifier="${specifier}-postalAddress"
                                                    string="${place.postalAddress}"
                                                    placeholder=" A physical street address."
                                                    label="Postal Address">
                    </myTags:editNonZeroLengthString>
                    <div class="form-group edit-form-group">
                        <label>Geometry</label>
                        <c:choose>
                            <c:when test="${not empty place.geometry}">
                                <button class="btn btn-success ${specifier}-geometry-add" id="${specifier}-geometry-add" type="button" style="display: none;"><i
                                        class="fa fa-plus-circle"></i> Add Geometry
                                </button>
                                <div class="form-group control-group edit-form-group ${specifier}-geometry">
                                    <label>Geometry</label>
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
                                    <button class="btn btn-danger ${specifier}-geometry-remove" id="${specifier}-geometry-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                                        Remove
                                    </button>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-success ${specifier}-geometry-add" id="${specifier}-geometry-add" type="button"><i
                                        class="fa fa-plus-circle"></i> Add Geometry
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group control-group edit-form-group">
            <label>${label}</label>
            <button class="btn btn-success add-${specifier}" id="${specifier}-add" type="button"><i
                    class="fa fa-plus-circle"></i> Add ${label}
            </button>
        </div>
    </c:otherwise>
</c:choose>


<div class="copy-${specifier} hide">
    <div class="form-group control-group edit-form-group">
        <label>${label}</label>
        <%--<div class="input-group-btn">--%>
            <button class="btn btn-danger ${specifier}-remove" id="${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        <%--</div>--%>
        <myTags:editIdentifierUnbounded specifier="${specifier}-identifier"
                                        label="Identifier"
                                        path="${path}.identifier"
                                        unbounded="${false}">
        </myTags:editIdentifierUnbounded>
        <myTags:editIdentifierUnbounded specifier="${specifier}-alternateIdentifiers"
                                        label="Alternate Identifiers"
                                        path="${path}.alternateIdentifiers"
                                        unbounded="${true}">
        </myTags:editIdentifierUnbounded>
        <myTags:editRequiredNonZeroLengthString path="${path}.name"
                                                placeholder=" The name of the place."
                                                label=" Name">
        </myTags:editRequiredNonZeroLengthString>
        <myTags:editNonRequiredNonZeroLengthStringTextArea path="${path}.description"
                                                   specifier="${specifier}-description"
                                                   placeholder=" A textual narrative comprised of one or more statements describing the place."
                                                   label="Description">
        </myTags:editNonRequiredNonZeroLengthStringTextArea>
        <myTags:editNonZeroLengthString path="${path}.postalAddress"
                                        specifier="${specifier}-postalAddress"
                                        placeholder=" A physical street address."
                                        label="Postal Address">
        </myTags:editNonZeroLengthString>
        <div class="form-group edit-form-group">
            <label>Geometry</label>
            <button class="btn btn-success ${specifier}-geometry-add" id="${specifier}-geometry-add" type="button"><i
                    class="fa fa-plus-circle"></i> Add Geometry
            </button>
        </div>
    </div>
</div>

<div class="copy-${specifier}-geometry hide">
    <div class="form-group control-group edit-form-group">
        <label>Geometry</label>
        <select name="${path}.geometry" id="${specifier}-geometry-select">
            <option value="">Please Select...</option>
            <option value="POINT">POINT</option>
            <option value="MULTIPOINT">MULTIPOINT</option>
            <option value="LINESTRING">LINESTRING</option>
            <option value="MULTILINESTRING">MULTILINESTRING</option>
            <option value="POLYGON">POLYGON</option>
            <option value="MULTIPOLYGON">MULTIPOLYGON</option>
            <option value="GEOMETRYCOLLECTION">GEOMETRYCOLLECTION</option>
        </select>
        <button class="btn btn-danger ${specifier}-geometry-remove" id="${specifier}-geometry-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
    </div>
</div>



<script type="text/javascript">
    $(document).ready(function () {

        //Remove section
        $("body").on("click", ".${specifier}-remove", function () {
            clearAndHideEditControlGroup(this);
            $("#${specifier}-add").show();
        });
        $("body").on("click", ".${specifier}-geometry-remove", function () {
            // clearAndHideEditControlGroup(this);
            document.getElementById("${specifier}-geometry-select").value = "";
            $(this).closest(".control-group").hide();
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
            <%--var path = "${path}.geometry";--%>
            <%--path = 'name="' + path + '" id=';--%>
            var html = $(".copy-${specifier}-geometry").html();
            // html = html.replace("id=", path);
            $(this).after(html);
            e.stopImmediatePropagation();
            $(this).hide();
        });


    });
</script>