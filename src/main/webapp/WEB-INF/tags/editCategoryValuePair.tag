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
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="categoryValuePair" required="false"
              type="edu.pitt.isg.mdc.dats2_2.CategoryValuePair" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>

<%--
<div id="${id}"
     class="form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${isUnboundedList and function:isObjectEmpty(categoryValuePair)}">hide</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <div id="${specifier}-add-input-button"
             class="input-group control-group ${specifier}-categoryValuePair-add-more <c:if test="${not function:isObjectEmpty(categoryValuePair)}">hide</c:if>">
            <div class="input-group-btn">
                <button class="btn btn-success ${specifier}-add-categoryValuePair" type="button"><i
                        class="fa fa-plus-circle"></i> Add
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
                class="fa fa-minus-circle"></i>
            Remove
        </button>
--%>

        <myTags:editMasterElementWrapper path="${path}"
                                         specifier="${specifier}"
                                         object="${categoryValuePair}"
                                         label="${label}"
                                         id="${id}"
                                         isUnboundedList="${isUnboundedList}"
                                         tagName="${tagName}"
                                         showTopOrBottom="top">
        </myTags:editMasterElementWrapper>
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
        <myTags:editMasterElementWrapper path="${path}"
                                         specifier="${specifier}"
                                         object="${categoryValuePair}"
                                         label="${label}"
                                         id="${id}"
                                         isUnboundedList="${isUnboundedList}"
                                         tagName="${tagName}"
                                         showTopOrBottom="bottom">
        </myTags:editMasterElementWrapper>

<%--
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
--%>
