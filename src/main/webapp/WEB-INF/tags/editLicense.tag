<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="licenses" required="false"
              type="java.util.ArrayList" %>


<c:choose>
    <c:when test="${not empty licenses}">
        <c:forEach items="${licenses}" var="license" varStatus="varStatus">
            <c:if test="${varStatus.first}">
                <div class="form-group edit-form-group">
                <label>License</label>
                <div class="form-group">
                    <button class="btn btn-success ${specifier}-add-license" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        License
                    </button>
                </div>
            </c:if>
            <div class="form-group control-group edit-form-group">
                <label>License</label>
                <br>
                <button class="btn btn-danger ${specifier}-${varStatus.count-1}-license-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>


                <div class="form-group">
                    <myTags:editIdentifier label="Identifier" path="${path}[${varStatus.count-1}]"
                                           identifierName="${license.identifier}"
                                           identifierSource="${license.identifierSource}"
                                           specifier="${specifier}-${varStatus.count-1}"></myTags:editIdentifier>
                </div>

                <c:choose>
                    <c:when test="${not empty license.version}">
                        <div class="form-group edit-form-group">
                            <label>Version</label>
                            <div class="input-group-btn">
                                <button class="btn btn-success ${specifier}-${varStatus.count-1}-add-version"
                                        style="display: none" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    Version
                                </button>
                                <div class="input-group control-group edit-form-group full-width">
                                    <input name="${path}[${varStatus.count-1}].version" value="${license.version}"
                                           type="text"
                                           class="form-control" placeholder="Version">
                                    <div class="input-group-btn">
                                        <button class="btn btn-danger ${specifier}-${varStatus.count-1}-version-remove"
                                                type="button"><i
                                                class="glyphicon glyphicon-remove"></i>
                                            Remove
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="form-group edit-form-group">
                            <label>Version</label>
                            <div class="input-group-btn">
                                <button class="btn btn-success ${specifier}-${varStatus.count-1}-add-version"
                                        type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    Version
                                </button>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <c:set var="licenseCount" scope="page" value="${varStatus.count}"/>

        </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>License</label>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-license" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    License
                </button>
            </div>
        </div>

        <c:set var="licenseCount" scope="page" value="0"/>

    </c:otherwise>
</c:choose>

<div class="${specifier}-0-copy-version hide">
    <div class="form-group edit-form-group">
        <myTags:editIdentifier label="Identifier" path="${path}[0]" specifier="${specifier}-0"></myTags:editIdentifier>
    </div>
    <div class="input-group-btn">
        <button class="btn btn-success ${specifier}-0-add-version" type="button"><i
                class="glyphicon glyphicon-plus"></i> Add
            Version
        </button>
    </div>
    <div class="input-group control-group edit-form-group full-width">
        <div class="input-group edit-form-group full-width">
            <label>Version</label>
            <input name="${path}[0].version" type="text" class="form-control" placeholder="Version">
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-0-version-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
        </div>
    </div>
</div>

<div class="${specifier}-copy-license hide">
    <div class="form-group control-group edit-form-group">
        <label>License</label>
        <br>
        <button class="btn btn-danger ${specifier}-0-license-remove" type="button"><i
                class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <br><br>
        <div class="form-group">
            <myTags:editIdentifier label="Identifier" path="${path}[0]"
                                   specifier="${specifier}-0"></myTags:editIdentifier>
        </div>
        <div class="form-group edit-form-group">
            <label>Version</label>
            <div class="input-group-btn">
                <button class="btn btn-success ${specifier}-0-add-version" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Version
                </button>
            </div>
        </div>

        <div class="${specifier}-0-copy-version hide">
            <div class="input-group control-group edit-form-group full-width">
                <input name="${path}[0].version" type="text" class="form-control" placeholder="Version">
                <div class="input-group-btn">
                    <button class="btn btn-danger ${specifier}-0-version-remove" type="button"><i
                            class="glyphicon glyphicon-remove"></i>
                        Remove
                    </button>
                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function () {
                    //Show/Hide Location
                    $("body").on("click", ".${specifier}-0-add-version", function (e) {
                        var html = $(".${specifier}-0-copy-version").html();

                        $(this).after(html);
                        $(this).hide();
                        e.stopImmediatePropagation()
                    });
                    $("body").on("click", ".${specifier}-0-version-remove", function () {
                        //console.log($(this).closest('.control-group'));
                        $(this).closest(".control-group").remove();
                        //$(this).parent(".control-group").remove();
                        $(".${specifier}-0-add-version").show();
                    });

                });
            </script>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                $("body").on("click", ".${specifier}-0-license-remove", function () {
                    $(this).parent(".control-group").remove();
                    $(".${specifier}-0-add-license").show();
                });
            });
        </script>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        //Show/Hide Version
        $("body").on("click", ".${specifier}-0-add-version", function (e) {
            var html = $(".${specifier}-0-copy-version").html();

            $(this).after(html);
            $(this).hide();
            e.stopImmediatePropagation()
        });
        $("body").on("click", ".${specifier}-0-version-remove", function () {
            $(this).parent(".control-group").remove();
            console.log($(this).parents());
            $(".${specifier}-0-add-version").show();
        });


        var licenseCount = ${licenseCount};
        //Show/Hide Location
        $("body").on("click", ".${specifier}-add-license", function (e) {
            var specifier = "${specifier}";
            var path = "${path}";
            //console.log(path);
            var regexEscapeOpenBracket = new RegExp('\\[', "g");
            var regexEscapeClosedBracket = new RegExp('\\]', "g");
            path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
            //console.log(path);
            var html = $(".${specifier}-copy-license").html();
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-0', "g");
            html = html.replace(regexPath, '${path}[' + licenseCount + ']').replace(regexSpecifier, '${specifier}-' + licenseCount + '-');
            licenseCount += 1;


            //console.log(html);
            $(this).after(html);
            //$(this).hide();
            e.stopImmediatePropagation()
        });

    });
</script>