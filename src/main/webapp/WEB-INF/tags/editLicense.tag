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
<%@ attribute name="licenses" required="false"
              type="java.util.List" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>


<c:choose>
    <c:when test="${not function:isObjectEmpty(licenses)}">
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <c:forEach items="${licenses}" var="license" varStatus="varStatus">
                <c:if test="${varStatus.first}">
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add-license" type="button"><i
                                class="fa fa-plus-circle"></i> Add
                                ${label}
                        </button>
                    </div>
                </c:if>
                <c:if test="${not function:isObjectEmpty(license)}">
                    <div class="form-group control-group edit-form-group">
                        <label>${label}</label>
                        <br>
                        <button class="btn btn-danger license-remove" type="button"><i
                                class="glyphicon glyphicon-remove"></i>
                            Remove
                        </button>
                        <myTags:editIdentifierUnbounded label="Identifier" path="${path}[${varStatus.count-1}].identifier"
                                                        identifier="${license.identifier}"
                                                        specifier="${specifier}-${varStatus.count-1}-identifier">
                        </myTags:editIdentifierUnbounded>
                        <myTags:editRequiredNonZeroLengthString path="${path}[${varStatus.count-1}].name"
                                                                placeholder=" Name of License"
                                                                string="${license.name}"
                                                                label="Name">
                        </myTags:editRequiredNonZeroLengthString>
                        <myTags:editNonZeroLengthString label="Version" placeholder=" Version"
                                                        specifier="${specifier}-${varStatus.count-1}-version"
                                                        string="${license.version}"
                                                        path="${path}[${varStatus.count-1}].version">
                        </myTags:editNonZeroLengthString>
                        <myTags:editPersonComprisedEntity path="${path}[${varStatus.count-1}].creators"
                                                          specifier="${specifier}-${varStatus.count-1}-creators"
                                                          label="Creator"
                                                          personComprisedEntities="${license.creators}"
                                                          isFirstRequired="false"
                                                          showAddPersonButton="true"
                                                          showAddOrganizationButton="true">
                        </myTags:editPersonComprisedEntity>
                    </div>
                    <c:set var="licenseCount" scope="page" value="${varStatus.count}"/>
                </c:if>

            </c:forEach>
            <div class="${specifier}-license-add-more"></div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>${label}</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-license" type="button"><i
                        class="fa fa-plus-circle"></i> Add
                    License
                </button>
            </div>
            <div class="${specifier}-license-add-more"></div>
        </div>
        <c:set var="licenseCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>

<div class="${specifier}-copy-license hide">
    <div class="form-group control-group edit-form-group">
        <label>${label}</label>
        <br>
        <button class="btn btn-danger license-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <myTags:editIdentifierUnbounded label="Identifier" path="${path}[0].identifier"
                                        specifier="${specifier}-0-identifier">
        </myTags:editIdentifierUnbounded>
        <myTags:editRequiredNonZeroLengthString path="${path}[0].name"
                                                placeholder=" Name of License"
                                                label="Name">
        </myTags:editRequiredNonZeroLengthString>
        <myTags:editNonZeroLengthString label="Version" placeholder=" Version"
                                        specifier="${specifier}-0-version"
                                        path="${path}[0].version">
        </myTags:editNonZeroLengthString>
        <myTags:editPersonComprisedEntity path="${path}[0].creators"
                                          specifier="${specifier}-0-creators"
                                          label="Creator"
                                          isFirstRequired="false"
                                          showAddPersonButton="true"
                                          showAddOrganizationButton="true">
        </myTags:editPersonComprisedEntity>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        var licenseCount = ${licenseCount};
        //Show/Hide Location
        $("body").on("click", ".${specifier}-add-license", function (e) {
            e.stopImmediatePropagation();
            var specifier = "${specifier}";
            var path = "${path}";
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            var html = $(".${specifier}-copy-license").html();
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}[' + licenseCount + ']').replace(regexSpecifier, '${specifier}-' + licenseCount);
            licenseCount += 1;


            //$(this).after(html);
            $(".${specifier}-license-add-more").before(html);
            //$(this).hide();
        });

        $("body").on("click", ".license-remove", function () {
            clearAndHideEditControlGroup(this);
            $(".${specifier}-0-add-license").show();
        });


    });
</script>