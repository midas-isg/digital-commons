<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<myTags:head title="MIDAS Digital Commons"/>
<script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/commons.js?v=" + Date.now() + "'><\/script>");</script>
<script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/content.js?v=" + Date.now() + "'><\/script>");</script>

<myTags:header
        pageTitle="MIDAS Digital Commons"
        loggedIn="true"
        preview="true"
        wantCollapse="true"
        iframe="false"/>

    <body id="commons-body">
        <div id="content-body" style="margin-top:10px">
            <c:forEach items="${treeInfoArr}" var="treeInfo" varStatus="treeLoop">
                <div class="col-sm-4">
                    <h3 class="content-title-font">${treeInfo.category}</h3>
                    <div id="tree-${treeLoop.index}" class="treeview"></div>
                </div>
                <script>
                        $('#tree-${treeLoop.index}').treeview(getTreeviewInfo('${treeInfo.json}', '#tree-${treeLoop.index}', 'tree${treeLoop.index}'));
                </script>
            </c:forEach>
            <table class="table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Category</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${entries}" var="entry">
                        <tr>
                            <c:choose>
                                <c:when test="${entry.entry.title != null}">
                                    <td>${entry.entry.title}</td>
                                </c:when>
                                <c:otherwise>
                                    <td>${entry.entry.name}</td>
                                </c:otherwise>
                            </c:choose>
                            <td>${entry.category.category}</td>
                        </tr>
                    </c:forEach>
                </tbody>

            </table>
        </div>

        <myTags:analytics/>

    </body>

    <myTags:footer/>

</html>
