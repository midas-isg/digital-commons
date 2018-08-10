<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="distributions" required="false"
              type="java.util.List" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>


<c:choose>
    <c:when test="${not function:isObjectEmpty(distributions)}">
        <c:forEach items="${distributions}" var="distribution" varStatus="varStatus">
            <c:if test="${varStatus.first}">
                <div class="form-group edit-form-group distribution-add-more-button">
                    <label>Distribution</label>
                    <div class="form-group">
                        <button class="btn btn-success add-distribution" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add Distribution
                        </button>
                    </div>
                </div>
            </c:if>
            <c:if test="${not function:isObjectEmpty(distribution)}">
                <div class="form-group control-group edit-form-group">
                    <label>Distribution</label>
                    <button class="btn btn-danger distribution-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i> Remove
                    </button>
                    <myTags:editIdentifier label="Identifier" specifier="${specifier}-${varStatus.count-1}"
                                           path="${path}[${varStatus.count-1}].identifier"
                                           identifier="${distribution.identifier}"
                                           unbounded="False">
                    </myTags:editIdentifier>
                    <myTags:editIdentifier specifier="${specifier}-${varStatus.count-1}-alternateIdentifiers"
                                           label="Alternate Identifiers"
                                           path="${path}[${varStatus.count-1}].alternateIdentifiers"
                                           identifiers="${distribution.alternateIdentifiers}"
                                           unbounded="${true}">
                    </myTags:editIdentifier>
                    <myTags:editNonRequiredNonZeroLengthString path="${path}[${varStatus.count-1}].title"
                                                               specifier="${specifier}-${varStatus.count-1}-title"
                                                               placeholder=" The name of the dataset, usually one sentece or short description of the dataset."
                                                               string="${distribution.title}"
                                                               label="Title">
                    </myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString path="${path}[${varStatus.count-1}].description"
                                                               string="${distribution.description}"
                                                               specifier="${specifier}-${varStatus.count-1}-description"
                                                               placeholder=" A textual narrative comprised of one or more statements describing the dataset distribution."
                                                               label="Description"
                                                               isTextArea="True" >
                    </myTags:editNonRequiredNonZeroLengthString>
<%--
                    <myTags:editNonRequiredNonZeroLengthStringTextArea path="${path}[${varStatus.count-1}].description"
                                                                       string="${distribution.description}"
                                                                       specifier="${specifier}-${varStatus.count-1}-description"
                                                                       placeholder=" A textual narrative comprised of one or more statements describing the dataset distribution."
                                                                       label="Description">
                    </myTags:editNonRequiredNonZeroLengthStringTextArea>
--%>
                    <myTags:editDataRepository name="Stored In" path="${path}[${varStatus.count-1}].storedIn"
                                               dataRepository="${distribution.storedIn}"
                                               specifier="${specifier}-${varStatus.count-1}-storedIn">
                    </myTags:editDataRepository>
                    <myTags:editDatesUnbounded dates="${distribution.dates}"
                                               path="${path}[${varStatus.count-1}].dates"
                                               specifier="${specifier}-dates">
                    </myTags:editDatesUnbounded>
                    <myTags:editNonRequiredNonZeroLengthString label="Version" placeholder=" A release point for the dataset when applicable."
                                                               specifier="${specifier}-${varStatus.count-1}-version"
                                                               string="${distribution.version}"
                                                               path="${path}[${varStatus.count-1}].version">
                    </myTags:editNonRequiredNonZeroLengthString>
                    <myTags:editLicense path="${path}[${varStatus.count-1}].licenses"
                                        licenses="${distribution.licenses}"
                                        label="License"
                                        specifier="${specifier}-${varStatus.count-1}-licenses">
                    </myTags:editLicense>
                    <myTags:editAccess path="${path}[${varStatus.count-1}].access"
                                       specifier="${specifier}-${varStatus.count-1}-access" isAccessRequired="true"
                                       access="${distribution.access}">
                    </myTags:editAccess>
                    <myTags:editDataStandard name="Conforms To" path="${path}[${varStatus.count-1}].conformsTo"
                                             dataStandards="${distribution.conformsTo}"
                                             specifier="${specifier}-${varStatus.count-1}-conformsTo">
                    </myTags:editDataStandard>
                    <myTags:editAnnotationUnbounded path="${path}[${varStatus.count-1}].qualifiers"
                                                    specifier="${specifier}-${varStatus.count-1}-qualifiers"
                                                    annotations="${distribution.qualifiers}"
                                                    label="Qualifiers">
                    </myTags:editAnnotationUnbounded>
                    <myTags:editUnboundedNonRequiredNonZeroLengthString formats="${distribution.formats}"
                                                                        path="${path}[${varStatus.count-1}].formats"
                                                                        specifier="${specifier}-${varStatus.count-1}-formats"
                                                                        placeholder=" The technical format of the dataset distribution. Use the file extension or MIME type when possible."
                                                                        label="Formats">
                    </myTags:editUnboundedNonRequiredNonZeroLengthString>
                    <myTags:editFloat path="${path}[${varStatus.count-1}].size"
                                      specifier="${specifier}-${varStatus.count-1}-size"
                                      number="${distribution.size}"
                                      placeholder=" The size of the dataset."
                                      label="Size" >
                    </myTags:editFloat>
                    <myTags:editAnnotationBounded annotation="${distribution.unit}" path="${path}[${varStatus.count-1}].unit"
                                                  specifier="${specifier}-${varStatus.count-1}-unit"
                                                  placeholder=" The unit of measurement used to estimate the size of the dataset (e.g, petabyte). Ideally, the unit should be coming from a reference controlled terminology."
                                                  label="Unit" >
                    </myTags:editAnnotationBounded>
                </div>
                <c:set var="distributionCount" scope="page" value="${varStatus.count}"/>
            </c:if>

        </c:forEach>
        <div class="distribution-add-more"></div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group distribution-add-more-button">
            <label>Distribution</label>
            <div class="form-group">
                <button class="btn btn-success add-distribution" type="button"><i class="glyphicon glyphicon-plus"></i>
                    Add Distribution
                </button>
            </div>
        </div>
        <div class="distribution-add-more"></div>
        <c:set var="distributionCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>


