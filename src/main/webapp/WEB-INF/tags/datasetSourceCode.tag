<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<div class="metadata-table">
    <h4 class="sub-title-font">Source code release</h4>
    <table class="table table-condensed table-borderless table-discrete table-striped">
        <tbody>
        <tr>
            <td>Source code links</td>
            <td>
                ${entryView.entry.sourceCodeRelease}
            </td>
        </tr>
        </tbody>
    </table>
</div>
