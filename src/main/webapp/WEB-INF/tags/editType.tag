<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="types" required="false"
              type="java.util.ArrayList" %>


<div class="form-group edit-form-group type-add-more">
    <label>Type</label>
    <button class="btn btn-success add-type" type="button"><i class="glyphicon glyphicon-plus"></i> Add Type</button>
    <br><br>
    <div>
        <button class="btn btn-success add-annotation" id="information" type="button"><i class="glyphicon glyphicon-plus"></i> Add
            Information
        </button>
    </div>
    <br>
    <div>
        <button class="btn btn-success add-annotation" id="method" type="button"><i class="glyphicon glyphicon-plus"></i> Add
            Method
        </button>
    </div>
    <br>
    <div>
        <button class="btn btn-success add-annotation" id="platform" type="button"><i class="glyphicon glyphicon-plus"></i> Add
            Platform
        </button>
    </div>
</div>


<div class="copy-annotation-information hide">
    <div class="form-group control-group edit-form-group">
        <label id="annotation-label">Information</label>
        <button class="btn btn-danger annotation-remove" id="information" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>

        <myTags:editAnnotation path="prefix"></myTags:editAnnotation>
    </div>
</div>

<div class="copy-annotation-method hide">
    <div class="form-group control-group edit-form-group">
        <label id="annotation-label">Method</label>
        <button class="btn btn-danger annotation-remove" id="method" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>

        <myTags:editAnnotation path="prefix"></myTags:editAnnotation>
    </div>
</div>

<div class="copy-annotation-platform hide">
    <div class="form-group control-group edit-form-group">
        <label id="annotation-label">Platform</label>
        <button class="btn btn-danger annotation-remove" id="platform" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>

        <myTags:editAnnotation path="prefix"></myTags:editAnnotation>
    </div>
</div>



<div class="copy-type hide">
    <div class="form-group control-group edit-form-group">
        <label>Type</label>
        <button class="btn btn-danger type-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>
        <br><br>
        <div>
            <button class="btn btn-success add-annotation" id="information" type="button"><i class="glyphicon glyphicon-plus"></i> Add
                Information
            </button>
        </div>
        <br>
        <div>
            <button class="btn btn-success add-annotation" id="method" type="button"><i class="glyphicon glyphicon-plus"></i> Add
                Method
            </button>
        </div>
        <br>
        <div>
            <button class="btn btn-success add-annotation" id="platform" type="button"><i class="glyphicon glyphicon-plus"></i> Add
                Platform
            </button>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var typeCount = 0;
        //Add section
        $(".add-type").click(function () {
            var html = $(".copy-type").html();
            $(".type-add-more").after(html);
            typeCount+= 1;
        });

        //Remove section
        $("body").on("click", ".type-remove", function () {
            $(this).parents(".control-group").remove();
        });


        //Show/Hide Annotation
        $("body").on("click", ".add-annotation", function () {
            var id = event.target.id;

            var html = $(".copy-annotation-" + id).html();
            //use '//g' regex for global capture, otherwise only first instance is repalced
            html = html.replace(/name="prefix/g, 'name="types[' + typeCount + '].' + id +'.');

            $(this).after(html);
            $(this).hide();
        });
        $("body").on("click", ".annotation-remove", function () {
            var id = event.target.id;
            $(this).parents(".control-group").remove();
            $("#" + id).show();
        });
    });
</script>