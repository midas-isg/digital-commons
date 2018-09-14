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
<%@ attribute name="addButtonLabel" required="true"
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
<%@ attribute name="cardText" required="true"
              type="java.lang.String" %>
<%@ attribute name="cardIcon" required="false"
              type="java.lang.String" %>
<%@ attribute name="showAddPersonButton" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="showAddOrganizationButton" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="createPersonOrganizationTags" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="showAddAnnotationButton" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="showAddBiologicalEntityButton" required="false"
              type="java.lang.Boolean" %>


<div class="col card-button d-flex align-items-stretch <c:if test="${not function:isObjectEmpty(listItems)}">hide</c:if>"
     id="${specifier}-add-input-button">
    <div class="card mx-auto input-group control-group card-rounded ${specifier}-${tagName}-add-more-button"
         style="width: 20rem;">
        <div class="card-header card-button-header add-card-header">
            <c:choose>
                <c:when test="${tagName == 'personComprisedEntity'}">
                    <c:if test="${showAddPersonButton and not showAddOrganizationButton}">
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-person" type="button"><i class="fa fa-plus-circle"></i> Add
                                ${label}
                        </button>
                    </c:if>
                    <c:if test="${showAddOrganizationButton and not showAddPersonButton}">
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-organization" type="button"><i class="fa fa-plus-circle"></i> Add
                                ${label}
                        </button>
                    </c:if>
                    <c:if test="${showAddPersonButton and showAddOrganizationButton}">
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-person" type="button"><i class="fa fa-plus-circle"></i> Add
                            Person
                        </button>
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-organization" type="button"><i class="fa fa-plus-circle"></i> Add
                            Organization
                        </button>
                    </c:if>
                </c:when>
                <c:when test="${tagName == 'isAbout'}">
                    <c:if test="${showAddAnnotationButton and not showAddBiologicalEntityButton}">
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-annotation" type="button"><i class="fa fa-plus-circle"></i> Add
                                ${label}
                        </button>
                    </c:if>
                    <c:if test="${showAddBiologicalEntityButton and not showAddAnnotationButton}">
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-biologicalEntity" type="button"><i class="fa fa-plus-circle"></i> Add
                                ${label}
                        </button>
                    </c:if>
                    <c:if test="${showAddBiologicalEntityButton and showAddAnnotationButton}">
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-annotation" type="button"><i class="fa fa-plus-circle"></i> Add
                            Annotation
                        </button>
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-biologicalEntity" type="button"><i class="fa fa-plus-circle"></i> Add
                            Biological Entity
                        </button>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" type="button"><i class="fa fa-plus-circle"></i> Add
                            ${label}
                    </button>
                </c:otherwise>
            </c:choose>

            <div class="d-flex justify-content-center align-items-center">
                <div class="card-label">${label}</div>
                <div class="card-icon"><i class="${cardIcon}"></i></div>
            </div>
        </div>
        <div class="card-body card-button-body d-flex">
            <p class="card-text">${cardText}</p>
            <p class="card-text">
                <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                    <span class="error-color error offset-2">${message.text}</span>
                </c:forEach>
            </p>
        </div>
    </div>
</div>
<c:set var="listItemsCount" scope="page" value="0"/>

