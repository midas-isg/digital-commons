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

                <c:choose>
                    <c:when test="${not empty creator.name}">
                        <div class="form-group edit-form-group">
                            <label>Name</label>
                            <input type="text" class="form-control" value="${creator.name}"
                                   name="creators[${status.count-1}].name"
                                   placeholder="Organization Name">
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="form-group edit-form-group">
                            <label>Name</label>
                            <input type="text" class="form-control"
                                   name="creators[${status.count-1}].name"
                                   placeholder="Organization Name">
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${not empty creator.abbreviation}">
                        <div class="form-group control-group edit-form-group">
                            <label>Abbreviation</label>
                            <button class="btn btn-success add-creators-abbreviation" style="display: none" id="creators-${status.count-1}-add-abbreviation" type="button"><i
                                    class="glyphicon glyphicon-plus"></i> Add Abbreviation
                            </button>
                            <div class="input-group control-group">
                                <div class="input-group-btn">
                                    <input type="text" class="form-control" value="${creator.abbreviation}"
                                           name="creators[${status.count-1}].abbreviation"
                                           placeholder="Abbreviation">
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
                <myTags:editPlace place="${creator.location}" path="creators[${status.count-1}].location" specifier="creators-${status.count-1}-location" label="Location"></myTags:editPlace>

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

                <myTags:editPlace place="${creators[0].location}" path="creators[0].location" specifier="creators-0-location" label="Location"></myTags:editPlace>

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

        <myTags:editPlace place="${creators[0].location}" path="creators[0].location" specifier="creators-0-location" label="Location"></myTags:editPlace>
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


<script type="text/javascript">
    $(document).ready(function () {

        //Remove section
        $("body").on("click", ".creators-abbreviation-remove", function () {
            $(this).closest(".control-group").remove();
            var creatorsIndex = $(this.id).selector;
            creatorsIndex = creatorsIndex.replace("creators-","").replace("-abbreviation-remove","");
            $("#creators-" + creatorsIndex + "-add-abbreviation").show();
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

        //Remove section
        $("body").on("click", ".creator-remove", function () {
            $(this).parents(".control-group").remove();
        });
    });
</script>