<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--
<%@ attribute name="descriptions" required="false"
              type="java.util.List" %>
--%>
<%@ attribute name="description" required="false"
              type="edu.pitt.isg.mdc.v1_0.DataServiceDescription" %>
<%@ attribute name="accessPointTypes" required="false"
              type="edu.pitt.isg.mdc.v1_0.DataServiceAccessPointType[]" %>

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isFirstRequired" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${description}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isInputGroup="${false}"
                                 isRequired="${isRequired}"
                                 cardText="A service that has some information content entity as input and output."
                                 isFirstRequired="${isFirstRequired}"
                                 tagName="dataServiceDescription"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editSelect path="${path}.accessPointType"
                   specifier="${specifier}-accessPointType"
                   label="Access Point Type"
                   enumData="${description.accessPointType}"
                   enumList="${accessPointTypes}"
                   cardText="Method by which access to the data service is provided."
                   tagName="accessPointType"
                   isRequired="${true}"
                   id="${specifier}-accessPointType">
</myTags:editSelect>
<myTags:editNonZeroLengthString label="Access Point Description"
                                string="${description.accessPointDescription}"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                specifier="${specifier}-accessPointDescription"
                                placeholder="Information which describes access to the data service."
                                cardText="Information which describes access to the data service."
                                id="${specifier}-accessPointDescription"
                                path="${path}.accessPointDescription">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString label="Access Point Url"
                                string="${description.accessPointUrl}"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                specifier="${specifier}-accessPointUrl"
                                placeholder="A web address defining the location of the data service."
                                cardText="A web address defining the location of the data service."
                                id="${specifier}-accessPointUrl"
                                path="${path}.accessPointUrl">
</myTags:editNonZeroLengthString>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${description}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 isInputGroup="${false}"
                                 isRequired="${isRequired}"
                                 cardText="A service that has some information content entity as input and output."
                                 isFirstRequired="${isFirstRequired}"
                                 tagName="dataServiceDescription"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>


