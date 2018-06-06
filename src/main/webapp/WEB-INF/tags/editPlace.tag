<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="place" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Place" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>


<c:choose>
    <c:when test="${not empty place.name or not empty place.description or not empty place.postalAddress}">
        <%--<spring:bind path="${path}">--%>
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
                    <c:choose>
                        <c:when test="${not empty place.name}">
                            <div class="form-group edit-form-group">
                                <label>Name</label>
                                <input type="text" class="form-control" value="${place.name}"
                                       name="${path}.name"
                                       placeholder="The name of the place.">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="form-group edit-form-group">
                                <label>Name</label>
                                <input type="text" class="form-control"
                                       name="${path}.name"
                                       placeholder="The name of the place.">
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${not empty place.description}">
                            <div class="form-group control-group edit-form-group">
                                <label>Description</label>
                                <button class="btn btn-success add-${specifier}-description" style="display: none" id="${specifier}-add-description" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add Description
                                </button>
                                <div class="input-group control-group">
                                    <input type="text" class="form-control" value="${place.description}"
                                           name="${path}.description"
                                           placeholder="A textual narrative comprised of one or more statements describing the place.">
                                    <div class="input-group-btn">
                                        <button class="btn btn-danger ${specifier}-description-remove" id="${specifier}-description-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                                            Remove
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="form-group edit-form-group">
                                <label>Description</label>
                                <button class="btn btn-success add-${specifier}-description" id="${specifier}-add-description" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add Description
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${not empty place.postalAddress}">
                            <div class="form-group control-group edit-form-group">
                                <label>Postal Address</label>
                                <button class="btn btn-success add-${specifier}-postalAddress" style="display: none" id="${specifier}-add-postalAddress" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add Postal Address
                                </button>
                                <div class="input-group control-group">
                                    <input type="text" class="form-control" value="${place.postalAddress}"
                                           name="${path}.postalAddress"
                                           placeholder="A physical street address.">
                                    <div class="input-group-btn">
                                        <button class="btn btn-danger ${specifier}-postalAddress-remove" id="${specifier}-postalAddress-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                                            Remove
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="form-group edit-form-group">
                                <label>Postal Address</label>
                                <button class="btn btn-success add-${specifier}-postalAddress" id="${specifier}-add-postalAddress" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add Postal Address
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <%--</spring:bind>--%>
    </c:when>
    <c:otherwise>
        <%--<spring:bind path="${path}">--%>
            <div class="form-group edit-form-group">
                <label>${label}</label>
                <button class="btn btn-success add-${specifier}" id="${specifier}-add" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add ${label}
                </button>
            </div>
        <%--</spring:bind>--%>
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
        <div class="form-group edit-form-group">
            <label>Name</label>
            <input type="text" class="form-control"
                   name="${path}.name"
                   placeholder="The name of the place.">
        </div>
        <div class="form-group edit-form-group">
            <label>Description</label>
            <button class="btn btn-success add-${specifier}-description" id="${specifier}-add-description" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add Description
            </button>
        </div>
        <div class="form-group edit-form-group">
            <label>Postal Address</label>
            <button class="btn btn-success add-${specifier}-postalAddress" id="${specifier}-add-postalAddress" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add Postal Address
            </button>
        </div>
    </div>
</div>

<div class="copy-${specifier}-description hide">
    <div class="input-group control-group">
        <input type="text" class="form-control"
               name="${path}.description"
               placeholder="A textual narrative comprised of one or more statements describing the place.">
        <div class="input-group-btn">
            <button class="btn btn-danger ${specifier}-description-remove" id="${specifier}-description-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
    </div>
</div>

<div class="copy-${specifier}-postalAddress hide">
    <div class="input-group control-group">
        <input type="text" class="form-control"
               name="${path}.postalAddress"
               placeholder="A physical street address.">
        <div class="input-group-btn">
            <button class="btn btn-danger ${specifier}-postalAddress-remove" id="${specifier}-postalAddress-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {

        //Remove section
        $("body").on("click", ".${specifier}-remove", function () {
            $(this).closest(".control-group").remove();
            $("#${specifier}-add").show();
        });
        $("body").on("click", ".${specifier}-description-remove", function () {
            $(this).closest(".control-group").remove();
            $("#${specifier}-add-description").show();
        });
        $("body").on("click", ".${specifier}-postalAddress-remove", function () {
            $(this).closest(".control-group").remove();
            $("#${specifier}-add-postalAddress").show();
        });


        //Add section
        $("body").on("click",".add-${specifier}", function (e) {
            var html = $(".copy-${specifier}").html();
            $(this).after(html);
            e.stopImmediatePropagation();
            $(this).hide();
        });

        $("body").on("click",".add-${specifier}-description", function (e) {
            var html = $(".copy-${specifier}-description").html();
            $(this).after(html);
            e.stopImmediatePropagation();
            $(this).hide();
        });

        $("body").on("click",".add-${specifier}-postalAddress", function (e) {
            var html = $(".copy-${specifier}-postalAddress").html();
            $(this).after(html);
            e.stopImmediatePropagation();
            $(this).hide();
        });

    });
</script>