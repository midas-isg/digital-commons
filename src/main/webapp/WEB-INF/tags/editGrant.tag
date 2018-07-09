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
<%@ attribute name="grants" required="false"
              type="java.util.ArrayList" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>


<c:choose>
    <c:when test="${not empty grants}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <c:forEach items="${grants}" var="grant" varStatus="varStatus">
                <c:if test="${varStatus.first}">
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add-grant" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                                ${label}
                        </button>
                    </div>
                </c:if>
                <div class="form-group control-group edit-form-group">
                    <label>${label}</label>
                    <br>
                    <button class="btn btn-danger grant-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                    <myTags:editIdentifier path="${path}[${varStatus.count-1}].identifier" identifier="${grant.identifier}"
                                           specifier="${specifier}-${varStatus.count-1}-identifier"
                                           label="Identifier">
                    </myTags:editIdentifier>
                    <myTags:editIdentifier specifier="${specifier}-${varStatus.count-1}-alternateIdentifiers"
                                           label="Alternate Identifiers"
                                           path="${path}[${varStatus.count-1}].alternateIdentifiers"
                                           identifiers="${grant.alternateIdentifiers}"
                                           unbounded="${true}">
                    </myTags:editIdentifier>
                    <myTags:editRequiredNonZeroLengthString placeholder=" The name of the grant and its funding program."
                                                            label="Name"
                                                            string="${grant.name}"
                                                            path="${path}[${varStatus.count-1}].name">
                    </myTags:editRequiredNonZeroLengthString>
                    <%--<myTags:editPersonComprisedEntity path="${path}[${varStatus.count-1}].funders"--%>
                                                      <%--specifier="${specifier}-${varStatus.count-1}-funders"--%>
                                                      <%--label="Funders"--%>
                                                      <%--personComprisedEntities="${grant.funders}"--%>
                                                      <%--isFirstRequired="true"--%>
                                                      <%--showAddPersonButton="true"--%>
                                                      <%--showAddOrganizationButton="true">--%>
                    <%--</myTags:editPersonComprisedEntity>--%>
                    <%--<myTags:editPersonComprisedEntity path="${path}[${varStatus.count-1}].awardees"--%>
                                                      <%--specifier="${specifier}-${varStatus.count-1}-awardees"--%>
                                                      <%--label="Awardees"--%>
                                                      <%--personComprisedEntities="${grant.awardees}"--%>
                                                      <%--isFirstRequired="false"--%>
                                                      <%--showAddPersonButton="true"--%>
                                                      <%--showAddOrganizationButton="true">--%>
                    <%--</myTags:editPersonComprisedEntity>--%>
                </div>
                <c:set var="grantCount" scope="page" value="${varStatus.count}"/>
            </c:forEach>
            <div class="${specifier}-grant-add-more"></div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-grant" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Grant
                </button>
            </div>
            <div class="${specifier}-grant-add-more"></div>
        </div>
        <c:set var="grantCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>

<div class="${specifier}-copy-grant hide">
    <div class="form-group control-group edit-form-group">
        <label>${label}</label>
        <br>
        <button class="btn btn-danger grant-remove" type="button"><i
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
        <myTags:editRequiredNonZeroLengthString placeholder=" The name of the grant and its funding program."
                                                label="Name"
                                                path="${path}[0].name">
        </myTags:editRequiredNonZeroLengthString>
        <%--<myTags:editPersonComprisedEntity path="${path}[0].funders"--%>
                                          <%--specifier="${specifier}-0-funders"--%>
                                          <%--label="Funders"--%>
                                          <%--isFirstRequired="true"--%>
                                          <%--showAddPersonButton="true"--%>
                                          <%--showAddOrganizationButton="true">--%>
        <%--</myTags:editPersonComprisedEntity>--%>
        <%--<myTags:editPersonComprisedEntity path="${path}[0].awardees"--%>
                                          <%--specifier="${specifier}-0-awardees"--%>
                                          <%--label="Awardees"--%>
                                          <%--isFirstRequired="false"--%>
                                          <%--showAddPersonButton="true"--%>
                                          <%--showAddOrganizationButton="true">--%>
        <%--</myTags:editPersonComprisedEntity>--%>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        var grantCount = ${grantCount};
        //Show/Hide Location
        $("body").on("click", ".${specifier}-add-grant", function (e) {
            e.stopImmediatePropagation();
            var specifier = "${specifier}";
            var path = "${path}";
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var html = $(".${specifier}-copy-grant").html();
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}[' + grantCount + ']').replace(regexSpecifier, '${specifier}-' + grantCount);
            grantCount += 1;


            //$(this).after(html);
            $(".${specifier}-grant-add-more").before(html);
            //$(this).hide();
        });

        $("body").on("click", ".grant-remove", function () {
            $(this).closest(".control-group").remove();
            $(".${specifier}-0-add-grant").show();
        });


    });
</script>