<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<footer class="footer-lg hidden-xs">
    <div class="leaf">
        <div class="footer-container-lg">
            <div class="pull-left">
                &#0169; 2017 University of Pittsburgh
            </div>

            <div style="position: absolute; margin-left: 40%; font-style: italic;">
                <span class="leaf">Version 1.0</span>
            </div>

            <div class="pull-right" style="margin-right:20px">
                <!--Please direct comments and questions to our <a class="leaf underline" href="mailto:isg-feedback@list.pitt.edu">development team</a>.-->
                <span class="leaf underline pointer" onclick="activeTab('about')">About the MIDAS Digital Commons.</span>
            </div>
        </div>
    </div>
</footer>

<footer class="footer-xs hidden-sm hidden-md hidden-lg">
    <div class="leaf">
        <div class="footer-container-xs">
            <div class="col-xs-8">
                &#0169; 2017 University of Pittsburgh
            </div>

            <div style="float:right; margin-right: 10px; font-style: italic;">
                <span class="leaf">Version 1.0</span>
            </div>

            <div id="dev-team-footer" class="col-xs-8">
                <!--Please direct comments and questions to our <a class="leaf underline" href="mailto:isg-feedback@list.pitt.edu">development team</a>.-->
                <span class="leaf underline pointer" onclick="activeTab('about')">About the MIDAS Digital Commons.</span>
            </div>
        </div>
    </div>
</footer>