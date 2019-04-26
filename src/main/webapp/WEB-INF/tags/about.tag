<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="row">
    <div class="col-md-12 font-size-16">
        <h3 class="title-font" id="subtitle">
            About
        </h3>

        <p class="font-size-16 standard-font">
            The primary purpose of the MIDAS Digital Commons (MDC) is to support infectious disease epidemiologists who
            are developing computational models of biological phenomena. The scope of the MDC is primarily defined by
            the past and present research of the MIDAS research network as reflected in its 1000+ publications (listed
            and linked to in reverse chronologic order <a href="http://publications.onbc.io/#/"
                                                          class="underline">here</a>).
        </p>

        <p class="font-size-16 standard-font">
            At present, the MDC consists of (1) a collection of digital objects in the domain of infectious disease
            epidemiology (2) a compute platform for running experiments, and (3) a search function that makes the
            digital objects findable.
        </p>

        <p class="font-size-16 standard-font">
            The <strong>digital objects</strong> include software, datasets, and data formats.
        </p>

        <p class="font-size-16 standard-font">
            The <strong>compute platform</strong> hosts programming languages and other software tools and some of the
            digital objects (e.g., disease transmission models and synthetic ecosystems). The locally hosted digital
            objects are labelled <i>AOC</i> (Available on the Olympus Cluster). Other digital objects are hosted
            remotely (i.e., they are virtual w.r.t. this digital commons).
        </p>

        <p class="font-size-16 standard-font">
            We intend that all digital objects conform to FAIR (Findable, Accessible, Interoperable, Reusable)
            guidelines. To make datasets interoperable, we represent them whenever possible in Apollo-XSD syntax and
            label them as being <i>AE</i> (Apollo-Encoded) in the MDC.
        </p>

        <div class="font-size-16 standard-font">
            <h3 class="sub-title-font font-size-20">Standard Identifiers</h3>
            <div id="standard-identifiers">
                <ul class="list-group">
                    <li class="list-group-item-wrap">
                        <span class="icon bullet-point"></span>
                        <span class="icon node-icon"></span>
                        <span>Apollo Location Codes (for locations)</span> <b><i class="sso-color"><sup>SSO</sup></i></b>
                        <span> - Locations for specific time intervals, including intervals that start in the past and are still open at present (i.e., the identifier should be used to refer to the location today.</span>
                    </li>
                    <li class="list-group-item-wrap">
                        <span class="icon bullet-point"></span>
                        <span class="icon node-icon"></span>
                        <span>LOINC codes (for lab tests)</span>
                        <span> - Applies universal code names and identifiers to medical terminology related to electronic health records.</span>
                    </li>
                    <li class="list-group-item-wrap">
                        <span class="icon bullet-point"></span>
                        <span class="icon node-icon"></span>
                        <span>NCBI Taxon identifiers (for host and pathogen taxa)</span>
                        <span> - A curated classification and nomenclature for all of the organisms in the public sequence databases.</span>
                    </li>
                    <li class="list-group-item-wrap">
                        <span class="icon bullet-point"></span>
                        <span class="icon node-icon"></span>
                        <span>RxNorm codes (for drugs)</span>
                        <span> - A standardized nomenclature for clinical drugs, is produced by the National Library of Medicine</span>
                    </li>
                    <li class="list-group-item-wrap">
                        <span class="icon bullet-point"></span>
                        <span class="icon node-icon"></span>
                        <span>SNOMED CT codes (for diagnoses)</span>
                        <span> - A systematically organized computer processable collection of medical terms providing codes, terms, synonyms and definitions used in clinical documentation and reporting.</span>
                    </li>
                    <li class="list-group-item-wrap">
                        <span class="icon bullet-point"></span>
                        <span class="icon node-icon"></span>
                        <span>Vaccine Ontology identifiers (for vaccines)</span>
                        <span> - describes the detailed classification and definitions of vaccine components and vaccine administration processes.</span>
                    </li>
                </ul>
            </div>
        </div>

        <div class="font-size-16 standard-font">
            <h3 class="sub-title-font font-size-20">FAIR-o-meter</h3>
            <span>We track conformance to FAIR guidelines <a
                    class="underline" href="http://meterdev.onbc.io/#/">here</a>.</span>
        </div>

        <div class="font-size-16 standard-font">
            <h3 class="sub-title-font font-size-20">Ontology</h3>
            <span>The Apollo-SV ontology represents our conceptualization of infectious disease epidemiology. You can find it <a
                    class="underline" href="https://github.com/ApolloDev/apollo-sv/releases/tag/v3.0.1">here</a>.</span>
        </div>

        <div class="font-size-16 standard-font">
            <h3 class="sub-title-font font-size-20">Web service</h3>
            <span>A programmatic interface to the MIDAS Digital Commons is available in the form of a RESTful Web service.

            The Web service (1) returns a list of the DOIs in MDC, (2) returns an object's metadata when presented with a DOI, and (3) returns data when presented with a DOI and a distribution identifier (there are one our more distributions of a dataset in the metadata) of a dataset.

           The MDC Web service is documented using the Swagger software library which describes the endpoint URLs, HTTP methods, required parameters, optional parameters, response syntaxes and input forms to test the API directly from a web browser.  The Web service documentation is available  <a
                        class="underline" href="${pageContext.request.contextPath}/sdoc.jsp">here</a>.

            </span>
        </div>

        <div class="font-size-16 standard-font">
            <h3 class="sub-title-font font-size-20">Submission Guidelines</h3>
            <span>If you have any digital objects that you'd like to submit to the commons, please contact Mike Wagner via email at <a
                    class="underline" href="mailto:mmw1@pitt.edu">mmw1@pitt.edu</a>.</span>
        </div>
        <div class="font-size-16 standard-font">
            <h3 class="sub-title-font font-size-20">Funding</h3>

            The MIDAS Digital Commons is funded by the National Institutes of Health (NIGMS) program for Models of
            Infectious Disease Agent Study (MIDAS) grant U24GM110707.
        </div>
        <div class="font-size-16 standard-font">
            <h3 class="sub-title-font font-size-20">Disclaimer</h3>

            By using the MIDAS Digital Commons you agree that no warranties of any kind are made by the University of
            Pittsburgh (University) with respect to the data provided in the MIDAS Digital Commons or any use thereof,
            and
            the University hereby disclaim the implied warranties of merchantability, fitness for a particular purpose
            and
            non-infringement. The University shall not be liable for any claims, losses or damages of any kind arising
            from
            the data provided in the MIDAS Digital Commons or any use thereof.
        </div>
        <br>
        <div class="font-size-16 standard-font">
            Please direct comments and questions to our <a class="underline" href="mailto:isg-feedback@list.pitt.edu">development
            team</a>.
        </div>
    </div>
</div>