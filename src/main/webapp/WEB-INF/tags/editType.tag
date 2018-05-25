<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="types" required="false"
              type="java.util.ArrayList" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>


<c:choose>
    <c:when test="${not empty types}">
        <spring:bind path="${path}[0]">
            <div class=" ${status.error ? 'has-error' : ''}">
            <c:forEach items="${types}" varStatus="status" var="type">
                <c:choose>
                    <c:when test="${status.first}">
                        <div class="form-group control-group edit-form-group ${specifier}-type-add-more">
                        <label>Type</label>
                        <button class="btn btn-success ${specifier}-add-type" type="button"><i class="glyphicon glyphicon-plus"></i>
                            Add Type
                        </button>
                    </c:when>
                    <c:otherwise>
                        <div class="form-group control-group edit-form-group">
                        <label>Type</label>
                        <button class="btn btn-danger ${specifier}-type-remove" type="button"><i
                                class="glyphicon glyphicon-remove"></i> Remove
                        </button>
                    </c:otherwise>
                </c:choose>

                <br><br>
                <div>
                    <c:choose>
                        <c:when test="${not empty type.information}">
                            <button class="btn btn-success ${specifier}-add-annotation" style="display: none;"
                                    id="${status.count-1}-add-information-${specifier}" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add
                                Information
                            </button>
                            <div class="form-group control-group edit-form-group">
                                <label id="annotation-label">Information</label>
                                <button class="btn btn-danger annotation-remove" id="${status.count-1}-information"
                                        type="button"><i
                                        class="glyphicon glyphicon-remove"></i> Remove
                                </button>

                                <myTags:editAnnotation annotation="${type.information}"
                                                       path="${path}[${status.count-1}].information."></myTags:editAnnotation>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-success ${specifier}-add-annotation" id="${status.count-1}-add-information-${specifier}"
                                    type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add
                                Information
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
                <br>

                <div>
                    <c:choose>
                        <c:when test="${not empty type.method}">
                            <button class="btn btn-success ${specifier}-add-annotation" style="display: none;"
                                    id="${status.count-1}-add-method-${specifier}" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add
                                Method
                            </button>
                            <div class="form-group control-group edit-form-group">
                                <label id="annotation-label">Method</label>
                                <button class="btn btn-danger annotation-remove" id="${status.count-1}-method"
                                        type="button"><i
                                        class="glyphicon glyphicon-remove"></i> Remove
                                </button>

                                <myTags:editAnnotation annotation="${type.method}"
                                                       path="${path}[${status.count-1}].method."></myTags:editAnnotation>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-success ${specifier}-add-annotation" id="${status.count-1}-add-method-${specifier}"
                                    type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add
                                Method
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
                <br>

                <div>
                    <c:choose>
                        <c:when test="${not empty type.platform}">
                            <button class="btn btn-success ${specifier}-add-annotation" style="display: none;"
                                    id="${status.count-1}-add-platform-${specifier}" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add
                                Platform
                            </button>
                            <div class="form-group control-group edit-form-group">
                                <label id="annotation-label">Platform</label>
                                <button class="btn btn-danger annotation-remove" id="${status.count-1}-platform"
                                        type="button"><i
                                        class="glyphicon glyphicon-remove"></i> Remove
                                </button>

                                <myTags:editAnnotation annotation="${type.platform}"
                                                       path="${path}[${status.count-1}].platform."></myTags:editAnnotation>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-success ${specifier}-add-annotation" id="${status.count-1}-add-platform-${specifier}"
                                    type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add
                                Platform
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
                <c:if test="${status.first}">
                    <form:errors path="${path}[0]" class="error-color"/>
                </c:if>
                </div>
                <c:set var="typeCount" scope="page" value="${status.count}"/>

            </c:forEach>
            </div>
        </spring:bind>
    </c:when>
    <c:otherwise>
        <spring:bind path="${path}[0]">
            <div class="form-group edit-form-group ${specifier}-type-add-more ${status.error ? 'has-error' : ''}">
                <label>Type</label>
                <button class="btn btn-success ${specifier}-add-type" type="button"><i class="glyphicon glyphicon-plus"></i> Add Type
                </button>
                <br><br>
                <div>
                    <button class="btn btn-success ${specifier}-add-annotation" id="0-add-information-${specifier}" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Information
                    </button>
                </div>
                <br>
                <div>
                    <button class="btn btn-success ${specifier}-add-annotation" id="0-add-method-${specifier}" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Method
                    </button>
                </div>
                <br>
                <div>
                    <button class="btn btn-success ${specifier}-add-annotation" id="0-add-platform-${specifier}" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Platform
                    </button>
                </div>
            </div>
            <form:errors path="${path}[0]" class="error-color"/>

            <c:set var="typeCount" scope="page" value="1"/>
        </spring:bind>
    </c:otherwise>
