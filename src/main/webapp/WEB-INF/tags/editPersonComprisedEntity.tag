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


<c:choose>
    <c:when test="${not function:isObjectEmpty(personComprisedEntities)}">
        <c:choose>
            <c:when test="${not empty flowRequestContext.messageContext.allMessages}">
                <div class="has-error">
                <c:forEach items="${flowRequestContext.messageContext.allMessages}" var="message">
                    <span class="error-color">${message.text}</span>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div>
            </c:otherwise>
        </c:choose>
        <c:set var="unboundedPersonComprisedEntityCount" scope="page" value="0"/>
            <c:forEach items="${personComprisedEntities}" varStatus="varStatus" var="personComprisedEntity">
                <c:if test="${varStatus.first}">
                    <div class="form-group edit-form-group ${specifier}-add-more-button">
                        <label>${label}s</label>
                        <c:if test="${showAddPersonButton}">
                            <button class="btn btn-success add-${specifier}-person" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add ${label} (Person)
                            </button>
                        </c:if>
                        <c:if test="${showAddOrganizationButton}">
                            <button class="btn btn-success add-${specifier}-organization" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add ${label} (Organization)
                            </button>
                        </c:if>
                    </div>
                </c:if>
                <c:choose>
                    <c:when test="${not function:isPerson(personComprisedEntity)}">
                        <myTags:editOrganization organization="${personComprisedEntity}"
                                                 path="${path}[${varStatus.count-1}]"
                                                 specifier="${specifier}-${varStatus.count-1}"
                                                 label="${label} (Organization)"
                                                 isFirstRequired="false">
                        </myTags:editOrganization>
                        <c:set var="unboundedPersonComprisedEntityCount" scope="page" value="${unboundedPersonComprisedEntityCount + 1}"/>

                    </c:when>
                    <c:when test="${function:isPerson(personComprisedEntity)}">
                        <myTags:editPerson person="${personComprisedEntity}"
                                           path="${path}[${varStatus.count-1}]"
                                           specifier="${specifier}-${varStatus.count-1}"
                                           label="${label} (Person)"
                                           isFirstRequired="false">
                        </myTags:editPerson>
                        <c:set var="unboundedPersonComprisedEntityCount" scope="page" value="${unboundedPersonComprisedEntityCount + 1}"/>

                    </c:when>
                </c:choose>
                <c:if test="${varStatus.first}">

                    <form:errors path="${path}[0]" class="error-color"/>
                </c:if>

                <%--<c:set var="unboundedPersonComprisedEntityCount" scope="page" value="${varStatus.count}"/>--%>

            </c:forEach>
        <div class="${specifier}-add-more"></div>


                <%--<c:choose>--%>
                    <%--<c:when test="${varStatus.first}">--%>
                        <%--<div class="form-group edit-form-group ${specifier}-add-more-button">--%>
                            <%--<label>${label}s</label>--%>
                            <%--<c:if test="${showAddPersonButton}">--%>
                                <%--<button class="btn btn-success add-${specifier}-person" type="button"><i--%>
                                        <%--class="glyphicon glyphicon-plus"></i> Add ${label} (Person)--%>
                                <%--</button>--%>
                            <%--</c:if>--%>
                            <%--<c:if test="${showAddOrganizationButton}">--%>
                                <%--<button class="btn btn-success add-${specifier}-organization" type="button"><i--%>
                                        <%--class="glyphicon glyphicon-plus"></i> Add ${label} (Organization)--%>
                                <%--</button>--%>
                            <%--</c:if>--%>
                        <%--</div>--%>
                        <%--<c:choose>--%>
                            <%--<c:when test="${(personComprisedEntity['class'] == 'class edu.pitt.isg.mdc.dats2_2.Organization' or personComprisedEntity['class'] == 'class edu.pitt.isg.mdc.dats2_2.PersonOrganization')--%>
                                                <%--and not empty personComprisedEntity.name}">--%>
                                <%--<myTags:editOrganization organization="${personComprisedEntity}"--%>
                                                         <%--path="${path}[0]"--%>
                                                         <%--specifier="${specifier}-0"--%>
                                                         <%--label="${label} (Organization)"--%>
                                                         <%--isFirstRequired="${isFirstRequired}">--%>
                                <%--</myTags:editOrganization>--%>
                            <%--</c:when>--%>
                            <%--<c:when test="${(personComprisedEntity['class'] == 'class edu.pitt.isg.mdc.dats2_2.Person' or personComprisedEntity['class'] == 'class edu.pitt.isg.mdc.dats2_2.PersonOrganization')--%>
                                                <%--and (not empty personComprisedEntity.fullName or not empty personComprisedEntity.firstName or not empty personComprisedEntity.lastName)}">--%>
                                <%--<myTags:editPerson person="${personComprisedEntity}"--%>
                                                   <%--path="${path}[0]"--%>
                                                   <%--specifier="${specifier}-0"--%>
                                                   <%--label="${label} (Person)"--%>
                                                   <%--isFirstRequired="${isFirstRequired}">--%>
                                <%--</myTags:editPerson>--%>
                            <%--</c:when>--%>
                        <%--</c:choose>--%>
                    <%--</c:when>--%>
                    <%--<c:otherwise>--%>
                        <%--<c:choose>--%>
                            <%--<c:when test="${(personComprisedEntity['class'] == 'class edu.pitt.isg.mdc.dats2_2.Organization' or personComprisedEntity['class'] == 'class edu.pitt.isg.mdc.dats2_2.PersonOrganization')--%>
                                                <%--and not empty personComprisedEntity.name}">--%>
                                <%--<myTags:editOrganization organization="${personComprisedEntity}"--%>
                                                         <%--path="${path}[${varStatus.count-1}]"--%>
                                                         <%--specifier="${specifier}-${varStatus.count-1}"--%>
                                                         <%--label="${label} (Organization)"--%>
                                                         <%--isFirstRequired="false">--%>
                                <%--</myTags:editOrganization>--%>
                                <%--<c:set var="unboundedPersonComprisedEntityCount" scope="page" value="${unboundedPersonComprisedEntityCount + 1}"/>--%>

                            <%--</c:when>--%>
                            <%--<c:when test="${(personComprisedEntity['class'] == 'class edu.pitt.isg.mdc.dats2_2.Person' or personComprisedEntity['class'] == 'class edu.pitt.isg.mdc.dats2_2.PersonOrganization')--%>
                                                <%--and (not empty personComprisedEntity.fullName or not empty personComprisedEntity.firstName or not empty personComprisedEntity.lastName)}">--%>
                                <%--<myTags:editPerson person="${personComprisedEntity}"--%>
                                                   <%--path="${path}[${varStatus.count-1}]"--%>
                                                   <%--specifier="${specifier}-${varStatus.count-1}"--%>
                                                   <%--label="${label} (Person)"--%>
                                                   <%--isFirstRequired="false">--%>
                                <%--</myTags:editPerson>--%>
                                <%--<c:set var="unboundedPersonComprisedEntityCount" scope="page" value="${unboundedPersonComprisedEntityCount + 1}"/>--%>

                            <%--</c:when>--%>
                        <%--</c:choose>--%>
                    <%--</c:otherwise>--%>
                <%--</c:choose>--%>

                <%--<c:if test="${varStatus.first}">--%>

                    <%--<form:errors path="${path}[0]" class="error-color"/>--%>
                <%--</c:if>--%>

                <%--&lt;%&ndash;<c:set var="unboundedPersonComprisedEntityCount" scope="page" value="${varStatus.count}"/>&ndash;%&gt;--%>

            <%--</c:forEach>--%>
            <%--<div class="${specifier}-add-more"></div>--%>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group ${specifier}-add-more-button ${status.error ? 'has-error' : ''}">
            <label>${label}s</label>
            <c:if test="${showAddPersonButton}">
                <button class="btn btn-success add-${specifier}-person" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add ${label} (Person)
                </button>
            </c:if>
            <c:if test="${showAddOrganizationButton}">
                <button class="btn btn-success add-${specifier}-organization" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add ${label} (Organization)
                </button>
            </c:if>
            <div class="${specifier}-add-more"></div>

            <form:errors path="${path}[0]" class="error-color"/>
        </div>
        <c:set var="unboundedPersonComprisedEntityCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>

