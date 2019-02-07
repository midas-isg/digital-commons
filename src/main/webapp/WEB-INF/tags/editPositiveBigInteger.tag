<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="number" required="true"
              type="java.math.BigInteger" %>
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
<%@ attribute name="isRequired" required="true"
              type="java.lang.Boolean" %>

<%--set wrapper Required to TRUE; its one line item for the user; otherwise we need to use a card and then specify cardText and cardIcon--%>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${number}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${false}"
                                 isInputGroup="${true}"
                                 isRequired="${true}"
                                 isBigInteger="${true}"
                                 cardText=""
                                 tagName="number"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editInputBlock path="${path}"
                       specifier="${specifier}-number"
                       numberBigInteger="${number}"
                       isBigInteger="${true}"
                            minimum="1"
                       placeholder="${placeholder}">
</myTags:editInputBlock>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${number}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${false}"
                                 isInputGroup="${true}"
                                 isRequired="${true}"
                                 cardText=""
                                 tagName="number"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
