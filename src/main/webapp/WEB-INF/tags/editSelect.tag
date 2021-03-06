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
<%@ attribute name="enumDataString" required="false"
              type="java.lang.String" %>
<%@ attribute name="enumDataList" required="false"
              type="java.util.List" %>
<%@ attribute name="enumDataMap" required="false"
              type="java.util.Map" %>
<%@ attribute name="enumList" required="false"
              type="java.util.List" %>
<%@ attribute name="enumListType" required="false"
              type="java.lang.String" %>
<%@ attribute name="enumListSubType" required="false"
              type="java.lang.String" %>
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
<%@ attribute name="updateCardTabTitleText" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isMulti" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isAutoComplete" required="false"
              type="java.lang.Boolean" %>

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
                       isMulti="${isMulti}"
                       enumData="${enumData}"
                       enumDataString="${enumDataString}"
                       enumDataList="${enumDataList}"
                       enumDataMap="${enumDataMap}"
                       enumList="${enumList}"
                       enumListType="${enumListType}"
                       enumListSubType="${enumListSubType}"
                       updateCardTabTitleText="${updateCardTabTitleText}"
                       isAutoComplete="${isAutoComplete}"
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

