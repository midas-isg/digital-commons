<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="person" required="false"
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
     class="form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${function:isObjectEmpty(person)}">hide</c:if>">
    <div id="${specifier}-input-block"
         class="form-group control-group <c:if test="${isUnboundedList}">edit-form-group</c:if> <c:if test="${function:isObjectEmpty(person) and not isUnboundedList}">hide</c:if>">
        <label>${label}</label>
        <c:if test="${not isFirstRequired}">
            <button class="btn btn-danger ${specifier}-person-remove" type="button"><i
                    class="glyphicon glyphicon-remove"></i> Remove
            </button>
        </c:if>
        <myTags:editIdentifier specifier="${specifier}-identifier"
                               label="Identifier"
                               path="${path}.identifier"
                               singleIdentifier="${person.identifier}"
                               isUnboundedList="${false}">
        </myTags:editIdentifier>
        <myTags:editIdentifierUnbounded specifier="${specifier}-alternateIdentifiers"
                                        label="Alternate Identifiers"
                                        path="${path}.alternateIdentifiers"
                                        identifiers="${person.alternateIdentifiers}">
        </myTags:editIdentifierUnbounded>
        <myTags:editNonZeroLengthString label="Full Name"
                                        placeholder=" The first name, any middle names, and surname of a person."
                                        string="${person.fullName}"
                                        isRequired="true"
                                        specifier="${specifier}-fullname"
                                        path="${path}.fullName">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString label="First Name"
                                        placeholder=" The given name of the person."
                                        string="${person.firstName}"
                                        specifier="${specifier}-firstName"
                                        isRequired="true"
                                        path="${path}.firstName">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString label="Middle Initial"
                                        placeholder=" The first letter of the person's middle name."
                                        string="${person.middleInitial}"
                                        specifier="${specifier}-middleInitial"
                                        isRequired="true"
                                        path="${path}.middleInitial">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString label="Last Name"
                                        placeholder=" The person's family name."
                                        string="${person.lastName}"
                                        specifier="${person}.lastName"
                                        isRequired="true"
                                        path="${path}.lastName">
        </myTags:editNonZeroLengthString>
        <myTags:editNonZeroLengthString label="Email"
                                        placeholder=" An electronic mail address for the person."
                                        string="${person.email}"
                                        specifier="${specifier}-email"
                                        isRequired="true"
                                        path="${path}.email">
        </myTags:editNonZeroLengthString>
<%--
        <myTags:editPersonComprisedEntity path="${path}.affiliations"
                                          specifier="${specifier}-affiliations"
                                          label="Affiliation"
                                          personComprisedEntities="${person.affiliations}"
                                          isFirstRequired="false"
                                          showAddPersonButton="false"
                                          showAddOrganizationButton="true">
        </myTags:editPersonComprisedEntity>
--%>
        <myTags:editAnnotationUnbounded path="${path}.roles"
                                        specifier="${specifier}-roles"
                                        annotations="${person.roles}"
                                        label="Roles">
        </myTags:editAnnotationUnbounded>
    </div>

    <script type="text/javascript">

        $(document).ready(function () {
            //Remove section
            $("body").on("click", ".${specifier}-person-remove", function () {
                clearAndHideEditControlGroup(this);
                $("#${specifier}-input-block").addClass("hide");
            });
        });

    </script>
</div>


