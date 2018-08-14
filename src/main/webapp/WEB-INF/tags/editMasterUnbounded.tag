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
<%@ attribute name="placeholder" required="false"
              type="java.lang.String" %>
<%@ attribute name="listItems" required="false"
              type="java.util.List" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>


<div class="form-group edit-form-group">
    <label>${label}</label>
    <div id="${specifier}-add-input-button" class="form-group ${specifier}-${tagName}-add-more-button">
        <button class="btn btn-success ${specifier}-add-${tagName}" type="button"><i
                class="glyphicon glyphicon-plus"></i> Add
            ${label}
        </button>
    </div>
    <c:set var="listItemsCount" scope="page" value="0"/>


    <c:forEach items="${listItems}" varStatus="varStatus" var="listItem">
        <div id="${specifier}-${varStatus.count-1}-tag" class="form-group">
            <c:if test="${not function:isObjectEmpty(listItem)}">
                <c:choose>
                    <c:when test="${tagName == 'access'}">
                        <myTags:editAccess path="${path}[${varStatus.count-1}].access"
                                           specifier="${specifier}-${varStatus.count-1}-access"
                                           isAccessRequired="false"
                                           access="${listItem}">
                        </myTags:editAccess>
                    </c:when>
                    <c:when test="${tagName == 'accessRequired'}">
                        <myTags:editAccess path="${path}[${varStatus.count-1}].access"
                                           specifier="${specifier}-${varStatus.count-1}-access"
                                           isAccessRequired="true"
                                           access="${listItem}">
                        </myTags:editAccess>
                    </c:when>
                    <c:when test="${tagName == 'annotation'}">
                        <myTags:editAnnotation annotation="${listItem}"
                                               specifier="${specifier}-${varStatus.count-1}"
                                               label="${label}"
                                               isUnboundedList="true"
                                               id="${specifier}-${varStatus.count-1}"
                                               path="${path}[${varStatus.count-1}]">
                        </myTags:editAnnotation>
                    </c:when>
                    <c:when test="${tagName == 'date'}">
                        <myTags:editDates path="${path}[${varStatus.count-1}]"
                                          specifier="${specifier}-${varStatus.count-1}"
                                          isUnboundedList="true"
                                          date="${listItem}">
                        </myTags:editDates>
                    </c:when>
                    <c:when test="${tagName == 'identifier'}">
                        <myTags:editIdentifier singleIdentifier="${listItem}"
                                               specifier="${specifier}-${varStatus.count-1}"
                                               isUnboundedList="true"
                                               path="${path}[${varStatus.count-1}]">
                        </myTags:editIdentifier>
                    </c:when>
                    <c:when test="${tagName == 'place'}">
                        <myTags:editPlace path="${path}[${varStatus.count-1}]"
                                          specifier="${specifier}-${varStatus.count-1}"
                                          place="${listItem}"
                                          isUnboundedList="true"
                                          label="${label}">
                        </myTags:editPlace>
                    </c:when>
                    <c:when test="${tagName == 'string'}">
                        <myTags:editNonZeroLengthString path="${path}[${varStatus.count-1}]"
                                                        specifier="${specifier}-${varStatus.count-1}"
                                                        placeholder="${placeholder}"
                                                        string="${listItem}"
                                                        isRequired="false"
                                                        isUnboundedList="true">
                        </myTags:editNonZeroLengthString>
                    </c:when>
                    <c:when test="${tagName == 'stringRequired'}">
                        <myTags:editNonZeroLengthString path="${path}[${varStatus.count-1}]"
                                                        specifier="${specifier}-${varStatus.count-1}"
                                                        placeholder="${placeholder}"
                                                        string="${listItem}"
                                                        isRequired="true"
                                                        isUnboundedList="true">
                        </myTags:editNonZeroLengthString>
                    </c:when>
                </c:choose>
            </c:if>
            <c:set var="listItemsCount" scope="page" value="${varStatus.count}"/>
        </div>
    </c:forEach>
    <div class="${specifier}-${tagName}-add-more"></div>
</div>

<c:choose>
    <c:when test="${tagName == 'access'}">
        <myTags:editAccess path="${path}[0].access"
                           specifier="${specifier}-0-access"
                           id="${specifier}-${tagName}-copy-tag"
                           isAccessRequired="false">
        </myTags:editAccess>
    </c:when>
    <c:when test="${tagName == 'accessRequired'}">
        <myTags:editAccess path="${path}[0].access"
                           specifier="${specifier}-0-access"
                           id="${specifier}-${tagName}-copy-tag"
                           isAccessRequired="true">
        </myTags:editAccess>
    </c:when>
    <c:when test="${tagName == 'annotation'}">
        <myTags:editAnnotation specifier="${specifier}-0"
                               label="${label}"
                               isUnboundedList="true"
                               id="${specifier}-${tagName}-copy-tag"
                               path="${path}[0]">
        </myTags:editAnnotation>
    </c:when>
    <c:when test="${tagName == 'date'}">
        <myTags:editDates path="${path}[0]"
                          specifier="${specifier}-0"
                          isUnboundedList="true"
                          id="${specifier}-${tagName}-copy-tag">
        </myTags:editDates>
    </c:when>
    <c:when test="${tagName == 'identifier'}">
        <myTags:editIdentifier specifier="${specifier}-0"
                               isUnboundedList="true"
                               id="${specifier}-${tagName}-copy-tag"
                               path="${path}[0]">
        </myTags:editIdentifier>
    </c:when>
    <c:when test="${tagName == 'place'}">
        <myTags:editPlace path="${path}[${varStatus.count-1}]"
                          specifier="${specifier}-${varStatus.count-1}"
                          id="${specifier}-${tagName}-copy-tag"
                          isUnboundedList="true"
                          label="${label}">
        </myTags:editPlace>
    </c:when>
    <c:when test="${tagName == 'string'}">
        <myTags:editNonZeroLengthString path="${path}[0]"
                                        specifier="${specifier}-0"
                                        placeholder="${placeholder}"
                                        id="${specifier}-${tagName}-copy-tag"
                                        isRequired="false"
                                        isUnboundedList="true">
        </myTags:editNonZeroLengthString>
    </c:when>
    <c:when test="${tagName == 'stringRequired'}">
        <myTags:editNonZeroLengthString path="${path}[0]"
                                        specifier="${specifier}-0"
                                        placeholder="${placeholder}"
                                        id="${specifier}-${tagName}-copy-tag"
                                        isRequired="true"
                                        isUnboundedList="true">
        </myTags:editNonZeroLengthString>
    </c:when>
</c:choose>

<script type="text/javascript">
    $(document).ready(function () {
        var listItemCount = ${listItemsCount};
        //Show/Hide Formats
        $("body").on("click", ".${specifier}-add-${tagName}", function (e) {
            e.stopImmediatePropagation();
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $("#" + specifier + "-${tagName}-copy-tag").html();
            <%--var html = $("#${specifier}-0-tag").html();--%>
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}[' + listItemCount + ']')
                .replace(regexSpecifier, '${specifier}-' + listItemCount);
/*
                .replace("hide", "");
*/

            $(".${specifier}-${tagName}-add-more").before(html);
            listItemCount += 1;
        });


    });
</script>