<div id="${specifier}-card"
     class="form-group edit-form-group col-sm-12 card <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${function:isObjectEmpty(listItems)}">hide</c:if>">
    <div class="card-header card-header-unbounded">
        <h6 class="card-title">${label}</h6>

        <div class="heading-elements">
            <ul class="list-inline mb-0">
                <c:if test="${not isUnboundedList}">
                    <%--<li>
                        <button class="${specifier}-add-identifier" id="${specifier}-add-input-button" type="button">
                            Add ${label}</button>
                    </li>--%>
                </c:if>
                <c:choose>
                    <c:when test="${tagName == 'personComprisedEntity'}">
                        <c:if test="${showAddPersonButton}">
                            <c:if test="${not showAddOrganizationButton}">
                                <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-person"><i class="fa fa-plus-circle"></i> Add ${addButtonLabel}</a></li>
                            </c:if>
                            <c:if test="${showAddOrganizationButton}">
                                <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-person"><i class="fa fa-plus-circle"></i> Add Person</a></li>
                            </c:if>
                        </c:if>
                        <c:if test="${showAddOrganizationButton}">
                            <c:if test="${not showAddPersonButton}">
                                <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-organization"><i class="fa fa-plus-circle"></i> Add ${addButtonLabel}</a></li>
                            </c:if>
                            <c:if test="${showAddPersonButton}">
                                <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-organization"><i class="fa fa-plus-circle"></i> Add Organization</a></li>
                            </c:if>
                        </c:if>
                    </c:when>
                    <c:when test="${tagName == 'isAbout'}">
                        <c:if test="${showAddAnnotationButton and not showAddBiologicalEntityButton}">
                            <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-annotation"><i class="fa fa-plus-circle"></i> Add ${addButtonLabel}</a></li>
                        </c:if>
                        <c:if test="${showAddBiologicalEntityButton and not showAddAnnotationButton}">
                            <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-biologicalEntity"><i class="fa fa-plus-circle"></i> Add ${addButtonLabel}</a></li>
                        </c:if>
                        <c:if test="${showAddBiologicalEntityButton and showAddAnnotationButton}">
                            <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-annotation"><i class="fa fa-plus-circle"></i> Add Annotation</a></li>
                            <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-biologicalEntity"><i class="fa fa-plus-circle"></i> Add Biological Entity</a></li>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}"><i class="fa fa-plus-circle"></i> Add ${addButtonLabel}</a></li>
                    </c:otherwise>
                </c:choose>
                <li><a data-action="collapse"><i class="ft-minus ft-buttons"></i></a></li>
                <li><a data-action="expand"><i class="ft-maximize ft-buttons"></i></a></li>
                <li><a data-action="close"><i for="${specifier}-card"
                                              class="ft-x ft-buttons ${specifier}-${tagName}-remove"></i></a></li>
            </ul>
        </div>
        <c:if test="${function:isObjectEmpty(listItems)}">
            <ul id="${specifier}-card-header" class="nav nav-tabs card-header-tabs">
                    <%-- <li class="nav-item">
                         <a class="wizard-nav-link nav-link active" href="#">Active</a>
                     </li>--%>
            </ul>
        </c:if>
        <c:if test="${not function:isObjectEmpty(listItems)}">
            <ul id="${specifier}-card-header" class="nav nav-tabs card-header-tabs">
                <c:forEach items="${listItems}" varStatus="varStatus" var="listItem">
                    <c:set var="cardTabTitle" value="${function:getCardTabTitle(listItem)}"></c:set>
                    <c:set var="cardTabToolTip" value="${function:getCardTabToolTip(listItem)}"></c:set>
                    <li for="${specifier}-${varStatus.count-1}-input-block" id="${specifier}-${varStatus.count-1}-tab" class="nav-item">
                        <a onclick="showTab(event, this, '${specifier}')" id="${specifier}-${varStatus.count-1}-listItem" class="wizard-nav-link nav-link " data-toggle="tooltip" title="${cardTabToolTip}">
                                ${cardTabTitle}
                            <i onclick="closeTab(event, this)" class="ft-x"></i>
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </c:if>

    </div>

    <c:if test="${not function:isObjectEmpty(listItems)}">

        <c:forEach items="${listItems}" varStatus="varStatus" var="listItem">
<%--
            <div id="${specifier}-${varStatus.count-1}-tag" class="form-group">
