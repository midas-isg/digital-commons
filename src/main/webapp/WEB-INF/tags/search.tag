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
            <button class="btn btn-default">Add constraint to query</button>

            <div id="new-constraint" style="margin-top:12px; border: 1px solid #ccc; border-radius:4px; padding:10px; margin-bottom:12px">
                <div>
                    <label>New Constraint:</label><br>
                    <label class="radio-inline"><input type="radio" name="constraintType" value="category" checked="checked">By Category</label>
                    <label class="radio-inline"><input type="radio" name="constraintType" value="field">By Field</label>
                </div>
                <div style="margin-top:10px">
                    <label>Category:</label><br>
                    <select class="form-control" id="category-select">
                        <option value=""></option>
                        <option value="software">Software</option>
                    </select>
                </div>
                <div style="margin-top:10px;" id="field-container">
                    <div>
                        <label>Field:</label><br>
                        <select class="form-control" id="field-select">
                            <option value=""></option>
                        </select>
                    </div>
                </div>
                <div style="margin-top:10px;">
                    <button class="btn btn-default">Add</button>
                    <button class="btn btn-default">Cancel</button>
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