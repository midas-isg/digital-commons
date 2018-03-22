<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<div class="modal fade" tabindex="-1" role="dialog" id="statusModal">
    <div class="modal-dialog" id="software-modal">
        <div class="modal-content">
            <div class="modal-header software-header">
                <h2 class="sub-title-font pull-left color-white" id="statusModalTitle"></h2>
            </div>
            <div class="modal-body status-modal-body">
                <div class="sub-title-font font-size-16 modal-software-item">
                    <span id="statusModalBody"></span>
                        <div class="ajax-loader"></div>
                </div>
            </div>
            <div class="modal-footer" id="statusModalFooter">
                <button type="button" class="btn btn-default" id="btnStatusModalClose" data-dismiss="modal">Close</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->