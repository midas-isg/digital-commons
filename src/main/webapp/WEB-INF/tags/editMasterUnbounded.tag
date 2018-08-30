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
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isFirstRequired" required="false"
              type="java.lang.Boolean" %>

<div id=${specifier}-card class="form-group edit-form-group card<c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if>">
    <div class="card-header">
        <h6 class="card-title">${label}</h6>

        <div class="heading-elements">
            <ul class="list-inline mb-0">
                <c:if test="${not isUnboundedList}">
                    <%--<li>
                        <button class="${specifier}-add-identifier" id="${specifier}-add-input-button" type="button">
                            Add ${label}</button>
                    </li>--%>
                </c:if>
                <li><a data-action="collapse"><i class="ft-minimize-2"></i></a></li>
                <li><a data-action="expand"><i class="ft-maximize"></i></a></li>
                <li><a data-action="close"><i class="ft-x"></i></a></li>
            </ul>
        </div>
        <ul id="date-card-header" class="nav nav-tabs card-header-tabs">
            <%-- <li class="nav-item">
                 <a class="wizard-nav-link nav-link active" href="#">Active</a>
             </li>--%>
        </ul>
    </div>


    <div id="${specifier}-add-input-button" class="form-group ${specifier}-${tagName}-add-more-button">
        <button class="btn btn-success ${specifier}-add-${tagName}" type="button"><i
                class="fa fa-plus-circle"></i> Add
            ${label}
        </button>
    </div>
    <c:set var="listItemsCount" scope="page" value="0"/>

    <c:forEach items="${listItems}" varStatus="varStatus" var="listItem">
        <div id="${specifier}-${varStatus.count-1}-tag" class="form-group">
            <c:if test="${not function:isObjectEmpty(listItem)}">
                <c:choose>
                    <c:when test="${tagName == 'access'}">
                        <myTags:editAccess path="${path}[${varStatus.count-1}]"
                                           specifier="${specifier}-${varStatus.count-1}"
                                           id="${specifier}-${varStatus.count-1}"
                                           tagName="${tagName}"
                                           isAccessRequired="${isRequired}"
                                           isUnboundedList="${true}"
                                           access="${listItem}">
                        </myTags:editAccess>
                    </c:when>
                    <c:when test="${tagName == 'annotation'}">
                        <myTags:editAnnotation annotation="${listItem}"
                                               specifier="${specifier}-${varStatus.count-1}"
                                               label="${label}"
                                               isUnboundedList="${true}"
                                               id="${specifier}-${varStatus.count-1}"
                                               path="${path}[${varStatus.count-1}]">
                        </myTags:editAnnotation>
                    </c:when>
                    <c:when test="${tagName == 'categoryValuePair'}">
                        <myTags:editCategoryValuePair path="${path}[${varStatus.count-1}]"
                                                      specifier="${specifier}-${varStatus.count-1}"
                                                      id="${specifier}-${varStatus.count-1}"
                                                      label="${label}"
                                                      isUnboundedList="${true}"
                                                      tagName="${tagName}"
                                                      categoryValuePair="${listItem}">
                        </myTags:editCategoryValuePair>
                    </c:when>
                    <c:when test="${tagName == 'dataStandard'}">
                        <myTags:editDataStandard path="${path}[${varStatus.count-1}]"
                                                 specifier="${specifier}-${varStatus.count-1}"
                                                 id="${specifier}-${varStatus.count-1}"
                                                 tagName="${tagName}"
                                                 label="${label}"
                                                 isUnboundedList="${true}"
                                                 dataStandard="${listItem}">
                        </myTags:editDataStandard>
                    </c:when>
                    <c:when test="${tagName == 'dataServiceDescription'}">
                        <myTags:editDataServiceDescription path="${path}[${varStatus.count-1}]"
                                                           specifier="${specifier}-${varStatus.count-1}"
                                                           id="${specifier}-${varStatus.count-1}"
                                                           tagName="${tagName}"
                                                           label="${label}"
                                                           isRequired="${isRequired}"
                                                           isUnboundedList="${true}"
                                                           description="${listItem}">
                        </myTags:editDataServiceDescription>
                    </c:when>
                    <c:when test="${tagName == 'date'}">
                        <myTags:editDates path="${path}[${varStatus.count-1}]"
                                          specifier="${specifier}-${varStatus.count-1}"
                                          id="${specifier}-${varStatus.count-1}"
                                          isUnboundedList="${true}"
                                          date="${listItem}"
                                            label="Date">
                        </myTags:editDates>
                    </c:when>
                    <c:when test="${tagName == 'distribution'}">
                        <myTags:editDistributions path="${path}[${varStatus.count-1}]"
                                                  specifier="${specifier}-${varStatus.count-1}"
                                                  id="${specifier}-${varStatus.count-1}"
                                                  distribution="${listItem}"
                                                  tagName="${tagName}"
                                                  isUnboundedList="${true}"
                                                  label="${label}">
                        </myTags:editDistributions>
                    </c:when>
                    <c:when test="${tagName == 'grant'}">
                        <myTags:editGrant path="${path}[${varStatus.count-1}]"
                                          specifier="${specifier}-${varStatus.count-1}"
                                          id="${specifier}-${varStatus.count-1}"
                                          grant="${listItem}"
                                          tagName="${tagName}"
                                          isUnboundedList="${true}"
                                          label="${label}">
                        </myTags:editGrant>
                    </c:when>
                    <c:when test="${tagName == 'identifier'}">
                        <myTags:editIdentifier singleIdentifier="${listItem}"
                                               label="Identifier"
                                               specifier="${specifier}-${varStatus.count-1}"
                                               id="${specifier}-${varStatus.count-1}"
                                               isUnboundedList="${true}"
                                               path="${path}[${varStatus.count-1}]">
                        </myTags:editIdentifier>
                    </c:when>
                    <c:when test="${tagName == 'license'}">
                        <myTags:editLicense path="${path}[${varStatus.count-1}]"
                                            label="${label}"
                                            license="${listItem}"
                                            tagName="${tagName}"
                                            id="${specifier}-${varStatus.count-1}"
                                            isUnboundedList="${true}"
                                            specifier="${specifier}-${varStatus.count-1}">
                        </myTags:editLicense>
                    </c:when>
                    <c:when test="${tagName == 'place'}">
                        <myTags:editPlace path="${path}[${varStatus.count-1}]"
                                          specifier="${specifier}-${varStatus.count-1}"
                                          id="${specifier}-${varStatus.count-1}"
                                          place="${listItem}"
                                          tagName="${tagName}"
                                          isUnboundedList="${true}"
                                          label="${label}">
                        </myTags:editPlace>
                    </c:when>
                    <c:when test="${tagName == 'publication'}">
                        <myTags:editPublication path="${path}[${varStatus.count-1}]"
                                                specifier="${specifier}-${varStatus.count-1}"
                                                id="${specifier}-${varStatus.count-1}"
                                                publication="${listItem}"
                                                tagName="${tagName}"
                                                isUnboundedList="${true}"
                                                label="${label}">
                        </myTags:editPublication>
                    </c:when>
                    <c:when test="${tagName == 'softwareIdentifier'}">
                        <myTags:editSoftwareIdentifier label="${label}"
                                                       path="${path}[${varStatus.count-1}].identifier"
                                                       identifier="${listItem.identifier}"
                                                       isUnboundedList="${true}"
                                                       isRequired="${isRequired}"
                                                       id="${specifier}-${varStatus.count-1}"
                                                       specifier="${specifier}-nested-identifier-${varStatus.count-1}">
                        </myTags:editSoftwareIdentifier>
                    </c:when>
                    <c:when test="${tagName == 'string'}">
                        <myTags:editNonZeroLengthString path="${path}[${varStatus.count-1}]"
                                                        specifier="${specifier}-${varStatus.count-1}"
                                                        id="${specifier}-${varStatus.count-1}"
                                                        placeholder="${placeholder}"
                                                        string="${listItem}"
                                                        isRequired="${isRequired}"
                                                        isFirstRequired="${isRequired}"
                                                        isUnboundedList="${true}">
                        </myTags:editNonZeroLengthString>
                    </c:when>
                    <c:when test="${tagName == 'type'}">
                        <myTags:editType path="${path}[${varStatus.count-1}]"
                                         specifier="${specifier}-${varStatus.count-1}"
                                         id="${specifier}-${varStatus.count-1}"
                                         tagName="${tagName}"
                                         label="${label}"
                                         type="${listItem}"
                                         isUnboundedList="${true}">
                        </myTags:editType>
                    </c:when>
                </c:choose>
                <c:set var="listItemsCount" scope="page" value="${varStatus.count}"/>

            </c:if>
        </div>
    </c:forEach>
    <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
        <span class="error-color">${message.text}</span>
    </c:forEach>
    <div class="${specifier}-${tagName}-add-more"></div>
