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


<div class="form-group edit-form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if>">
    <label>${label}</label>
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
                        <myTags:editAccess path="${path}[${varStatus.count-1}].access"
                                           specifier="${specifier}-${varStatus.count-1}-access"
                                           id="${specifier}-${varStatus.count-1}-access"
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
                    <c:when test="${tagName == 'date'}">
                        <myTags:editDates path="${path}[${varStatus.count-1}]"
                                          specifier="${specifier}-${varStatus.count-1}"
                                          id="${specifier}-${varStatus.count-1}"
                                          isUnboundedList="${true}"
                                          date="${listItem}">
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
                    <c:when test="${tagName == 'string'}">
                        <myTags:editNonZeroLengthString path="${path}[${varStatus.count-1}]"
                                                        specifier="${specifier}-${varStatus.count-1}"
                                                        id="${specifier}-${varStatus.count-1}"
                                                        placeholder="${placeholder}"
                                                        string="${listItem}"
                                                        isRequired="${false}"
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
        <myTags:editAccess path="${path}[0].access"
                           specifier="${specifier}-0-access"
                           tagName="${tagName}"
                           isUnboundedList="${true}"
                           id="${specifier}-${tagName}-copy-tag"
                           isAccessRequired="${isRequired}">
        </myTags:editAccess>
    </c:when>
    <c:when test="${tagName == 'annotation'}">
        <myTags:editAnnotation specifier="${specifier}-0"
                               label="${label}"
                               isUnboundedList="${true}"
                               id="${specifier}-${tagName}-copy-tag"
                               path="${path}[0]">
        </myTags:editAnnotation>
    </c:when>
    <c:when test="${tagName == 'categoryValuePair'}">
        <myTags:editCategoryValuePair path="${path}[0]"
                                      specifier="${specifier}-0"
                                      id="${specifier}-${tagName}-copy-tag"
                                      tagName="${tagName}"
                                      isUnboundedList="${true}"
                                      label="${label}">
        </myTags:editCategoryValuePair>
    </c:when>
    <c:when test="${tagName == 'dataStandard'}">
        <myTags:editDataStandard path="${path}[0]"
                                 specifier="${specifier}-0"
                                 tagName="${tagName}"
                                 label="${label}"
                                 isUnboundedList="${true}"
                                 id="${specifier}-${tagName}-copy-tag">
        </myTags:editDataStandard>
    </c:when>
    <c:when test="${tagName == 'date'}">
        <myTags:editDates path="${path}[0]"
                          specifier="${specifier}-0"
                          isUnboundedList="${true}"
                          id="${specifier}-${tagName}-copy-tag">
        </myTags:editDates>
    </c:when>
    <c:when test="${tagName == 'distribution'}">
        <myTags:editDistributions path="${path}[0]"
                                  specifier="${specifier}-0"
                                  tagName="${tagName}"
                                  id="${specifier}-${tagName}-copy-tag"
                                  label="${label}"
                                  isUnboundedList="${true}">
        </myTags:editDistributions>
    </c:when>
    <c:when test="${tagName == 'grant'}">
        <myTags:editGrant path="${path}[0]"
                          specifier="${specifier}-0"
                          tagName="${tagName}"
                          id="${specifier}-${tagName}-copy-tag"
                          isUnboundedList="${true}"
                          label="${label}">
        </myTags:editGrant>
    </c:when>
    <c:when test="${tagName == 'identifier'}">
        <myTags:editIdentifier specifier="${specifier}-0"
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
                            specifier="${specifier}-0">
        </myTags:editLicense>
    </c:when>
    <c:when test="${tagName == 'place'}">
        <myTags:editPlace path="${path}[0]"
                          specifier="${specifier}-0"
                          id="${specifier}-${tagName}-copy-tag"
                          tagName="${tagName}"
                          isUnboundedList="${true}"
                          label="${label}">
        </myTags:editPlace>
    </c:when>
    <c:when test="${tagName == 'publication'}">
        <myTags:editPublication path="${path}[0]"
                                specifier="${specifier}-0"
                                id="${specifier}-${tagName}-copy-tag"
                                tagName="${tagName}"
                                isUnboundedList="${true}"
                                label="${label}">
        </myTags:editPublication>
    </c:when>
    <c:when test="${tagName == 'string'}">
        <myTags:editNonZeroLengthString path="${path}[0]"
                                        specifier="${specifier}-0"
                                        placeholder="${placeholder}"
                                        id="${specifier}-${tagName}-copy-tag"
                                        isRequired="${false}"
                                        isUnboundedList="${true}">
        </myTags:editNonZeroLengthString>
    </c:when>
    <c:when test="${tagName == 'type'}">
        <myTags:editType path="${path}[0]"
                         specifier="${specifier}-0"
                         label="${label}"
                         tagName="${tagName}"
                         id="${specifier}-${tagName}-copy-tag"
                         isUnboundedList="${true}">
        </myTags:editType>
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

            $("#${specifier}-" + listItemCount+ "-date-picker").datepicker({
                constrainInput: false,
                showOptions: { direction: "up" },
                changeMonth: true,
                changeYear: true,
                uiLibrary: 'bootstrap4',
            });

            listItemCount += 1;
        });


    });
</script>
