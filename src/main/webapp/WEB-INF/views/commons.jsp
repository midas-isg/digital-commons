<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<myTags:head title="MIDAS Digital Commons"/>

<myTags:header
        pageTitle="MIDAS Digital Commons"
        loggedIn="${loggedIn}"/>

    <body id="commons-body">
        <div id="content-body">

            <myTags:softwareModal/>

            <div id="commons-main-body" class="row">
                <div class="tab-content">
                    <div id="content" class="tab-pane fade in active">
                        <myTags:content
                                softwareEntries="${softwareEntries}"
                                datasetEntries="${datasetEntries}"
                                dataStandardEntries="${dataStandardEntries}"
                        />
                    </div>
                    <div id="compute-platform" class="tab-pane fade">
                        <myTags:computePlatform/>
                    </div>
                    <div id="workflows" class="tab-pane fade">
                        <myTags:workflows workflowLocationsAndIds="${workflowLocationsAndIds}"/>
                    </div>
                    <div id="search" class="tab-pane fade">
                        <myTags:search/>
                    </div>
                    <div id="about" class="tab-pane fade">
                        <myTags:about/>
                    </div>
                </div>
            </div>

            <%--<myTags:software
                    software="${software}"/>--%>
            <%--<myTags:libraryViewerCollections
                    libraryViewerUrl="${libraryViewerUrl}"
                    libraryViewerToken="${libraryViewerToken}"
                    spewRegions="${spewRegions}"/>
            <myTags:webServices/>
            <myTags:dataFormats/>--%>
            <myTags:standardIdentifiers/>
        </div>

        <myTags:analytics/>

    </body>

    <myTags:footer/>

</html>
