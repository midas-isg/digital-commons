<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>
<%@ attribute name="lineage" required="true"
              type="java.util.List" %>
<script src="${pageContext.request.contextPath}/resources/js/commons.js"></script>

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
        <myTags:datasetControlMeasures entryView="${entryView}"/>
        <myTags:datasetPublicationsThatUsedRelease entryView="${entryView}"/>

        <%--Data standard information--%>
        <c:if test="${not empty entryView.entry.version}">
            <tr>
                <td>Version</td>
                <td>${entryView.entry.version}</td>
            </tr>
        </c:if>

        <c:if test="${not empty entryView.entry.type}">
            <tr>
                <td>Type</td>
                <td>
                    <c:choose>
                        <c:when test="${not empty entryView.entry.type.valueIRI}">
                            <a class="underline" href="${entryView.entry.type.valueIRI}">${entryView.entry.type.value}</a>
                        </c:when>
                        <c:otherwise>
                            ${entryView.entry.type.value}
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:if>

        <c:if test="${not empty entryView.entry.extraProperties}">
            <c:forEach items="${entryView.entry.extraProperties}" var="extraProperty" varStatus="varStatus">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${fn:contains(fn:toLowerCase(extraProperty.category), 'human-readable') or fn:contains(fn:toLowerCase(extraProperty.category), 'human readable')}">
                                Human readable specification
                            </c:when>
                            <c:when test="${fn:contains(fn:toLowerCase(extraProperty.category), 'machine-readable') or fn:contains(fn:toLowerCase(extraProperty.category), 'machine readable')}">
                                Machine readable specification
                            </c:when>
                            <c:when test="${fn:contains(fn:toLowerCase(extraProperty.category), 'validator') and extraProperty.values ne null}">
                                Validator
                            </c:when>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty extraProperty.values[0].valueIRI}">
                                <script>
                                    document.write(urlify('${extraProperty.values[0].valueIRI}'));
                                </script>
                            </c:when>
                            <c:when test="${not empty extraProperty.values[0].value}">
                                 <script>
                                    document.write(urlify('${extraProperty.values[0].value}'));
                                </script>
                            </c:when>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </c:if>

        </tbody>
    </table>
</div>