<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<footer class="footer">
    <div class="leaf">
        <div class="hidden-xs footer-container-lg">
            <div class="pull-left">
                &#0169; 2017 University of Pittsburgh
            </div>

            <div class="pull-right" style="margin-right:20px">
                Please direct comments and questions to our <a class="leaf underline" href="mailto:isg-feedback@list.pitt.edu">development team</a>.
            </div>
        </div>

        <div class="hidden-sm hidden-md hidden-lg footer-container-xs">
            <div class="col-xs-12">
                &#0169; 2017 University of Pittsburgh
            </div>

            <div class="col-xs-12" style="font-size:12px">
                Please direct comments and questions to our <a class="leaf underline" href="mailto:isg-feedback@list.pitt.edu">development team</a>.
            </div>
        </div>
    </div>
</footer>

<%--<footer class="bs-docs-footer" role="contentinfo" id="footer">
    <!--<div class="col-sm-5 col-md-7 col-lg-8">
        &#0169; 2017 University of Pittsburgh
    </div>

    <div class="col-sm-7 col-md-5 col-lg-4">
        Please direct comments and questions to <a href="mailto:mmw1@pitt.edu">Mike Wagner</a>.
    </div>-->

    <div class="hidden-xs">
        <div class="pull-left">
            &#0169; 2017 University of Pittsburgh
        </div>

        <div class="pull-right">
            Please direct comments and questions to <a href="mailto:mmw1@pitt.edu">Mike Wagner</a>.
        </div>
    </div>

    <div class="hidden-sm hidden-md hidden-lg">
        <div class="col-xs-12">
            &#0169; 2017 University of Pittsburgh
        </div>

        <div class="col-xs-12">
            Please direct comments and questions to <a href="mailto:mmw1@pitt.edu">Mike Wagner</a>.
        </div>
    </div>
</footer>--%>
<%--<footer class="bs-docs-footer" role="contentinfo" id="footer">
    <div class="container">
        <p>&#0169; 2017 University of Pittsburgh</p>
        <p>
            Please direct comments and questions to <a
                href="mailto:mmw1@pitt.edu">Mike Wagner</a>.
        </p>

        <!--<div class="footer-sep">
            <a href="https://github.com/ApolloDev/apollo">Powered by the
                Apollo Library v3.1.0</a>
        </div>-->

        <div class="snomed-message">This work was funded by award
            U24GM110707 from the National Institute for General
            Medical Sciences (NIGMS). The work does not represent the view of
            NIGMS.</div>


        <!--<div class="snomed-message">This material includes SNOMED
            Clinical Terms&#174; (SNOMED CT&#174;) which is used by permission of the
            International Health Terminology Standards Development Organisation
            (IHTSDO). All rights reserved. SNOMED CT&#174;, was originally created by
            The College of American Pathologists. "SNOMED" and "SNOMED CT" are
            registered trademarks of the IHTSDO.</div>-->

        <div class="disclaimer">BY USING THE DIGITAL COMMONS YOU
            AGREE THAT NO WARRANTIES OF ANY KIND ARE MADE BY THE UNIVERSITY OF
            PITTSBURGH (UNIVERSITY) WITH RESPECT TO THE DATA PROVIDED IN THE
            DIGITAL COMMONS OR ANY USE THEREOF, AND THE UNIVERSITY HEREBY
            DISCLAIM THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
            PARTICULAR PURPOSE AND NON-INFRINGEMENT. THE UNIVERSITY SHALL NOT BE
            LIABLE FOR ANY CLAIMS, LOSSES OR DAMAGES OF ANY KIND ARISING FROM THE
            DATA PROVIDED IN THE DIGITAL COMMONS OR ANY USE THEREOF.</div>
    </div>

</footer>

<script>
    function autoMargin() {
        var subtitleHeight = 0;

        if($('#subtitle').length) {
            subtitleHeight = $('#subtitle').height();
        }

        var topMargin = $(document).height()
                - ( $('#content').height() + $('#header').height() + subtitleHeight + 50)
                - ($('#footer').height());

        if(topMargin < 0 || ($(document).width() < 768 && subtitleHeight == 0)) {
            topMargin = 10;
        }

        $('#footer').css('margin-top',
                topMargin
        );
    }

    autoMargin();

    // onResize bind of the function
    $(window).resize(function() {
        autoMargin();
    });
</script>--%>