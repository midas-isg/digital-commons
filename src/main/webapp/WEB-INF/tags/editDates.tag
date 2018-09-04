<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="date" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Date" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="label" required="false"
              type="java.lang.String" %>
<%@ attribute name="cardText" required="true"
              type="java.lang.String" %>

<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${date}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isInputGroup="${false}"
                                 isRequired="${isRequired}"
                                 cardText="${cardText}"
                                 tagName="date"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<%--TODO: make date look like other inputs with a label, might need to create new tag like editFloat--%>
<myTags:editInputBlock path="${path}.date"
                       specifier="${specifier}-date-picker"
                       date="${date}"
                       isDate="${true}"
                       placeholder="">
</myTags:editInputBlock>

<c:set var="datePath" value="${path}.date"/>
<c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(datePath)}" var="message">
    <span class="error-color">${message.text}</span>
</c:forEach>
<myTags:editAnnotation path="${path}.type"
                       annotation="${date.type}"
                       isRequired="false"
                       label="Type"
                       id="${specifier}-date"
                       cardText="The type of date, used to specify the process which is being timestamped by the date attribute value, ideally comes from a controlled terminology."
                       isUnboundedList="${false}"
                       specifier="${specifier}-date">
</myTags:editAnnotation>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${date}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isInputGroup="${false}"
                                 isRequired="${isRequired}"
                                 cardText="${cardText}"
                                 tagName="date"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
<script type="text/javascript">
    $(document).ready(function () {
        <c:if test="${not empty date.date}">
        $("#${specifier}-date-picker").datepicker({
            forceParse: false,
            orientation: 'top auto',
            todayHighlight: true,
            format: 'yyyy-mm-dd',
            uiLibrary: 'bootstrap4'
        });
        </c:if>
    });

</script>