</div>

<c:choose>
    <c:when test="${tagName == 'access'}">
        <myTags:editAccess path="${path}[0]"
                           specifier="${specifier}-00"
                           tagName="${tagName}"
                           isUnboundedList="${true}"
                           id="${specifier}-${tagName}-copy-tag"
                           isAccessRequired="${isRequired}">
        </myTags:editAccess>
    </c:when>
    <c:when test="${tagName == 'annotation'}">
        <myTags:editAnnotation specifier="${specifier}-00"
                               label="${label}"
                               isUnboundedList="${true}"
                               id="${specifier}-${tagName}-copy-tag"
                               path="${path}[0]">
        </myTags:editAnnotation>
    </c:when>
    <c:when test="${tagName == 'categoryValuePair'}">
        <myTags:editCategoryValuePair path="${path}[0]"
                                      specifier="${specifier}-00"
                                      id="${specifier}-${tagName}-copy-tag"
                                      tagName="${tagName}"
                                      isUnboundedList="${true}"
                                      label="${label}">
        </myTags:editCategoryValuePair>
    </c:when>
    <c:when test="${tagName == 'dataStandard'}">
        <myTags:editDataStandard path="${path}[0]"
                                 specifier="${specifier}-00"
                                 tagName="${tagName}"
                                 label="${label}"
                                 isUnboundedList="${true}"
                                 id="${specifier}-${tagName}-copy-tag">
        </myTags:editDataStandard>
    </c:when>
    <c:when test="${tagName == 'dataServiceDescription'}">
        <myTags:editDataServiceDescription path="${path}[0]"
                                           specifier="${specifier}-00"
                                           id="${specifier}-${tagName}-copy-tag"
                                           tagName="${tagName}"
                                           label="${label}"
                                           isRequired="${isRequired}"
                                           isUnboundedList="${true}">
        </myTags:editDataServiceDescription>
    </c:when>
    <c:when test="${tagName == 'date'}">
        <myTags:editDates path="${path}[0]"
                          specifier="${specifier}-00"
                          isUnboundedList="${true}"
                          id="${specifier}-${tagName}-copy-tag"
                          label="Date">
        </myTags:editDates>
    </c:when>
    <c:when test="${tagName == 'distribution'}">
        <myTags:editDistributions path="${path}[0]"
                                  specifier="${specifier}-00"
                                  tagName="${tagName}"
                                  id="${specifier}-${tagName}-copy-tag"
                                  label="${label}"
                                  isUnboundedList="${true}">
        </myTags:editDistributions>
    </c:when>
    <c:when test="${tagName == 'grant'}">
        <myTags:editGrant path="${path}[0]"
                          specifier="${specifier}-00"
                          tagName="${tagName}"
                          id="${specifier}-${tagName}-copy-tag"
                          isUnboundedList="${true}"
                          label="${label}">
        </myTags:editGrant>
    </c:when>
    <c:when test="${tagName == 'identifier'}">
        <myTags:editIdentifier specifier="${specifier}-00"
                               label="Identifier"
                               isUnboundedList="${true}"
                               id="${specifier}-${tagName}-copy-tag"
                               path="${path}[0]">
        </myTags:editIdentifier>
    </c:when>
    <c:when test="${tagName == 'license'}">
        <myTags:editLicense path="${path}[0]"
                            label="License"
                            id="${specifier}-${tagName}-copy-tag"
                            tagName="${tagName}"
                            isUnboundedList="${true}"
                            specifier="${specifier}-00">
        </myTags:editLicense>
    </c:when>
    <c:when test="${tagName == 'place'}">
        <myTags:editPlace path="${path}[0]"
                          specifier="${specifier}-00"
                          id="${specifier}-${tagName}-copy-tag"
                          tagName="${tagName}"
                          isUnboundedList="${true}"
                          label="${label}">
        </myTags:editPlace>
    </c:when>
    <c:when test="${tagName == 'publication'}">
        <myTags:editPublication path="${path}[0]"
                                specifier="${specifier}-00"
                                id="${specifier}-${tagName}-copy-tag"
                                tagName="${tagName}"
                                isUnboundedList="${true}"
                                label="${label}">
        </myTags:editPublication>
    </c:when>
    <c:when test="${tagName == 'softwareIdentifier'}">
        <myTags:editSoftwareIdentifier label="${label}"
                                       path="${path}[0].identifier"
                                       tagName="${tagName}"
                                       isUnboundedList="${true}"
                                       id="${specifier}-${tagName}-copy-tag"
                                       specifier="${specifier}-00">
        </myTags:editSoftwareIdentifier>
    </c:when>
    <c:when test="${tagName == 'string'}">
        <myTags:editNonZeroLengthString path="${path}[0]"
                                        specifier="${specifier}-00"
                                        placeholder="${placeholder}"
                                        id="${specifier}-${tagName}-copy-tag"
                                        isRequired="${false}"
                                        isUnboundedList="${true}">
        </myTags:editNonZeroLengthString>
    </c:when>
    <c:when test="${tagName == 'type'}">
        <myTags:editType path="${path}[0]"
                         specifier="${specifier}-00"
                         label="${label}"
                         tagName="${tagName}"
                         id="${specifier}-${tagName}-copy-tag"
                         isUnboundedList="${true}">
        </myTags:editType>
    </c:when>
