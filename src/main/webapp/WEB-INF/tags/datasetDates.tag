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

<%--Dates for Tycho datasets--%>
<c:if test="${not empty entryView.entry.dates}">
    <c:forEach items="${entryView.entry.dates}" var="date">
        <div class="metadata-row">
            <div class="metadata-pair">
                <c:choose>
                    <c:when test="${fn:contains(date.type.value,'interval')}">
                        <dt class="metadata-pair-title">
                                Interval
                        </dt>
                        <dd class="metadata-pair-value">
                        ${fn:toUpperCase(fn:substring(date.date, 0, 1))}${fn:substring(date.date, 1,fn:length(date.date))}
                        </dd>
                    </c:when>
                    <c:otherwise>
                    <dt class="metadata-pair-title">
                            ${fn:toUpperCase(fn:substring(date.type.value, 0, 1))}${fn:substring(date.type.value, 1,fn:length(date.type.value))}
                    </dt>
                    <dd class="metadata-pair-value">
                        <c:catch var="ex">
                            <fmt:parseDate value="${date.date}" var="parsedDate"
                                           pattern="yyyy-MM-dd"/>

                            <fmt:formatDate dateStyle="medium"
                                            value="${parsedDate}"></fmt:formatDate>
                        </c:catch>
                        <c:if test="${not empty ex}">
                            ${date.date}
                        </c:if>
                    </dd>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:forEach>
</c:if>
<c:if test="${not empty entryView.entry.producedBy}">
    <%--Date modified for data.gov datasets--%>
    <c:if test="${not empty entryView.entry.producedBy.startDate}">
        <c:choose>
            <c:when test="${not empty entryView.entry.producedBy.startDate.type}">
                <div class="metadata-row">
                    <div class="metadata-pair">
                        <dt class="metadata-pair-title">
                                ${fn:toUpperCase(fn:substring(entryView.entry.producedBy.startDate.type.value, 0, 1))}${fn:substring(entryView.entry.producedBy.startDate.type.value, 1,fn:length(entryView.entry.producedBy.startDate.type.value))}
                        </dt>
                        <dd class="metadata-pair-value">
                            <c:catch var="ex">
                                <fmt:parseDate value="${entryView.entry.producedBy.startDate.date}" var="parsedDate"
                                               pattern="yyyy-MM-dd"/>

                                <fmt:formatDate dateStyle="medium"
                                                value="${parsedDate}"></fmt:formatDate>
                            </c:catch>
                            <c:if test="${not empty ex}">
                                ${entryView.entry.producedBy.startDate.date}
                            </c:if>
                        </dd>
                    </div>
                </div>
            </c:when>
            <%--Start Date for producedby--%>
            <c:otherwise>
                <div class="metadata-row metadata-detail-groups">
                    <div class="metadata-detail-group">
                        <dt class="metadata-detail-group-title">
                            Start Date
                        </dt>
                        <dd class="metadata-detail-group-value">
                            <c:catch var="ex">
                                <fmt:parseDate value="${entryView.entry.producedBy.startDate.date}" var="parsedDate"
                                               pattern="yyyy-MM-dd"/>

                                <fmt:formatDate dateStyle="medium"
                                                value="${parsedDate}"></fmt:formatDate>
                            </c:catch>
                            <c:if test="${not empty ex}">
                                ${entryView.entry.producedBy.startDate.date}
                            </c:if>
                        </dd>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>


    <%--End Date for producedby--%>
    <c:if test="${not empty entryView.entry.producedBy.endDate}">
        <div class="metadata-row metadata-detail-groups">
            <div class="metadata-detail-group">
                <dt class="metadata-detail-group-title">
                    End Date
                </dt>
                <dd class="metadata-detail-group-value">
                    <c:catch var="ex">
                        <fmt:parseDate value="${entryView.entry.producedBy.endDate.date}" var="parsedDate"
                                       pattern="yyyy-MM-dd"/>

                        <fmt:formatDate dateStyle="medium"
                                        value="${parsedDate}"></fmt:formatDate>
                    </c:catch>
                    <c:if test="${not empty ex}">
                        ${entryView.entry.producedBy.endDate.date}
                    </c:if>
                </dd>
            </div>
        </div>
    </c:if>
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
                        <c:catch var="ex">
                            <fmt:parseDate value="${extraProperty.values[0].value}" var="parsedDate"
                                           pattern="yyyy-MM-dd"/>

                            <fmt:formatDate dateStyle="medium"
                                            value="${parsedDate}"></fmt:formatDate>
                        </c:catch>
                        <c:if test="${not empty ex}">
                            ${extraProperty.values[0].value}
                        </c:if>
                    </dd>
                </div>
            </div>
        </c:if>
    </c:forEach>
</c:if>

<%--Date when added to our repo--%>
<c:if test="${not empty entryView.dateAdded}">
    <div class="metadata-row metadata-detail-groups">
        <div class="metadata-detail-group">
            <dt class="metadata-detail-group-title">
                Added to repository
            </dt>
            <dd class="metadata-detail-group-value">
                <c:catch var="ex">
                    <fmt:parseDate value="${entryView.dateAdded}" var="parsedDate"
                                   pattern="yyyy-MM-dd"/>

                    <fmt:formatDate dateStyle="medium"
                                    value="${parsedDate}"></fmt:formatDate>
                </c:catch>
                <c:if test="${not empty ex}">
                    ${entryView.dateAdded}
                </c:if>
            </dd>
        </div>
    </div>
</c:if>