<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="col-md-12 font-size-16">
    <h3 class="title-font" id="subtitle">
        Search
    </h3>

    <div class="col-sm-12 col-md-12 col-lg-12" style="border: 1px solid #ccc; border-radius:4px;">
        <div class="col-sm-6 col-md-6 col-lg-6 no-padding">
            <h4 class="sub-title-font">Query Builder</h4>
            <button class="btn btn-default" onclick="$('#query-builder-constraint-container').show()">Add constraint to query</button>

            <div id="query-builder-constraint-container" style="display:none">
                <div id="new-constraint" style="margin-top:12px; border: 1px solid #ccc; border-radius:4px; padding:10px; margin-bottom:12px;">
                    <div>
                        <label>New Constraint:</label><br>
                        <label class="radio-inline"
                               onclick="$('#field-container').hide(); $('#category-container').show(); changeQueryCategory();">
                            <input type="radio" name="constraintType" value="category" checked="checked">By Category
                        </label>

                        <label class="radio-inline"
                               onclick="$('#field-container').show(); $('#category-container').hide(); changeQueryField()">
                            <input type="radio" name="constraintType" value="field">By Field
                        </label>
                    </div>
                    <div style="margin-top:10px" id="category-container">
                        <label>Category:</label><br>
                        <select class="form-control" id="category-select" onchange="changeQueryCategory();">
                            <option value=""></option>
                            <option value="software">Software</option>
                        </select>
                    </div>
                    <div style="margin-top:10px; display:none" id="field-container">
                        <div>
                            <label>Field:</label><br>
                            <select class="form-control" id="field-select" onchange="populateFieldValues(); changeQueryField();">
                                <option></option>
                                <option value="pathogenCoverage">Software - Disease Transmission Models - Pathogen coverage</option>
                                <option value="locationCoverage">Software - Disease Transmission Models - Location coverage</option>
                                <option value="hostSpeciesIncluded">Software - Disease Transmission Models - Host species included</option>
                                <option value="controlMeasures">Software - Disease Transmission Models - Control measures</option>
                            </select>
                        </div>
                        <div style="margin-top:10px">
                            <label class="radio-inline"><input type="radio" name="fieldOperator" value="equals" checked="checked" onclick="$('#value-select-container').show(); changeQueryField();">equals</label>
                            <label class="radio-inline"><input type="radio" name="fieldOperator" value="contains" onclick="$('#value-select-container').show(); changeQueryField();">contains</label>
                            <label class="radio-inline"><input type="radio" name="fieldOperator" value="hasValue" onclick="$('#value-select-container').hide();  changeQueryField();">has value</label>
                        </div>
                        <div style="margin-top:10px" id="value-select-container">
                            <label>Value:</label><br>
                            <select class="form-control" id="value-select" onchange="changeQueryField()">
                                <option></option>
                            </select>
                        </div>
                    </div>

                    <div style="margin-top:10px; display:none" id="human-readable-query">
                        <label>Resulting Human Readable Query:</label><br>
                        <span id="human-readable-query-text"></span>
                    </div>

                    <div style="margin-top:10px;">
                        <button class="btn btn-default">Add</button>
                        <button class="btn btn-default">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="constraint-list-container" class="col-sm-6 col-md-6 col-lg-6 no-padding" style="padding-left:20px !important">
            <div id="constraint-list" style="padding:10px 0 0 0">
                <h4 class="sub-title-font" style="margin: 0px 0px 8px 0px;">Constraints</h4>
                <ol style="margin-left:-22px">
                    <li>&nbsp; Constraint 1</li>
                    <li>&nbsp; Constraint 2</li>
                    <li>&nbsp; Constraint 3</li>
                </ol>
            </div>
        </div>
    </div>
</div>