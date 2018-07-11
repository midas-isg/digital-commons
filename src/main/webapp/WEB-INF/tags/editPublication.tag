<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="publications" required="false"
              type="java.util.ArrayList" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>


<c:choose>
    <c:when test="${not empty publications}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <c:forEach items="${publications}" var="publication" varStatus="varStatus">
                <c:if test="${varStatus.first}">
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add-publication" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                                ${label}
                        </button>
                    </div>
                </c:if>
                <div class="form-group control-group edit-form-group">
                    <label>${label}</label>
                    <br>
                    <button class="btn btn-danger publication-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                    <myTags:editIdentifier path="${path}[${varStatus.count-1}].identifier"
                                           identifier="${publication.identifier}"
                                           specifier="${specifier}-${varStatus.count-1}-identifier"
                                           label="Identifier">
                    </myTags:editIdentifier>
                    <myTags:editIdentifier specifier="${specifier}-${varStatus.count-1}-alternateIdentifiers"
                                           label="Alternate Identifiers"
                                           path="${path}[${varStatus.count-1}].alternateIdentifiers"
                                           identifiers="${publication.alternateIdentifiers}"
                                           unbounded="${true}">
                    </myTags:editIdentifier>
                    <myTags:editRequiredNonZeroLengthString
                            placeholder=" The name of the publication and its funding program."
                            label="Title"
                            string="${publication.title}"
                            path="${path}[${varStatus.count-1}].title">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editAnnotationBounded path="${path}[${varStatus.count-1}].type"
                                                  specifier="${specifier}-${varStatus.count-1}-type"
                                                  annotation="${publication.type}"
                                                  placeholder=" Publication type, ideally delegated to an external vocabulary/resource."
                                                  label="Type">
                    </myTags:editAnnotationBounded>
                    <myTags:editNonRequiredNonZeroLengthString path="${path}.publicationVenue"
                                                               string="${publication.publicationVenue}"
                                                               specifier="${specifier}-publicationVenue"
                                                               placeholder=" The name of the publication venue where the document is published if applicable."
                                                               label="Publication Venue">
                    </myTags:editNonRequiredNonZeroLengthString>
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

            </c:forEach>
            <div class="${specifier}-publication-add-more"></div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-publication" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
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
        <myTags:editIdentifier path="${path}[0].identifier"
                               specifier="${specifier}-0-identifier"
                               label="Identifier">
        </myTags:editIdentifier>
        <myTags:editIdentifier specifier="${specifier}-0-alternateIdentifiers"
                               label="Alternate Identifiers"
                               path="${path}[0].alternateIdentifiers"
                               unbounded="${true}">
        </myTags:editIdentifier>
        <myTags:editRequiredNonZeroLengthString placeholder=" The name of the publication and its funding program."
                                                label="Title"
                                                path="${path}[0].title">
        </myTags:editRequiredNonZeroLengthString>
        <myTags:editAnnotationBounded path="${path}[0].type"
                                      specifier="${specifier}-0-type"
                                      placeholder=" Publication type, ideally delegated to an external vocabulary/resource."
                                      label="Type">
        </myTags:editAnnotationBounded>
        <myTags:editNonRequiredNonZeroLengthString path="${path}[0].publicationVenue"
                                                   specifier="${specifier}-0-publicationVenue"
                                                   placeholder=" The name of the publication venue where the document is published if applicable."
                                                   label="Publication Venue">
        </myTags:editNonRequiredNonZeroLengthString>
        <myTags:editDatesUnbounded path="${path}[0].dates"
                                   specifier="${specifier}-0-dates">
        </myTags:editDatesUnbounded>
        <myTags:editPersonComprisedEntity path="${path}[0].authors"
                                          specifier="${specifier}-0-authors"
                                          label="Authors"
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
            $(this).closest(".control-group").remove();
            $(".${specifier}-0-add-publication").show();
        });


    });
</script>