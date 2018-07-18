<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="isAboutList" required="false"
              type="java.util.List" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="showAddAnnotationButton" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="showAddBiologicalEntityButton" required="true"
              type="java.lang.Boolean" %>


<c:choose>
    <c:when test="${not function:isObjectEmpty(isAboutList)}">
        <div class=" ${status.error ? 'has-error' : ''}">
            <c:forEach items="${isAboutList}" varStatus="varStatus" var="isAbout">
                <c:choose>
                    <c:when test="${varStatus.first}">
                        <div class="form-group edit-form-group ${specifier}-add-more-button">
                            <label>${label}</label>
                            <c:if test="${showAddAnnotationButton}">
                                <button class="btn btn-success ${specifier}-add-annotation" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add ${label} (Annotation)
                                </button>
                            </c:if>
                            <c:if test="${showAddBiologicalEntityButton}">
                                <button class="btn btn-success ${specifier}-add-biologicalEntity" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add ${label} (BiologicalEntity)
                                </button>
                            </c:if>
                        </div>
                    </c:when>
                </c:choose>
                <c:if test="${not function:isObjectEmpty(isAbout)}">
                    <c:choose>
                        <%--<c:when test="${isAbout['class'] == 'class edu.pitt.isg.mdc.dats2_2.Annotation'}">--%>
                        <c:when test="${not empty isAbout.value or not empty isAbout.valueIRI}">
                            <div class="form-group edit-form-group control-group">
                                <myTags:editAnnotation annotation="${isAbout}"
                                                       path="${path}[${varStatus.count-1}]"
                                                       specifier="${specifier}-${varStatus.count-1}"
                                                       label="Is About (Annotation)"
                                                       showRemoveButton="true"
                                                       supportError="true">
                                </myTags:editAnnotation>
                            </div>
                        </c:when>
                        <%--<c:when test="${isAbout['class'] == 'class edu.pitt.isg.mdc.dats2_2.BiologicalEntity'}">--%>
                        <c:when test="${not empty isAbout.identifier or not empty isAbout.name or not empty isAbout.description}">
                            <myTags:editBiologicalEntity entity="${isAbout}"
                                                         path="${path}[${varStatus.count-1}]"
                                                         specifier="${specifier}-${varStatus.count-1}"
                                                         label="${label} (BiologicalEntity)">
                            </myTags:editBiologicalEntity>
                        </c:when>
                    </c:choose>

                    <c:if test="${varStatus.first}">

                        <form:errors path="${path}[0]" class="error-color"/>
                    </c:if>

                    <c:set var="unboundedIsAboutCount" scope="page" value="${varStatus.count}"/>
                </c:if>

            </c:forEach>
            <div class="${specifier}-add-more"></div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group ${specifier}-add-more-button ${status.error ? 'has-error' : ''}">
            <label>${label}</label>
            <c:if test="${showAddAnnotationButton}">
                <button class="btn btn-success ${specifier}-add-annotation" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add ${label} (Annotation)
                </button>
            </c:if>
            <c:if test="${showAddBiologicalEntityButton}">
                <button class="btn btn-success ${specifier}-add-biologicalEntity" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add ${label} (BiologicalEntity)
                </button>
            </c:if>
            <div class="${specifier}-add-more"></div>

            <form:errors path="${path}[0]" class="error-color"/>
        </div>
        <c:set var="unboundedIsAboutCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>

<c:if test="${showAddAnnotationButton}">
    <div class="${specifier}-annotation-copy hide">
        <div class="form-group edit-form-group control-group">
            <myTags:editAnnotation path="${path}[0]"
                                   specifier="${specifier}-"
                                   label="Is About (Annotation)"
                                   showRemoveButton="true"
                                   supportError="true">
            </myTags:editAnnotation>
        </div>
    </div>
</c:if>
<c:if test="${showAddBiologicalEntityButton}">
    <div class="${specifier}-biologicalEntity-copy hide">
        <myTags:editBiologicalEntity path="${path}[0]"
                                     specifier="${specifier}-"
                                     label="${label} (BiologicalEntity)">
        </myTags:editBiologicalEntity>
    </div>
</c:if>


<script type="text/javascript">
    $(document).ready(function () {
        var unboundedIsAboutCount = ${unboundedIsAboutCount};
        //Add section
        $(".add-${specifier}-annotation").click(function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $(".${specifier}-annotation-copy").html();
            path = path.replace('[', '\\[').replace(']', '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}[' + unboundedIsAboutCount + ']').replace(regexSpecifier, '${specifier}-' + unboundedIsAboutCount + '-');
            unboundedIsAboutCount += 1;

            $(".${specifier}-add-more").before(html);
            e.stopImmediatePropagation();
        });


        $(".add-${specifier}-biologicalEntity").click(function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $(".${specifier}-biologicalEntity-copy").html();
            path = path.replace('[', '\\[').replace(']', '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}[' + unboundedIsAboutCount + ']').replace(regexSpecifier, '${specifier}-' + unboundedIsAboutCount + '-');
            unboundedIsAboutCount += 1;

            $(".${specifier}-add-more").before(html);
            e.stopImmediatePropagation();
        });

        //Remove section
        $("body").on("click", ".annotation-remove", function () {
            $(this).closest(".control-group").remove();
        });

        //Remove section
        $("body").on("click", ".biologicalEntity-remove", function () {
            $(this).closest(".control-group").remove();
        });

    });
</script>