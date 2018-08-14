<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="categoryValuePair" required="false"
              type="edu.pitt.isg.mdc.dats2_2.CategoryValuePair" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>

<div id="${id}"
     class="form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${isUnboundedList and function:isObjectEmpty(categoryValuePair)}">hide</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <div id="${specifier}-add-input-button"
             class="input-group control-group ${specifier}-categoryValuePair-add-more <c:if test="${not function:isObjectEmpty(categoryValuePair)}">hide</c:if>">
            <div class="input-group-btn">
                <button class="btn btn-success ${specifier}-add-categoryValuePair" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                        ${label}
                </button>
            </div>
        </div>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(categoryValuePair) and not isUnboundedList}">hide</c:if>">
        <c:if test="${isUnboundedList}">
            <label>${label}</label>
        </c:if>
        <button class="btn btn-danger ${specifier}-categoryValuePair-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <myTags:editNonZeroLengthString label="Category"
                                        placeholder=" A characteristic or property about the entity this object is associated with."
                                        specifier="${specifier}-category"
                                        path="${path}.category"
                                        string="${categoryValuePair.category}">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString label="CategoryIRI"
                                        placeholder=" The IRI corresponding to the category, if associated with an ontology term."
                                        specifier="${specifier}-categoryIRI"
                                        path="${path}.categoryIRI"
                                        string="${categoryValuePair.categoryIRI}">
        </myTags:editNonZeroLengthString>
        <myTags:editMasterUnbounded path="${path}.values"
                                        specifier="${specifier}-values"
                                        label="Value"
                                        tagName="annotation"
                                        listItems="${categoryValuePair.values}">
        </myTags:editMasterUnbounded>

        <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </c:if>
    </div>

    <c:if test="${not isRequired}">
        <script type="text/javascript">
            $(document).ready(function () {
                $("body").on("click", ".${specifier}-add-categoryValuePair", function (e) {
                    e.stopImmediatePropagation();

                    $("#${specifier}-input-block").removeClass("hide");
                    <c:if test="${isUnboundedList or not isRequired}">
                    $("#${specifier}-add-input-button").addClass("hide");
                    </c:if>

                    //Add section
                    $("#${specifier}-categoryValuePair").val("");
                });

                //Remove section
                $("body").on("click", ".${specifier}-categoryValuePair-remove", function (e) {
                    e.stopImmediatePropagation();

                    clearAndHideEditControlGroup(this);
                    $("#${specifier}-add-input-button").removeClass("hide");
                    $("#${specifier}-input-block").addClass("hide");
                });
            });

        </script>
    </c:if>

</div>

<%--
<div class="<c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if>">
    <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
        <span class="error-color">${message.text}</span>
    </c:forEach>
    <div class="form-group edit-form-group">
        <label>${label}</label>
        <div class="form-group">
            <button class="btn btn-success ${specifier}-add" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                ${label}
            </button>
        </div>
    </div>
    <c:set var="categoryValuePairCount" scope="page" value="0"/>
    <c:forEach items="${categoryValuePairs}" var="categoryValuePair" varStatus="varStatus">
        <div class="form-group control-group edit-form-group">
            <label>${label}</label>
            <div class="form-group">
                <button class="btn btn-danger categoryValuePair-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
            <myTags:editNonZeroLengthString label="Category"
                                            placeholder=" A characteristic or property about the entity this object is associated with."
                                            specifier="${specifier}-${varStatus.count-1}-category"
                                            path="${path}[${varStatus.count-1}].category"
                                            string="${categoryValuePair.category}">
            </myTags:editNonZeroLengthString>
            <myTags:editNonZeroLengthString label="CategoryIRI"
                                            placeholder=" The IRI corresponding to the category, if associated with an ontology term."
                                            specifier="${specifier}-${varStatus.count-1}-categoryIRI"
                                            path="${path}[${varStatus.count-1}].categoryIRI"
                                            string="${categoryValuePair.categoryIRI}">
            </myTags:editNonZeroLengthString>
            <myTags:editAnnotationUnbounded path="${path}[${varStatus.count-1}].values"
                                            specifier="${specifier}-${varStatus.count-1}-values"
                                            label="Value"
                                            annotations="${categoryValuePair.values}">
            </myTags:editAnnotationUnbounded>

        </div>
        <div class="${specifier}-categoryValuePair-add-more">
        </div>
        <c:set var="categoryValuePairCount" scope="page" value="${varStatus.count}"/>
    </c:forEach>
