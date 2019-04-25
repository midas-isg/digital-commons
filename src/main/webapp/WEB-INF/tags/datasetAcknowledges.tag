<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<div class="metadata-table">
    <h4 class="sub-title-font">Acknowledges</h4>
    <table class="table table-condensed table-borderless table-discrete">

        <tbody>
        <c:forEach items="${entryView.entry.acknowledges}" var="acknowledge" varStatus="varStatus">
            <tr>
                <td>
                    <h4 class="sub-title-font">
                        Acknowledgement ${varStatus.count}
                    </h4>
                    <table class="table table-condensed table-borderless table-discrete table-striped">
                        <tbody>
                        <c:if test="${not empty acknowledge.name}">
                            <tr>
                                <td>Name</td>
                                <td>${acknowledge.name}</td>
                            </tr>
                        </c:if>
                        <c:if test="${not empty acknowledge.identifier}">
                            <tr>
                                <td>Identifier</td>
                                <td>${acknowledge.identifier.identifier}</td>
                            </tr>
                        </c:if>
                        <c:if test="${not empty acknowledge.funders}">
                            <tr>
                                <td>Funders</td>
                                <td>
                                    <c:forEach items="${acknowledge.funders}" var="funder" varStatus="varStatus">
                                        ${funder.name}<c:if test="${not empty funder.abbreviation}"> (${funder.abbreviation})</c:if> ${!varStatus.last ? ',' : ''}
                                    </c:forEach>
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
