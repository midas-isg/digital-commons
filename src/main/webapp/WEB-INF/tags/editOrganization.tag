<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--<%@ attribute name="organizations" required="true"--%>
<%--type="java.util.ArrayList" %>--%>
<%@ attribute name="organization" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Organization" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isFirstRequired" required="true"
              type="java.lang.Boolean" %>

<div class="form-group control-group edit-form-group">
    <label>${label}</label>
    <c:choose>
        <c:when test="${not empty organization}">
            <c:choose>
                <c:when test="${not isFirstRequired}">
                    <button class="btn btn-danger organization-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i> Remove
                    </button>
                </c:when>
            </c:choose>
            <myTags:editIdentifier specifier="${specifier}-identifier"
                                   label="Identifier"
                                   path="${path}.identifier"
                                   identifier="${organization.identifier}"
                                   unbounded="${false}">
            </myTags:editIdentifier>
            <myTags:editIdentifier specifier="${specifier}-alternateIdentifiers"
                                   label="Alternate Identifiers"
                                   path="${path}.alternateIdentifiers"
                                   identifiers="${organization.alternateIdentifiers}"
                                   unbounded="${true}">
            </myTags:editIdentifier>
            <myTags:editRequiredNonZeroLengthString label="Name"
                                                    placeholder=" The name of the organization."
                                                    string="${organization.name}"
                                                    path="${path}.name"></myTags:editRequiredNonZeroLengthString>
            <myTags:editNonRequiredNonZeroLengthString label="Abbreviation"
                                                       placeholder=" The shortname, abbreviation associated to the organization."
                                                       specifier="${specifier}-abbreviation"
                                                       path="${path}.abbreviation"
                                                       string="${organization.abbreviation}"></myTags:editNonRequiredNonZeroLengthString>
            <myTags:editPlace place="${organization.location}"
                              path="${path}.location"
                              specifier="${specifier}-location"
                              label="Location"></myTags:editPlace>
        </c:when>
        <c:otherwise>
            <c:choose>
                <c:when test="${not isFirstRequired}">
                    <button class="btn btn-danger organization-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i> Remove
                    </button>
                </c:when>
            </c:choose>
            <myTags:editIdentifier specifier="${specifier}-identifier"
                                   label="Identifier"
                                   path="${path}.identifier"
                                   unbounded="${false}">
            </myTags:editIdentifier>
            <myTags:editIdentifier specifier="${specifier}-alternateIdentifiers"
                                   label="Alternate Identifiers"
                                   path="${path}.alternateIdentifiers"
                                   unbounded="${true}">
            </myTags:editIdentifier>
            <myTags:editNonRequiredNonZeroLengthString label="Name" placeholder=" The name of the organization."
                                                       specifier="${specifier}-name"
                                                    path="${path}.name"></myTags:editNonRequiredNonZeroLengthString>
            <myTags:editNonRequiredNonZeroLengthString label="Abbreviation"
                                                       placeholder=" The shortname, abbreviation associated to the organization."
                                                       specifier="${specifier}-abbreviation"
                                                       path="${path}.abbreviation"></myTags:editNonRequiredNonZeroLengthString>

            <%--<myTags:editPlace path="${path}.location"--%>
                              <%--specifier="${specifier}-location"--%>
                              <%--label="Location"></myTags:editPlace>--%>
        </c:otherwise>
    </c:choose>
</div>

