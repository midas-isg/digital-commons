<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="path" required="false"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="false"
              type="java.lang.String" %>
<%@ attribute name="access" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Access" %>

<c:choose>
    <c:when test="${not empty access}">
        <div class="form-group edit-form-group">
            <label>Access</label>

            <spring:bind path="${path}.landingPage">
                <div class="form-group edit-form-group ${status.error ? 'has-error' : ''}">
                    <label>Landing Page</label>
                    <input type="text" class="form-control" value="${access.landingPage}" name="${path}.landingPage"
                           id="${specifier}-landingPage">
                    <form:errors path="${path}.landingPage" class="error-color"/>
                </div>
            </spring:bind>

            <c:choose>
                <c:when test="${not empty access.accessURL}">
                    <button class="btn btn-success ${specifier}-add-accessURL" style="display: none" type="button">
                        <i
                                class="glyphicon glyphicon-plus"></i> Add
                        Access URL
                    </button>
                    <div class="input-group control-group edit-form-group full-width">
                        <label>Access URL</label>

                        <spring:bind path="${path}.accessURL">
                            <div class="input-group edit-form-group ${status.error ? 'has-error' : ''}">
                                <input name="${path}.accessURL" value="${access.accessURL}" type="text" class="form-control"
                                       placeholder="Access URL">
                                <div class="input-group-btn">
                                    <button class="btn btn-danger ${specifier}-accessURL-remove" type="button"><i
                                            class="glyphicon glyphicon-remove"></i>
                                        Remove
                                    </button>
                                </div>
                            </div>
                            <form:errors path="${path}.accessURL" class="error-color"/>
                        </spring:bind>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="form-group">
                        <button class="btn btn-success ${specifier}-add-accessURL" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add
                            Access URL
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group edit-form-group">
            <form:label path="${path}">Access</form:label>
            <spring:bind path="${path}.landingPage">
                <div class="form-group edit-form-group ${status.error ? 'has-error' : ''}">
                    <label>Landing Page</label>
                    <input type="text" class="form-control" name="${path}.landingPage" id="${specifier}-landingPage">
                </div>
                <form:errors path="${path}.landingPage" class="error-color"/>
            </spring:bind>
            <div class="form-group">
                <button class="btn btn-success ${specifier}-add-accessURL" type="button"><i
                        class="glyphicon glyphicon-plus"></i> Add
                    Access URL
                </button>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<div class="${specifier}-copy-accessURL hide">
    <div class="input-group control-group edit-form-group full-width">
        <label>Access URL</label>
        <div class="input-group edit-form-group">
            <input name="${path}.accessURL" type="text" class="form-control" placeholder="Access URL">
            <div class="input-group-btn">
                <button class="btn btn-danger ${specifier}-accessURL-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        //Show/Hide Location
        $("body").on("click", ".${specifier}-add-accessURL", function () {
            var html = $(".${specifier}-copy-accessURL").html();

            $(this).after(html);
            $(this).hide();
            //e.stopImmediatePropagation()
        });
        $("body").on("click", ".${specifier}-accessURL-remove", function () {
            $(this).closest(".control-group").remove();
            $(".${specifier}-add-accessURL").show();
        });

    });
</script>