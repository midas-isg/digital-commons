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
<%@ attribute name="publication" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Publication" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>


<div id="${id}"
     class="form-group <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">has-error</c:if> <c:if test="${isUnboundedList and function:isObjectEmpty(publication)}">hide</c:if>">
    <c:if test="${not isUnboundedList}">
        <label>${label}</label>
        <div id="${specifier}-add-input-button"
             class="input-group control-group ${specifier}-publication-add-more <c:if test="${not function:isObjectEmpty(publication)}">hide</c:if>">
            <div class="input-group-btn">
                <button class="btn btn-success ${specifier}-add-publication" type="button"><i
                        class="fa fa-plus-circle"></i> Add
                        ${label}
                </button>
            </div>
        </div>
    </c:if>
    <div id="${specifier}-input-block"
         class="form-group control-group edit-form-group <c:if test="${function:isObjectEmpty(publication) and not isUnboundedList}">hide</c:if>">
        <c:if test="${isUnboundedList}">
            <label>${label}</label>
        </c:if>
        <button class="btn btn-danger ${specifier}-publication-remove" type="button"><i
                class="fa fa-minus-circle"></i>
            Remove
        </button>
        <myTags:editIdentifier path="${path}.identifier"
                               singleIdentifier="${publication.identifier}"
                               specifier="${specifier}-identifier"
                               isUnboundedList="${false}"
                               label="Identifier">
        </myTags:editIdentifier>
        <myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                                    label="Alternate Identifiers"
                                    path="${path}.alternateIdentifiers"
                                    listItems="${publication.alternateIdentifiers}"
                                    tagName="identifier">
        </myTags:editMasterUnbounded>
        <myTags:editNonZeroLengthString
                placeholder=" The name of the publication and its funding program."
                label="Title"
                string="${publication.title}"
                path="${path}.title"
                specifier="${specifier}-title">
        </myTags:editNonZeroLengthString>
        <myTags:editAnnotation path="${path}.type"
                               isUnboundedList="${false}"
                               specifier="${specifier}-type"
                               id="${specifier}-type"
                               annotation="${publication.type}"
                               label="Type">
        </myTags:editAnnotation>
        <myTags:editNonZeroLengthString path="${path}.publicationVenue"
                                        string="${publication.publicationVenue}"
                                        specifier="${specifier}-publicationVenue"
                                        placeholder=" The name of the publication venue where the document is published if applicable."
                                        label="Publication Venue">
        </myTags:editNonZeroLengthString>
        <myTags:editMasterUnbounded listItems="${publication.dates}"
                                    label="Publication Date"
                                    path="${path}.dates"
                                    tagName="date"
                                    specifier="${specifier}-dates">
        </myTags:editMasterUnbounded>
        <myTags:editPersonComprisedEntity path="${path}.authors"
                                          specifier="${specifier}-authors"
                                          label="Author"
                                          personComprisedEntities="${publication.authors}"
                                          createPersonOrganizationTags="${true}"
                                          isFirstRequired="${true}"
                                          showAddPersonButton="${true}"
                                          showAddOrganizationButton="${false}">
        </myTags:editPersonComprisedEntity>
        <myTags:editMasterUnbounded path="${path}.acknowledges"
                                    specifier="${specifier}-acknowledges"
                                    listItems="${publication.acknowledges}"
                                    tagName="grant"
                                    label="Acknowledges">
        </myTags:editMasterUnbounded>

        <c:if test="${not empty flowRequestContext.messageContext.getMessagesBySource(path)}">
            <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(path)}" var="message">
                <span class="error-color">${message.text}</span>
            </c:forEach>
        </c:if>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $("body").on("click", ".${specifier}-add-publication", function (e) {
                e.stopImmediatePropagation();

                $("#${specifier}-input-block").removeClass("hide");
                <c:if test="${isUnboundedList or not isRequired}">
                $("#${specifier}-add-input-button").addClass("hide");
                </c:if>

                //Add section
                $("#${specifier}-publication").val("");
            });

            //Remove section
            $("body").on("click", ".${specifier}-publication-remove", function (e) {
                e.stopImmediatePropagation();

                clearAndHideEditControlGroup(this);
                $("#${specifier}-add-input-button").removeClass("hide");
                $("#${specifier}-input-block").addClass("hide");
            });
        });

    </script>

</div>
