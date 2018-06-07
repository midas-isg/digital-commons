<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="descriptions" required="false"
              type="java.util.ArrayList" %>
<%@ attribute name="accessPointTypes" required="false"
              type="edu.pitt.isg.mdc.v1_0.DataServiceAccessPointType[]" %>

<c:choose>
    <c:when test="${not empty descriptions}">
        <c:forEach items="${descriptions}" varStatus="varStatus" var="description">
            <spring:bind path="dataServiceDescription[${varStatus.count-1}]">
                <div class=" ${status.error ? 'has-error' : ''}">
                <c:choose>
                    <c:when test="${varStatus.first}">
                        <div class="form-group edit-form-group description-add-more">
                        <label>Data Service Descriptions</label>
                        <button class="btn btn-success add-description" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add Data Service Description
                        </button>
                    </c:when>
                    <c:otherwise>

                        <div class="form-group control-group edit-form-group">
                        <label>Data Service Description</label>
                        <button class="btn btn-danger description-remove" type="button"><i
                                class="glyphicon glyphicon-remove"></i> Remove
                        </button>
                    </c:otherwise>
                </c:choose>

                <div class="form-group edit-form-group">
                    <label>Access Point Type</label>
                    <br>
                    <form:select path="dataServiceDescription[${varStatus.count-1}].accessPointType"
                                 items="${accessPointTypes}"></form:select>
                </div>

                <div class="form-group edit-form-group">
                    <label>Access Point Description</label>
                    <input type="text" class="form-control" value="${description.accessPointDescription}"
                           name="dataServiceDescription[${varStatus.count-1}].accessPointDescription"
                           placeholder="Access Point Description">
                </div>

                <div class="form-group edit-form-group">
                    <label>Access Point Url</label>
                    <input type="text" class="form-control" value="${description.accessPointUrl}"
                           name="dataServiceDescription[${varStatus.count-1}].accessPointUrl"
                           placeholder="Access Point Url">
                </div>

                <form:errors path="dataServiceDescription[${varStatus.count-1}]" class="error-color"/>

                </div>
                <c:set var="descriptionCount" scope="page" value="${varStatus.count}"/>
                </div>
            </spring:bind>
        </c:forEach>

    </c:when>
    <c:otherwise>
        <spring:bind path="dataServiceDescription[0]">
            <div class="form-group edit-form-group description-add-more ${status.error ? 'has-error' : ''}">
                <label>Data Service Descriptions</label>
                <button class="btn btn-success add-description" type="button"><i class="glyphicon glyphicon-plus"></i>
                    Add
                    Data Service Description
                </button>

                <div class="form-group edit-form-group">
                    <label>Access Point Type</label>
                    <br>
                    <form:select path="dataServiceDescription[0].accessPointType"
                                 items="${accessPointTypes}"></form:select>
                </div>

                <div class="form-group edit-form-group">
                    <label>Access Point Description</label>
                    <input type="text" class="form-control" value="${descriptions[0].accessPointDescription}"
                           name="dataServiceDescription[0].accessPointDescription"
                           placeholder="Access Point Description">
                </div>

                <div class="form-group edit-form-group">
                    <label>Access Point Url</label>
                    <input type="text" class="form-control" value="${descriptions[0].accessPointUrl}"
                           name="dataServiceDescription[0].accessPointUrl"
                           placeholder="Access Point Url">
                </div>
                <form:errors path="dataServiceDescription[0]" class="error-color"/>
            </div>
            <c:set var="descriptionCount" scope="page" value="1"/>

        </spring:bind>
    </c:otherwise>
</c:choose>


<div class="copy-description hide">
    <div class="form-group  control-group edit-form-group">
        <label>Data Service Description</label>
        <button class="btn btn-danger description-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>

        <div class="form-group edit-form-group">
            <label>Access Point Type</label>
            <br>
            <form:select path="dataServiceDescription[0].accessPointType" items="${accessPointTypes}"></form:select>
        </div>

        <div class="form-group edit-form-group">
            <label>Access Point Description</label>
            <input type="text" class="form-control" name="accessPointDescription"
                   placeholder="Access Point Description">
        </div>

        <div class="form-group edit-form-group">
            <label>Access Point Url</label>
            <input type="text" class="form-control" name="accessPointUrl" placeholder="Access Point Url">
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var descriptionCount = ${descriptionCount};
        //Add section
        $(".add-description").click(function () {
            var html = $(".copy-description").html();
            html = html.replace('name="dataServiceDescription[0].accessPointType"', 'name="dataServiceDescription[' + descriptionCount + '].accessPointType"').replace('name="accessPointDescription"', 'name="dataServiceDescription[' + descriptionCount + '].accessPointDescription"').replace('name="accessPointUrl"', 'name="dataServiceDescription[' + descriptionCount + '].accessPointUrl"');
            descriptionCount += 1;

            $(".description-add-more").after(html);
        });

        //Remove section
        $("body").on("click", ".description-remove", function () {
            $(this).parents(".control-group").remove();
        });
    });
</script>