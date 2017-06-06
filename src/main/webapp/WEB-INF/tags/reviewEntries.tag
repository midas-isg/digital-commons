<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="entries" required="true"
              type="java.util.List"%>
<%@ attribute name="datasetEntries" required="true"
              type="java.util.List"%>
<%@ attribute name="dataStandardEntries" required="true"
              type="java.util.List"%>
<%@ attribute name="softwareEntries" required="true"
              type="java.util.List"%>

<div class="col-md-12 container">
    <h3 class="title-font" id="subtitle">
        Review Submissions
    </h3>
    <ul class="nav nav-tabs">
        <li class="active"><a href="#all">All</a></li>
        <li><a href="#dataset">Dataset</a></li>
        <li><a href="#data-standard">Data Standard</a></li>
        <li><a href="#software">Software</a></li>
    </ul>

    <div class="tab-content">
        <div id="all" class="tab-pane fade in active">
            <myTags:approveTable title="All" entries="${entries}"></myTags:approveTable>
        </div>
        <div id="dataset" class="tab-pane fade">
            <myTags:approveTable title="Dataset" entries="${datasetEntries}"></myTags:approveTable>
        </div>
        <div id="data-standard" class="tab-pane fade">
            <myTags:approveTable title="Data Standard" entries="${dataStandardEntries}"></myTags:approveTable>
        </div>
        <div id="software" class="tab-pane fade">
            <myTags:approveTable title="Software" entries="${softwareEntries}"></myTags:approveTable>
        </div>
    </div>
</div>