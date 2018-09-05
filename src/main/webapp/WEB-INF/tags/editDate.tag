<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%@ attribute name="date" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Date" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="placeholder" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${date}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${false}"
                                 isInputGroup="${true}"
                                 isRequired="${true}"
                                 cardText=""
                                 tagName="date"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<myTags:editInputBlock path="${path}"
                       specifier="${specifier}"
                       date="${date}"
                       isDate="${true}"
                       placeholder="">
</myTags:editInputBlock>
<c:set var="datePath" value="${path}.date"/>
<c:forEach items="${flowRequestContext.messageContext.getMessagesBySource(datePath)}" var="message">
    <span class="error-color error offset-2">${message.text}</span>
</c:forEach>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${date}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${false}"
                                 isInputGroup="${true}"
                                 isRequired="${true}"
                                 cardText=""
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

