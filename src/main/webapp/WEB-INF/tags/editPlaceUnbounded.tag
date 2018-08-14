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
<%@ attribute name="placeList" required="false"
              type="java.util.List" %>


<div class="form-group edit-form-group">
    <label>${label}</label>
    <button class="btn btn-success ${specifier}-add-place" type="button"><i
            class="glyphicon glyphicon-plus"></i> Add
        ${label}
    </button>
    <c:set var="placeCount" value="0"/>

    <c:forEach items="${placeList}" var="place" varStatus="varStatus">
        <c:if test="${not function:isObjectEmpty(place)}">

            <myTags:editPlace path="${path}[${varStatus.count-1}]"
                              specifier="${specifier}-${varStatus.count-1}"
                              place="${place}"
                              isUnboundedList="true"
                              label="${label}">
            </myTags:editPlace>

            <c:set var="placeCount" scope="page" value="${varStatus.count}"/>
        </c:if>

    </c:forEach>
    <div class="${specifier}-place-add-more">
    </div>
</div>

<myTags:editPlace path="${path}[0]"
                  specifier="${specifier}-0"
                  isUnboundedList="true"
                  id="${specifier}-copy-tag"
                  label="${label}">
</myTags:editPlace>


<%--

<c:choose>
    <c:when test="${not function:isObjectEmpty(placeList)}">
        <c:forEach items="${placeList}" var="place" varStatus="varStatus">
            <c:if test="${varStatus.first}">
                <div class="form-group edit-form-group">
                    <label>${label}</label>
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            ${label}
                        </button>
                    </div>
                </div>
            </c:if>
            <c:if test="${not function:isObjectEmpty(place)}">
                <myTags:editPlace path="${path}[${varStatus.count-1}]"
                                  specifier="${specifier}-${varStatus.count-1}"
                                  place="${place}"
                                  label="${label}">
                </myTags:editPlace>
                <c:set var="placeCount" scope="page" value="${varStatus.count}"/>
            </c:if>
        </c:forEach>
        <div class="${specifier}-place-add-more"></div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    ${label}
                </button>
            </div>
        </div>
        <div class="${specifier}-place-add-more"></div>
        <c:set var="placeCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>


<div class="${specifier}-copy hide">
    &lt;%&ndash;<div class="form-group control-group edit-form-group">&ndash;%&gt;
        &lt;%&ndash;<label>${label}</label>&ndash;%&gt;
        &lt;%&ndash;<div class="form-group">&ndash;%&gt;
            &lt;%&ndash;<button class="btn btn-danger place-remove" type="button"><i&ndash;%&gt;
                    &lt;%&ndash;class="glyphicon glyphicon-remove"></i>&ndash;%&gt;
                &lt;%&ndash;Remove&ndash;%&gt;
            &lt;%&ndash;</button>&ndash;%&gt;
        &lt;%&ndash;</div>&ndash;%&gt;
        <myTags:editPlace path="${path}[0]"
                           specifier="${specifier}-"
                          label="${label}"
                          expanded="${true}"
        >
        </myTags:editPlace>
    &lt;%&ndash;</div>&ndash;%&gt;
</div>

--%>


<script type="text/javascript">
    $(document).ready(function () {

        var placeCount = ${placeCount};
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
            html = html.replace(regexPath, '${path}['+ placeCount + ']')
                .replace(regexSpecifier,'${specifier}-' + placeCount + '-');
            placeCount += 1;

            // $(this).after(html);
            $(".${specifier}-place-add-more").before(html);
        });
        $("body").on("click", ".place-remove", function () {
            clearAndHideEditControlGroup(this);
        });


    });
</script>