--%>
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
                                                   cardText="${cardText}"
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
                                              cardText="${cardText}"
                                              cardIcon="${cardIcon}"
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
                        <c:when test="${tagName == 'isAbout'}">
                            <c:choose>
                                <c:when test="${not empty listItem.value or not empty listItem.valueIRI}">
                                    <myTags:editAnnotation annotation="${listItem}"
                                                           path="${path}[${varStatus.count-1}]"
                                                           specifier="${specifier}-${varStatus.count-1}"
                                                           id="${specifier}-${varStatus.count-1}"
                                                           label="${label} (Annotation)"
                                                           cardText="Different entities associated with this dataset."
                                                           isUnboundedList="${true}"
                                                           isRequired="${false}">
                                    </myTags:editAnnotation>
                                </c:when>
                                <c:when test="${not empty listItem.identifier or not empty listItem.name or not empty listItem.description}">
                                    <myTags:editBiologicalEntity entity="${listItem}"
                                                                 path="${path}[${varStatus.count-1}]"
                                                                 id="${specifier}-${varStatus.count-1}"
                                                                 specifier="${specifier}-${varStatus.count-1}"
                                                                 isUnboundedList="${true}"
                                                                 isRequired="${false}"
                                                                 label="${label} (BiologicalEntity)">
                                    </myTags:editBiologicalEntity>
                                </c:when>
                            </c:choose>
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
                        <c:when test="${tagName == 'personComprisedEntity'}">
                            <c:choose>
                                <c:when test="${not function:isPerson(listItem)}">
                                    <myTags:editOrganization organization="${listItem}"
                                                             path="${path}[${varStatus.count-1}]"
                                                             specifier="${specifier}-${varStatus.count-1}"
                                                             label="${label} (Organization)"
                                                             id="${specifier}-${varStatus.count-1}"
                                                             cardText="Organization ${cardText}"
                                                             tagName="organization"
                                                             isUnboundedList="${true}"
                                                             isFirstRequired="false">
                                    </myTags:editOrganization>

                                </c:when>
                                <c:when test="${function:isPerson(listItem)}">
                                    <myTags:editPerson person="${listItem}"
                                                       path="${path}[${varStatus.count-1}]"
                                                       specifier="${specifier}-${varStatus.count-1}"
                                                       label="${label} (Person)"
                                                       id="${specifier}-${varStatus.count-1}"
                                                       cardText="Person ${cardText}"
                                                       tagName="person"
                                                       isUnboundedList="${true}"
                                                       isFirstRequired="false">
                                    </myTags:editPerson>

                                </c:when>
                            </c:choose>
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
                                                            isInputGroup="${false}"
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
<%--
            </div>
--%>
        </c:forEach>
        <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
            <span class="error-color error offset-2">${message.text}</span>
        </c:forEach>

    </c:if>

    <div class="${specifier}-${tagName}-add-more"></div>

    <div class="card-footer">
        ${label} <a class="color-white" onclick="scrollToAnchor('${specifier}-card');"><i class="fa fa-arrow-circle-o-up" aria-hidden="true"></i></a>

    </div>
</div>


<%--<div id=${specifier}-card class="form-group edit-form-group col-sm-12 card<c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if>">--%>
<%--<div class="card-header">--%>
<%--<h6 class="card-title">${label}</h6>--%>

<%--<div class="heading-elements">--%>
<%--<ul class="list-inline mb-0">--%>
<%--<c:if test="${not isUnboundedList}">--%>
<%--&lt;%&ndash;<li>--%>
<%--<button class="${specifier}-add-identifier" id="${specifier}-add-input-button" type="button">--%>
<%--Add ${label}</button>--%>
<%--</li>&ndash;%&gt;--%>
<%--</c:if>--%>
<%--<li><a class="${specifier}-add-${tagName}"><i class="fa fa-plus-circle"></i> Add ${label}</a></li>--%>
<%--<li><a data-action="collapse"><i class="ft-minus"></i></a></li>--%>
<%--<li><a data-action="expand"><i class="ft-maximize"></i></a></li>--%>
<%--<li><a data-action="close"><i class="ft-x"></i></a></li>--%>
<%--</ul>--%>
<%--</div>--%>
<%--<ul id="date-card-header" class="nav nav-tabs card-header-tabs">--%>
<%--&lt;%&ndash; <li class="nav-item">--%>
<%--<a class="wizard-nav-link nav-link active" href="#">Active</a>--%>
<%--</li>&ndash;%&gt;--%>
<%--</ul>--%>
<%--</div>--%>


<%--&lt;%&ndash;<div id="${specifier}-add-input-button" class="form-group ${specifier}-${tagName}-add-more-button">&ndash;%&gt;--%>
<%--&lt;%&ndash;<button class="btn btn-success ${specifier}-add-${tagName}" type="button"><i&ndash;%&gt;--%>
<%--&lt;%&ndash;class="fa fa-plus-circle"></i> Add&ndash;%&gt;--%>
<%--&lt;%&ndash;${label}&ndash;%&gt;--%>
<%--&lt;%&ndash;</button>&ndash;%&gt;--%>
<%--&lt;%&ndash;</div>&ndash;%&gt;--%>
<%--<c:set var="listItemsCount" scope="page" value="0"/>--%>

