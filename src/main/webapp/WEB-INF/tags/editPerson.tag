<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--<%@ attribute name="people" required="false"--%>
              <%--type="java.util.ArrayList" %>--%>
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


<div class="form-group edit-form-group control-group">
    <label>${label}</label>
    <c:choose>
        <c:when test="${not empty person}">
            <c:if test="${not isFirstRequired}">
                <button class="btn btn-danger person-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i> Remove
                </button>
            </c:if>
            <myTags:editIdentifierUnbounded specifier="${specifier}-identifier"
                                            label="Identifier"
                                            path="${path}.identifier"
                                            identifier="${person.identifier}"
                                            unbounded="${false}">
            </myTags:editIdentifierUnbounded>
            <myTags:editIdentifierUnbounded specifier="${specifier}-alternateIdentifiers"
                                            label="Alternate Identifiers"
                                            path="${path}.alternateIdentifiers"
                                            identifiers="${person.alternateIdentifiers}"
                                            unbounded="${true}">
            </myTags:editIdentifierUnbounded>
            <c:choose>
                <c:when test="${isFirstRequired}">
                    <myTags:editRequiredNonZeroLengthString label="Full Name"
                                                            placeholder=" The first name, any middle names, and surname of a person."
                                                            string="${person.fullName}"
                                                            path="${path}.fullName">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editRequiredNonZeroLengthString label="First Name"
                                                            placeholder=" The given name of the person."
                                                            string="${person.firstName}"
                                                            path="${path}.firstName">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editRequiredNonZeroLengthString label="Middle Initial"
                                                            placeholder=" The first letter of the person's middle name."
                                                            string="${person.middleInitial}"
                                                            path="${path}.middleInitial">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editRequiredNonZeroLengthString label="Last Name" placeholder=" The person's family name."
                                                            string="${person.lastName}"
                                                            path="${path}.lastName">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editRequiredNonZeroLengthString label="Email"
                                                            placeholder=" An electronic mail address for the person."
                                                            string="${person.email}"
                                                            path="${path}.email">
                    </myTags:editRequiredNonZeroLengthString>
                </c:when>
                <c:otherwise>
                    <myTags:editNonZeroLengthString label="Full Name"
                                                    placeholder=" The first name, any middle names, and surname of a person."
                                                    specifier="${specifier}-fullName"
                                                    string="${person.fullName}"
                                                    path="${path}.fullName">
                    </myTags:editNonZeroLengthString>
                    <myTags:editNonZeroLengthString label="First Name"
                                                    placeholder=" The given name of the person."
                                                    specifier="${specifier}-firstName"
                                                    string="${person.firstName}"
                                                    path="${path}.firstName">
                    </myTags:editNonZeroLengthString>
                    <myTags:editNonZeroLengthString label="Middle Initial"
                                                    placeholder=" The first letter of the person's middle name."
                                                    specifier="${specifier}-middleInitial"
                                                    string="${person.middleInitial}"
                                                    path="${path}.middleInitial">
                    </myTags:editNonZeroLengthString>
                    <myTags:editNonZeroLengthString label="Last Name"
                                                    placeholder=" The person's family name."
                                                    specifier="${specifier}-lastName"
                                                    string="${person.lastName}"
                                                    path="${path}.lastName">
                    </myTags:editNonZeroLengthString>
                    <myTags:editNonZeroLengthString label="Email"
                                                    placeholder=" An electronic mail address for the person."
                                                    specifier="${specifier}-email"
                                                    string="${person.email}"
                                                    path="${path}.email">
                    </myTags:editNonZeroLengthString>
                </c:otherwise>
            </c:choose>
            <myTags:editPersonComprisedEntity path="${path}.affiliations"
                                              specifier="${specifier}-affiliations"
                                              label="Affiliation"
                                              personComprisedEntities="${person.affiliations}"
                                              isFirstRequired="false"
                                              showAddPersonButton="false"
                                              showAddOrganizationButton="true">
            </myTags:editPersonComprisedEntity>
            <myTags:editAnnotationUnbounded path="${path}.roles"
                                            specifier="${specifier}-roles"
                                            annotations="${person.roles}"
                                            label="Roles">
            </myTags:editAnnotationUnbounded>
        </c:when>
        <c:otherwise>
            <c:if test="${not isFirstRequired}">
                <button class="btn btn-danger person-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i> Remove
                </button>
            </c:if>
            <myTags:editIdentifierUnbounded specifier="${specifier}-identifier"
                                            label="Identifier"
                                            path="${path}.identifier"
                                            unbounded="${false}">
            </myTags:editIdentifierUnbounded>
            <myTags:editIdentifierUnbounded specifier="${specifier}-alternateIdentifiers"
                                            label="Alternate Identifiers"
                                            path="${path}.alternateIdentifiers"
                                            unbounded="${true}">
            </myTags:editIdentifierUnbounded>
            <c:choose>
                <c:when test="${isFirstRequired}">
                    <myTags:editRequiredNonZeroLengthString label="Full Name"
                                                            placeholder=" The first name, any middle names, and surname of a person."
                                                            path="${path}.fullName">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editRequiredNonZeroLengthString label="First Name"
                                                            placeholder=" The given name of the person."
                                                            path="${path}.firstName">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editRequiredNonZeroLengthString label="Middle Initial"
                                                            placeholder=" The first letter of the person's middle name."
                                                            path="${path}.middleInitial">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editRequiredNonZeroLengthString label="Last Name" placeholder=" The person's family name."
                                                            path="${path}.lastName">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editRequiredNonZeroLengthString label="Email"
                                                            placeholder=" An electronic mail address for the person."
                                                            path="${path}.email">
                    </myTags:editRequiredNonZeroLengthString>
                </c:when>
                <c:otherwise>
                    <myTags:editNonZeroLengthString label="Full Name"
                                                    placeholder=" The first name, any middle names, and surname of a person."
                                                    specifier="${specifier}-fullName"
                                                    path="${path}.fullName">
                    </myTags:editNonZeroLengthString>
                    <myTags:editNonZeroLengthString label="First Name"
                                                    placeholder=" The given name of the person."
                                                    specifier="${specifier}-firstName"
                                                    path="${path}.firstName">
                    </myTags:editNonZeroLengthString>
                    <myTags:editNonZeroLengthString label="Middle Initial"
                                                    placeholder=" The first letter of the person's middle name."
                                                    specifier="${specifier}-middleInitial"
                                                    path="${path}.middleInitial">
                    </myTags:editNonZeroLengthString>
                    <myTags:editNonZeroLengthString label="Last Name"
                                                    placeholder=" The person's family name."
                                                    specifier="${specifier}-lastName"
                                                    path="${path}.lastName">
                    </myTags:editNonZeroLengthString>
                    <myTags:editNonZeroLengthString label="Email"
                                                    placeholder=" An electronic mail address for the person."
                                                    specifier="${specifier}-email"
                                                    path="${path}.email">
                    </myTags:editNonZeroLengthString>
                </c:otherwise>
            </c:choose>
            <myTags:editPersonComprisedEntity path="${path}.affiliations"
                                              specifier="${specifier}-affiliations"
                                              label="Affiliation"
                                              isFirstRequired="false"
                                              showAddPersonButton="false"
                                              showAddOrganizationButton="true">
            </myTags:editPersonComprisedEntity>
            <myTags:editAnnotationUnbounded path="${path}.roles"
                                            specifier="${specifier}-roles"
                                            label="Roles">
            </myTags:editAnnotationUnbounded>
        </c:otherwise>
    </c:choose>
</div>


