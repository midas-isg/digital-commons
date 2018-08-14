<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="entity" required="false"
              type="edu.pitt.isg.mdc.dats2_2.IsAbout" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>

<div id="${id}"
     class="form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${not isRequired and function:isObjectEmpty(entity)}">hide</c:if>">
    <c:if test="${isRequired and not isUnboundedList}">
        <label>${label}</label>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group <c:if test="${isUnboundedList}">edit-form-group</c:if>
         <c:if test="${function:isObjectEmpty(entity) and not isRequired and not isUnboundedList}">hide</c:if>">
        <c:if test="${not isRequired}">
            <c:if test="${isUnboundedList}">
                <label>${label}</label>
            </c:if>
            <button class="btn btn-danger ${specifier}-biological-entity-remove" type="button"><i
                    class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </c:if>
        <myTags:editIdentifier singleIdentifier="${entity.identifier}"
                               path="${path}.identifier"
                               specifier="${specifier}-identifier"
                               label="Identifier">
        </myTags:editIdentifier>
        <myTags:editIdentifierUnbounded path="${path}.alternateIdentifiers"
                                        specifier="${specifier}-alternateIdentifiers"
                                        identifiers="${entity.alternateIdentifiers}"
                                        label="Alternate Identifier">
        </myTags:editIdentifierUnbounded>
        <myTags:editNonZeroLengthString placeholder=" The name of the biological entity."
                                        label="Name"
                                        isRequired="true"
                                        specifier="${specifier}-name"
                                        string="${entity.name}"
                                        path="${path}.name">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString string="${entity.description}"
                                        path="${path}.description"
                                        label="Description"
                                        placeholder="Description"
                                        isTextArea="true"
                                        specifier="${specifier}-description">
        </myTags:editNonZeroLengthString>
    </div>


    <script type="text/javascript">

        $(document).ready(function () {
            $("body").on("click", ".${specifier}-add-biological-entity", function (e) {
                e.stopImmediatePropagation();

                $("#${specifier}-input-block").removeClass("hide");
                $("#${specifier}-add-input-button").addClass("hide");

            });

            //Remove section
            $("body").on("click", ".${specifier}-biological-entity-remove", function () {
                clearAndHideEditControlGroup(this);
                $("#${specifier}-input-block").addClass("hide");
                $("#${specifier}-add-input-button").removeClass("hide");
            });
        });

    </script>
</div>
<%--

<div class="form-group edit-form-group control-group">
    <label>${label}</label>
    <c:choose>
        <c:when test="${not empty entity}">
            <div class="form-group control-group">
                <button class="btn btn-danger  ${specifier}-biological-entity-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
                <div class="form-group control-group edit-form-group">
                    <myTags:editIdentifierUnbounded identifier="${entity.identifier}"
                                                    path="${path}.identifier"
                                                    specifier="${specifier}"
                                                    label="Identifier">
                    </myTags:editIdentifierUnbounded>
                    <myTags:editIdentifierUnbounded path="${path}.alternateIdentifiers"
                                                    unbounded="${true}"
                                                    specifier="${specifier}-alternateIdentifiers"
                                                    identifiers="${entity.alternateIdentifiers}"
                                                    label="Alternate Identifier">
                    </myTags:editIdentifierUnbounded>
                    <c:choose>
                        <c:when test="${not empty entity.name}">
                            <myTags:editRequiredNonZeroLengthString placeholder=" The name of the biological entity."
                                                                    label="Name"
                                                                    string="${entity.name}"
                                                                    path="${path}.name">
                            </myTags:editRequiredNonZeroLengthString>
                        </c:when>
                        <c:otherwise>
                            <myTags:editRequiredNonZeroLengthString placeholder=" The name of the biological entity."
                                                                    label="Name"
                                                                    path="${path}.name">
                            </myTags:editRequiredNonZeroLengthString>
                        </c:otherwise>
                    </c:choose>
                    <myTags:editNonRequiredNonZeroLengthStringTextArea string="${entity.description}"
                                                                       path="${path}.description"
                                                                       label="Description"
                                                                       placeholder="Description"
                                                                       specifier="${specifier}">
                    </myTags:editNonRequiredNonZeroLengthStringTextArea>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="form-group control-group">
                <button class="btn btn-danger  ${specifier}-biological-entity-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
                <div class="form-group control-group edit-form-group">
                    <myTags:editIdentifierUnbounded path="${path}.identifier"
                                                    specifier="${specifier}"
                                                    label="Identifier">
                    </myTags:editIdentifierUnbounded>
                    <myTags:editIdentifierUnbounded path="${path}.alternateIdentifiers"
                                                    unbounded="${true}"
                                                    specifier="${specifier}-alternateIdentifiers"
                                                    label="Alternate Identifier">
                    </myTags:editIdentifierUnbounded>
                    <myTags:editRequiredNonZeroLengthString placeholder=" The name of the biological entity."
                                                            label="Name"
                                                            path="${path}.name">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthStringTextArea path="${path}.description"
                                                                       label="Description"
                                                                       placeholder="Description"
                                                                       specifier="${specifier}">
                    </myTags:editNonRequiredNonZeroLengthStringTextArea>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
--%>

