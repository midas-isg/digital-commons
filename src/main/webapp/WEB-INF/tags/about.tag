<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="col-md-12 font-size-16">
    <h2 class="title-font" id="subtitle">
        About
    </h2>

    <p class="font-size-16 standard-font">
        The primary purpose of the MIDAS Digital Commons (MDC) is to support epidemiologists who are developing computational models of biological phenomena. Its secondary purpose is to play the role of a community digital commons within the BD2K framework.
    </p>

    <p class="font-size-16 standard-font">
        At present, MDC consists of (1) a collection of <strong>digital objects</strong> in the domain of infectious disease epidemiology, and (2) a <strong>compute platform</strong> for running experiments.   In an upcoming release, the MDC will add (3) a <strong>search function</strong> that allows digital objects -- software, web services, synthetic ecosystems, datasets, and machine-interpretable knowledge -- to be discovered via user programs and web services.  The search function will play the same role as a Data Discovery Index, but for a larger range of digital objects.
    </p>

     <p class="font-size-16 standard-font">
        The compute platform hosts some of the digital objects (e.g., disease transmission models and synthetic ecosystems) as well as programming languages and other software tools.   These locally hosted digital objects are labelled <i>RROO</i> (Ready to run on Olympus). Other digital objects are hosted remotely (i.e., they are virtual w.r.t. this digital commons).
     </p>

    <p class="font-size-16 standard-font">
        We intend that all digital objects conform to FAIR (Findable, Accessible, Interoperable, Reusable) guidelines.  To make objects interoperable, we are representing them in Apollo-XSD syntax.   Objects that we have done this with are labelled <i>AE</i> (Apollo-Encoded).   Note that we fully represent data and knowledge objects in Apollo-XSD syntax, but for software objects represent only the inputs and outputs in Apollo-XSD syntax.
    </p>
    <div class="font-size-16 standard-font">
        <h3 class="sub-title-font">Submission Guidelines</h3>
        <span>If you have any digital objects that you'd like to submit to the commons, please contact Mike Wagner via email at <a
                class="underline" href="mailto:mmw1@pitt.edu">mmw1@pitt.edu</a>.</span>
    </div>
    <div class="font-size-16 standard-font">
        <h3 class="sub-title-font">Funding</h3>

        The MIDAS Digital Commons is funded by the National Institutes of Health (NIGMS) program for Models of
        Infectious Disease Agent Study (MIDAS) grant U24GM110707.
    </div>
    <div class="font-size-16 standard-font">
        <h3 class="sub-title-font">Disclaimer</h3>

        By using the MIDAS Digital Commons you agree that no warranties of any kind are made by the University of
        Pittsburgh (University) with respect to the data provided in the MIDAS Digital Commons or any use thereof, and
        the University hereby disclaim the implied warranties of merchantability, fitness for a particular purpose and
        non-infringement. The University shall not be liable for any claims, losses or damages of any kind arising from
        the data provided in the MIDAS Digital Commons or any use thereof.
    </div>
    <br>
    <div class="font-size-16 standard-font">
        Please direct comments and questions to our <a class="underline" href="mailto:isg-feedback@list.pitt.edu">development
        team</a>.
    </div>
</div>