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
<%@ attribute name="publications" required="false"
              type="java.util.List" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>


<c:choose>
    <c:when test="${not function:isObjectEmpty(publications)}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <c:forEach items="${publications}" var="publication" varStatus="varStatus">
                <c:if test="${varStatus.first}">
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add-publication" type="button"><i
                                class="fa fa-plus-circle"></i> Add
                                ${label}
                        </button>
                    </div>
                </c:if>
                <c:if test="${not function:isObjectEmpty(publication)}">
                    <div class="form-group control-group edit-form-group">
                        <label>${label}</label>
                        <br>
                        <button class="btn btn-danger publication-remove" type="button"><i
                                class="glyphicon glyphicon-remove"></i>
                            Remove
                        </button>
                        <myTags:editIdentifierUnbounded path="${path}[${varStatus.count-1}].identifier"
                                                        identifier="${publication.identifier}"
                                                        specifier="${specifier}-${varStatus.count-1}-identifier"
                                                        label="Identifier">
                        </myTags:editIdentifierUnbounded>
                        <myTags:editIdentifierUnbounded specifier="${specifier}-${varStatus.count-1}-alternateIdentifiers"
                                                        label="Alternate Identifiers"
                                                        path="${path}[${varStatus.count-1}].alternateIdentifiers"
                                                        identifiers="${publication.alternateIdentifiers}"
                                                        unbounded="${true}">
                        </myTags:editIdentifierUnbounded>
                        <myTags:editNonZeroLengthString
                                placeholder=" The name of the publication and its funding program."
                                label="Title"
                                string="${publication.title}"
                                path="${path}[${varStatus.count-1}].title"
                                specifier="${specifier}-title">
                        </myTags:editNonZeroLengthString>
                        <myTags:editAnnotationBounded path="${path}[${varStatus.count-1}].type"
                                                      specifier="${specifier}-${varStatus.count-1}-type"
                                                      annotation="${publication.type}"
                                                      placeholder=" Publication type, ideally delegated to an external vocabulary/resource."
                                                      label="Type">
                        </myTags:editAnnotationBounded>
                        <myTags:editNonZeroLengthString path="${path}.publicationVenue"
                                                        string="${publication.publicationVenue}"
                                                        specifier="${specifier}-publicationVenue"
                                                        placeholder=" The name of the publication venue where the document is published if applicable."
                                                        label="Publication Venue">
                        </myTags:editNonZeroLengthString>
                        <myTags:editDatesUnbounded dates="${publication.dates}"
                                                   path="${path}[${varStatus.count-1}].dates"
                                                   specifier="${specifier}-dates">
                        </myTags:editDatesUnbounded>
                        <myTags:editPersonComprisedEntity path="${path}[${varStatus.count-1}].authors"
                                                          specifier="${specifier}-${varStatus.count-1}-authors"
                                                          label="Author"
                                                          personComprisedEntities="${publication.authors}"
                                                          isFirstRequired="true"
                                                          showAddPersonButton="true"
                                                          showAddOrganizationButton="false">
                        </myTags:editPersonComprisedEntity>
                        <myTags:editGrant path="${path}[${varStatus.count-1}].acknowledges"
                                          specifier="${specifier}-${varStatus.count-1}-acknowledges"
                                          grants="${publication.acknowledges}"
                                          label="Acknowledges">
                        </myTags:editGrant>
                    </div>
                    <c:set var="publicationCount" scope="page" value="${varStatus.count}"/>
                </c:if>

            </c:forEach>
            <div class="${specifier}-publication-add-more"></div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-publication" type="button"><i
                        class="fa fa-plus-circle"></i> Add
                        ${label}
                </button>
            </div>
            <div class="${specifier}-publication-add-more"></div>
        </div>
        <c:set var="publicationCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>

<div class="${specifier}-copy-publication hide">
    <div class="form-group control-group edit-form-group">
        <label>${label}</label>
        <br>
        <button class="btn btn-danger publication-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <myTags:editIdentifierUnbounded path="${path}[0].identifier"
                                        specifier="${specifier}-0-identifier"
                                        label="Identifier">
        </myTags:editIdentifierUnbounded>
        <myTags:editIdentifierUnbounded specifier="${specifier}-0-alternateIdentifiers"
                                        label="Alternate Identifiers"
                                        path="${path}[0].alternateIdentifiers"
                                        unbounded="${true}">
        </myTags:editIdentifierUnbounded>
        <myTags:editNonZeroLengthString placeholder=" The name of the publication and its funding program."
                                        label="Title"
                                        path="${path}[0].title"
                                        specifier="${specifier}-0-title">
        </myTags:editNonZeroLengthString>
        <myTags:editAnnotationBounded path="${path}[0].type"
                                      specifier="${specifier}-0-type"
                                      placeholder=" Publication type, ideally delegated to an external vocabulary/resource."
                                      label="Type">
        </myTags:editAnnotationBounded>
        <myTags:editNonZeroLengthString path="${path}[0].publicationVenue"
                                        specifier="${specifier}-0-publicationVenue"
                                        placeholder=" The name of the publication venue where the document is published if applicable."
                                        label="Publication Venue">
        </myTags:editNonZeroLengthString>
        <myTags:editDatesUnbounded path="${path}[0].dates"
                                   specifier="${specifier}-0-dates">
        </myTags:editDatesUnbounded>
        <myTags:editPersonComprisedEntity path="${path}[0].authors"
                                          specifier="${specifier}-0-authors"
                                          label="Author"
                                          isFirstRequired="true"
                                          showAddPersonButton="true"
                                          showAddOrganizationButton="false">
        </myTags:editPersonComprisedEntity>
        <myTags:editGrant path="${path}[0].acknowledges"
                          specifier="${specifier}-0-acknowledges"
                          label="Acknowledges">
        </myTags:editGrant>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        var publicationCount = ${publicationCount};
        //Show/Hide Location
        $("body").on("click", ".${specifier}-add-publication", function (e) {
            e.stopImmediatePropagation();
            var specifier = "${specifier}";
            var path = "${path}";
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var html = $(".${specifier}-copy-publication").html();
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}[' + publicationCount + ']').replace(regexSpecifier, '${specifier}-' + publicationCount);
            publicationCount += 1;


            //$(this).after(html);
            $(".${specifier}-publication-add-more").before(html);
            //$(this).hide();
        });

        $("body").on("click", ".publication-remove", function () {
            clearAndHideEditControlGroup(this);
            $(".${specifier}-0-add-publication").show();
        });


    });
</script>