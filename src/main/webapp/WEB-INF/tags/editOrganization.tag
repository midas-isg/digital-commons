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

<%--<c:choose>--%>
<%--<c:when test="${not empty organizations}">--%>
<%--<spring:bind path="${path}[0]">--%>
<%--<div class=" ${status.error ? 'has-error' : ''}">--%>
<%--<c:forEach items="${organizations}" varStatus="varStatus" var="organization">--%>
<%--<spring:bind path="${path}[${varStatus.count-1}].name">--%>
<%--<c:choose>--%>
<%--<c:when test="${varStatus.first}">--%>
<%--<div class="form-group edit-form-group ${specifier}-add-more">--%>
<%--<label>${label}</label>--%>
<%--<button class="btn btn-success add-${specifier}"--%>
<%--type="button"><i--%>
<%--class="glyphicon glyphicon-plus"></i> Add ${label}--%>
<%--</button>--%>
<%--<c:choose>--%>
<%--<c:when test="${isFirstRequired}">--%>
<%--<myTags:editRequiredNonZeroLengthString label="Name" placeholder=" The name of the organization."--%>
<%--path="${path}[0].name"></myTags:editRequiredNonZeroLengthString>--%>
<%--</c:when>--%>
<%--<c:otherwise>--%>
<%--<myTags:editNonRequiredNonZeroLengthString label="Name" placeholder=" The name of the organization."--%>
<%--specifier="${specifier}-${varStatus.count-1}-name"--%>
<%--path="${path}[${varStatus.count-1}].name"--%>
<%--string="${organization.name}"></myTags:editNonRequiredNonZeroLengthString>--%>
<%--</c:otherwise>--%>
<%--</c:choose>--%>
<%--</c:when>--%>
<%--<c:otherwise>--%>
<%--<div class="form-group control-group edit-form-group">--%>
<%--<label>${label}</label>--%>
<%--<button class="btn btn-danger organization-remove" type="button"><i--%>
<%--class="glyphicon glyphicon-remove"></i> Remove--%>
<%--</button>--%>
<%--<myTags:editNonRequiredNonZeroLengthString label="Name" placeholder=" The name of the organization."--%>
<%--specifier="${specifier}-${varStatus.count-1}-name"--%>
<%--path="${path}[${varStatus.count-1}].name"--%>
<%--string="${organization.name}"></myTags:editNonRequiredNonZeroLengthString>--%>
<%--</c:otherwise>--%>
<%--</c:choose>--%>


<%--<myTags:editNonRequiredNonZeroLengthString label="Abbreviation" placeholder=" The shortname, abbreviation associated to the organization."--%>
<%--specifier="${specifier}-${varStatus.count-1}-abbreviation"--%>
<%--path="${path}[${varStatus.count-1}].abbreviation"--%>
<%--string="${organization.abbreviation}"></myTags:editNonRequiredNonZeroLengthString>--%>
<%--<myTags:editPlace place="${organization.location}"--%>
<%--path="${path}[${varStatus.count-1}].location"--%>
<%--specifier="${specifier}-${varStatus.count-1}-location"--%>
<%--label="Location"></myTags:editPlace>--%>

<%--<c:if test="${varStatus.first}">--%>

<%--<form:errors path="${path}[0]" class="error-color"/>--%>
<%--</c:if>--%>

<%--</div>--%>

<%--<c:set var="unboundedOrganizationCount" scope="page" value="${varStatus.count}"/>--%>
<%--&lt;%&ndash;<spring:eval expression="${varStatus.count}" var="unbounded${specifier}Count" scope="session"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;<spring:eval expression="${varStatus.count}" var="unboundedCreatorCount" scope="session"/>&ndash;%&gt;--%>
<%--</spring:bind>--%>
<%--</c:forEach>--%>
<%--</div>--%>
<%--</spring:bind>--%>
<%--</c:when>--%>
<%--<c:otherwise>--%>
<%--<spring:bind path="${path}[0]">--%>
<%--<div class="form-group edit-form-group ${specifier}-add-more ${status.error ? 'has-error' : ''}">--%>
<%--<label>${label}</label>--%>
<%--<button class="btn btn-success add-${specifier}" type="button"><i--%>
<%--class="glyphicon glyphicon-plus"></i> Add--%>
<%--${label}--%>
<%--</button>--%>

