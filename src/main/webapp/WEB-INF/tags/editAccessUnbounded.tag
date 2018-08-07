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
<%@ attribute name="accessList" required="false"
              type="java.util.List" %>



<div class="form-group edit-form-group">
    <label>${label}</label>
    <button class="btn btn-success ${specifier}-add-access" type="button"><i
            class="glyphicon glyphicon-plus"></i> Add
        ${label}
    </button>
    <c:set var="accessCount" value="0"/>

    <c:forEach items="${accessList}" var="access" varStatus="varStatus">
        <c:if test="${not function:isObjectEmpty(access)}">

            <myTags:editAccess path="${path}[${varStatus.count-1}]"
                               specifier="${specifier}-${varStatus.count-1}"
                               access="${access}"
                               isAccessRequired="false">
            </myTags:editAccess>

            <c:set var="accessCount" scope="page" value="${varStatus.count}"/>
        </c:if>

    </c:forEach>
    <div class="${specifier}-access-add-more">
    </div>
</div>

<myTags:editAccess path="${path}[0]"
                   specifier="${specifier}-0"
                   id="${specifier}-copy-tag"
                   isAccessRequired="false">
</myTags:editAccess>

<%--

<c:choose>
    <c:when test="${not function:isObjectEmpty(accessList)}">
        <c:forEach items="${accessList}" var="access" varStatus="varStatus">
            <c:if test="${varStatus.first}">
                <div class="form-group edit-form-group">
                    <label>${label}</label>
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add" type="button"><i
                                class="fa fa-plus-circle"></i> Add
                            ${label}
                        </button>
                    </div>
                </div>
            </c:if>
            <c:if test="${not function:isObjectEmpty(access)}">
                <div class="form-group control-group edit-form-group">
                    <label>${label}</label>
                    <div class="form-group">
                        <button class="btn btn-danger access-remove" type="button"><i
                                class="glyphicon glyphicon-remove"></i>
                            Remove
                        </button>
                    </div>
                    <myTags:editAccess path="${path}[${varStatus.count-1}]"
                                       specifier="${specifier}-${varStatus.count-1}"
                                       access="${access}"
                                       isAccessRequired="false">
                    </myTags:editAccess>
                </div>
                <c:set var="accessCount" scope="page" value="${varStatus.count}"/>
            </c:if>
        </c:forEach>
        <div class="${specifier}-access-add-more">
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add" type="button"><i
                        class="fa fa-plus-circle"></i> Add
                    ${label}
                </button>
            </div>
            <div class="${specifier}-access-add-more">
            </div>
        </div>
        <c:set var="accessCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>


<div class="${specifier}-copy hide">
    <div class="form-group control-group edit-form-group">
        <label>${label}</label>
        <div class="form-group">
            <button class="btn btn-danger access-remove" type="button"><i
                    class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
        <myTags:editAccess path="${path}[0]"
                           specifier="${specifier}-"
                           isAccessRequired="false">
        </myTags:editAccess>
    </div>
</div>
--%>



<script type="text/javascript">
    $(document).ready(function () {

        var accessCount = ${accessCount};
        //Show/Hide Values
        $("body").on("click", ".${specifier}-add", function (e) {
            e.stopImmediatePropagation();

            var specifier = "${specifier}";
            var path = "${path}";
            var html = $(".${specifier}-copy-tag").html();
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}['+ accessCount + ']')
                .replace(regexSpecifier,'${specifier}-' + accessCount + '-');
            accessCount += 1;

            // $(this).after(html);
            $(".${specifier}-access-add-more").before(html);
        });
        $("body").on("click", ".access-remove", function () {
            clearAndHideEditControlGroup(this);
        });


    });
</script>