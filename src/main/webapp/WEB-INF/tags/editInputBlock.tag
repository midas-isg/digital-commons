<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="string" required="false"
              type="java.lang.String" %>
<%@ attribute name="number" required="false"
              type="java.lang.Float" %>
<%@ attribute name="numberBigInteger" required="false"
              type="java.math.BigInteger" %>
<%@ attribute name="date" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Date" %>
<%@ attribute name="enumData" required="false"
              type="java.lang.Enum" %>
<%@ attribute name="enumDataString" required="false"
              type="java.lang.String" %>
<%@ attribute name="enumList" required="false"
              type="java.util.List" %>
<%@ attribute name="enumDataList" required="false"
              type="java.util.List" %>
<%@ attribute name="enumDataMap" required="false"
              type="java.util.Map" %>
<%@ attribute name="enumListType" required="false"
              type="java.lang.String" %>
<%@ attribute name="enumListSubType" required="false"
              type="java.lang.String" %>

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
<%@ attribute name="isBigInteger" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isDate" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isSelect" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="updateCardTabTitleText" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="updateCardTabTitleTextPerson" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="updateCardTabTitleTextType" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isMulti" required="false"
              type="java.lang.Boolean" %>

<%@ attribute name="minimum" required="false"
              type="java.lang.Integer" %>
<%@ attribute name="maximum" required="false"
              type="java.lang.Integer" %>
<%@ attribute name="step" required="false"
              type="java.lang.String" %>
<%@ attribute name="isAutoComplete" required="false"
              type="java.lang.Boolean" %>
<c:choose>

    <c:when test="${isFloat}">
        <input type="number" step="any" class="form-control" value="${number}" name="${path}" id="${specifier}"
               placeholder="${placeholder}"/>
    </c:when>
    <c:when test="${isBigInteger}">
        <input type="number" step="1" min="${minimum}" max="${maximum}"
               value="${numberBigInteger}"
               class="form-control" name="${path}" id="${specifier}" placeholder="${placeholder}"/>
    </c:when>
    <c:when test="${isDate}">
        <input type="text" class="form-control date" value="${date.date}" name="${path}"
               id="${specifier}">
    </c:when>
    <c:when test="${isTextArea}">
        <textarea name="${path}" id="${specifier}" type="text" class="form-control" rows="5"
                  <c:if test="${updateCardTabTitleText}">onchange="updateCardTabTitle('${specifier}')"</c:if>
                  placeholder="${placeholder}">${fn:escapeXml(string)}</textarea>
    </c:when>
    <c:when test="${isSelect}">
        <c:choose>
            <c:when test="${isAutoComplete}">
                <select class="autoCompleteSelect" style="width: 100%;" name="${path}" id="${specifier}-select" onchange="autoCompleteFields('${specifier}', '${path}', '${pageContext.request.contextPath}', '${enumListType}', '${enumListSubType}', '${updateCardTabTitleText}')">
                    <option></option>
                    <c:forEach items="${enumList}" var="varEnum" varStatus="status">
                        <c:set var="varEnumName" value="${varEnum.get('name').getAsString()}"/>
                        <%--<c:set var="varEnumName" value="${varEnum.name}"/>--%>
                        <option
                                <c:if test="${enumDataString == varEnumName}"> selected="selected" </c:if>
<%--
                                <c:forEach items="${enumDataList}" var="data" varStatus="statusDataList">
                                    <c:if test="${data == varEnumName}">selected="selected"</c:if>
                                </c:forEach>
--%>
                                value="${varEnumName}"
                                identifier="[${varEnum.get('identifier').get('identifier').getAsString()}]">
                                <%--identifier="[${varEnum.identifier.identifier}]">--%>
                                ${varEnumName}</option>
                    </c:forEach>
                </select>
            </c:when>
            <c:otherwise>
                <select class="multiSelect" <c:if test="${isMulti}">multiple</c:if> style="width: 100%" name="${path}" id="${specifier}-select"
                        title="${specifier}"
                        <c:if test="${updateCardTabTitleText}">onchange="updateCardTabTitleFromSelect('${specifier}-select')"</c:if>
                        <c:if test="${isMulti}">onchange="clearMultiSelectIfEmpty('${specifier}-select')"</c:if>>
                    <c:if test="${function:isObjectEmpty(enumDataMap)}">
                        <option></option>
                        <c:forEach items="${enumList}" var="varEnum" varStatus="status">
                            <c:set var="normalizedEnum" value="${fn:replace(varEnum, '_', ' ')}"/>
                            <option
                                    <c:if test="${enumData == varEnum}">selected="selected"</c:if>
                                    <c:forEach items="${enumDataList}" var="data" varStatus="statusDataList">
                                        <c:if test="${data == varEnum}">selected="selected"</c:if>
                                    </c:forEach>
                                    value="${varEnum}">
                                    ${fn:toUpperCase(fn:substring(normalizedEnum, 0, 1))}${fn:toLowerCase(fn:substring(normalizedEnum, 1,fn:length(normalizedEnum)))}</option>
                        </c:forEach>
                    </c:if>
                    <c:if test="${not function:isObjectEmpty(enumDataMap)}">
                        <c:forEach items="${enumDataMap.keySet().toArray()}" var="varEnum" varStatus="status">
                            <option
                                    <c:forEach items="${enumDataList}" var="data" varStatus="statusDataList">
                                        <c:if test="${data == varEnum}">selected="selected"</c:if>
                                    </c:forEach>
                                    value="${varEnum}">
                                    ${enumDataMap.get(varEnum)}</option>
                        </c:forEach>
                        <option value=""></option>
                    </c:if>
                </select>
            </c:otherwise>
        </c:choose>
    </c:when>

    <c:otherwise>
        <input type="text" class="form-control" value="${fn:escapeXml(string)}" name="${path}"
               id="${specifier}" placeholder="${placeholder}"
               <c:if test="${updateCardTabTitleText}">onchange="updateCardTabTitle('${specifier}')"</c:if>
               <c:if test="${updateCardTabTitleTextPerson}">onchange="updateCardTabTitlePerson('${specifier}')"</c:if>
               <c:if test="${updateCardTabTitleTextType}">onchange="updateCardTabTitleType('${specifier}')"</c:if> />

    </c:otherwise>

</c:choose>