<div class="copy-distribution hide">
    <div class="form-group control-group edit-form-group">
        <label>Distribution</label>
        <button class="btn btn-danger distribution-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <myTags:editIdentifier label="Identifier" specifier="${specifier}-0" path="${path}[0].identifier"
                               unbounded="False">
        </myTags:editIdentifier>
        <myTags:editIdentifier specifier="${specifier}-alternateIdentifiers"
                               label="Alternate Identifiers"
                               path="${path}[0].alternateIdentifiers"
                               unbounded="${true}">
        </myTags:editIdentifier>
        <myTags:editNonRequiredNonZeroLengthString path="${path}[0].title"
                                                   specifier="${specifier}-title"
                                                   placeholder=" The name of the dataset, usually one sentece or short description of the dataset."
                                                   label="Title">
        </myTags:editNonRequiredNonZeroLengthString>
        <myTags:editNonRequiredNonZeroLengthString path="${path}[0].description"
                                                           specifier="${specifier}-description"
                                                           placeholder=" A textual narrative comprised of one or more statements describing the dataset distribution."
                                                           label="Description"
                                                            isTextArea="True">
        </myTags:editNonRequiredNonZeroLengthString>
        <myTags:editDataRepository name="Stored In" path="${path}[0].storedIn"
                                   specifier="${specifier}-storedIn">
        </myTags:editDataRepository>
        <myTags:editDatesUnbounded path="${path}[0].dates"
                                   specifier="${specifier}-dates">
        </myTags:editDatesUnbounded>
        <myTags:editNonRequiredNonZeroLengthString label="Version" placeholder=" A release point for the dataset when applicable."
                                                   specifier="${specifier}-version"
                                                   path="${path}[0].version">
        </myTags:editNonRequiredNonZeroLengthString>
        <myTags:editLicense path="${path}[0].licenses"
                            label="License"
                            specifier="${specifier}-licenses">
        </myTags:editLicense>
        <myTags:editAccess path="${path}[0].access"
                           specifier="${specifier}-access"
                           isAccessRequired="true">
        </myTags:editAccess>
        <myTags:editDataStandard name="Conforms To"
                                 path="${path}[0].conformsTo"
                                 specifier="${specifier}-conformsTo">
        </myTags:editDataStandard>
        <myTags:editAnnotationUnbounded path="${path}[0].qualifiers"
                                        specifier="${specifier}-qualifiers"
                                        label="Qualifiers">
        </myTags:editAnnotationUnbounded>
        <myTags:editUnboundedNonRequiredNonZeroLengthString path="${path}[0].formats"
                                                            specifier="${specifier}-formats"
                                                            placeholder=" The technical format of the dataset distribution. Use the file extension or MIME type when possible."
                                                            label="Formats">
        </myTags:editUnboundedNonRequiredNonZeroLengthString>
        <myTags:editFloat path="${path}[0].size"
                          specifier="${specifier}-size"
                          placeholder=" The size of the dataset."
                          label="Size" >
        </myTags:editFloat>
        <myTags:editAnnotationBounded path="${path}[0].unit"
                                      specifier="${specifier}-unit"
                                      placeholder=" The unit of measurement used to estimate the size of the dataset (e.g, petabyte). Ideally, the unit should be coming from a reference controlled terminology."
                                      label="Unit" >
        </myTags:editAnnotationBounded>

    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var distributionCount = ${distributionCount};
        var specifier = "${specifier}";
        var path = "${path}";
        //Add section
        $(".add-distribution").click(function () {
            var html = $(".copy-distribution").html();
            //html = html.replace(/${path}.identifier/g, '${path}['+ distributionCount + '].identifier').replace(/${specifier}--/g,'${specifier}-' + distributionCount + '-');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}[' + distributionCount + ']').replace(regexSpecifier, '${specifier}-' + distributionCount + '-');

            //$(".distribution-add-more").after(html);
            $(".distribution-add-more").before(html);
            distributionCount += 1;
        });

        //Remove section
        $("body").on("click", ".distribution-remove", function () {
            clearAndHideEditControlGroup(this);
            // $(this).parents(".control-group").remove();
        });


    });
</script>