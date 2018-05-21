<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>
<%@ attribute name="lineage" required="true"
              type="java.util.ArrayList" %>

<div class="metadata-table"><h4 class="sub-title-font">Topics</h4>
    <table class="table table-condensed table-borderless table-discrete table-striped">
        <tbody>
        <tr>
            <td>Category</td>
            <c:choose>
                <c:when test="${fn:length(lineage) > 2}">
                    <td>${lineage[2]}</td>
                </c:when>
                <c:otherwise>
                    <td>${lineage[1]}</td>
                </c:otherwise>
            </c:choose>
        </tr>
        <myTags:datasetPathogenCoverage entryView="${entryView}"/>
        <myTags:datasetSpatialCoverage entryView="${entryView}" lineage="${lineage}"/>
        <myTags:datasetIsAbout entryView="${entryView}"/>
        <myTags:datasetHostSpeciesIncluded entryView="${entryView}"/>
        </tbody>
    </table>
</div>