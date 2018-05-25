<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="study" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Study" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>

<c:choose>
    <c:when test="${not empty study and not empty study.name}">
        <div class="form-group edit-form-group">
            <label>Produced By</label>
            <div class="input-group control-group ${specifier}-study-add-more" style="display: none">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-study" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Produced By
                    </button>
                </div>
            </div>
            <div class="form-group control-group">
                <div class="form-group-btn">
                    <button class="btn btn-danger ${specifier}-study-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
                    </button>

                    <div class="form-group edit-form-group">
                        <label>Name</label>
                        <input type="text" class="form-control" name="${path}.name" value="${study.name}"
                               placeholder="Name">
                    </div>

                    <c:choose>
                        <c:when test="${not empty study.location}">
                            <div>
                                <button class="btn btn-success add-location" id="location" type="button" style="display: none"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    Location
                                </button>
                            </div>
                            <div class="form-group control-group edit-form-group">
                                <label>Location</label>
                                <br>
                                <button class="btn btn-danger location-remove" type="button"><i
                                        class="glyphicon glyphicon-remove"></i>
                                    Remove
                                </button>
                                <div class="form-group edit-form-group">
                                    <label id="location-label">Postal Address</label>
                                    <input type="text" class="form-control" name="postalAddress" value="${study.location.postalAddress}"
                                           placeholder="Postal Address">
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div>
                                <button class="btn btn-success add-location" id="location" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    Location
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <br>

                    <c:choose>
                        <c:when test="${not empty study.startDate}">
                            <div>
                                <button class="btn btn-success add-start-date" id="startDate" type="button" style="display:none;"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    Start Date
                                </button>
                            </div>
                            <div class="form-group control-group edit-form-group">
                                <label>Start Date</label>
                                <br>
                                <button class="btn btn-danger start-date-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                                    Remove
                                </button>
                                <myTags:editDates date="${study.startDate}" path="${path}.startDate" specifier="${specifier}-startDate"></myTags:editDates>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div>
                                <button class="btn btn-success add-start-date" id="startDate" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    Start Date
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <br>

                    <c:choose>
                        <c:when test="${not empty study.endDate}">
                            <div>
                                <button class="btn btn-success add-end-date" id="endDate" type="button" style="display: none"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    End Date
                                </button>
                            </div>
                            <div class="form-group control-group edit-form-group">
                                <label>End Date</label>
                                <br>
                                <button class="btn btn-danger end-date-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                                    Remove
                                </button>
                                <myTags:editDates date="${study.endDate}" path="${path}.endDate" specifier="${specifier}-endDate"></myTags:editDates>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div>
                                <button class="btn btn-success add-end-date" id="endDate" type="button"><i
                                        class="glyphicon glyphicon-plus"></i> Add
                                    End Date
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <label>Produced By</label>
            <div class="input-group control-group ${specifier}-study-add-more">
                <div class="input-group-btn">
                    <button class="btn btn-success ${specifier}-add-study" type="button"><i
                            class="glyphicon glyphicon-plus"></i> Add
                        Produced By
                    </button>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>


<div class="copy-location hide">
    <div class="form-group control-group edit-form-group">
        <label>Location</label>
        <br>
        <button class="btn btn-danger location-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <div class="form-group edit-form-group">
            <label id="location-label">Postal Address</label>
            <input type="text" class="form-control" name="postalAddress" placeholder="Postal Address">
        </div>
    </div>
</div>

<div class="copy-start-date hide">
    <div class="form-group control-group edit-form-group">
        <label>Start Date</label>
        <br>
        <button class="btn btn-danger start-date-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <myTags:editDates path="${path}.startDate" specifier="study-startDate"></myTags:editDates>
    </div>
</div>

<div class="copy-end-date hide">
    <div class="form-group control-group edit-form-group">
        <label>End Date</label>
        <br>
        <button class="btn btn-danger end-date-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <myTags:editDates path="${path}.endDate" specifier="study-endDate"></myTags:editDates>
    </div>
</div>

<div class="copy-study hide">
    <div class="form-group control-group">
        <button class="btn btn-danger study-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>
        <div class="form-group edit-form-group">
            <label>Name</label>
            <input type="text" class="form-control" name="${path}.name" placeholder="Name">
        </div>

        <div>
            <button class="btn btn-success add-location" id="location" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Location
            </button>
        </div>
        <br>

        <div>
            <button class="btn btn-success add-start-date" id="startDate" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                Start Date
            </button>
        </div>
        <br>

        <div>
            <button class="btn btn-success add-end-date" id="endDate" type="button"><i
                    class="glyphicon glyphicon-plus"></i> Add
                End Date
            </button>
        </div>

    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        $("body").on("click", ".${specifier}-add-study", function (e) {
            e.stopImmediatePropagation();

            var html = $(".copy-study").html();
            html = html.replace('name=""', 'name="${path}"').replace('study-remove', '${specifier}-study-remove');

            //Add section
            $(".${specifier}-study-add-more").after(html);
            $(".${specifier}-study-add-more").hide();
        });
        //Remove section
        $("body").on("click", ".${specifier}-study-remove", function (e) {
            e.stopImmediatePropagation();

            $(this).parents(".control-group").remove();
            $(".${specifier}-study-add-more").show();
        });

        //Show/Hide Location
        $("body").on("click", ".add-location", function () {
            var html = $(".copy-location").html();
            html = html.replace('name="postalAddress"', 'name="${path}.location.postalAddress"');

            $(this).after(html);
            $(this).hide();
        });
        $("body").on("click", ".location-remove", function () {
            $(this).parent(".control-group").remove();
            $(".add-location").show();
        });

        //Show/Hide Start Date
        $("body").on("click", ".add-start-date", function () {
            var html = $(".copy-start-date").html();
            //html = html.replace('name="postalAddress"', 'name="${path}.location.postalAddress"');

            $(this).after(html);
            $(this).hide();

        });
        $("body").on("click", ".start-date-remove", function () {
            $(this).parent(".control-group").remove();
            $(".add-start-date").show();
        });

        //Show/Hide End Date
        $("body").on("click", ".add-end-date", function () {
            var html = $(".copy-end-date").html();
            //html = html.replace('name="postalAddress"', 'name="${path}.location.postalAddress"');

            $(this).after(html);
            $(this).hide();

        });
        $("body").on("click", ".end-date-remove", function () {
            $(this).parent(".control-group").remove();
            $(".add-end-date").show();
        });

    });

</script>