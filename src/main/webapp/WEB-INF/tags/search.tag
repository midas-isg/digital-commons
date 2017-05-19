<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="col-md-12">
    <h3 class="title-font" id="subtitle">
        Search
    </h3>

    <iframe class="frame" src="http://mdcsearchdev.onbc.io/#/" scrolling="no" allowfullscreen id="searchFrame"></iframe>

    <%--<style>--%>
        <%--#constraints-container [class*="col-"] {--%>
            <%--background-clip: padding-box;--%>
            <%--border: 10px solid transparent;--%>
        <%--}--%>

        <%--#constraints-container select {--%>
            <%--width:100%;--%>
        <%--}--%>

        <%--#constraints-container input {--%>
            <%--width:100%;--%>
        <%--}--%>
    <%--</style>--%>

    <%--<div class="col-sm-12 col-md-12 col-lg-12" style="border: 1px solid #ccc; border-radius:4px;" id="constraints-container">--%>
        <%--<div style="margin-bottom:10px">--%>
            <%--<h4 class="sub-title-font" style="font-size:18px">Query Builder</h4>--%>
            <%--<button class="btn btn-default" onclick="addConstraint();">Add constraint</button>--%>
        <%--</div>--%>

        <%--<div class="col-sm-12 col-md-12 col-lg-12 no-padding" id="new-constraint-1" style="display:none">--%>

            <%--<div style="margin-top:0px; border: 1px solid #ccc; border-radius:4px; padding:10px;">--%>
                <%--<h4 style="margin-top:0px; font-size:16px;" class="constraint-header">Constraint #1</h4>--%>
                <%--<div>--%>
                    <%--<div class="form-inline" style="margin-bottom:4px">--%>
                        <%--<label class="control-label" for="category-select" style="margin-right:5px">Find </label>--%>
                        <%--<select class="form-control"--%>
                                <%--id="category-select"--%>
                                <%--aria-describedby="category-select-feedback">--%>
                            <%--<option value=""></option>--%>
                            <%--<option value="software">Software</option>--%>
                        <%--</select>--%>
                    <%--</div>--%>

                    <%--<div class="form-inline" style="margin-bottom:4px">--%>
                        <%--<label class="control-label" for="field-select" style="margin-right:5px">Field </label>--%>
                        <%--<select class="form-control"--%>
                                <%--id="field-select"--%>
                                <%--aria-describedby="field-select-feedback">--%>
                            <%--<option value=""></option>--%>
                            <%--<option value="pathogenCoverage">Software - Disease Transmission Models - Pathogen coverage</option>--%>
                            <%--<option value="locationCoverage">Software - Disease Transmission Models - Location coverage</option>--%>
                            <%--<option value="hostSpeciesIncluded">Software - Disease Transmission Models - Host species included</option>--%>
                            <%--<option value="controlMeasures">Software - Disease Transmission Models - Control measures</option>--%>
                        <%--</select>--%>
                    <%--</div>--%>

                    <%--<div class="form-inline" style="margin-bottom:4px">--%>
                        <%--<label class="control-label" for="field-value-input" style="margin-right:5px">Field value equals</label>--%>
                        <%--<input class="form-control"--%>
                                <%--id="field-value-input"--%>
                                <%--aria-describedby="field-value-input-feedback"/>--%>
                    <%--</div>--%>

                    <%--<div class="form-inline" style="margin-bottom:4px">--%>
                        <%--<label class="control-label" for="field-value-category-input" style="margin-right:5px">Field value is of category</label>--%>
                        <%--<input class="form-control"--%>
                               <%--id="field-value-category-input"--%>
                               <%--aria-describedby="field-value-input-feedback"/>--%>
                    <%--</div>--%>

                    <%--<div style="margin-top:10px; height:34px">--%>
                        <%--<button class="btn btn-danger delete-constraint pull-right" style="right:0" onclick="deleteConstraint(this)">Delete</button>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>

        <%--<div class="col-sm-12 col-md-12 col-lg-12" id="constraint-operator-1-2" style="display:none">--%>
            <%--<select class="form-control"--%>
                    <%--id="operator-select"--%>
                    <%--aria-describedby="operator-select-feedback">--%>
                <%--<option>AND</option>--%>
                <%--<option>OR</option>--%>
            <%--</select>--%>
        <%--</div>--%>
    <%--</div>--%>

    <%--&lt;%&ndash;<div class="col-sm-12 col-md-12 col-lg-12" style="border: 1px solid #ccc; border-radius:4px;">--%>
        <%--<div class="col-sm-6 col-md-6 col-lg-6 no-padding">--%>
            <%--<h4 class="sub-title-font">Query Builder</h4>--%>
            <%--<button id="add-constraint-btn" class="btn btn-default" style="margin-bottom:10px" onclick="$('#query-builder-constraint-container').show(); $(this).hide();">Add constraint to query</button>--%>

            <%--<div id="query-builder-constraint-container" style="display:none">--%>
                <%--<div id="new-constraint" style="margin-top:12px; border: 1px solid #ccc; border-radius:4px; padding:10px; margin-bottom:12px;">--%>
                    <%--<div>--%>
                        <%--<label>New Constraint:</label><br>--%>
                        <%--<label class="radio-inline"--%>
                               <%--onclick="$('#field-container').hide(); $('#category-container').show(); changeQueryCategory(); removeErrors();">--%>
                            <%--<input type="radio" name="constraintType" value="category" checked="checked">By Category--%>
                        <%--</label>--%>

                        <%--<label class="radio-inline"--%>
                               <%--onclick="$('#field-container').show(); $('#category-container').hide(); changeQueryField(); removeErrors();">--%>
                            <%--<input type="radio" name="constraintType" value="field">By Field--%>
                        <%--</label>--%>
                    <%--</div>--%>
                    <%--<div style="margin-top:10px" id="category-container">--%>
                        <%--<div id="category-select-container">--%>
                            <%--<label class="control-label" for="category-select">Category:</label><br>--%>
                            <%--<select class="form-control"--%>
                                    <%--id="category-select"--%>
                                    <%--onchange="changeQueryCategory(); removeError('category-select'); removeDuplicateError();"--%>
                                    <%--aria-describedby="category-select-feedback">--%>
                                <%--<option value=""></option>--%>
                                <%--<option value="software">Software</option>--%>
                            <%--</select>--%>

                            <%--<span id="category-select-feedback" class="error-color"></span>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                    <%--<div style="margin-top:10px; display:none" id="field-container">--%>
                        <%--<div id="field-select-container">--%>
                            <%--<label class="control-label" for="field-select">Field:</label><br>--%>
                            <%--<select class="form-control"--%>
                                    <%--id="field-select"--%>
                                    <%--onchange="populateFieldValues(); changeQueryField(); removeError('field-select'); removeDuplicateError();"--%>
                                    <%--aria-describedby="field-select-feedback">--%>
                                <%--<option></option>--%>
                                <%--<option value="pathogenCoverage">Software - Disease Transmission Models - Pathogen coverage</option>--%>
                                <%--<option value="locationCoverage">Software - Disease Transmission Models - Location coverage</option>--%>
                                <%--<option value="hostSpeciesIncluded">Software - Disease Transmission Models - Host species included</option>--%>
                                <%--<option value="controlMeasures">Software - Disease Transmission Models - Control measures</option>--%>
                            <%--</select>--%>

                            <%--<span id="field-select-feedback" class="error-color"></span>--%>
                        <%--</div>--%>
                        <%--<div style="margin-top:10px">--%>
                            <%--<label class="radio-inline"><input type="radio" name="fieldOperator" value="equals" checked="checked" onclick="$('#value-select-container').show(); changeQueryField();">equals</label>--%>
                            <%--<label class="radio-inline"><input type="radio" name="fieldOperator" value="contains" onclick="$('#value-select-container').show(); changeQueryField();">contains</label>--%>
                            <%--<label class="radio-inline"><input type="radio" name="fieldOperator" value="hasValue" onclick="$('#value-select-container').hide();  changeQueryField();">has value</label>--%>
                        <%--</div>--%>
                        <%--<div style="margin-top:10px"--%>
                             <%--id="value-select-container">--%>
                            <%--<label class="control-label"--%>
                                   <%--for="value-select"--%>
                                   <%--aria-describedby="value-select-feedback">Value:</label><br>--%>
                            <%--<select class="form-control" id="value-select" onchange="changeQueryField(); removeError('value-select'); removeDuplicateError();">--%>
                                <%--<option></option>--%>
                            <%--</select>--%>

                            <%--<span id="value-select-feedback" class="error-color"></span>--%>
                        <%--</div>--%>
                    <%--</div>--%>

                    <%--<div style="margin-top:10px; display:none" id="human-readable-query">--%>
                        <%--<label>Resulting Human Readable Query:</label><br>--%>
                        <%--<span id="human-readable-query-text"></span>--%>

                        <%--<div style="margin-top:15px">--%>
                            <%--<span id="human-readable-query-feedback" class="error-color"></span>--%>
                        <%--</div>--%>
                    <%--</div>--%>

                    <%--<div style="margin-top:10px;">--%>
                        <%--<button class="btn btn-default" onclick="addConstraintToList();">Add</button>--%>
                        <%--<button class="btn btn-default" onclick="$('#query-builder-constraint-container').hide(); $('#add-constraint-btn').show();">Cancel</button>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<style>--%>
            <%--#constraint-list-container {--%>
                <%--padding-left:20px !important;--%>
                <%--height:100%;--%>
                <%--margin-bottom:10px--%>
            <%--}--%>

            <%--@media screen and (max-width: 768px){--%>
                <%--#constraint-list-container {--%>
                    <%--padding-left:0px !important;--%>
                <%--}--%>
            <%--}--%>
        <%--</style>--%>
        <%--<div id="constraint-list-container" class="col-sm-6 col-md-6 col-lg-6 no-padding">--%>
            <%--<div id="constraint-list" style="padding:10px 0 0 0">--%>
                <%--<h4 class="sub-title-font" style="margin: 0px 0px 8px 0px;">Constraints</h4>--%>
                <%--<span id="no-constraints-listed">--%>
                    <%--N/A--%>
                <%--</span>--%>
                <%--<ol id="constraints-listed" style="margin-left:-22px; display:none">--%>
                <%--</ol>--%>
            <%--</div>--%>

            <%--<div id="run-query" style="display:none;">--%>
                <%--<button class="btn btn-default" style="margin-top:5px;">Run Query</button>--%>
            <%--</div>--%>
        <%--</div>--%>
    <%--</div>&ndash;%&gt;--%>
</div>