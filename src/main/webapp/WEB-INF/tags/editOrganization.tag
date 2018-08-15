<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="organization" required="false"
              type="edu.pitt.isg.mdc.dats2_2.PersonComprisedEntity" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isFirstRequired" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>


<div id="${id}"
     class="form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${function:isObjectEmpty(organization)}">hide</c:if>">
    <div id="${specifier}-input-block"
         class="form-group control-group <c:if test="${isUnboundedList}">edit-form-group</c:if> <c:if test="${function:isObjectEmpty(organization) and not isUnboundedList}">hide</c:if>">
        <label>${label}</label>
        <c:if test="${not isFirstRequired}">
            <button class="btn btn-danger ${specifier}-organization-remove" type="button"><i
                    class="fa fa-minus-circle"></i> Remove
            </button>
        </c:if>
        <myTags:editIdentifier specifier="${specifier}-identifier"
                               label="Identifier"
                               path="${path}.identifier"
                               singleIdentifier="${organization.identifier}"
                               isUnboundedList="${false}">
        </myTags:editIdentifier>
        <myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                                    label="Alternate Identifiers"
                                    path="${path}.alternateIdentifiers"
                                    tagName="identifier"
                                    listItems="${organization.alternateIdentifiers}">
        </myTags:editMasterUnbounded>
        <myTags:editNonZeroLengthString label="Name"
                                        placeholder=" The name of the organization."
                                        string="${organization.name}"
                                        isRequired="true"
                                        specifier="${specifier}-name"
                                        id="${specifier}-name"
                                        path="${path}.name">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString label="Abbreviation"
                                        placeholder=" The shortname, abbreviation associated to the organization."
                                        specifier="${specifier}-abbreviation"
                                        path="${path}.abbreviation"
                                        string="${organization.abbreviation}">
        </myTags:editNonZeroLengthString>
        <myTags:editPlace place="${organization.location}"
                          path="${path}.location"
                          specifier="${specifier}-location"
                          label="Location">
        </myTags:editPlace>
    </div>

    <script type="text/javascript">

        $(document).ready(function () {
            //Remove section
            $("body").on("click", ".${specifier}-organization-remove", function () {
                clearAndHideEditControlGroup(this);
                $("#${specifier}-input-block").addClass("hide");
            });
        });

    </script>
</div>

