<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<div class="metadata-table">
    <h4 class="sub-title-font">Software information</h4>
    <table class="table table-condensed table-borderless table-discrete table-striped">
        <tbody>
        <c:if test="${not empty entryView.entry.softwareVersion}">
            <tr>
                <td>Software version</td>
                <td>
                        ${entryView.entry.softwareVersion}
                </td>
            </tr>
        </c:if>
        <c:if test="${not empty entryView.entry.website}">
            <tr>
                <td>Website</td>
                <td>
                    <a class="underline" href="${entryView.entry.website}">${entryView.entry.website}</a>
                </td>
            </tr>
        </c:if>
        <c:if test="${not empty entryView.entry.sourceCodeRelease}">
            <tr>
                <td>Source code links</td>
                <td>
                        ${entryView.entry.sourceCodeRelease}
                </td>
            </tr>
        </c:if>
        <c:if test="${not empty entryView.entry.codeRepository}">
            <tr>
                <td>Code repository</td>
                <td>
                    <a class="underline" href="${entryView.entry.codeRepository}">${entryView.entry.codeRepository}</a>
                </td>
            </tr>
        </c:if>
        <c:if test="${not empty entryView.entry.binaryUrl}">
            <tr>
                <td>Binary Url</td>
                <td>
                    <c:forEach items="${entryView.entry.binaryUrl}"
                               var="binary"
                               varStatus="varStatus">
                        ${binary}${!varStatus.last ? ',' : ''}
                    </c:forEach>
                </td>
            </tr>
        </c:if>


        <c:if test="${not empty entryView.entry.diseases}">
            <tr>
                <td>Diseases</td>
                <td>
                    <div class="tag-list">
                        <c:forEach items="${entryView.entry.diseases}" varStatus="varStatus" var="disease">
                            <a href="${disease.identifier.identifierSource}"
                               class="color-white badge badge-primary">${disease.identifier.identifierDescription}</a>
                        </c:forEach>
                    </div>
                </td>
            </tr>
        </c:if>
        <c:if test="${not empty entryView.entry.forecastFrequency}">
            <tr>
                <td>Frequency of forecast</td>
                <td>
                        ${entryView.entry.forecastFrequency}
                </td>
            </tr>
        </c:if>
        <c:if test="${not empty entryView.entry.forecasts}">
            <tr>
                <td>Forecasts</td>
                <td>
                    <c:forEach items="${entryView.entry.forecasts}"
                               var="forecast"
                               varStatus="varStatus">
                        ${forecast}${!varStatus.last ? ',' : ''}
                    </c:forEach>
                </td>
            </tr>
        </c:if>

        <c:if test="${not empty entryView.entry.documentation}">
            <tr>
                <td>Documentation</td>
                <td>
                        ${entryView.entry.documentation}
                </td>
            </tr>
        </c:if>
        <c:if test="${not empty entryView.entry.license}">
            <tr>
                <td>License</td>
                <td>
                        ${entryView.entry.license}
                </td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
