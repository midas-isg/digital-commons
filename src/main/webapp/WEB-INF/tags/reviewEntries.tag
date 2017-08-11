<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="entries" required="true"
              type="java.util.List"%>
<%@ attribute name="datasetEntries" required="true"
              type="java.util.List"%>
<%@ attribute name="dataStandardEntries" required="true"
              type="java.util.List"%>
<%@ attribute name="softwareEntries" required="true"
              type="java.util.List"%>
<%@ attribute name="categoryPaths" required="true"
              type="java.util.Map"%>

<script>
    function getEntryParams(entryId, revisionId, categoryId, comments) {
        var auth = getParameterByName("auth");
        var params = {
            'auth': auth,
            'entryId': entryId,
            'revisionId': revisionId,
            'categoryId': categoryId,
            'comments': comments
        };
        return params;
    }

    function getParameterByName(name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }

    function hideCategoryErrors() {
        $('#category-form-group').removeClass("has-error");
        $('#category-label').removeClass("error-color");
        $('#category-feedback').hide();
    }

    $('#category-select').change(function() {
        hideCategoryErrors();
    });

    function showReviewEntryModal(htmlId, entryId, revisionId, category, elem) {
        var tableRow = $(elem).parent().parent();
        var tableData = tableRow.children();

        var elemInfo = [];
        for(var i = 0; i < 4; i++) {
            elemInfo.push($(tableData[i]).text().trim());
        }

        var baseId = "#approve-entry-";
        var endId = "-" + htmlId;
        $(baseId + "id" + endId).val(entryId);
        $(baseId + "revision-id" + endId).val(revisionId);
        $(baseId + "title" + endId).text(elemInfo[0]);
        $(baseId + "version" + endId).text(elemInfo[1]);
        $(baseId + "author" + endId).text(elemInfo[2]);
        $(baseId + "type" + endId).text(elemInfo[3]);

        if(htmlId == "approveModal") {
            if(category !== null && category !== '') {
                $('#category-select' + endId).val(category);
            }
        } else if(htmlId == "rejectModal") {
            if(category !== null && category !== '') {
                $('#category-span' + endId).text(category);
            } else {
                $('#category-span' + endId).text("None");
            }
        }

        $('#' + htmlId).modal('show');
    }


    function approveButton(id) {
        var endId = "-" + id;
        var entryId = $("#approve-entry-id" + endId).val();
        var revisionId = $("#approve-entry-revision-id" + endId).val();
        var categoryId = $("#category-select" + endId).val();
        var params = getEntryParams(entryId, revisionId, categoryId);
        if(categoryId === null || categoryId === '' || categoryId === 'none') {
            $('#category-form-group' + endId).addClass("has-error");
            $('#category-label' + endId).addClass("error-color");
            $('#category-feedback' + endId).show();
        } else {
            $.post("${pageContext.request.contextPath}/approve", params ,function(data){
                if(data === "success") {
                    window.location.reload();
                } else {
                    alert("There was an issue approving this entry. Please try again.");
                }
            }).fail(function() {
                alert("There was an issue approving this entry. Please try again.");
            });
        }
    }

    function rejectButton(id) {
        var endId = "-" + id;
        var entryId = $("#approve-entry-id" + endId).val();
        var revisionId = $("#approve-entry-revision-id" + endId).val();

        var comments = [];
        $.each($("#reject-comments").children(), function(index, child) {
            var comment = $(child).find(">:first-child").val();
            if(comment != null && comment != '') {
                comments.push(comment);
            }
        });

        var params = getEntryParams(entryId, revisionId, null, comments);
        $.post("${pageContext.request.contextPath}/reject", params ,function(data){
            if(data == "success") {
                window.location.reload();
            } else {
                alert("There was an issue rejecting this entry. Please try again.");
            }
        }).fail(function() {
            alert("There was an issue rejecting this entry. Please try again.");
        });
    }

    function addComment() {
        var toAppend = "<div>" +
            "<input class='form-control reject-input'/>" +
            "<button class='btn btn-sm btn-danger reject-input-btn' onclick='$(this).parent().remove()'>" +
            "<icon class='glyphicon glyphicon-trash'></icon>" +
            "</button>" +
            "<div>";

        $('#reject-comments').append(toAppend);
    }
</script>

<style>
    .reject-input {
        margin-bottom:5px;
        width:80%;
        display:inline-block;
    }

    .reject-input-btn {
        margin-left:10px;
        display:inline-block;
    }
</style>
<myTags:softwareModal/>
<myTags:viewModal/>
<myTags:reviewModal id="approveModal"
                    modalHeader="Approve Submission"
                    type="approve"
                    categoryPaths="${categoryPaths}"/>
<myTags:reviewModal id="commentModal"
                    modalHeader="Comments"
                    type="comments"
                    categoryPaths="${categoryPaths}"/>
<myTags:reviewModal id="rejectModal"
                    modalHeader="Reject Submission"
                    type="reject"
                    categoryPaths="${categoryPaths}"/>
<div class="col-md-12 container">
    <h3 class="title-font" id="subtitle">
        Review Submissions
    </h3>
    <ul class="nav nav-tabs">
        <li class="active"><a href="#all">All</a></li>
        <li><a href="#dataset">Dataset</a></li>
        <li><a href="#data-standard">Data Standard</a></li>
        <li><a href="#software">Software</a></li>
    </ul>

    <div class="tab-content">
        <div id="all" class="tab-pane fade in active">
            <myTags:approveTable title="All" entries="${entries}"></myTags:approveTable>
        </div>
        <div id="dataset" class="tab-pane fade">
            <myTags:approveTable title="Dataset" entries="${datasetEntries}"></myTags:approveTable>
        </div>
        <div id="data-standard" class="tab-pane fade">
            <myTags:approveTable title="Data Standard" entries="${dataStandardEntries}"></myTags:approveTable>
        </div>
        <div id="software" class="tab-pane fade">
            <myTags:approveTable title="Software" entries="${softwareEntries}"></myTags:approveTable>
        </div>
    </div>
</div>