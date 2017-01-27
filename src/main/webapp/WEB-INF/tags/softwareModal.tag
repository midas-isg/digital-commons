<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>


<div id="pageModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header software-header">
                <h2 class="sub-title-font pull-left color-white">PSC Fred v2.0.1</h2>
                    <span class="hidden-xs">
                        <img src="${pageContext.request.contextPath}/resources/img/psc_logo.png" id="logo-img" class="pull-right">
                    </span>
            </div>
            <div class="modal-body">
                <h3 class="sub-title-font" id="software-name"></h3>
                <div class="sub-title-font font-size-16" id="software-type-container">
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
