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
        <c:if test="${not empty entryView.entry.softwareVersion}">
            <tr>
                <td>Website</td>
                <td>
                        ${entryView.entry.website}
                </td>
            </tr>
        </c:if>
        <c:if test="${not empty entryView.entry.softwareVersion}">
            <tr>
                <td>Source code links</td>
                <td>
                        ${entryView.entry.sourceCodeRelease}
                </td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
