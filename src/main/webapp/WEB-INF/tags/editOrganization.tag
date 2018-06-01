<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="creators" required="false"
              type="java.util.ArrayList" %>


<c:choose>
    <c:when test="${not empty creators}">
        <spring:bind path="creators[0]">
            <div class=" ${status.error ? 'has-error' : ''}">
            <c:forEach items="${creators}" varStatus="status" var="creator">
                <c:choose>
                    <c:when test="${status.first}">
                        <div class="form-group edit-form-group creator-add-more">
                        <label>Creator</label>
                        <button class="btn btn-success add-creator" id="creators-${status.count-1}-add-creators" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add Creator
                        </button>
                    </c:when>
                    <c:otherwise>

                        <div class="form-group control-group edit-form-group">
                        <label>Creator</label>
                        <button class="btn btn-danger creator-remove" type="button"><i
                                class="glyphicon glyphicon-remove"></i> Remove
                        </button>
                    </c:otherwise>
                </c:choose>

                <div class="form-group edit-form-group">
                    <label>Name</label>
                    <input type="text" class="form-control" value="${creator.name}"
                           name="creators[${status.count-1}].name"
                           placeholder="Organization Name">
                </div>

                <c:choose>
                    <c:when test="${not empty creator.abbreviation}">
                        <div class="form-group control-group edit-form-group">
                            <label>Abbreviation</label>
                            <button class="btn btn-success add-creators-abbreviation" style="display: none" id="creators-${status.count-1}-add-abbreviation" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add Abbreviation
                            </button>
                            <div class="input-group control-group">
                                <input type="text" class="form-control" value="${creator.abbreviation}"
                                       name="creators[${status.count-1}].abbreviation"
                                       placeholder="Abbreviation">
                                <div class="input-group-btn">
                                    <button class="btn btn-danger creators-abbreviation-remove" id="creators-${status.count-1}-abbreviation-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                                        Remove
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="form-group edit-form-group">
                            <label>Abbreviation</label>
                            <button class="btn btn-success add-creators-abbreviation" id="creators-${status.count-1}-add-abbreviation" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add Abbreviation
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${not empty creator.location}">
                        <div class="form-group control-group edit-form-group">
                            <label>Location</label>
                            <button class="btn btn-success add-creators-location" style="display: none" id="creators-${status.count-1}-add-location" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add Location
                            </button>
                            <div class="form group control-group">
                                <div class="input-group-btn">
                                    <button class="btn btn-danger creators-location-remove" id="creators-${status.count-1}-location-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                                        Remove
                                    </button>
                                </div>
                                <div class="form-group edit-form-group">
                                    <label>Name</label>
                                    <input type="text" class="form-control" value="${creator.location.name}"
                                           name="creators[${status.count-1}].location.name"
                                           placeholder="Name">
                                </div>
                                <c:choose>
                                    <c:when test="${not empty creator.location.description}">
                                        <div class="form-group control-group edit-form-group">
                                            <label>Description</label>
                                            <button class="btn btn-success add-creators-location-description" style="display: none" id="creators-${status.count-1}-add-location-description" type="button"><i
                                                    class="glyphicon glyphicon-plus"></i> Add Description
                                            </button>
                                            <div class="input-group control-group">
                                                <input type="text" class="form-control" value="${creator.location.description}"
                                                       name="creators[${status.count-1}].location.description"
                                                       placeholder="Description">
                                                <div class="input-group-btn">
                                                    <button class="btn btn-danger creators-location-description-remove" id="creators-${status.count-1}-location-description-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                                                        Remove
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="form-group edit-form-group">
                                            <label>Description</label>
                                            <button class="btn btn-success add-creators-location-description" id="creators-${status.count-1}-add-location-description" type="button"><i
                                                    class="glyphicon glyphicon-plus"></i> Add Description
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${not empty creator.location.postalAddress}">
                                        <div class="form-group control-group edit-form-group">
                                            <label>Postal Address</label>
                                            <button class="btn btn-success add-creators-location-postalAddress" style="display: none" id="creators-${status.count-1}-add-location-postalAddress" type="button"><i
                                                    class="glyphicon glyphicon-plus"></i> Add Postal Address
                                            </button>
                                            <div class="input-group control-group">
                                                <input type="text" class="form-control" value="${creator.location.postalAddress}"
                                                       name="creators[${status.count-1}].location.postalAddress"
                                                       placeholder="Postal Address">
                                                <div class="input-group-btn">
                                                    <button class="btn btn-danger creators-location-postalAddress-remove" id="creators-${status.count-1}-location-postalAddress-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                                                        Remove
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="form-group edit-form-group">
                                            <label>Postal Address</label>
                                            <button class="btn btn-success add-creators-location-postalAddress" id="creators-${status.count-1}-add-location-postalAddress" type="button"><i
                                                    class="glyphicon glyphicon-plus"></i> Add Postal Address
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="form-group edit-form-group">
                            <label>Location</label>
                            <button class="btn btn-success add-creators-location" id="creators-${status.count-1}-add-location" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add Location
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:if test="${status.first}">

                    <form:errors path="creators[0]" class="error-color"/>
                </c:if>

                </div>
            </c:forEach>
            </div>
        </spring:bind>
    </c:when>
    <c:otherwise>
        <spring:bind path="creators[0]">
            <div class="form-group edit-form-group creator-add-more ${status.error ? 'has-error' : ''}">
                <label>Creator</label>
                <button class="btn btn-success add-creator" id="creators-0-add-creators" type="button"><i class="glyphicon glyphicon-plus"></i> Add
                    Creator
                </button>

                <div class="form-group edit-form-group">
                    <label>Name</label>
                    <input type="text" class="form-control"
                           name="creators[0].name"
                           placeholder="Organization Name">
                </div>

                <div class="form-group edit-form-group">
                    <label>Abbreviation</label>
                    <button class="btn btn-success add-creators-abbreviation" id="creators-0-add-abbreviation" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add Abbreviation
                    </button>
                </div>

                <div class="form-group edit-form-group">
                    <label>Location</label>
                    <button class="btn btn-success add-creators-location" id="creators-0-add-location" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add Location
                    </button>
                </div>

                <form:errors path="creators[0]" class="error-color"/>
            </div>
        </spring:bind>
    </c:otherwise>
