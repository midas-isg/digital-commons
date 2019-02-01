<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="comments" required="true"
              type="java.util.List" %>
<%@ attribute name="entryTitle" required="true"
              type="java.lang.String" %>

<h3 class="title-font" id="subtitle">
    Review and add comments
</h3>
<button class="btn btn-success" id="new-comment-button" onclick="addComment()">Add comment</button>
<br><br>
<div class="row">
    <div class="col-md-5">
        <myTags:commentsTable comments="${comments}"/>
    </div>
    <div class="col-md-7">
        <myTags:detailedViewTag type="${entry.entryTypeBaseName}" revId="${revId}"
                                entryJson="${entry.unescapedEntryJsonString}" entryID="${entry.id.entryId}"
                                id="${entry.id.entryId}" entryView="${entry}" description="${entry.entry.description}"></myTags:detailedViewTag>

    </div>

</div>
<script>

    function submitComment() {
        var comments = [];
        comments.push($("#new-comment").val());
        var entryId = "${entry.id.entryId}";
        var revisionId = "${entry.id.revisionId}";

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

    function addComment() {
        $("#new-comment-button").prop("disabled", true);
        var toAppend = "<div class='input-group mb-3'>" +
            "<textarea class='form-control' id='new-comment'rows='4' style='resize:none'/>" +
                "<div class='input-group-append'>" +
                    "<button class='btn btn-success' onclick='submitComment()' type='button'>Submit<br> Comment</button>" +
                "</div>" +
        "</div>";

        $('#comments-table').after(toAppend);
    }
</script>

<myTags:reviewModal id="commentModal"
                    modalHeader="Comments"
                    type="comments"
                    categoryPaths="${categoryPaths}"/>