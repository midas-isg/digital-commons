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
        <c:forEach items="${distributions}" var="distribution" varStatus="status">
            <c:if test="${status.first}">
                <div class="form-group edit-form-group distribution-add-more">
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


                <myTags:editIdentifier label="Identifier" specifier="${specifier}-${status.count-1}"
                                       path="${path}[${status.count-1}].identifier"
                                       identifier="${distribution.identifier}"
                                       unbounded="False"></myTags:editIdentifier>

                <myTags:editDatesUnbounded dates="${distribution.dates}" path="${path}[${status.count-1}]" specifier="${specifier}"></myTags:editDatesUnbounded>

                <myTags:editAccess path="${path}[${status.count-1}].access"
                                   specifier="${specifier}-${status.count-1}-access"
                                   access="${distribution.access}"></myTags:editAccess>

                <myTags:editDataStandard name="Conforms To" path="${path}[${status.count-1}].conformsTo"
                                         dataStandards="${distribution.conformsTo}"
                                         specifier="${specifier}-${status.count-1}-conformsTo"></myTags:editDataStandard>

            </div>
            <c:set var="distributionCount" scope="page" value="${status.count}"/>

        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group distribution-add-more">
            <label>Distribution</label>
            <div class="form-group">
                <button class="btn btn-success add-distribution" type="button"><i class="glyphicon glyphicon-plus"></i>
                    Add Distribution
                </button>
            </div>
        </div>
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
        <myTags:editSize path="${path}[0].size" specifier="${specifier}-size"></myTags:editSize>
        <myTags:editUnit path="${path}[0].unit" specifier="${specifier}-unit"></myTags:editUnit>
        <myTags:editFormats path="${path}[0].formats" specifier="${specifier}-formats"></myTags:editFormats>

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

            $(".distribution-add-more").after(html);
            distributionCount += 1;
        });

        //Remove section
        $("body").on("click", ".distribution-remove", function () {
            $(this).parents(".control-group").remove();
        });


    });
</script>