</c:choose>


<div class="copy-creator hide">
    <div class="form-group  control-group edit-form-group">
        <label>Creator</label>
        <button class="btn btn-danger creator-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>

        <div class="form-group edit-form-group">
            <label>Name</label>
            <input type="text" class="form-control"
                   name="creators[0].name"
                   placeholder="Organization Name">
        </div>

        <div class="form-group edit-form-group">
            <label>Abbreviation</label>
            <button class="btn btn-success add-creators-abbreviation" id="creators-0-add-abbreviation" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add Abbreviation
            </button>
        </div>

        <div class="form-group edit-form-group">
            <label>Location</label>
            <button class="btn btn-success add-creators-location" id="creators-0-add-location" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add Location
            </button>
        </div>
    </div>
</div>

<div class="copy-creator-abbreviation hide">
    <div class="input-group control-group">
        <input type="text" class="form-control"
               name="creators[0].abbreviation"
               placeholder="Abbreviation">
        <div class="input-group-btn">
            <button class="btn btn-danger creators-abbreviation-remove" id="creators-0-abbreviation-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
    </div>
</div>

<div class="copy-creators-location hide">
    <div class="form-group control-group edit-form-group">
        <label>Location</label>
        <div class="input-group-btn">
            <button class="btn btn-danger creators-location-remove" id="creators-0-location-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
        <div class="form-group edit-form-group">
            <label>Name</label>
            <input type="text" class="form-control"
                   name="creators[0].location.name"
                   placeholder="Name">
        </div>
        <div class="form-group edit-form-group">
            <label>Description</label>
            <button class="btn btn-success add-creators-location-description" id="creators-0-add-location-description" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add Description
            </button>
        </div>
        <div class="form-group edit-form-group">
            <label>Postal Address</label>
            <button class="btn btn-success add-creators-location-postalAddress" id="creators-0-add-location-postalAddress" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add Postal Address
            </button>
        </div>
    </div>
</div>

<div class="copy-creator-location-description hide">
    <div class="input-group control-group">
        <input type="text" class="form-control"
               name="creators[0].location.description"
               placeholder="Description">
        <div class="input-group-btn">
            <button class="btn btn-danger creators-location-description-remove" id="creators-0-location-description-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
    </div>
</div>

