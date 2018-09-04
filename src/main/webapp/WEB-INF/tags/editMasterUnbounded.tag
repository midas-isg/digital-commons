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
<%@ attribute name="cardText" required="true"
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


<div class="col card-button <c:if test="${not function:isObjectEmpty(listItem)}">hide</c:if>"
     id="${specifier}-add-input-button">
    <div class="card mx-auto input-group control-group ${specifier}-${tagName}-add-more-button"
         style="width: 18rem;">
        <div class="card-body">
            <h5 class="card-title">${label}</h5>
            <%--<h6 class="card-subtitle mb-2 text-muted">Card subtitle</h6>--%>
            <p class="card-text">${cardText}</p>
            <c:choose>
                <c:when test="${tagName == 'personComprisedEntity'}">
                    <c:if test="${showAddPersonButton}">
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-person" type="button">Add
                                ${label} (Person)
                        </button>
                    </c:if>
                    <c:if test="${showAddOrganizationButton}">
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-organization" type="button">Add
                                ${label} (Organization)
                        </button>
                    </c:if>
                </c:when>
                <c:when test="${tagName == 'isAbout'}">
                    <c:if test="${showAddAnnotationButton}">
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-annotation" type="button">Add
                                ${label} (Annotation)
                        </button>
                    </c:if>
                    <c:if test="${showAddBiologicalEntityButton}">
                        <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-biologicalEntity" type="button">Add
                                ${label} (Biological Entity)
                        </button>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-primary btn-block ${specifier}-add-${tagName}" type="button">Add
                            ${label}
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<c:set var="listItemsCount" scope="page" value="0"/>

