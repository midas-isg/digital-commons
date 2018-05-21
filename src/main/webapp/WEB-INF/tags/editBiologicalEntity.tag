<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--<%@ attribute name="types" required="false"--%>
<%--type="java.util.ArrayList" %>--%>
<%@ attribute name="name" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>

<div class="form-group edit-form-group ${specifier}-biological-entity-add-more">
    <label>${name}</label>
    <br>
    <button class="btn btn-success ${specifier}-add-biological-entity" type="button"><i class="glyphicon glyphicon-plus"></i> Add ${name}
    </button>
</div>


<div class="copy-biological-entity hide">
    <div class="form-group control-group edit-form-group">
        <label></label>
        <br>
        <button class="btn btn-danger biological-entity-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>
        <br><br>
        <div class="form-group edit-form-group">
            <label>Name</label>
            <input name="isAbout[0].name" type="text" class="form-control" placeholder="Name">
        </div>
        <div class="form-group">
            <myTags:editDescription path="isAbout[0].description" specifier="isAbout-0"></myTags:editDescription>
        </div>

        <div class="form-group">
            <myTags:editIdentifier path="isAbout[0].identifier" specifier="isAbout-0"
                                   name="Identifier"></myTags:editIdentifier>
        </div>

        <div class="form-group">
            <myTags:editIdentifier path="isAbout[0].alternateIdentifiers" unbounded="${true}"
                                   specifier="isAbout-alternate-0" name="Alternate Identifier"></myTags:editIdentifier>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var isAboutCount = 0;
        //Add section
        $(".${specifier}-add-biological-entity").click(function () {
            var html = $(".copy-biological-entity").html();
            html = html.replace('biological-entity-remove', '${specifier}-biological-entity-remove').replace("<label></label>", "<label>${name}</label>");
            $(".${specifier}-biological-entity-add-more").after(html);
            isAboutCount += 1;
        });

        //Remove section
        $("body").on("click", ".${specifier}-biological-entity-remove", function () {
            $(this).parents(".control-group").remove();
        });

    });
</script>