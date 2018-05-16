<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>

<%--<div class="metadata-row">--%>
<%--<div class="metadata-pair">--%>
<%--<dt class="metadata-pair-title">Updated</dt>--%>
<%--<dd class="metadata-pair-value">August 27, 2015</dd>--%>
<%--</div>--%>
<%--</div>--%>

<%--Date modified for data.gov datasets--%>
<c:if test="${not empty entryView.entry.producedBy.startDate}">
    <div class="metadata-row">
        <div class="metadata-pair">
            <dt class="metadata-pair-title">
                <c:if test="${not empty entryView.entry.producedBy.startDate.type}">
                    ${fn:toUpperCase(fn:substring(entryView.entry.producedBy.startDate.type.value, 0, 1))}${fn:substring(entryView.entry.producedBy.startDate.type.value, 1,fn:length(entryView.entry.producedBy.startDate.type.value))}
                </c:if>
            </dt>
            <dd class="metadata-pair-value">${entryView.entry.producedBy.startDate.date}</dd>
        </div>
    </div>
</c:if>
<%--Date metadata dates for data.gov datasets--%>
<c:if test="${not empty entryView.entry.extraProperties}">
    <c:forEach items="${entryView.entry.extraProperties}" var="extraProperty">
        <c:if test="${fn:contains(extraProperty.category,'CKAN metadata')}">
            <c:set var="title" value="${fn:replace(extraProperty.category, 'CKAN ', '')}"/>
            <c:set var="title" value="${fn:replace(title, '_', ' ')}"/>

            <div class="metadata-row metadata-detail-groups">
                <div class="metadata-detail-group">
                    <dt class="metadata-detail-group-title">
                            ${fn:toUpperCase(fn:substring(title, 0, 1))}${fn:substring(title, 1,fn:length(title))}
                    </dt>
                    <dd class="metadata-detail-group-value">
                            ${extraProperty.values[0].value}
                    </dd>
                </div>
            </div>
        </c:if>
    </c:forEach>
</c:if>
<%--Dates for Tycho datasets--%>
<c:if test="${not empty entryView.entry.dates}">
    <c:forEach items="${entryView.entry.dates}" var="date">
        <div class="metadata-row">
            <div class="metadata-pair">
                <dt class="metadata-pair-title">
                        ${fn:toUpperCase(fn:substring(date.type.value, 0, 1))}${fn:substring(date.type.value, 1,fn:length(date.type.value))}
                </dt>
                <dd class="metadata-pair-value">
                        ${date.date}
                </dd>
            </div>
        </div>
    </c:forEach>
</c:if>
<c:if test="${not empty entryView.entry.producedBy}">
    <%--Start Date for producedby--%>
    <c:if test="${not empty entryView.entry.producedBy.startDate}">
        <div class="metadata-row metadata-detail-groups">
            <div class="metadata-detail-group">
                <dt class="metadata-detail-group-title">
                    Start Date
                </dt>
                <dd class="metadata-detail-group-value">
                        ${entryView.entry.producedBy.startDate.date}
                </dd>
            </div>
        </div>
    </c:if>
    <%--End Date for producedby--%>
    <c:if test="${not empty entryView.entry.producedBy.endDate}">
        <div class="metadata-row metadata-detail-groups">
            <div class="metadata-detail-group">
                <dt class="metadata-detail-group-title">
                    End Date
                </dt>
                <dd class="metadata-detail-group-value">
                        ${entryView.entry.producedBy.endDate.date}
                </dd>
            </div>
        </div>
    </c:if>
</c:if>

<%--Date when added to our repo--%>
<c:if test="${not empty entryView.dateAdded}">
    <div class="metadata-row metadata-detail-groups">
        <div class="metadata-detail-group">
            <dt class="metadata-detail-group-title">
                Added to repository
            </dt>
            <dd class="metadata-detail-group-value">
                    ${entryView.dateAdded}
            </dd>
        </div>
    </div>
</c:if>