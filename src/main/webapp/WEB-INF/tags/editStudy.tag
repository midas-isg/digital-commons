<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="study" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Study" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>

<c:choose>
    <c:when test="${not empty study.name or not empty study.location or not empty study.startDate or not empty study.endDate}">
    <%--<c:when test="${not empty study}">--%>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="input-group control-group ${specifier}-study-add-more" style="display: none">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-study" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
            <div class="form-group control-group">
                <div class="form-group-btn">
                    <button class="btn btn-danger ${specifier}-study-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
                    </button>

                    <c:choose>
                        <c:when test="${not empty study.name}">
                            <myTags:editRequiredNonZeroLengthString placeholder=" The name of the activity, usually one sentece or short description of the study."
                                                                    label="Name"
                                                                    string="${study.name}"
                                                                    path="${path}.name"></myTags:editRequiredNonZeroLengthString>
                        </c:when>
                        <c:otherwise>
                            <myTags:editRequiredNonZeroLengthString placeholder=" The name of the activity, usually one sentece or short description of the study."
                                                                    label="Name"
                                                                    path="${path}.name"></myTags:editRequiredNonZeroLengthString>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${not empty study.location}">
                            <div>
                                <button class="btn btn-success add-location" id="location" type="button" style="display: none"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    Location
                                </button>
                            </div>
                            <div class="form-group control-group edit-form-group">
                                <label>Location</label>
                                <br>
                                <button class="btn btn-danger location-remove" type="button"><i
                                        class="glyphicon glyphicon-remove"></i>
                                    Remove
                                </button>
                                <myTags:editRequiredNonZeroLengthString placeholder=" Postal Address"
                                                                           label="Postal Address"
                                                                           string="${study.location.postalAddress}"
                                                                           path="${path}.location.postalAddress"></myTags:editRequiredNonZeroLengthString>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div>
                                <button class="btn btn-success add-location" id="location" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    Location
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <br>
                    <myTags:editDatesBounded label="Start Date"
                                             path="${path}.startDate"
                                             specifier="${specifier}-startDate"
                                             date="${study.startDate}"></myTags:editDatesBounded>
                    <br>
                    <myTags:editDatesBounded label="End Date"
                                             path="${path}.endDate"
                                             specifier="${specifier}-endDate"
                                             date="${study.endDate}"></myTags:editDatesBounded>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="input-group control-group ${specifier}-study-add-more">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-study" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                    </button>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>


<div class="copy-location hide">
    <div class="form-group control-group edit-form-group">
        <label>Location</label>
        <br>
        <button class="btn btn-danger location-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <myTags:editRequiredNonZeroLengthString placeholder=" Postal Address"
                                                label="Postal Address"
                                                path="${path}.location.postalAddress"></myTags:editRequiredNonZeroLengthString>
    </div>
</div>


<div class="copy-study hide">
    <div class="form-group control-group">
        <button class="btn btn-danger study-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>
        <myTags:editRequiredNonZeroLengthString placeholder=" The name of the activity, usually one sentece or short description of the study."
                                                label="Name"
                                                path="${path}.name"></myTags:editRequiredNonZeroLengthString>
        <div>
            <button class="btn btn-success add-location" id="location" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Location
            </button>
        </div>
        <br>
        <myTags:editDatesBounded label="Start Date"
                                 path="${path}.startDate"
                                 specifier="${specifier}-startDate"></myTags:editDatesBounded>
        <br>
        <myTags:editDatesBounded label="End Date"
                                 path="${path}.endDate"
                                 specifier="${specifier}-endDate"></myTags:editDatesBounded>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        $("body").on("click", ".${specifier}-add-study", function (e) {
            e.stopImmediatePropagation();

            var html = $(".copy-study").html();
            html = html.replace('name=""', 'name="${path}"').replace('study-remove', '${specifier}-study-remove');

            //Add section
            $(".${specifier}-study-add-more").after(html);
            $(".${specifier}-study-add-more").hide();
        });
        //Remove section
        $("body").on("click", ".${specifier}-study-remove", function (e) {
            e.stopImmediatePropagation();

            $(this).parents(".control-group").remove();
            $(".${specifier}-study-add-more").show();
        });

        //Show/Hide Location
        $("body").on("click", ".add-location", function () {
            var html = $(".copy-location").html();
            html = html.replace('name="postalAddress"', 'name="${path}.location.postalAddress"');

            $(this).after(html);
            $(this).hide();
        });
        $("body").on("click", ".location-remove", function () {
            $(this).parent(".control-group").remove();
            $(".add-location").show();
        });

    });

</script>