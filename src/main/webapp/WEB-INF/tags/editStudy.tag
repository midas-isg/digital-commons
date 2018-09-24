<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

<%@ attribute name="study" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Study" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>

<fmt:message key="dataset.study" var="studyPlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${study}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${studyPlaceHolder}"
                                 cardIcon="far fa-user"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<fmt:message key="dataset.study.name" var="namePlaceHolder" />
<myTags:editNonZeroLengthString
        placeholder="${namePlaceHolder}"
        label="Name"
        string="${study.name}"
        specifier="${specifier}-name"
        isUnboundedList="${false}"
        id="${specifier}-name"
        isRequired="${true}"
        isInputGroup="${true}"
        path="${path}.name">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.study.startDate" var="startDatePlaceHolder" />
<myTags:editDates label="Start Date"
                  path="${path}.startDate"
                  specifier="${specifier}-startDate"
                  id="${specifier}-startDate"
                  isUnboundedList="${false}"
                  isRequired="${false}"
                  cardText="${startDatePlaceHolder}"
                  date="${study.startDate}">
</myTags:editDates>

<fmt:message key="dataset.study.endDate" var="endDatePlaceHolder" />
<myTags:editDates label="End Date"
                  path="${path}.endDate"
                  specifier="${specifier}-endDate"
                  id="${specifier}-endDate"
                  isUnboundedList="${false}"
                  isRequired="${false}"
                  cardText="${endDatePlaceHolder}"
                  date="${study.endDate}">
</myTags:editDates>
<myTags:editPlace path="${path}.location"
                  specifier="${specifier}-location"
                  id="${specifier}-location"
                  tagName="place"
                  place="${study.location}"
                  isUnboundedList="${false}"
                  label="Location">
</myTags:editPlace>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${study}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${studyPlaceHolder}"
                                 cardIcon="far fa-user"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>


