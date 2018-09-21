<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

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
<%@ attribute name="cardIcon" required="false"
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
                                 cardIcon="far fa-calendar-alt"
                                 tagName="date"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<myTags:editDate path="${path}.date"
                  specifier="${specifier}-date-picker"
                  id="${specifier}-size"
                  date="${date}"
                  placeholder=""
                  label="Date">
</myTags:editDate>

<fmt:message key="dataset.dates.annotation" var="annotationPlaceHolder" />
<myTags:editAnnotation path="${path}.type"
                       annotation="${date.type}"
                       isRequired="${true}"
                       label="Type"
                       id="${specifier}-date"
                       cardText="${annotationPlaceholder}"
                       updateCardTabTitleText="${isUnboundedList}"
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
                                 cardIcon="far fa-calendar-alt"
                                 tagName="date"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
