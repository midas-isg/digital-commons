<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="distributions" required="false"
              type="java.util.ArrayList" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>


<c:choose>
    <c:when test="${not empty distributions}">
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
            <div class="form-group control-group edit-form-group">
                <label>Distribution</label>
                <button class="btn btn-danger distribution-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i> Remove
                </button>

                <div class="form-group">

                    <myTags:editIdentifier label="Identifier" specifier="${specifier}-${varStatus.count-1}"
                                           path="${path}[${varStatus.count-1}].identifier"
                                           identifier="${distribution.identifier}"
                                           unbounded="False"></myTags:editIdentifier>
                </div>

                <myTags:editDatesUnbounded dates="${distribution.dates}" path="${path}[${varStatus.count-1}]"
                                           specifier="${specifier}"></myTags:editDatesUnbounded>

                <myTags:editAccess path="${path}[${varStatus.count-1}].access"
                                   specifier="${specifier}-${varStatus.count-1}-access"
                                   access="${distribution.access}"></myTags:editAccess>

                <myTags:editDataStandard name="Conforms To" path="${path}[${varStatus.count-1}].conformsTo"
                                         dataStandards="${distribution.conformsTo}"
                                         specifier="${specifier}-${varStatus.count-1}-conformsTo"></myTags:editDataStandard>

                <myTags:editDataRepository name="Stored In" path="${path}[${varStatus.count-1}].storedIn"
                                           dataRepository="${distribution.storedIn}"
                                           specifier="${specifier}-${varStatus.count-1}-storedIn"></myTags:editDataRepository>

                <myTags:editSize size="${distribution.size}" path="${path}[${varStatus.count-1}].size"
                                 specifier="${specifier}-${varStatus.count-1}-size"
                                 placeholder=" Size"
                                 label="Size" ></myTags:editSize>

                <myTags:editAnnotationBounded annotation="${distribution.unit}" path="${path}[${varStatus.count-1}].unit"
                                              specifier="${specifier}-${varStatus.count-1}-unit"
                                              placeholder=" Unit"
                                              label="Unit" ></myTags:editAnnotationBounded>

                <myTags:editUnboundedNonRequiredNonZeroLengthString formats="${distribution.formats}" path="${path}[${varStatus.count-1}].formats"
                                                                    specifier="${specifier}-${varStatus.count-1}-formats" placeholder="Format" label="Formats"></myTags:editUnboundedNonRequiredNonZeroLengthString>
            </div>
            <c:set var="distributionCount" scope="page" value="${varStatus.count}"/>

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
        <div class="form-group">
            <myTags:editIdentifier label="Identifier" specifier="${specifier}-0" path="${path}[0].identifier"
                                   unbounded="False"></myTags:editIdentifier>
        </div>
        <myTags:editDatesUnbounded path="${path}[0]" specifier="${specifier}"></myTags:editDatesUnbounded>
        <myTags:editAccess path="${path}[0].access" specifier="${specifier}-access"></myTags:editAccess>
        <myTags:editDataStandard name="Conforms To" path="${path}[0].conformsTo"
                                 specifier="${specifier}-conformsTo"></myTags:editDataStandard>
        <myTags:editDataRepository name="Stored In" path="${path}[0].storedIn"
                                   specifier="${specifier}-storedIn"></myTags:editDataRepository>
        <myTags:editSize path="${path}[0].size"
                         specifier="${specifier}-size"
                         placeholder=" Size"
                         label="Size" ></myTags:editSize>
        <myTags:editAnnotationBounded path="${path}[0].unit"
                                      specifier="${specifier}-unit"
                                      placeholder=" Unit"
                                      label="Unit" ></myTags:editAnnotationBounded>
        <myTags:editUnboundedNonRequiredNonZeroLengthString path="${path}[0].formats"
                                                            specifier="${specifier}-formats"
                                                            placeholder="Format"
                                                            label="Formats"></myTags:editUnboundedNonRequiredNonZeroLengthString>

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
            $(this).parents(".control-group").remove();
        });


    });
</script>