<%--<c:forEach items="${listItems}" varStatus="varStatus" var="listItem">--%>
<%--<div id="${specifier}-${varStatus.count-1}-tag" class="form-group">--%>
<%--<c:if test="${not function:isObjectEmpty(listItem)}">--%>
<%--<c:choose>--%>
<%--<c:when test="${tagName == 'access'}">--%>
<%--<myTags:editAccess path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--tagName="${tagName}"--%>
<%--isAccessRequired="${isRequired}"--%>
<%--isUnboundedList="${true}"--%>
<%--access="${listItem}">--%>
<%--</myTags:editAccess>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'annotation'}">--%>
<%--<myTags:editAnnotation annotation="${listItem}"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--label="${label}"--%>
<%--isUnboundedList="${true}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--path="${path}[${varStatus.count-1}]">--%>
<%--</myTags:editAnnotation>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'categoryValuePair'}">--%>
<%--<myTags:editCategoryValuePair path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--label="${label}"--%>
<%--isUnboundedList="${true}"--%>
<%--tagName="${tagName}"--%>
<%--categoryValuePair="${listItem}">--%>
<%--</myTags:editCategoryValuePair>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'dataStandard'}">--%>
<%--<myTags:editDataStandard path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--tagName="${tagName}"--%>
<%--label="${label}"--%>
<%--isUnboundedList="${true}"--%>
<%--dataStandard="${listItem}">--%>
<%--</myTags:editDataStandard>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'dataServiceDescription'}">--%>
<%--<myTags:editDataServiceDescription path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--tagName="${tagName}"--%>
<%--label="${label}"--%>
<%--isRequired="${isRequired}"--%>
<%--isUnboundedList="${true}"--%>
<%--description="${listItem}">--%>
<%--</myTags:editDataServiceDescription>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'date'}">--%>
<%--<myTags:editDates path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--isUnboundedList="${true}"--%>
<%--date="${listItem}"--%>
<%--label="Date">--%>
<%--</myTags:editDates>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'distribution'}">--%>
<%--<myTags:editDistributions path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--distribution="${listItem}"--%>
<%--tagName="${tagName}"--%>
<%--isUnboundedList="${true}"--%>
<%--label="${label}">--%>
<%--</myTags:editDistributions>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'grant'}">--%>
<%--<myTags:editGrant path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--grant="${listItem}"--%>
<%--tagName="${tagName}"--%>
<%--isUnboundedList="${true}"--%>
<%--label="${label}">--%>
<%--</myTags:editGrant>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'identifier'}">--%>
<%--<myTags:editIdentifier singleIdentifier="${listItem}"--%>
<%--label="Identifier"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--isUnboundedList="${true}"--%>
<%--path="${path}[${varStatus.count-1}]">--%>
<%--</myTags:editIdentifier>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'license'}">--%>
<%--<myTags:editLicense path="${path}[${varStatus.count-1}]"--%>
<%--label="${label}"--%>
<%--license="${listItem}"--%>
<%--tagName="${tagName}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--isUnboundedList="${true}"--%>
<%--specifier="${specifier}-${varStatus.count-1}">--%>
<%--</myTags:editLicense>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'place'}">--%>
<%--<myTags:editPlace path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--place="${listItem}"--%>
<%--tagName="${tagName}"--%>
<%--isUnboundedList="${true}"--%>
<%--label="${label}">--%>
<%--</myTags:editPlace>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'publication'}">--%>
<%--<myTags:editPublication path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--publication="${listItem}"--%>
<%--tagName="${tagName}"--%>
<%--isUnboundedList="${true}"--%>
<%--label="${label}">--%>
<%--</myTags:editPublication>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'softwareIdentifier'}">--%>
<%--<myTags:editSoftwareIdentifier label="${label}"--%>
<%--path="${path}[${varStatus.count-1}].identifier"--%>
<%--identifier="${listItem.identifier}"--%>
<%--isUnboundedList="${true}"--%>
<%--isRequired="${isRequired}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--specifier="${specifier}-nested-identifier-${varStatus.count-1}">--%>
<%--</myTags:editSoftwareIdentifier>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'string'}">--%>
<%--<myTags:editNonZeroLengthString path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--placeholder="${placeholder}"--%>
<%--string="${listItem}"--%>
<%--isRequired="${isRequired}"--%>
<%--isFirstRequired="${isRequired}"--%>
<%--isUnboundedList="${true}">--%>
<%--</myTags:editNonZeroLengthString>--%>
<%--</c:when>--%>
<%--<c:when test="${tagName == 'type'}">--%>
<%--<myTags:editType path="${path}[${varStatus.count-1}]"--%>
<%--specifier="${specifier}-${varStatus.count-1}"--%>
<%--id="${specifier}-${varStatus.count-1}"--%>
<%--tagName="${tagName}"--%>
<%--label="${label}"--%>
<%--type="${listItem}"--%>
<%--isUnboundedList="${true}">--%>
<%--</myTags:editType>--%>
<%--</c:when>--%>
<%--</c:choose>--%>
<%--<c:set var="listItemsCount" scope="page" value="${varStatus.count}"/>--%>

