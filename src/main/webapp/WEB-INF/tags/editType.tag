<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="types" required="false"
              type="java.util.List" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>


<c:choose>
    <c:when test="${not function:isObjectEmpty(types)}">
        <c:choose>
            <c:when test="${not empty flowRequestContext.messageContext.allMessages}">
                <div class="has-error">

            </c:when>
            <c:otherwise>
                <div>
            </c:otherwise>
        </c:choose>
        <c:forEach items="${types}" varStatus="varStatus" var="type">
            <c:choose>
                <c:when test="${varStatus.first}">
                    <div class="form-group control-group edit-form-group ${specifier}-type-add-more-button">
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
                                id="${specifier}-${varStatus.count-1}-information-add-annotation" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            Information
                        </button>
                        <div class="form-group control-group edit-form-group">
                            <myTags:editAnnotation annotation="${type.information}"
                                                   supportError="${true}"
                                                   specifier="${specifier}-${varStatus.count-1}-information"
                                                   label="Information"
                                                   showRemoveButton="true"
                                                   path="${path}[${varStatus.count-1}].information">
                            </myTags:editAnnotation>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-success ${specifier}-add-annotation" id="${specifier}-${varStatus.count-1}-information-add-annotation"
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
                                id="${specifier}-${varStatus.count-1}-method-add-annotation" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            Method
                        </button>
                        <div class="form-group control-group edit-form-group">
                            <myTags:editAnnotation annotation="${type.method}"
                                                   supportError="${true}"
                                                   specifier="${specifier}-${varStatus.count-1}-method"
                                                   label="Method"
                                                   showRemoveButton="true"
                                                   path="${path}[${varStatus.count-1}].method">
                            </myTags:editAnnotation>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-success ${specifier}-add-annotation" id="${specifier}-${varStatus.count-1}-method-add-annotation"
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
                                id="${specifier}-${varStatus.count-1}-platform-add-annotation" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            Platform
                        </button>
                        <div class="form-group control-group edit-form-group">
                            <myTags:editAnnotation annotation="${type.platform}"
                                                   supportError="${true}"
                                                   specifier="${specifier}-${varStatus.count-1}-platform"
                                                   label="Platform"
                                                   showRemoveButton="true"
                                                   path="${path}[${varStatus.count-1}].platform">
                            </myTags:editAnnotation>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-success ${specifier}-add-annotation" id="${specifier}-${varStatus.count-1}-platform-add-annotation"
                                type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            Platform
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
            <c:if test="${varStatus.first}">
                <c:forEach items="${flowRequestContext.messageContext.allMessages}" var="message">
                    <span class="error-color">${message.text}</span>
                </c:forEach>
                <%--<form:errors path="${path}[0]" class="error-color"/>--%>
            </c:if>
            </div>
            <c:set var="typeCount" scope="page" value="${varStatus.count}"/>

        </c:forEach>
        </div>
        <div class="${specifier}-type-add-more">
        </div>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${not empty flowRequestContext.messageContext.allMessages}">
                <div class="form-group edit-form-group ${specifier}-type-add-more-button has-error">

            </c:when>
            <c:otherwise>
                <div class="form-group edit-form-group ${specifier}-type-add-more-button">
            </c:otherwise>
        </c:choose>
            <label>Type</label>
            <button class="btn btn-success ${specifier}-add-type" type="button"><i class="glyphicon glyphicon-plus"></i> Add Type
            </button>
            <br><br>
            <div>
                <button class="btn btn-success ${specifier}-add-annotation" id="${specifier}-0-information-add-annotation" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Information
                </button>
            </div>
            <br>
            <div>
                <button class="btn btn-success ${specifier}-add-annotation" id="${specifier}-0-method-add-annotation" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Method
                </button>
            </div>
            <br>
            <div>
                <button class="btn btn-success ${specifier}-add-annotation" id="${specifier}-0-platform-add-annotation" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Platform
                </button>
            </div>
        <c:forEach items="${flowRequestContext.messageContext.allMessages}" var="message">
            <span class="error-color">${message.text}</span>
        </c:forEach>
        </div>
        <div class="${specifier}-type-add-more">
        </div>

        <%--<form:errors path="${path}[0]" class="error-color"/>--%>

        <c:set var="typeCount" scope="page" value="1"/>
    </c:otherwise>
</c:choose>


<div class="copy-annotation-information hide">
    <div class="form-group control-group edit-form-group">
        <myTags:editAnnotation supportError="${true}"
                               specifier="${specifier}-information"
                               label="Information"
                               showRemoveButton="true"
                               path="${path}[0].information">
        </myTags:editAnnotation>
    </div>
</div>

<div class="copy-annotation-method hide">
    <div class="form-group control-group edit-form-group">
        <myTags:editAnnotation supportError="${true}"
                               specifier="${specifier}-method"
                               label="Method"
                               showRemoveButton="true"
                               path="${path}[0].method">
        </myTags:editAnnotation>
    </div>
</div>

<div class="copy-annotation-platform hide">
    <div class="form-group control-group edit-form-group">
        <myTags:editAnnotation supportError="${true}"
                               specifier="${specifier}-platform"
                               label="Platform"
                               showRemoveButton="true"
                               path="${path}[0].platform">
        </myTags:editAnnotation>
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
            <%--$(".${specifier}-type-add-more").after(html);--%>
            $(".${specifier}-type-add-more").before(html);
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
            var count = id.split('-')[1];
            var attributeName = id.split('-')[2];
            if (count != undefined && attributeName != undefined) {

                var html = $(".copy-annotation-" + attributeName).html();
                //use '//g' regex for global capture, otherwise only first instance is repalced
                <%--html = html.replace(attributeName, count + '-' + attributeName).replace(/name="path/g, 'name="${path}[' + count + '].' + attributeName + '.').replace(/path="path/g, 'path="${path}[' + count + '].' + attributeName + '.');--%>

                var specifier = "${specifier}";
                var path = "${path}";
                var html = $(".copy-annotation-" + attributeName).html();
                path = path.replace('[','\\[').replace(']','\\]');
                var regexPath = new RegExp(path + '\\[0\\]', "g");
                var regexSpecifier = new RegExp(specifier + '\\-', "g");
                html = html.replace(regexPath, '${path}['+ count + ']')
                    .replace(regexSpecifier,'${specifier}-' + count + '-');

                $(this).after(html);
                console.log($(this));
                $(this).hide();
            }
        });
    });
</script>