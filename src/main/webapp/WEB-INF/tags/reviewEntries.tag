<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="entries" required="true"
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
            <h4>All</h4>
            <table class="table table-condensed">
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Type</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${entries}" var="entry">
                    <tr>
                        <td>${entry.entry.title}</td>
                        <td>${entry.entryType}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div id="dataset" class="tab-pane fade">
            <h4>Dataset</h4>
            <table class="table table-condensed">
                <thead>
                <tr>
                    <th>Title</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${entries}" var="entry">
                    <c:if test="${fn:contains(entry.entryType, 'Dataset')}">
                        <tr>
                            <td>${entry.entry.title}</td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div id="data-standard" class="tab-pane fade">
            <h4>Data Standard</h4>

            <table class="table table-condensed">
                <thead>
                <tr>
                    <th>Title</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${entries}" var="entry">
                    <c:if test="${fn:contains(entry.entryType, 'DataStandard')}">
                        <tr>
                            <td>${entry.entry.title}</td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div id="software" class="tab-pane fade">
            <h4>Software</h4>

            <table class="table table-condensed">
                <thead>
                <tr>
                    <th>Title</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${entries}" var="entry">
                    <c:if test="${fn:contains(entry.entryType, 'Dataset')}">
                        <tr>
                            <td>${entry.entry.title}</td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>