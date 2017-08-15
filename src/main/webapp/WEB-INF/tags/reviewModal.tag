<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="id" required="true" type="java.lang.String"%>
<%@ attribute name="modalHeader" required="true" type="java.lang.String"%>
<%@ attribute name="type" required="true" type="java.lang.String"%>
<%@ attribute name="categoryPaths" required="true" type="java.util.Map"%>

<div id="${id}" class="modal fade">
    <div class="modal-dialog" style="max-width:600px;">
        <div class="modal-content">
            <div class="modal-header software-header">
                <h2 class="sub-title-font pull-left color-white">${modalHeader}</h2>
            </div>
            <div class="modal-body">
                <input id="approve-entry-id-${id}" class="hidden">
                <input id="approve-entry-revision-id-${id}" class="hidden">

                <c:if test="${type != 'comments'}">
                    <div class="sub-title-font font-size-16 modal-software-item">
                        <h4 class="inline bold">Title: </h4><br>
                        <span id="approve-entry-title-${id}"></span>
                    </div>
                    <div class="sub-title-font font-size-16 modal-software-item">
                        <h4 class="inline bold">Version: </h4><br>
                        <span id="approve-entry-version-${id}"></span>
                    </div>
                    <div class="sub-title-font font-size-16 modal-software-item">
                        <h4 class="inline bold">Author: </h4><br>
                        <span id="approve-entry-author-${id}"></span>
                    </div>
                    <div class="sub-title-font font-size-16 modal-software-item">
                        <h4 class="inline bold">Data type: </h4><br>
                        <span id="approve-entry-type-${id}"></span>
                    </div>
                </c:if>
                <div class="sub-title-font font-size-16 modal-software-item form-group" id="category-form-group-${id}">
                    <c:choose>
                        <c:when test="${type == 'approve'}">
                            <h4 class="inline bold" id="category-label-${id}">Category*: </h4><br>
                            <select id="category-select-${id}" class="form-control" style="margin-top:2px">
                                <option value="none">None provided</option>
                                <c:forEach items="${categoryPaths}" var="categoryPath">
                                    <option value="${categoryPath.key}">${categoryPath.value}</option>
                                </c:forEach>
                            </select>
                            <div id="category-feedback-${id}" class="error-color" style="margin-top:3px; margin-left:2px; display:none">Please select a category.</div>
                        </c:when>
                        <c:when test="${type == 'reject'}">
                            <h4 class="inline bold" id="category-label-${id}">Category: </h4><br>
                            <span id="category-span-${id}"></span>
                        </c:when>
                    </c:choose>
                    <c:if test="${type == 'reject' || type == 'comments'}">
                        <div class="sub-title-font font-size-16 modal-software-item">
                            <c:if test="${type == 'reject'}">
                                <h4 class="inline bold">Comment(s): </h4><br>
                            </c:if>
                            <div id="reject-comments-${id}"></div>
                            <button type="button" class="btn btn-default" style="margin-top:5px" onclick="addComment('${id}')">Add comment</button>
                        </div>
                    </c:if>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <c:choose>
                    <c:when test="${type == 'approve'}">
                        <button type="button" class="btn btn-success" onclick="approveButton('${id}')">Approve</button>
                    </c:when>
                    <c:when test="${type == 'reject'}">
                        <button type="button" class="btn btn-danger" onclick="rejectButton('${id}')">Reject</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn btn-default" onclick="commentButton('${id}')">Submit</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    $('#${id}').on('hidden.bs.modal', function () {
        hideCategoryErrors();
        $('#category-select-${id}').val('none');
        $("#reject-comments-${id}").html("");
    });
</script>