<%--</c:if>--%>
<%--</div>--%>
<%--</c:forEach>--%>
<%--<c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">--%>
<%--<span class="error-color">${message.text}</span>--%>
<%--</c:forEach>--%>
<%--<div class="${specifier}-${tagName}-add-more"></div>--%>
<%--</div>--%>

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
                               cardText="${cardText}"
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
                          cardText="${cardText}"
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
    <c:when test="${tagName == 'isAbout'}">
        <myTags:editAnnotation path="${path}[0]"
                               specifier="${specifier}-00"
                               id="${specifier}-annotation-copy-tag"
                               label="${label} (Annotation)"
                               isUnboundedList="${true}"
                               cardText="Different entities associated with this dataset."
                               isRequired="${false}">
        </myTags:editAnnotation>

        <myTags:editBiologicalEntity path="${path}[0]"
                                     specifier="${specifier}-00"
                                     id="${specifier}-biologicalEntity-copy-tag"
                                     isUnboundedList="${true}"
                                     isRequired="${false}"
                                     label="${label} (BiologicalEntity)">
        </myTags:editBiologicalEntity>
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
    <c:when test="${tagName == 'personComprisedEntity'}">
        <c:if test="${showAddOrganizationButton}">
            <myTags:editOrganization path="${path}[0]"
                                     specifier="${specifier}-00"
                                     label="${label} (Organization)"
                                     id="${specifier}-organization-required-copy-tag"
                                     cardText="Organization ${cardText}"
                                     tagName="organization"
                                     isFirstRequired="true"
                                     isUnboundedList="true">
            </myTags:editOrganization>

            <myTags:editOrganization path="${path}[0]"
                                     specifier="${specifier}-00"
                                     label="${label} (Organization)"
                                     id="${specifier}-organization-copy-tag"
                                     cardText="Organization ${cardText}"
                                     tagName="organization"
                                     isUnboundedList="true"
                                     isFirstRequired="false">
            </myTags:editOrganization>
        </c:if>

        <c:if test="${showAddPersonButton and createPersonOrganizationTags}">
            <myTags:editPerson path="${path}[0]"
                               specifier="${specifier}-00"
                               label="${label} (Person)"
                               id="${specifier}-person-required-copy-tag"
                               cardText="Person ${cardText}"
                               tagName="person"
                               isUnboundedList="true"
                               isFirstRequired="true">
            </myTags:editPerson>

            <myTags:editPerson path="${path}[0]"
                               specifier="${specifier}-00"
                               label="${label} (Person)"
                               id="${specifier}-person-copy-tag"
                               cardText="Person ${cardText}"
                               tagName="person"
                               isUnboundedList="true"
                               isFirstRequired="false">
            </myTags:editPerson>
        </c:if>
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
                                        isInputGroup="${false}"
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

    $(document).ready(function () {

        <c:if test="${not function:isObjectEmpty(listItems)}">
        $("#" + "${specifier}-0-listItem").addClass("active");
        </c:if>

        var listItemCount = ${listItemsCount};

        //Show/Hide Formats
        $("body").on("click", ".${specifier}-add-${tagName}", function (e) {
            debugger;
            e.stopImmediatePropagation();
            var isFirstRequired = "${isFirstRequired}";
            if(isFirstRequired == "") {
                isFirstRequired = false;
            }

            createNewTab(this, '${specifier}', '${path}', '${tagName}', '${addButtonLabel}', isFirstRequired, listItemCount);
            scrollToAnchor('${specifier}-card');
            highlightDiv('${specifier}-card');
            listItemCount += 1;

        });

        //Remove section
        $("body").on("click", ".${specifier}-${tagName}-remove", function (e) {
            e.stopImmediatePropagation();
            $("#${specifier}-add-input-button").removeClass("hide");

            clearAndHideEditControlGroup($(e.target).attr("for"));

            closeAllTabs(e, $("#${specifier}-card"));

            $(this).closest('.card').addClass("hide").slideUp('fast');

            $("#${specifier}-card").addClass("hide");
        });

    });
</script>
