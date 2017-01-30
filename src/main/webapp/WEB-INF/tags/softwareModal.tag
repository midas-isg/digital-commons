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

                <%--<myTags:softwareModalItem id="disease-coverage" title="Disease coverage"></myTags:softwareModalItem>--%>
                <div class="sub-title-font font-size-16 modal-software-item" id="software-disease-coverage-container">
                    <h4 class="inline bold">Disease coverage: </h4><br>
                    <span id="software-disease-coverage"></span>
                </div>

                <div class="sub-title-font font-size-16 modal-software-item" id="software-location-coverage-container">
                    <h4 class="inline bold">Location coverage: </h4><br>
                    <span id="software-location-coverage"></span>
                </div>

                <div class="sub-title-font font-size-16 modal-software-item" id="software-species-included-container">
                    <h4 class="inline bold">Species included: </h4><br>
                    <span id="software-species-included"></span>
                </div>

                <div class="sub-title-font font-size-16 modal-software-item" id="software-control-measures-container">
                    <h4 class="inline bold">Control measures: </h4><br>
                    <span id="software-control-measures"></span>
                </div>

                <div class="sub-title-font font-size-16 modal-software-item" id="software-type-container">
                    <h4 class="inline bold">Type: </h4><br>
                    <span id="software-type"></span>
                </div>

                <div class="sub-title-font font-size-16 modal-software-item" id="software-version-container">
                    <h4 class="inline bold">Source code version: </h4><br>
                    <span id="software-version"></span>
                </div>

                <div class="sub-title-font font-size-16 modal-software-item" id="software-developer-container">
                    <h4 class="inline bold" id="software-developer-tag"></h4><br>
                    <span id="software-developer"></span>
                </div>

                <div class="sub-title-font font-size-16 modal-software-item" id="software-doi-container">
                    <h4 class="inline bold">DOI: </h4><br>
                    <span id="software-doi"></span>
                </div>

                <div class="sub-title-font font-size-16 modal-software-item" id="software-location-container">
                    <h4 class="inline bold">Software location: </h4><br>
                    <a id="software-location" href=""></a>
                </div>

                <div class="sub-title-font font-size-16 modal-software-item" id="software-source-code-container">
                    <h4 class="inline bold">Source code location: </h4><br>
                    <a id="software-source-code" href=""></a>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
