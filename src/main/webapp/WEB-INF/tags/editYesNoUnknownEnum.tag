<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText"/>

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="yesNoUnknown" required="false"
              type="edu.pitt.isg.mdc.v1_0.YesNoUnknownEnum" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>

<%--
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${yesNoUnknown}"
                                 label="${label}"
                                 id="${id}"
                                 isRequired="${true}"
                                 isUnboundedList="${false}"
                                 cardText=""
                                 cardIcon="fas fa-sign-in-alt"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
--%>

<myTags:editSelect path="${path}"
                   specifier="${specifier}"
                   label="${label}"
                   enumData="${yesNoUnknown}"
                   enumList="${yesNoUnknownEnums}"
                   cardText=""
                   tagName="yesNoUnknownEnum"
                   isRequired="${true}"
                   updateCardTabTitleText="${isUnboundedList}"
                   id="${specifier}">
</myTags:editSelect>

<%--
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${yesNoUnknown}"
                                 label="${label}"
                                 id="${id}"
                                 isRequired="${true}"
                                 isUnboundedList="${false}"
                                 cardText=""
                                 cardIcon="fas fa-sign-in-alt"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
--%>

