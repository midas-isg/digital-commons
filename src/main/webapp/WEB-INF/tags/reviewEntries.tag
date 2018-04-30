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
<%@ attribute name="approvedEntries" required="true"
              type="java.util.List"%>
<%@ attribute name="categoryPaths" required="true"
              type="java.util.Map"%>
<%@ attribute name="adminType" required="true"
              type="java.lang.String"%>

<script>
    var entryComments = {};
    var softwareXml = {};

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

    function showReviewEntryModal(htmlId, entryId, revisionId, category, elem, status) {
        var tableRow = $(elem).parent().parent();
        var tableData = tableRow.children();

        var elemInfo = [];
        for(var i = 1; i < 5; i++) {
            elemInfo.push($(tableData[i]).text().trim());
        }

        var baseId = "#approve-entry-";
        var endId = "-" + htmlId;
        $(baseId + "id" + endId).val(entryId);
        $(baseId + "revision-id" + endId).val(revisionId);
        $(baseId + "status" + endId).val(status);
        $(baseId + "title" + endId).text(elemInfo[0]);
        $(baseId + "version" + endId).text(elemInfo[1]);
        $(baseId + "author" + endId).text(elemInfo[2]);
        $(baseId + "type" + endId).text(elemInfo[3]);

        if(htmlId == "approveModal") {
            if(category !== null && category !== '') {
                $('#category-select' + endId).val(category);
            }

            if(status == "approved") {
                $("#approve-btn" + endId).text("Make Public");
                $("#approve-modal-header" + endId).text("Make Submission Public");
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


    function evalPublishModal() {

        $.ajax({
            type : "GET",
            contentType : "application/json; charset=utf-8",
            url : "${pageContext.request.contextPath}/api/cache-tree-info-json",
            dataType : 'json',
            data: {},
            cache: false,
            timeout : 500000,
            beforeSend: function() {
                $(".ajax-loader").html("<img src='../img/spinner.gif'>");
                },
            complete: function(){
                $(".ajax-loader").html("");
            },
            success : function(data) {
                console.log(data);
                showPublishModal(data);
            },
            error : function(xhr, textStatus, errorThrown) {
                console.log(xhr.responseText);
                console.log(textStatus);
                console.log(errorThrown);
                showPublishModal(null);
            }
        });

        $('#statusModal').modal({backdrop: 'static', keyboard: false});
        $('#statusModalTitle').text("Publish");
        $('#statusModalBody').text("Publishing updates...");
        $('#btnStatusModalClose').prop('disabled', true);
        //$('#statusModalFooter').hide();
        $('#statusModal').modal('show');
    }


    function showPublishModal(publishData) {
        //console.log(publishData.valueOf("result"));
        $('#btnStatusModalClose').prop('disabled', false);
        //$('#statusModalFooter').show();
        if(publishData.result === "success") {
            $('#statusModalBody').text("All updates have been published.");
        }
        else {
            $('#statusModalBody').text("There was an error attempting to publish updates!");
        }
    }


    function approveButton(id) {
        var endId = "-" + id;
        var entryId = $("#approve-entry-id" + endId).val();
        var revisionId = $("#approve-entry-revision-id" + endId).val();
        var status = $("#approve-entry-status" + endId).val();
        var categoryId = $("#category-select" + endId).val();
        var params = getEntryParams(entryId, revisionId, categoryId);
        if(categoryId === null || categoryId === '' || categoryId === 'none') {
            $('#category-form-group' + endId).addClass("has-error");
            $('#category-label' + endId).addClass("error-color");
            $('#category-feedback' + endId).show();
        } else {
            var alertMsg;
            if(status === 'approved') {
                alertMsg = "There was an issue making this entry public. Please try again.";
                $.post("${pageContext.request.contextPath}/add/make-public", params ,function(data){
                    if(data === "success") {
                        window.location.reload();
                    } else {
                        alert(alertMsg);
                    }
                }).fail(function() {
                    alert(alertMsg);
                });
            } else {
                alertMsg = "There was an issue approving this entry. Please try again.";
                $.post("${pageContext.request.contextPath}/add/approve", params ,function(data){
                    if(data === "success") {
                        window.location.reload();
                    } else {
                        alert(alertMsg);
                    }
                }).fail(function() {
                    alert(alertMsg);
                });
            }
        }
    }

    function rejectButton(id) {
        var endId = "-" + id;
        var entryId = $("#approve-entry-id" + endId).val();
        var revisionId = $("#approve-entry-revision-id" + endId).val();

        var comments = [];
        $.each($("#reject-comments-" + id).children(), function(index, child) {
            var comment = $(child).find(">:first-child").val();
            if(comment != null && comment != '') {
                comments.push(comment);
            }
        });

        var params = getEntryParams(entryId, revisionId, null, comments);
        $.post("${pageContext.request.contextPath}/add/reject", params ,function(data){
            if(data == "success") {
                window.location.reload();
            } else {
                alert("There was an issue rejecting this entry. Please try again.");
            }
        }).fail(function() {
            alert("There was an issue rejecting this entry. Please try again.");
        });
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
<myTags:statusModal/>
<myTags:reviewModal id="approveModal"
                    modalHeader="Approve Submission"
                    type="approve"
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
        <li><a href="#approved-entries">Approved</a></li>
        <c:choose>
            <c:when test="${adminType == 'ISG_ADMIN'}">
                    <button type="button" class="btn btn-default btn-publish" name="btnPublish"
                            onclick="evalPublishModal();">Publish</button>
            </c:when>
        </c:choose>
    </ul>

    <div class="tab-content">
        <div id="all" class="tab-pane fade in active">
            <myTags:approveTable title="All" entries="${entries}" adminType="${adminType}"></myTags:approveTable>
        </div>
        <div id="dataset" class="tab-pane fade">
            <myTags:approveTable title="Dataset" entries="${datasetEntries}" adminType="${adminType}"></myTags:approveTable>
        </div>
        <div id="data-standard" class="tab-pane fade">
            <myTags:approveTable title="Data Standard" entries="${dataStandardEntries}" adminType="${adminType}"></myTags:approveTable>
        </div>
        <div id="software" class="tab-pane fade">
            <myTags:approveTable title="Software" entries="${softwareEntries}" adminType="${adminType}"></myTags:approveTable>
        </div>
        <div id="approved-entries" class="tab-pane fade">
            <myTags:approveTable title="Approved" entries="${approvedEntries}" adminType="${adminType}"></myTags:approveTable>
        </div>
    </div>
</div>