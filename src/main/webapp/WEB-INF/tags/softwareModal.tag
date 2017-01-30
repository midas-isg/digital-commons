<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>


<div id="pageModal" class="modal fade">
    <div class="modal-dialog" id="software-modal">
        <div class="modal-content">
            <div class="modal-header software-header">
                <h2 class="sub-title-font pull-left color-white" id="software-name"></h2>
                    <%--<span class="hidden-xs">
                        <img src="${pageContext.request.contextPath}/resources/img/psc_logo.png" id="logo-img" class="pull-right">
                    </span>--%>
            </div>
            <div class="modal-body">

                <myTags:softwareModalItem id="disease-coverage" title="Disease coverage"></myTags:softwareModalItem>

                <myTags:softwareModalItem id="location-coverage" title="Location coverage"></myTags:softwareModalItem>

                <myTags:softwareModalItem id="species-included" title="Species included"></myTags:softwareModalItem>

                <myTags:softwareModalItem id="control-measures" title="Control measures"></myTags:softwareModalItem>

                <myTags:softwareModalItem id="type" title="Type"></myTags:softwareModalItem>

                <myTags:softwareModalItem id="version" title="Source code version"></myTags:softwareModalItem>

                <myTags:softwareModalItem id="developer" title=""></myTags:softwareModalItem>

                <myTags:softwareModalItem id="doi" title="DOI"></myTags:softwareModalItem>

                <myTags:softwareModalItem id="location" title="Software location"></myTags:softwareModalItem>

                <myTags:softwareModalItem id="source-code" title="Source code location"></myTags:softwareModalItem>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
