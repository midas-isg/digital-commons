<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="categoryPaths" required="false"
              type="java.util.Map" %>
<%@ attribute name="selectedID" required="false"
              type="java.lang.Integer" %>

<div class="form-group row edit-form-group <c:if
        test="${ not empty flowRequestContext.messageContext.getMessagesBySource('category')}">has-error</c:if>">
    <div class="my-2 col-sm-2">
        <label class="item-label">Category</label>
    </div>

    <div class="col-sm-10">
        <select class="selectpicker" data-live-search="true"
                title="Please select a category ..." name="category" id="categoryValue">
            <c:forEach items="${categoryPaths}" var="categoryPath">
                <c:choose>
                    <c:when test="${categoryPath.key==selectedID}">
                        <option selected value="${categoryPath.key}">${categoryPath.value}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${categoryPath.key}">${categoryPath.value}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
    </div>
    <c:if test="${ not empty flowRequestContext.messageContext.getMessagesBySource('category')}">
        <c:forEach items="${flowRequestContext.messageContext.getMessagesBySource('category')}" var="message">
            <span class="error-color error offset-2">${message.text}</span>
        </c:forEach>
    </c:if>
</div>

<script>
    $(document).ready(function () {
        //The select is initially hidden, we make it visible when it has the selectpicker components added to it
        $('#categoryValue').removeClass('d-none');

        var mySelect = $('#categoryValue').selectpicker({
            width: '100%',
        });

        // Enables mobile scrolling
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
            mySelect.selectpicker('mobile');
        }
    });
</script>