</c:choose>


<div class="copy-annotation-information hide">
    <div class="form-group control-group edit-form-group">
        <label id="annotation-label">Information</label>
        <button class="btn btn-danger annotation-remove" id="information" type="button"><i
                class="glyphicon glyphicon-remove"></i> Remove
        </button>

        <myTags:editAnnotation path="path"></myTags:editAnnotation>
    </div>
</div>

<div class="copy-annotation-method hide">
    <div class="form-group control-group edit-form-group">
        <label id="annotation-label">Method</label>
        <button class="btn btn-danger annotation-remove" id="method" type="button"><i
                class="glyphicon glyphicon-remove"></i> Remove
        </button>

        <myTags:editAnnotation path="path"></myTags:editAnnotation>
    </div>
</div>

<div class="copy-annotation-platform hide">
    <div class="form-group control-group edit-form-group">
        <label id="annotation-label">Platform</label>
        <button class="btn btn-danger annotation-remove" id="platform" type="button"><i
                class="glyphicon glyphicon-remove"></i> Remove
        </button>

        <myTags:editAnnotation path="path"></myTags:editAnnotation>
    </div>
</div>


<div class="copy-type hide">
    <div class="form-group control-group edit-form-group">
        <label>Type</label>
        <button class="btn btn-danger ${specifier}-type-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>
        <br><br>
        <div>
            <button class="btn btn-success ${specifier}-add-annotation" id="add-information-${specifier}" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Information
            </button>
        </div>
        <br>
        <div>
            <button class="btn btn-success ${specifier}-add-annotation" id="add-method-${specifier}" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Method
            </button>
        </div>
        <br>
        <div>
            <button class="btn btn-success ${specifier}-add-annotation" id="add-platform-${specifier}" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Platform
            </button>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var typeCount = ${typeCount};
        //Add section
        $("body").on("click", ".${specifier}-add-type", function (e) {
            e.stopImmediatePropagation();

            var html = $(".copy-type").html();

            html = html.replace(/id="add/g, 'id="' + typeCount + '-add');
            $(".${specifier}-type-add-more").after(html);
            typeCount += 1;

        });

        //Remove section
        $("body").on("click", ".${specifier}-type-remove", function () {
            $(this).parents(".control-group").remove();
        });


        //Show/Hide Annotation
        $("body").on("click", ".${specifier}-add-annotation", function (e) {
            e.stopImmediatePropagation();

            var id = event.target.id;
            var count = id.split('-')[0];
            var attributeName = id.split('-')[2];
            if (count != undefined && attributeName != undefined) {

                var html = $(".copy-annotation-" + attributeName).html();
                //use '//g' regex for global capture, otherwise only first instance is repalced
                html = html.replace(attributeName, count + '-' + attributeName).replace(/name="path/g, 'name="${path}[' + count + '].' + attributeName + '.');

                $(this).after(html);
                $(this).hide();
            }
        });
        $("body").on("click", ".annotation-remove", function () {
            var id = event.target.id;
            var count = id.split('-')[0];
            var attributeName = id.split('-')[1];
            if (count != undefined && attributeName != undefined) {

                $(this).parents(".control-group")[0].remove();
                console.log("#" + count + "-add-" + attributeName);
                $("#" + count + "-add-" + attributeName + "-${specifier}").show();
            } else {
                console.log(event.target);
            }
        });
    });
</script>