<%--<c:choose>--%>
<%--<c:when test="${isFirstRequired}">--%>
<%--<myTags:editRequiredNonZeroLengthString label="Name" placeholder=" The name of the organization."--%>
<%--path="${path}[0].name"></myTags:editRequiredNonZeroLengthString>--%>
<%--</c:when>--%>
<%--<c:otherwise>--%>
<%--<myTags:editNonRequiredNonZeroLengthString label="Name" placeholder=" The name of the organization."--%>
<%--specifier="${specifier}-0-name"--%>
<%--path="${path}[0].name"></myTags:editNonRequiredNonZeroLengthString>--%>
<%--</c:otherwise>--%>
<%--</c:choose>--%>

<%--<myTags:editNonRequiredNonZeroLengthString label="Abbreviation" placeholder=" The shortname, abbreviation associated to the organization."--%>
<%--specifier="${specifier}-0-abbreviation"--%>
<%--path="${path}[0].abbreviation"></myTags:editNonRequiredNonZeroLengthString>--%>

<%--<myTags:editPlace path="${path}[0].location"--%>
<%--specifier="${specifier}-0-location"--%>
<%--label="Location"></myTags:editPlace>--%>

<%--<form:errors path="${path}[0]" class="error-color"/>--%>
<%--</div>--%>
<%--<c:set var="unboundedOrganizationCount" scope="page" value="1"/>--%>
<%--&lt;%&ndash;<spring:eval expression="1" var="unbounded${specifier}Count" scope="session"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;<spring:eval expression="1" var="unboundedCreatorCount" scope="session"/>&ndash;%&gt;--%>
<%--</spring:bind>--%>
<%--</c:otherwise>--%>
<%--</c:choose>--%>


<%--<div class="${specifier}-copy hide">--%>
<%--<div class="form-group  control-group edit-form-group">--%>
<%--<label>${label}</label>--%>
<%--<button class="btn btn-danger organization-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove--%>
<%--</button>--%>

<%--<myTags:editNonRequiredNonZeroLengthString label="Name" placeholder=" The name of the organization."--%>
<%--specifier="${specifier}-name"--%>
<%--path="${path}[0].name"></myTags:editNonRequiredNonZeroLengthString>--%>

<%--<myTags:editNonRequiredNonZeroLengthString label="Abbreviation" placeholder=" The shortname, abbreviation associated to the organization."--%>
<%--specifier="${specifier}-abbreviation"--%>
<%--path="${path}[0].abbreviation"></myTags:editNonRequiredNonZeroLengthString>--%>

<%--<myTags:editPlace--%>
<%--path="${path}[0].location"--%>
<%--specifier="${specifier}-location"--%>
<%--label="Location"></myTags:editPlace>--%>
<%--</div>--%>
<%--</div>--%>

<%--<script type="text/javascript">--%>
<%--$(document).ready(function () {--%>

<%--&lt;%&ndash;var unbounded${specifier}Count = ${unbounded${specifier}Count};&ndash;%&gt;--%>
<%--&lt;%&ndash;var unbounded${specifier}Count = ${unboundedCreatorCount};&ndash;%&gt;--%>
<%--var unboundedOrganizationCount = ${unboundedOrganizationCount};--%>
<%--&lt;%&ndash;console.log("unbounded${specifier}Count = " + unbounded${specifier}Count);&ndash;%&gt;--%>
<%--// console.log(unboundedOrganizationCount);--%>
<%--//Add section--%>
<%--$("body").on("click", ".add-${specifier}", function () {--%>
<%--var specifier = "${specifier}";--%>
<%--var path = "${path}";--%>
<%--var html = $(".${specifier}-copy").html();--%>
<%--var regexPath = new RegExp(path + '\\[0\\]', "g");--%>
<%--var regexSpecifier = new RegExp(specifier + '\\-', "g");--%>
<%--html = html.replace(regexPath, '${path}['+ unboundedOrganizationCount + ']').replace(regexSpecifier,'${specifier}-' + unboundedOrganizationCount +'-');--%>
<%--unboundedOrganizationCount += 1;--%>
<%--$(".${specifier}-add-more").after(html);--%>
<%--});--%>

<%--//Remove section--%>
<%--$("body").on("click", ".organization-remove", function () {--%>
<%--$(this).parents(".control-group").remove();--%>
<%--});--%>
<%--});--%>
<%--</script>--%>
