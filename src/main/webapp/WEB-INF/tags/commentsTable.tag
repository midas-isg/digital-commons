<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ attribute name="comments" required="true" type="java.util.List" %>
<h4>${title}</h4>

<table class="table table-condensed">
    <thead>
    <tr>
        <th>Comment</th>
        <th>Author</th>
        <th>Date added</th>
        <th class="text-center">Delete</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${comments}" var="comment">
        <tr>
            <td>${fn:escapeXml(comment.content)}</td>
            <td>${comment.users.name}</td>
            <td><fmt:formatDate type="both"
                                dateStyle="short" timeStyle="short" value="${comment.dateAdded}"/></td>
            <td class="text-center">
                <button id="delete-comment-btn" class="btn btn-xs btn-default"
                        onclick="deleteComment(${comment.id})">
                    <icon class="fa fa-minus-circle"></icon>
                </button>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>