<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>
<fmt:setBundle basename="cardText" />
<fmt:message key="dataset.type.information" var="informationMessage" />
<fmt:message key="dataset.type.method" var="methodMessage" />
<fmt:message key="dataset.type.platform" var="platformMessage" />

<div class="metadata-table">
    <h4 class="sub-title-font">Types</h4>
    <table class="table table-condensed table-borderless table-discrete">

        <tbody>
        <c:forEach items="${entryView.entry.types}" var="type" varStatus="varStatus">
            <tr>
                <td>
                    <h4 class="sub-title-font">
                        Type ${varStatus.count}
                    </h4>
                    <table class="table table-condensed table-borderless table-discrete table-striped">
                        <tbody>
                        <c:if test="${not empty type.information}">
                            <tr>
                                <td>Information <a data-toggle="tooltip" data-placement="top" title="${informationMessage}"><i
                                class="ft-info ft-buttons"></i></a></td>
                                <td><a href="${type.information.valueIRI}"
                                       class="underline">${type.information.value}</a></td>
                            </tr>
                        </c:if>
                        <c:if test="${not empty type.method}">
                            <tr>
                                <td>Method <a data-toggle="tooltip" data-placement="top" title="${methodMessage}"><i
                                class="ft-info ft-buttons"></i></a></td>
                                <td><a href="${type.method.valueIRI}"
                                       class="underline">${type.method.value}</a></td>
                            </tr>
                        </c:if>
                        <c:if test="${not empty type.platform}">
                            <tr>
                                <td>Platform <a data-toggle="tooltip" data-placement="top" title="${platformMessage}"><i
                                class="ft-info ft-buttons"></i></a></td>
                                <td><a href="${type.platform.valueIRI}"
                                       class="underline">${type.platform.value}</a></td>
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
