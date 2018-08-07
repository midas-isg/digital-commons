<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="date" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Date" %>


<div class="form-group">
    <c:choose>
        <c:when test="${not function:isObjectEmpty(date)}">
            <div>
                <button class="btn btn-success ${specifier}-add" type="button" style="display:none;"><i
                        class="fa fa-plus-circle"></i> Add
                    ${label}
                </button>
            </div>
            <div class="form-group control-group edit-form-group">
                <label>${label}</label>
                <br>
                <button class="btn btn-danger ${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
                <myTags:editDates date="${date}"
                                  path="${path}"
                                  specifier="${specifier}">
                </myTags:editDates>
            </div>
        </c:when>
        <c:otherwise>
            <div>
                <button class="btn btn-success ${specifier}-add" type="button"><i
                        class="fa fa-plus-circle"></i> Add
                    ${label}
                </button>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<div class="${specifier}-copy hide">
    <div class="form-group control-group edit-form-group">
        <label>${label}</label>
        <br>
        <button class="btn btn-danger ${specifier}-remove" type="button"><i class="glyphicon glyphicon-remove"></i>
            Remove
        </button>
        <myTags:editDates path="${path}"
                          specifier="${specifier}">
        </myTags:editDates>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        //Show/Hide Start Date
        $("body").on("click", ".${specifier}-add", function (e) {
            e.stopImmediatePropagation();
            var html = $(".${specifier}-copy").html();

            $(this).after(html);
            $(this).hide();

        });
        $("body").on("click", ".${specifier}-remove", function () {
            clearAndHideEditControlGroup(this);
            $(".${specifier}-add").show();
        });

    });

</script>