<div class="copy-creator-location-postalAddress hide">
    <div class="input-group control-group">
        <input type="text" class="form-control"
               name="creators[0].location.postalAddress"
               placeholder="Postal Address">
        <div class="input-group-btn">
            <button class="btn btn-danger creators-location-postalAddress-remove" id="creators-0-location-postalAddress-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                Remove
            </button>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {

        //Remove section
        $("body").on("click", ".creators-abbreviation-remove", function () {
            $(this).closest(".control-group").remove();
            var creatorsIndex = $(this.id).selector;
            creatorsIndex = creatorsIndex.replace("creators-","").replace("-abbreviation-remove","");
            $("#creators-" + creatorsIndex + "-add-abbreviation").show();
        });
        $("body").on("click", ".creators-location-remove", function () {
            $(this).closest(".control-group").remove();
            var creatorsIndex = $(this.id).selector;
            creatorsIndex = creatorsIndex.replace("creators-","").replace("-location-remove","");
            $("#creators-" + creatorsIndex + "-add-location").show();
        });
        $("body").on("click", ".creators-location-description-remove", function () {
            $(this).closest(".control-group").remove();
            var creatorsIndex = $(this.id).selector;
            console.log(creatorsIndex);
            creatorsIndex = creatorsIndex.replace("creators-","").replace("-location-description-remove","");
            console.log(creatorsIndex);
            $("#creators-" + creatorsIndex + "-add-location-description").show();
        });
        $("body").on("click", ".creators-location-postalAddress-remove", function () {
            $(this).closest(".control-group").remove();
            var creatorsIndex = $(this.id).selector;
            creatorsIndex = creatorsIndex.replace("creators-","").replace("-location-postalAddress-remove","");
            $("#creators-" + creatorsIndex + "-add-location-postalAddress").show();
        });


        var newCreatorsCount = 1;
        //Add section
        $("body").on("click",".add-creator", function () {
            var creatorsIndex = $(this.id).selector;
            creatorsIndex = creatorsIndex.replace("creators-","").replace("-add-creators","");
            var creatorsCount = newCreatorsCount + parseInt(creatorsIndex);
            var html = $(".copy-creator").html();
            var regexPath = new RegExp("creators" + '\\[0\\]', "g");
            var regexSpecifier = new RegExp("creators" + '\\-0', "g");
            html = html.replace(regexPath, 'creators['+ creatorsCount + ']').replace(regexSpecifier,'creators-' + creatorsCount);
            newCreatorsCount += 1;
            $(".creator-add-more").after(html);
        });

        $("body").on("click",".add-creators-location", function () {
            var creatorsIndex = $(this.id).selector;
            creatorsIndex = creatorsIndex.replace("creators-","").replace("-add-location","");
            var html = $(".copy-creators-location").html();
            var regexPath = new RegExp("creators" + '\\[0\\]', "g");
            var regexSpecifier = new RegExp("creators" + '\\-0', "g");
            html = html.replace(regexPath, 'creators['+ creatorsIndex + ']').replace(regexSpecifier,'creators-' + creatorsIndex);
            $(this).after(html);
            $(this).hide();
        });

        $("body").on("click",".add-creators-abbreviation", function () {
            var creatorsIndex = $(this.id).selector;
            creatorsIndex = creatorsIndex.replace("creators-","").replace("-add-abbreviation","");
            var html = $(".copy-creator-abbreviation").html();
            var regexPath = new RegExp("creators" + '\\[0\\]', "g");
            var regexSpecifier = new RegExp("creators" + '\\-0', "g");
            html = html.replace(regexPath, 'creators['+ creatorsIndex + ']').replace(regexSpecifier,'creators-' + creatorsIndex);
            $(this).after(html);
            $(this).hide();
        });

        $("body").on("click",".add-creators-location-description", function () {
            var creatorsIndex = $(this.id).selector;
            creatorsIndex = creatorsIndex.replace("creators-","").replace("-add-location-description","");
            var html = $(".copy-creator-location-description").html();
            var regexPath = new RegExp("creators" + '\\[0\\]', "g");
            var regexSpecifier = new RegExp("creators" + '\\-0', "g");
            html = html.replace(regexPath, 'creators['+ creatorsIndex + ']').replace(regexSpecifier,'creators-' + creatorsIndex);
            $(this).after(html);
            $(this).hide();
        });

        $("body").on("click",".add-creators-location-postalAddress", function () {
            var creatorsIndex = $(this.id).selector;
            creatorsIndex = creatorsIndex.replace("creators-","").replace("-add-location-postalAddress","");
            var html = $(".copy-creator-location-postalAddress").html();
            var regexPath = new RegExp("creators" + '\\[0\\]', "g");
            var regexSpecifier = new RegExp("creators" + '\\-0', "g");
            html = html.replace(regexPath, 'creators['+ creatorsIndex + ']').replace(regexSpecifier,'creators-' + creatorsIndex);
            $(this).after(html);
            $(this).hide();
        });

        //Remove section
        $("body").on("click", ".creator-remove", function () {
            $(this).parents(".control-group").remove();
        });
    });
</script>