<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="personComprisedEntities" required="false"
              type="java.util.List" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isFirstRequired" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="showAddPersonButton" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="showAddOrganizationButton" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="createPersonOrganizationTags" required="true"
              type="java.lang.Boolean" %>


<div class="<c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if>">
    <div class="form-group edit-form-group ${specifier}-add-more-button">
        <label>${label}s</label>
        <c:if test="${showAddPersonButton}">
            <button class="btn btn-success add-${specifier}-person" type="button"><i
                    class="fa fa-plus-circle"></i> Add ${label} (Person)
            </button>
        </c:if>
        <c:if test="${showAddOrganizationButton}">
            <button class="btn btn-success add-${specifier}-organization" type="button"><i
                    class="fa fa-plus-circle"></i> Add ${label} (Organization)
            </button>
        </c:if>
    </div>
    <c:set var="unboundedPersonComprisedEntityCount" scope="page" value="0"/>
    <c:forEach items="${personComprisedEntities}" varStatus="varStatus" var="personComprisedEntity">
        <c:choose>
            <c:when test="${not function:isPerson(personComprisedEntity)}">
                <myTags:editOrganization organization="${personComprisedEntity}"
                                         path="${path}[${varStatus.count-1}]"
                                         specifier="${specifier}-${varStatus.count-1}"
                                         label="${label} (Organization)"
                                         id="${specifier}-${varStatus.count-1}"
                                         tagName="organization"
                                         isUnboundedList="${true}"
                                         isFirstRequired="false">
                </myTags:editOrganization>

            </c:when>
            <c:when test="${function:isPerson(personComprisedEntity)}">
                <myTags:editPerson person="${personComprisedEntity}"
                                   path="${path}[${varStatus.count-1}]"
                                   specifier="${specifier}-${varStatus.count-1}"
                                   label="${label} (Person)"
                                   id="${specifier}-${varStatus.count-1}"
                                   tagName="person"
                                   isUnboundedList="${true}"
                                   isFirstRequired="false">
                </myTags:editPerson>

            </c:when>
        </c:choose>

        <c:set var="unboundedPersonComprisedEntityCount" scope="page" value="${varStatus.count}"/>
        <c:set var="errorMessagePath" scope="page" value="${path}[${varStatus.count-1}]"/>

        <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(errorMessagePath)}" var="message">
            <span class="error-color">${message.text}</span>
        </c:forEach>
    </c:forEach>
    <div class="${specifier}-add-more"></div>
</div>

<c:if test="${showAddOrganizationButton}">
    <myTags:editOrganization path="${path}[0]"
                             specifier="${specifier}-0"
                             label="${label} (Organization)"
                             id="${specifier}-organization-required-copy-tag"
                             tagName="organization"
                             isFirstRequired="true"
                             isUnboundedList="true">
    </myTags:editOrganization>

    <myTags:editOrganization path="${path}[0]"
                             specifier="${specifier}-0"
                             label="${label} (Organization)"
                             id="${specifier}-organization-copy-tag"
                             tagName="organization"
                             isUnboundedList="true"
                             isFirstRequired="false">
    </myTags:editOrganization>
</c:if>

<c:if test="${showAddPersonButton and createPersonOrganizationTags}">
    <myTags:editPerson path="${path}[0]"
                       specifier="${specifier}-0"
                       label="${label} (Person)"
                       id="${specifier}-person-required-copy-tag"
                       tagName="person"
                       isUnboundedList="true"
                       isFirstRequired="true">
    </myTags:editPerson>

    <myTags:editPerson path="${path}[0]"
                       specifier="${specifier}-0"
                       label="${label} (Person)"
                       id="${specifier}-person-copy-tag"
                       tagName="person"
                       isUnboundedList="true"
                       isFirstRequired="false">
    </myTags:editPerson>
</c:if>


<script type="text/javascript">
    $(document).ready(function () {
        var unboundedPersonComprisedEntityCount = ${unboundedPersonComprisedEntityCount};
        //Add section
        $(".add-${specifier}-person").click(function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            var html;
            if (unboundedPersonComprisedEntityCount === 0 && ${isFirstRequired}) {
                html = $("#${specifier}-person-required-copy-tag").html();
            } else html = $("#${specifier}-person-copy-tag").html();
            // path = path.replace('[', '\\[').replace(']', '\\]');
            // path = path.replace(/\[/g, "\\[").replace(/\]/g, "\\]");
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}[' + unboundedPersonComprisedEntityCount + ']')
                .replace(regexSpecifier, '${specifier}-' + unboundedPersonComprisedEntityCount + '-');
            unboundedPersonComprisedEntityCount += 1;

            $(".${specifier}-add-more").before(html);
            e.stopImmediatePropagation();
        });


        $(".add-${specifier}-organization").click(function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            var html;
            if (unboundedPersonComprisedEntityCount === 0 && ${isFirstRequired}) {
                html = $("#${specifier}-organization-required-copy-tag").html();
            } else {
                html = $("#${specifier}-organization-copy-tag").html();
            }
            // path = path.replace('[', '\\[').replace(']', '\\]');
            // path = path.replace(/\[/g, "\\[").replace(/\]/g, "\\]");
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}[' + unboundedPersonComprisedEntityCount + ']')
                .replace(regexSpecifier, '${specifier}-' + unboundedPersonComprisedEntityCount + '-');
            unboundedPersonComprisedEntityCount += 1;

            $(".${specifier}-add-more").before(html);
            e.stopImmediatePropagation();
        });

        //Remove section
        $("body").on("click", ".person-remove", function () {
            clearAndHideEditControlGroup(this);
        });

        //Remove section
        $("body").on("click", ".organization-remove", function () {
            clearAndHideEditControlGroup(this);
        });

    });
</script>