<div id="${specifier}-card"
     class="form-group edit-form-group col-sm-12 card<c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${function:isObjectEmpty(listItem)}">hide</c:if>">
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
                <c:choose>
                    <c:when test="${tagName == 'personComprisedEntity'}">
                        <c:if test="${showAddPersonButton}">
                            <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-person"><i class="fa fa-plus-circle"></i> Add ${label} (Person)</a></li>
                        </c:if>
                        <c:if test="${showAddOrganizationButton}">
                            <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-organization"><i class="fa fa-plus-circle"></i> Add ${label} (Organization)</a></li>
                        </c:if>
                    </c:when>
                    <c:when test="${tagName == 'isAbout'}">
                        <c:if test="${showAddAnnotationButton}">
                            <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-annotation"><i class="fa fa-plus-circle"></i> Add ${label} (Annotation)</a></li>
                        </c:if>
                        <c:if test="${showAddBiologicalEntityButton}">
                            <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}-biologicalEntity"><i class="fa fa-plus-circle"></i> Add ${label} (Biological Entity)</a></li>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <li><a class="${specifier}-add-${tagName}" id="${specifier}-add-${tagName}"><i class="fa fa-plus-circle"></i> Add ${label}</a></li>
                    </c:otherwise>
                </c:choose>
                <li><a data-action="collapse"><i class="ft-minus"></i></a></li>
                <li><a data-action="expand"><i class="ft-maximize"></i></a></li>
                <li><a data-action="close"><i for="${specifier}-card"
                                              class="ft-x ${specifier}-${tagName}-remove"></i></a></li>
            </ul>
        </div>
        <ul id="${specifier}-card-header" class="nav nav-tabs card-header-tabs">
            <%-- <li class="nav-item">
                 <a class="wizard-nav-link nav-link active" href="#">Active</a>
             </li>--%>
        </ul>
    </div>

    <c:if test="${not function:isObjectEmpty(listItem)}">

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

    </c:if>

    <div class="${specifier}-${tagName}-add-more"></div>

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
    function makeAllTabsInactive(specifier) {
        $("#"+ specifier+"-card-header").find("a").each(function () {
            $(this).removeClass("active");
        });
    }

    function closeTab(e, div) {

        //find closest tab to the left tab to make it active (we don't just want to use the first tab)
        var prevDiv = undefined;
        var takeNext = false;
        $("#${specifier}-card-header").find("a").each(function () {
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
    };

    //find each card header in the section and subsections and close all tabs
    function closeAllTabs(e, div) {
        $(div).find(".card-header").each(function() {
            closeAllTabs(e, $(this));
            $(this).find("a").each(function(){
                if ($(this).hasClass("nav-link")) {
                    $(this.parentElement).remove();
                }
            });
        });
    };

    function showTab(e, div, specifier) {
        makeAllTabsInactive(specifier);
        console.log("calling showTab");
        var divToShow = $(div.parentElement).attr('for');

        $(div).addClass("active");

        $('#'+specifier+'-card .card-content').each(function (index) {
            console.log($(this).attr("id") + " . " + $(this).parents('#card-content').length);
            if ($(this).attr("id") != divToShow) {
                $(this).addClass("hide");
            }
        });

        $('#' + divToShow).removeClass("hide");
        $('#'+divToShow+' .card-content').each(function (index) {
            console.log("HELLO"+$(this).attr("id") + " . " + $(this).parents('#card-content').length);
            $(this).removeClass("hide");
        });
    };

    function showTabNamed(tabToActivate, divToShow, specifier) {
        makeAllTabsInactive(specifier);
        console.log("calling showTabNamed");
        // var divToShow = $(div.parentElement).attr('for');

        $('#' + divToShow).removeClass("hide");
        //   $(tabToActivate).addClass("active");
        $($("[for='" + divToShow + "'] .nav-link")[0]).addClass("active");
        $('#'+specifier+'-card .card-content').each(function (index) {
            console.log($(this).attr("id") + " . " + $(this).parents('#card-content').length);
            if ($(this).attr("id") != divToShow) {
                $(this).addClass("hide");
                // $(this).hide();
            }
        });
    };


    $(document).ready(function () {
        var listItemCount = ${listItemsCount};

        //Show/Hide Formats
        $("body").on("click", ".${specifier}-add-${tagName}", function (e) {
            debugger;
            e.stopImmediatePropagation();
            var specifier = "${specifier}";
            var path = "${path}";
            $("#${specifier}-add-input-button").addClass("hide");
            $("#${specifier}-card").removeClass("hide");
            debugger;
            <c:choose>
                <c:when test="${tagName == 'personComprisedEntity'}">
                    if (this.id == "${specifier}-add-${tagName}-person") {
                        if (listItemCount === 0 && ${isFirstRequired}) {
                            var html = $("#" + "${specifier}-person-required-copy-tag").html();
                        } else var html = $("#" + "${specifier}-person-copy-tag").html();
                    } else if (this.id == "${specifier}-add-${tagName}-organization") {
                        if (listItemCount === 0 && ${isFirstRequired}) {
                            var html = $("#" + "${specifier}-organization-required-copy-tag").html();
                        } else var html = $("#" + "${specifier}-organization-copy-tag").html();
                    }
                </c:when>
                <c:when test="${tagName == 'isAbout'}">
                    if (this.id == "${specifier}-add-${tagName}-annotation") {
                        var html = $("#" + "${specifier}-annotation-copy-tag").html();
                    } else if (this.id == "${specifier}-add-${tagName}-biologicalEntity") {
                        var html = $("#" + "${specifier}-biologicalEntity-copy-tag").html();
                    }
                </c:when>
                <c:otherwise>
                    var html = $("#" + specifier + "-${tagName}-copy-tag").html();
                </c:otherwise>
            </c:choose>
            <%--var html = $("#${specifier}-0-tag").html();--%>
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-00', "g");
            html = html.replace(regexPath, '${path}[' + listItemCount + ']')
                .replace(regexSpecifier, '${specifier}-' + listItemCount);

            var newDivId = html.match("${specifier}-\\d*[A-Za-z\-]*")[0];
            $(".${specifier}-${tagName}-add-more").before(html);
            $("#${specifier}-" + listItemCount + "-date-picker").datepicker({
                forceParse: false,
                orientation: 'top auto',
                todayHighlight: true,
                format: 'yyyy-mm-dd',
                uiLibrary: 'bootstrap4',
            });

            makeAllTabsInactive(specifier);
            //create a new tab
            $("#${specifier}-card").find(".card-header-tabs").first().append("<li  for=" + newDivId + " id=\"${specifier}-" + listItemCount + "-tab\" class=\"nav-item\">" +
                " <a onclick=\"showTab(event, this, '${specifier}')\" class=\"wizard-nav-link nav-link active\" >${label} " + listItemCount + "" +
                "<i onclick=\"closeTab(event, this)\" class=\"ft-x\"></i></a></li>");

            //switch to newly created tab
            showTabNamed("${specifier}-" + listItemCount + "-tab", newDivId, specifier);
            /* $('#card-content').children().each(function (index) {
                 console.log($(this).attr("id") + " . " + $(this).parents('#card-content').length);
                 if ($(this).attr("id") != newDivId) {
                     $(this).hide();
                 }
             });*/


            $("#${specifier}-"+listItemCount+"-input-block").addClass("collapse");
            $("#${specifier}-"+listItemCount+"-input-block").addClass("show");
            //move card buttons to the bottom
            rearrangeCards('${specifier}-' + listItemCount + '-input-block');

            e.stopImmediatePropagation();

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
