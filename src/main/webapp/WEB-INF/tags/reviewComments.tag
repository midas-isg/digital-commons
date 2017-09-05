<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="comments" required="true"
              type="java.util.List" %>
<%@ attribute name="entryTitle" required="true"
              type="java.lang.String" %>

<div class="col-md-12 container">
    <h3 class="title-font" id="subtitle">
        Review and add comments
    </h3>
    <button class="btn btn-success" onclick="showCommentModal('${entryId}', '${revisionId}')">Add comment
    </button>
    <br><br>
    <div class="col-md-6">
        <myTags:commentsTable comments="${comments}"/>
    </div>
    <div class="col-md-6">
        <div class="panel panel-default" id="html-view">
            <div class="panel-heading clearfix background-nav"><button class="btn btn-default pull-right" onclick="switchView()">Switch to Metadata View</button> <h4 class="leaf">Summary for ${entryTitle}</h4></div>

            <div class="panel-body">

                <myTags:softwareModalItems></myTags:softwareModalItems>
                <c:set var="splitEntryType" value="${fn:split(entry.entryType, '.')}"></c:set>
                <script>
                    toggleModalItems(JSON.parse("${entry.entryJsonString}")["entry"], "${splitEntryType[fn:length(splitEntryType) - 1]}");
                </script>
            </div>
        </div>

        <div class="panel panel-default" id="meta-view" style="display: none">
            <div class="panel-heading clearfix background-nav"><button class="btn btn-default pull-right" onclick="switchView()">Switch to HTML View</button> <h4 class="leaf">Summary for ${entryTitle}</h4></div>

            <div class="panel-body">
                <c:choose>
                    <c:when test="${entry.xmlString} != null">
                        <pre style="border:none; margin:0;"><code style="white-space:pre; display:inline-block">${entry.xmlString}</code></pre>
                    </c:when>
                    <c:otherwise>
                        <pre style="border:none; margin:0;"><code style="white-space:pre; display:inline-block">${entry.unescapedEntryJsonString}</code></pre>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

</div>

<script>
    function switchView() {
        $( "#html-view" ).toggle();
        $( "#meta-view" ).toggle();
    }

    function commentButton(id) {
        var endId = "-" + id;
        var entryId = $("#approve-entry-id" + endId).val();
        var revisionId = $("#approve-entry-revision-id" + endId).val();

        var comments = [];
        $.each($("#reject-comments-" + id).children(), function (index, child) {
            var comment = $(child).find(">:first-child").val();
            if (comment != null && comment != '') {
                comments.push(comment);
            }
        });

        var params = {
            'entryId': entryId,
            'revisionId': revisionId,
            'comments': comments
        };

        $.post("${pageContext.request.contextPath}/add/comment", params, function (data) {
            if (data == "success") {
                window.location.reload();
            } else {
                alert("There was an issue commenting on this entry. Please try again.");
            }
        }).fail(function () {
            alert("There was an issue commenting on this entry. Please try again.");
        });
    }

    function hideCategoryErrors() {
        $('#category-form-group').removeClass("has-error");
        $('#category-label').removeClass("error-color");
        $('#category-feedback').hide();
    }

    function deleteComment(commentId) {
        if (commentId != "undefined") {
            var params = {'commentId': commentId};
            $.post("${pageContext.request.contextPath}/add/comment/delete", params, function (data) {
                if (data == "success") {
                    window.location.reload();
                } else {
                    alert("There was an issue deleting this comment. Please try again.");
                }
            }).fail(function () {
                alert("There was an issue deleting this comment. Please try again.");
            });
        }
    }

    function showCommentModal(entryId, revisionId) {
        var baseId = "#approve-entry-";
        var endId = "-commentModal";
        $(baseId + "id" + endId).val(entryId);
        $(baseId + "revision-id" + endId).val(revisionId);
        addComment('commentModal');
        $('#commentModal').modal('show');

    }

    function addComment(id) {
        var value = "";

        var toAppend = "<div>" +
            "<input class='form-control reject-input' value=\"" + value + "\"/>" +
            "</button>" +
            "</div>";

        $('#reject-comments-commentModal').append(toAppend);
    }
</script>

<myTags:reviewModal id="commentModal"
                    modalHeader="Comments"
                    type="comments"
                    categoryPaths="${categoryPaths}"/>