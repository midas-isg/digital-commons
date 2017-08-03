<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="categoryPaths" required="true"
              type="java.util.Map"%>

<div id="approveModal" class="modal fade">
    <div class="modal-dialog" id="software-modal">
        <div class="modal-content">
            <div class="modal-header software-header">
                <h2 class="sub-title-font pull-left color-white">Approve Submission</h2>
            </div>
            <div class="modal-body">
                <input id="approve-entry-id" class="hidden">

                <div class="sub-title-font font-size-16 modal-software-item">
                    <h4 class="inline bold">Title: </h4><br>
                    <span id="approve-entry-title"></span>
                </div>
                <div class="sub-title-font font-size-16 modal-software-item">
                    <h4 class="inline bold">Version: </h4><br>
                    <span id="approve-entry-version"></span>
                </div>
                <div class="sub-title-font font-size-16 modal-software-item">
                    <h4 class="inline bold">Author: </h4><br>
                    <span id="approve-entry-author"></span>
                </div>
                <div class="sub-title-font font-size-16 modal-software-item">
                    <h4 class="inline bold">Data type: </h4><br>
                    <span id="approve-entry-type"></span>
                </div>
                <div class="sub-title-font font-size-16 modal-software-item form-group" id="category-form-group">
                    <h4 class="inline bold" id="category-label">Category*: </h4><br>
                    <select id="category-select" class="form-control" style="margin-top:2px">
                        <option value="none">None provided</option>
                        <c:forEach items="${categoryPaths}" var="categoryPath">
                            <option value="${categoryPath.key}">${categoryPath.value}</option>
                        </c:forEach>
                    </select>
                    <div id="category-feedback" class="error-color" style="margin-top:3px; margin-left:2px; display:none">Please select a category.</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-success" onclick="approveButton()">Approve</button>
            </div>
        </div>
    </div>
</div>

<script>
    function hideCategoryErrors() {
        $('#category-form-group').removeClass("has-error");
        $('#category-label').removeClass("error-color");
        $('#category-feedback').hide();
    }

    $('#category-select').change(function() {
        hideCategoryErrors();
    });

    $('#approveModal').on('hidden.bs.modal', function () {
        hideCategoryErrors();
        $('#category-select').val('none');
    });

    function getEntryParams(entryId, categoryId) {
        var auth = getParameterByName("auth");
        var params = {
            'auth': auth,
            'entryId': entryId,
            'categoryId': categoryId
        };
        return params;
    }

    function showApproveEntryModal(entryId, categoryId, elem) {
        var tableRow = $(elem).parent().parent();
        var tableData = tableRow.children();

        var elemInfo = [];
        for(var i = 0; i < 4; i++) {
            elemInfo.push($(tableData[i]).text().trim());
        }

        var baseId = "#approve-entry-";
        $(baseId + "id").val(entryId);
        $(baseId + "title").text(elemInfo[0]);
        $(baseId + "version").text(elemInfo[1]);
        $(baseId + "author").text(elemInfo[2]);
        $(baseId + "type").text(elemInfo[3]);

        if(categoryId !== null && categoryId !== '') {
            $('#category-select').val(categoryId);
        }

        $('#approveModal').modal('show');
    }


    function approveButton() {
         var entryId = $("#approve-entry-id").val();
         var categoryId = $("#category-select").val();
         var params = getEntryParams(entryId, categoryId);
         if(categoryId === null || categoryId === '' || categoryId === 'none') {
             $('#category-form-group').addClass("has-error");
             $('#category-label').addClass("error-color");
             $('#category-feedback').show();
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
</script>
