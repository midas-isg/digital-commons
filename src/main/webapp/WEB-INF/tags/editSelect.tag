<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%--
<%@ attribute name="geometry" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Geometry" %>
--%>
<%@ attribute name="enumData" required="false"
              type="java.lang.Enum" %>
<%@ attribute name="enumList" required="false"
              type="java.util.List" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="cardText" required="true"
              type="java.lang.String" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${enumData}"
                                 label="${label}"
                                 id="${id}"
                                 isRequired="${isRequired}"
                                 isUnboundedList="${false}"
                                 isInputGroup="${true}"
                                 cardText="${cardText}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editInputBlock path="${path}"
                       specifier="${specifier}-${tagName}"
                       isSelect="${true}"
                       enumData="${enumData}"
                       enumList="${enumList}"
                       placeholder="Please select...">
</myTags:editInputBlock>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${enumData}"
                                 label="${label}"
                                 id="${id}"
                                 isRequired="${isRequired}"
                                 isUnboundedList="${false}"
                                 isInputGroup="${true}"
                                 cardText="${cardText}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

