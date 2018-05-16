<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>


<div id="pageModal" class="modal fade">
    <div class="modal-dialog" id="software-modal">
        <div class="modal-content">
            <div class="modal-header software-header">
                <h2 class="sub-title-font pull-left color-white" id="software-name"></h2>
            </div>
            <div class="modal-body">
                <ul class="nav nav-tabs" id="modal-nav-tabs" style="display:none">
                    <li class="active"><a href="#modal-html" data-toggle="tab" id="modal-html-link">HTML</a></li>
                    <li><a href="#modal-json" data-toggle="tab" id="modal-json-link">DATS JSON</a></li>
                </ul>

                <div class="tab-content">
                    <div class="tab-pane fade in active" id="modal-html">
                        <myTags:softwareModalItems></myTags:softwareModalItems>
                    </div>

                    <div class="tab-pane fade" id="modal-json">
                        <style>
                            #modal-code-block {
                                max-height:500px;
                                max-width:560px;
                                overflow:scroll;
                                margin-bottom:10px;
                                border: 1px solid #ccc;
                                border-radius:4px
                            }
                        </style>

                        <script>
                            var width = 700;
                            for(var i = 760; i >= 100; i-=5) {
                                document.querySelector('style').textContent +=
                                    "@media screen and (max-width:" + i + "px) { #modal-code-block {max-width:" + width + "px; }}\n"
                                width-=5;
                            }
                        </script>

                        <div class="sub-title-font font-size-16 modal-software-item" style="margin-bottom:3px">
                            <h4 class="inline bold" id="jsonFormat">
                                Metadata format:
                            </h4>
                            <a id="dats-json" href="https://docs.google.com/document/d/1hVcYRleE6-dFfn7qbF9Bv1Ohs1kTF6a8OwWUvoZlDto/edit" class="underline">DATS v2.2</a>
                            <span id="mdc-json">MDC Software Metadata Format</span>
                            <br>
                        </div>

                        <div id="modal-code-block" onmouseenter="$('#modal-download-btns').fadeIn();" onmouseleave="$('#modal-download-btns').fadeOut();">
                            <pre style="border:none; margin:0; overflow:visible; display:inline-block"><code style="white-space:pre; display:inline-block" id="display-json"></code></pre>
                            <div id="modal-download-btns" style="display:none">
                                <button class="btn btn-xs btn-default"
                                        style="top: 48px;right: 70px; position:absolute;"
                                        onclick="copyToClipboard('#display-json')">
                                    <icon class="glyphicon glyphicon glyphicon-copy"></icon>
                                </button>
                                <button class="btn btn-xs btn-default"
                                        style="top: 48px;right: 44px; position:absolute;"
                                        onclick="download($('#software-name').text() + '.json', '#display-json')">
                                    <icon class="glyphicon glyphicon glyphicon-download"></icon>
                                </button>
                                <button class="btn btn-xs btn-default" id="detailed-metadata-view-button"
                                        style="top: 48px;right: 18px; position:absolute;"
                                        >
                                    <icon class="glyphicon glyphicon-new-window"></icon>
                                </button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-default" id="detailed-view-button">Detailed view</button>
                <button id="modal-switch-btn"
                        type="button"
                        class="btn btn-default"
                        onclick="toggleModalView();">
                    Switch to Metadata View
                </button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