</div>


<c:choose>
    <c:when test="${not function:isObjectEmpty(categoryValuePairs)}">

        <c:choose>
            <c:when test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
                <div class="has-error">
                <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                    <span class="error-color">${message.text}</span>
                </c:forEach>
                </div>
            </c:when>
        </c:choose>

        <c:forEach items="${categoryValuePairs}" var="categoryValuePair" varStatus="varStatus">
            <c:if test="${varStatus.first}">
                <div class="form-group edit-form-group">
                    <label>${label}</label>
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                        </button>
                    </div>
                </div>
            </c:if>
            <div class="form-group control-group edit-form-group">
                <label>${label}</label>
                <div class="form-group">
                    <button class="btn btn-danger categoryValuePair-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                </div>
                <myTags:editNonZeroLengthString label="Category" placeholder=" A characteristic or property about the entity this object is associated with."
                                                specifier="${specifier}-${varStatus.count-1}-category"
                                                path="${path}[${varStatus.count-1}].category"
                                                string="${categoryValuePair.category}">
                </myTags:editNonZeroLengthString>
                <myTags:editNonZeroLengthString label="CategoryIRI" placeholder=" The IRI corresponding to the category, if associated with an ontology term."
                                                specifier="${specifier}-${varStatus.count-1}-categoryIRI"
                                                path="${path}[${varStatus.count-1}].categoryIRI"
                                                string="${categoryValuePair.categoryIRI}">
                </myTags:editNonZeroLengthString>
                <myTags:editAnnotationUnbounded path="${path}[${varStatus.count-1}].values"
                                                specifier="${specifier}-${varStatus.count-1}-values"
                                                label="Value"
                                                annotations="${categoryValuePair.values}">
                </myTags:editAnnotationUnbounded>

            </div>
            <div class="${specifier}-categoryValuePair-add-more">
            </div>
            <c:set var="categoryValuePairCount" scope="page" value="${varStatus.count}"/>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Extra Properties
                </button>
            </div>
            <div class="${specifier}-categoryValuePair-add-more">
            </div>
        </div>
        <c:set var="categoryValuePairCount" scope="page" value="0"/>
    </c:otherwise>
</c:choose>

<div class="${specifier}-copy hide">
    <div class="form-group control-group edit-form-group">
        <label>${label}</label>
        <div class="form-group">
            <button class="btn btn-danger categoryValuePair-remove" id="${specifier}-0-remove" type="button"><i
                    class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
        <myTags:editNonZeroLengthString label="Category" placeholder=" A characteristic or property about the entity this object is associated with."
                                        specifier="${specifier}-0-category"
                                        path="${path}[0].category">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString label="CategoryIRI" placeholder=" The IRI corresponding to the category, if associated with an ontology term."
                                        specifier="${specifier}-0-categoryIRI"
                                        path="${path}[0].categoryIRI">
        </myTags:editNonZeroLengthString>
        <myTags:editAnnotationUnbounded path="${path}[0].values"
                                        specifier="${specifier}-0-values"
                                        label="Value">
        </myTags:editAnnotationUnbounded>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {

        var categoryValuePairCount = ${categoryValuePairCount};
        //Show/Hide categoryValuePair
        $("body").on("click", ".${specifier}-add", function (e) {
            e.stopImmediatePropagation()

            var specifier = "${specifier}";
            var path = "${path}";
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var html = $(".${specifier}-copy").html();
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}['+ categoryValuePairCount + ']')
                .replace(regexSpecifier,'${specifier}-' + categoryValuePairCount);

            // $(this).after(html);
            $(".${specifier}-categoryValuePair-add-more").before(html);
            //$(this).hide();
            categoryValuePairCount += 1;
        });
        $("body").on("click", ".categoryValuePair-remove", function () {
            clearAndHideEditControlGroup(this);
            //$(".${specifier}-0-add").show();
        });

    });
</script>
--%>