</c:choose>

<script type="text/javascript">
    function makeAllTabsInactive() {
        $("#date-card-header").find("a").each(function () {
            $(this).removeClass("active");
        });
    }

    function closeTab(e, div) {

        //find closest tab to the left tab to make it active (we don't just want to use the first tab)
        var prevDiv = undefined;
        var takeNext = false;
        $("#date-card-header").find("a").each(function () {
            if (takeNext) {
                prevDiv = $(this.parentElement);
                return false;
            }
            if ($(div.parentElement.parentElement).attr("for") == $(this.parentElement).attr("for")) {
                if ($(this).hasClass("active")) {
                    takeNext = true;
                }
            } else if ($(this).hasClass("active")) {
                prevDiv = $(this.parentElement);
                return false;
            } else prevDiv = $(this.parentElement);


            // console.log($(this.parentElement).attr("for"));
            //  console.log(myDiv.parentElement.parentElement);
        });
        //console.log($(prevDiv).attr("for"));
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
        console.log("calling showTab");
        var divToShow = $(div.parentElement).attr('for');

        $('#' + divToShow).show();
        $(div).addClass("active");

        $('#${specifier}-card .card-content').each(function (index) {
            console.log($(this).attr("id") + " . " + $(this).parents('#card-content').length);
            if ($(this).attr("id") != divToShow) {
                $(this).hide();
            }
        });
    };

    function showTabNamed(tabToActivate, divToShow) {
        makeAllTabsInactive();
        console.log("calling showTabNamed");
       // var divToShow = $(div.parentElement).attr('for');

        $('#' + divToShow).show();
     //   $(tabToActivate).addClass("active");
        $($("[for='"+divToShow+"'] .nav-link" )[0]).addClass("active");
        $('#${specifier}-card .card-content').each(function (index) {
            console.log($(this).attr("id") + " . " + $(this).parents('#card-content').length);
            if ($(this).attr("id") != divToShow) {
                $(this).hide();
            }
        });
    };



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
            var regexSpecifier = new RegExp(specifier + '\\-00', "g");
            html = html.replace(regexPath, '${path}[' + listItemCount + ']')
                .replace(regexSpecifier, '${specifier}-' + listItemCount);
            /*
                            .replace("hide", "");
            */
            var newDivId = html.match("${path}-\\d*[A-Za-z\-]*")[0].replace('0', listItemCount);
            $(".${specifier}-${tagName}-add-more").before(html);
            $("#${specifier}-" + listItemCount + "-date-picker").datepicker({
                forceParse: false,
                orientation: 'top auto',
                todayHighlight: true,
                format: 'yyyy-mm-dd',
                uiLibrary: 'bootstrap4',
            });

            makeAllTabsInactive();
            $(".card-header-tabs").append("<li  for=" + newDivId + " id=\"${path}-" + listItemCount + "-tab\" class=\"nav-item\">" +
                " <a onclick=\"showTab(event, this)\" class=\"wizard-nav-link nav-link active\" >Date " + listItemCount + "" +
                "<i onclick=\"closeTab(event, this)\" class=\"ft-x\"></i></a></li>");

            showTabNamed("${path}-" + listItemCount + "-tab", newDivId);
           /* $('#card-content').children().each(function (index) {
                console.log($(this).attr("id") + " . " + $(this).parents('#card-content').length);
                if ($(this).attr("id") != newDivId) {
                    $(this).hide();
                }
            });*/

            e.stopImmediatePropagation();

            listItemCount += 1;
        });


    });
</script>
