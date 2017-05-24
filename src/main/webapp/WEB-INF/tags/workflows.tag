<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="col-sm-12">
    <h3 class="title-font">Workflows on Olympus</h3>
    <div class="font-size-16 standard-font">
                        <span>
                            These scripts and all the programs they invoke are staged on the Olympus cluster.
                            Follow the instructions below to execute a workflow on your Olympus account.
                            Alternatively, you can copy and edit the script before running on Olympus.
                        </span>
    </div>
    <div>
        <h3 class="title-font">Obtaining a Synthetic Population in Synthia Format</h3>
        <div class="font-size-16 standard-font">
                            <span class="col-md-12 col-lg-12 no-padding">
                                The LSDTM script requests the name of the synthetic population ('Synthia' or 'SPEW') and the location
                                (US, state, or county code). It creates a runnable instance of FRED for that location.
                            </span>

            <div class="col-md-12 col-lg-12 no-padding">
                <div style="margin-top:10px">
                    <label>Olympus username:</label><br>
                    <input style="max-width:280px" id="olympus-username" onkeyup="checkLocationSelect()" class="form-control"/>
                </div>
                <div style="margin-top:10px">
                    <label>Select location:</label><br>
                    <select class="form-control" id="location-select" style="max-width:280px" onchange="checkLocationSelect()"><option value=""></option></select>
                </div>
                <div style="margin-top:10px" id="synthpop-radios">
                    <label disabled="disabled">Select available synthetic population(s) for location:</label><br>
                    <label disabled="disabled" class="radio-inline"><input type="radio" name="synthpop" value="spew" onclick="drawDiagram()" disabled>SPEW</label>
                    <label disabled="disabled" class="radio-inline"><input type="radio" name="synthpop" value="synthia" onclick="drawDiagram()" disabled>Synthia</label>
                </div>
                <div style="margin-top:10px; margin-bottom:10px" id="dtm-radios">
                    <label>Select disease transmission model:</label><br>
                    <label class="radio-inline"><input type="radio" name="dtm" value="fred" onclick="drawDiagram()" checked>FRED</label>
                </div>

                <label id="workflow-diagram-label"></label>
                <img src="${pageContext.request.contextPath}/resources/img/workflow_mockup.jpg" style="width:100%">
                <!--<div id="workflow-diagram" style="overflow:scroll"></div>-->
            </div>

            <div id="lsdtm-script-container" class="col-md-12 col-lg-12 no-padding" style="display:none; margin-top:10px;">
                <label style="margin-right:5px; display:inline">LSDTM script</label>

                <%--<span>[</span>
                <small>
                    <icon class="glyphicon glyphicon-minus" onclick="toggleElementById('#lsdtm-script-code-block', this)">
                    </icon>
                </small>
                <span>]</span>--%>

                <br>
                <div id="lsdtm-script-code-block" style="overflow:scroll; width:100%; margin-bottom:10px; max-height:400px; border: 1px solid #ccc; border-radius:4px"
                     onmouseenter="$('#lsdtm-script-btns').fadeIn();"
                     onmouseleave="$('#lsdtm-script-btns').fadeOut();">
                    <myTags:lsdtmScript></myTags:lsdtmScript>
                    <div id="lsdtm-script-btns" style="display:none">
                        <button class="btn btn-xs btn-default"
                                style="top: 27px;right: 30px; position:absolute;"
                                onclick="copyToClipboard('#lsdtm-script')">
                            <icon class="glyphicon glyphicon glyphicon-copy"></icon>
                        </button>
                        <button class="btn btn-xs btn-default"
                                style="top: 27px;right: 4px; position:absolute;"
                                onclick="download('lsdtm.sh', '#lsdtm-script')">
                            <icon class="glyphicon glyphicon glyphicon-download"></icon>
                        </button>
                    </div>
                </div>

                <myTags:workflowCodeBlock buttonId="submit-lsdtm-script-btns"
                                          scriptId="submit-lsdtm-script"
                                          scriptFilename="submit-lsdtm.txt"
                                          label="Instructions to submit the LSDTM script to the job scheduler">
                </myTags:workflowCodeBlock>
                <myTags:workflowCodeBlock buttonId="example-submit-lsdtm-script-btns"
                                          scriptId="example-submit-lsdtm-script"
                                          scriptFilename="example-submit-lsdtm.txt"
                                          label="Example usage">
                </myTags:workflowCodeBlock>

                <myTags:workflowCodeBlock buttonId="status-lsdtm-script-btns"
                                          scriptId="status-lsdtm-script"
                                          scriptFilename="status-lsdtm.txt"
                                          label="Instructions to check the status of your job">
                </myTags:workflowCodeBlock>
                <myTags:workflowCodeBlock buttonId="example-status-lsdtm-script-btns"
                                          scriptId="example-status-lsdtm-script"
                                          scriptFilename="example-status-lsdtm.txt"
                                          label="Example usage">
                </myTags:workflowCodeBlock>

                <myTags:workflowCodeBlock buttonId="view-output-lsdtm-script-btns"
                                          scriptId="view-output-lsdtm-script"
                                          scriptFilename="view-output-lsdtm.txt"
                                          label="Instructions to view the output of the LSDTM script">
                </myTags:workflowCodeBlock>
                <myTags:workflowCodeBlock buttonId="example-view-output-lsdtm-script-btns"
                                          scriptId="example-view-output-lsdtm-script"
                                          scriptFilename="example-view-output-lsdtm.txt"
                                          label="Example usage">
                </myTags:workflowCodeBlock>

                <myTags:workflowCodeBlock buttonId="view-error-lsdtm-script-btns"
                                          scriptId="view-error-lsdtm-script"
                                          scriptFilename="view-error-lsdtm.txt"
                                          label="Instructions to view the error log of the LSDTM script">
                </myTags:workflowCodeBlock>
                <myTags:workflowCodeBlock buttonId="example-view-error-lsdtm-script-btns"
                                          scriptId="example-view-error-lsdtm-script"
                                          scriptFilename="example-view-error-lsdtm.txt"
                                          label="Example usage">
                </myTags:workflowCodeBlock>

                <myTags:workflowCodeBlock buttonId="view-stdout-lsdtm-script-btns"
                                          scriptId="view-stdout-lsdtm-script"
                                          scriptFilename="view-stdout-lsdtm.txt"
                                          label="Instructions to view the standard output log of the LSDTM script">
                </myTags:workflowCodeBlock>
                <myTags:workflowCodeBlock buttonId="example-view-stdout-lsdtm-script-btns"
                                          scriptId="example-view-stdout-lsdtm-script"
                                          scriptFilename="example-view-stdout-lsdtm.txt"
                                          label="Example usage">
                </myTags:workflowCodeBlock>

                <myTags:workflowCodeBlock buttonId="view-fred-out-lsdtm-script-btns"
                                          scriptId="view-fred-out-lsdtm-script"
                                          scriptFilename="view-fred-out-lsdtm.txt"
                                          label="Instructions to view the output generated by FRED">
                </myTags:workflowCodeBlock>
                <myTags:workflowCodeBlock buttonId="example-view-fred-out-lsdtm-script-btns"
                                          scriptId="example-view-fred-out-lsdtm-script"
                                          scriptFilename="example-view-fred-out-lsdtm.txt"
                                          label="Example usage">
                </myTags:workflowCodeBlock>
            </div>
        </div>
    </div>
</div>