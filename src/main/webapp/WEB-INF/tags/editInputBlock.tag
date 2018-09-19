<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="string" required="false"
              type="java.lang.String" %>
<%@ attribute name="number" required="false"
              type="java.lang.Float" %>
<%@ attribute name="date" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Date" %>
<%@ attribute name="enumData" required="false"
              type="java.lang.Enum" %>
<%@ attribute name="enumList" required="false"
              type="java.util.List" %>

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>

<%@ attribute name="isTextArea" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isFloat" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isDate" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isSelect" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="updateCardTabTitleText" required="false"
              type="java.lang.Boolean" %>

<c:choose>

    <c:when test="${isFloat}">
        <input type="number" step="any" class="form-control" value="${number}" name="${path}" id="${specifier}"
               placeholder="${placeholder}"/>
    </c:when>
    <c:when test="${isDate}">
        <input type="text" class="form-control date" value="${date.date}" name="${path}"
               id="${specifier}">
    </c:when>
    <c:when test="${isTextArea}">
        <textarea name="${path}" id="${specifier}" type="text" class="form-control" rows="5"
                  placeholder="${placeholder}">${fn:escapeXml(string)}</textarea>
    </c:when>
    <c:when test="${isSelect}">
        <select class="custom-select" name="${path}" id="${specifier}-select"
                title="${specifier}">
            <option value="">Please Select...</option>
            <c:forEach items="${enumList}" var="varEnum" varStatus="status">
                <option
                        <c:if test="${enumData == varEnum}">selected="selected"</c:if>
                        value="${varEnum}">
                        ${varEnum}</option>
            </c:forEach>
        </select>
    </c:when>
    <c:otherwise>
        <input type="text" class="form-control" value="${fn:escapeXml(string)}" name="${path}"
               id="${specifier}" placeholder="${placeholder}" <c:if test="${updateCardTabTitleText}">onfocusout="updateCardTabTitle('${specifier}')"</c:if> />
    </c:otherwise>

</c:choose>
