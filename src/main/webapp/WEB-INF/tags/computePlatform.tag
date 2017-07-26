<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<div class="col-sm-12">
    <h3 class="title-font">Olympus</h3>
    <div class="font-size-16 standard-font">
        <div class="col-sm-7 no-padding">
            Olympus is a linux-based supercomputer intended to be a workspace for model development and running experiments.   It is configured with several programming languages, compilers, and popular development tools (listed below) for general modeling work.  Olympus is also configured to run 4 disease transmission models, and hosts synthetic ecosystems for many countries.
            <br><br>
            Olympus is provided as a free resource to members of the MIDAS network. To sign up for an account on Olympus, please visit <a href="http://epimodels.org" class="underline">http://epimodels.org</a>.
            <br><br>
            For more information on Olympus, please read this <a class="underline" href="${pageContext.request.contextPath}/resources/pdf/olympus-presentation.pdf" download>PowerPoint presentation</a> or watch the video <span class="hidden-xs">to the right.</span> <span class="hidden-lg hidden-md hidden-sm">below.</span>
            <br><br>
        </div>
        <div class="col-sm-5 no-padding">
            <iframe id="olympus-video" class="full-width" height="275" src="" data-src="//www.youtube.com/embed/8DoMUjl_yCw" frameborder="0" allowfullscreen></iframe>
        </div>
    </div>
</div>

<div class="col-sm-12">
    <h3 class="title-font">Software available on Olympus</h3>
    <div class="font-size-16 standard-font">
        <div class="col-sm-12 no-padding">
            A list of the programming languages, compilers, development tools, and disease transmission models that are available on Olympus is shown below. A wiki describing how to use Olympus is available at <a href="https://git.isg.pitt.edu/hpc/olympus/wikis/home" class="underline">https://git.isg.pitt.edu/hpc/olympus/wikis/home</a>.
            <br/><br/>
            If you require software on Olympus that is not listed below, please contact <a href="mailto:remarks@psc.edu" class="underline">remarks@psc.edu</a>.<br/><br/>
        </div>
    </div>
</div>

<div class="col-sm-4">
    <h4 class="subtitle-font">System Software</h4>
    <div id="system-software-treeview" class="treeview"></div>
</div>

<div class="col-sm-4">
    <h4 class="subtitle-font">Tools</h4>
    <h5 class="tools">Statistical analysis</h5>
    <div id="statistical-analysis-treeview" class="treeview"></div>
    <h5 class="tools">Image manipulation</h5>
    <div id="image-manipulation-treeview" class="treeview"></div>
    <h5 class="tools">Genetic sequence</h5>
    <div id="genetic-sequence-treeview" class="treeview"></div>
</div>

<div class="col-sm-4">
    <h4 class="subtitle-font">Disease Transmission Models</h4>
    <div class="dtm-disclaimer"><i>These entries are cross-references of disease transmission models listed on the ‘Content’ page.</i></div>
    <div id="disease-transmission-models-treeview" class="treeview"></div>

    <h4 class="subtitle-font">Modeling Platforms</h4>
    <div id="modeling-platforms-treeview" class="treeview"></div>
</div>