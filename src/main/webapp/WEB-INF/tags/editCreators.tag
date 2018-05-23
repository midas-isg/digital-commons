<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="creators" required="false"
              type="java.util.ArrayList" %>


<div class="form-group edit-form-group creator-add-more">
    <label>Creator</label>
    <button class="btn btn-success add-creator" type="button"><i class="glyphicon glyphicon-plus"></i> Add Creator</button>

    <div class="form-group edit-form-group">
        <label>First Name</label>
        <input type="text" class="form-control" value="${creators[0].firstName}" name="creators[0].firstName" placeholder="Last Name">
    </div>

    <div class="form-group edit-form-group">
        <label>Last Name</label>
        <input type="text" class="form-control" value="${creators[0].lastName}" name="creators[0].lastName" placeholder="Last Name">
    </div>

    <div class="form-group edit-form-group">
        <label>Email</label>
        <input type="email" class="form-control" value="${creators[0].email}" name="creators[0].email" placeholder="Email">
    </div>
</div>


<div class="copy-creator hide">
    <div class="form-group  control-group edit-form-group">
        <label>Creator</label>
        <button class="btn btn-danger creator-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>

        <div class="form-group edit-form-group">
            <label>First Name</label>
            <input type="text" class="form-control" name="firstName" placeholder="First Name">
        </div>

        <div class="form-group edit-form-group">
            <label>Last Name</label>
            <input type="text" class="form-control" name="lastName" placeholder="Last Name">
        </div>

        <div class="form-group edit-form-group">
            <label>Email</label>
            <input type="email" class="form-control" name="email" placeholder="Email">
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var creatorCount = 1;
        //Add section
        $(".add-creator").click(function () {
//            $("div.copy-creator input").each(function () {
//                $(this).attr('name', 'creators['+ creatorCount + '].' + $(this).attr('name'));
//            });

            var html = $(".copy-creator").html();
            html = html.replace('name="firstName"', 'name="creators['+ creatorCount + '].firstName"').replace('name="lastName"', 'name="creators['+ creatorCount + '].lastName"').replace('name="email"', 'name="creators['+ creatorCount + '].email"');
            creatorCount += 1;

            $(".creator-add-more").after(html);
        });

        //Remove section
        $("body").on("click", ".creator-remove", function () {
            $(this).parents(".control-group").remove();
        });
        
        <c:if test="${not empty creators and fn:length(creators) gt 1}">
        <c:forEach items="${creators}" var="person" varStatus="status">
        <c:if test="${not status.first}">
        var html = $(".copy-creator").html();
        html = html.replace('name="firstName"', 'name="creators[${status.count-1}].firstName" value="${creators[status.count-1].firstName}"').replace('name="lastName"', 'name="creators[${status.count-1}].lastName" value="${creators[status.count-1].lastName}"').replace('name="email"', 'name="creators[${status.count-1}].email" value="${creators[status.count-1].email}"');
        creatorCount += 1;
        $(".creator-add-more").after(html);
        </c:if>
        </c:forEach>
        </c:if>

    });
</script>