<c:if test="${showAddPersonButton}">
    <div class="${specifier}-person-required-copy hide">
        <myTags:editPerson path="${path}[0]"
                           specifier="${specifier}-0"
                           label="${label} (Person)"
                           isFirstRequired="true">
        </myTags:editPerson>
    </div>

    <div class="${specifier}-person-copy hide">
        <myTags:editPerson path="${path}[0]"
                           specifier="${specifier}-0"
                           label="${label} (Person)"
                           isFirstRequired="false">
        </myTags:editPerson>
    </div>
</c:if>
<c:if test="${showAddOrganizationButton}">
    <div class="${specifier}-organization-required-copy hide">
        <myTags:editOrganization path="${path}[0]"
                                 specifier="${specifier}-0"
                                 label="${label} (Organization)"
                                 isFirstRequired="true">
        </myTags:editOrganization>
    </div>

    <div class="${specifier}-organization-copy hide">
        <myTags:editOrganization path="${path}[0]"
                                 specifier="${specifier}-0"
                                 label="${label} (Organization)"
                                 isFirstRequired="false">
        </myTags:editOrganization>
    </div>
</c:if>


<script type="text/javascript">
    $(document).ready(function () {
        var unboundedPersonComprisedEntityCount = ${unboundedPersonComprisedEntityCount};
        //Add section
        $(".add-${specifier}-person").click(function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            var html;
            if (unboundedPersonComprisedEntityCount === 0) {
                html = $(".${specifier}-person-required-copy").html();
            } else html = $(".${specifier}-person-copy").html();
            path = path.replace('[', '\\[').replace(']', '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}[' + unboundedPersonComprisedEntityCount + ']').replace(regexSpecifier, '${specifier}-' + unboundedPersonComprisedEntityCount + '-');
            unboundedPersonComprisedEntityCount += 1;

            $(".${specifier}-add-more").before(html);
            e.stopImmediatePropagation();
        });


        $(".add-${specifier}-organization").click(function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            var html;
            if (unboundedPersonComprisedEntityCount === 0) {
                html = $(".${specifier}-organization-required-copy").html();
            } else {
                html = $(".${specifier}-organization-copy").html();
            }
            path = path.replace('[', '\\[').replace(']', '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}[' + unboundedPersonComprisedEntityCount + ']').replace(regexSpecifier, '${specifier}-' + unboundedPersonComprisedEntityCount + '-');
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