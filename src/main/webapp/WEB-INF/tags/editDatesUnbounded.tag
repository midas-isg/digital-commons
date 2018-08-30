<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="dates" required="false"
              type="java.util.List" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>


<div class="card form-group edit-form-group">
    <div class="card-header">
        <h6 class="card-title">${label}</h6>
        <ul id="date-card-header" class="nav nav-tabs card-header-tabs">
            <%-- <li class="nav-item">
                 <a class="wizard-nav-link nav-link active" href="#">Active</a>
             </li>--%>
        </ul>

        <div class="heading-elements">
            <ul class="list-inline mb-0">
                <c:if test="${not isUnboundedList}">
                    <li>
                        <button class="${specifier}-add-date" id="${specifier}-add-input-button" type="button">
                            Add Date
                        </button>
                    </li>
                </c:if>
                <li><a data-action="collapse"><i class="ft-minus"></i></a></li>

                <%--     <li><a data-action="expand"><i class="ft-maximize"></i></a></li>
                     <li><a data-action="close"><i class="ft-x"></i></a></li>--%>
            </ul>
        </div>
    </div>
    <div id="card-content" class="card-content">


        <%--<div id="${specifier}-add-input-button" class="form-group ${specifier}-date-add-more-button">
            <button class="btn btn-success ${specifier}-add-date" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                ${label}
            </button>
        </div>--%>
        <c:set var="dateCount" scope="page" value="0"/>


        <c:forEach items="${dates}" varStatus="varStatus" var="date">
            <div id="${specifier}-${varStatus.count-1}-tag" class="form-group">
                <c:if test="${not function:isObjectEmpty(date)}">
                    <myTags:editDates path="${path}[0]"
                                      specifier="${specifier}-0"
                                      isUnboundedList="true"
                                      date="${date}">
                    </myTags:editDates>
                </c:if>
                <c:set var="dateCount" scope="page" value="${varStatus.count}"/>
            </div>
        </c:forEach>
        <div class="${specifier}-date-add-more"></div>
    </div>
</div>


<myTags:editDates path="${path}[0]"
                  specifier="${specifier}-0"
                  isUnboundedList="true"
                  id="${specifier}-copy-tag">
</myTags:editDates>


<script type="text/javascript">
    function makeAllTabsInactive() {
        $("#date-card-header").find("a").each(function () {
            $(this).removeClass("active");
        });
    }

    function closeTab(e, div) {

        //find closest tab to the left tab to make it active (we don't just want to use the first tab)
        var myDiv = div;
        var prevDiv = undefined;
        var takeNext = false;
        $("#date-card-header").find("a").each(function () {
            if (takeNext) {
                prevDiv = $(this.parentElement);
                return false;
            }
            if ($(myDiv.parentElement.parentElement).attr("for") == $(this.parentElement).attr("for")) {
                takeNext = true;
            }

            prevDiv = $(this.parentElement);
            /* console.log($(this.parentElement).attr("for"));
             console.log(myDiv.parentElement.parentElement);*/
        });
        console.log($(prevDiv).attr("for"));
        var divToClose = $(div.parentElement.parentElement).attr("for")
        $("#" + divToClose).remove();
        $(div.parentElement.parentElement).remove();

        $("#" + $(prevDiv).attr("for")).show();
        $($(prevDiv).find("a")[0]).addClass("active")

        e.preventDefault();
        e.stopPropagation();
    }

    function showTab(e, div) {
        makeAllTabsInactive();

        var divToShow = $(div.parentElement).attr('for');

        $('#' + divToShow).show();
        $(div).addClass("active");

        $('#card-content').children().each(function (index) {
            console.log($(this).attr("id") + " . " + $(this).parents('#card-content').length);
            if ($(this).attr("id") != divToShow) {
                $(this).hide();
            }
        });
    };


    $(document).ready(function () {
        var unboundedDateCount = ${dateCount};


        //Show/Hide Date
        $("body").on("click", ".${specifier}-add-date", function (e) {

            //update specifier like classname-index
            //update name
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $("#${specifier}-copy-tag").html();
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            var newDivId = html.match("${path}-\\d*[A-Za-z\-]*")[0].replace('0', unboundedDateCount);
            html = html.replace(regexPath, '${path}[' + unboundedDateCount + ']').replace(regexSpecifier, '${specifier}-' + unboundedDateCount);

            makeAllTabsInactive();
            $(".card-header-tabs").append("<li  for=" + newDivId + " id=\"${path}-" + unboundedDateCount + "-tab\" class=\"nav-item\">" +
                " <a onclick=\"showTab(event, this)\" class=\"wizard-nav-link nav-link active\" >Date " + unboundedDateCount + "" +
                "<i onclick=\"closeTab(event, this)\" class=\"ft-x\"></i></a></li>");

            $(".${specifier}-date-add-more").after(html);
            $('#card-content').children().each(function (index) {
                console.log($(this).attr("id") + " . " + $(this).parents('#card-content').length);
                if ($(this).attr("id") != newDivId) {
                    $(this).hide();
                }
            });


            e.stopImmediatePropagation();

            unboundedDateCount += 1;
        });
    });
</script>
