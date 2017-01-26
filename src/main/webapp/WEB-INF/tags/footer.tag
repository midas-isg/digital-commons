<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<footer class="bs-docs-footer" role="contentinfo" id="footer">
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
        var topMargin = $(document).height()
                - ( $('#content').height() + $('#header').height() + 50)
                - $('#footer').height();

        if(topMargin <= 280) {
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
</script>