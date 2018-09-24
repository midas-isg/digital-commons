<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="type" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Type" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${type}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editAnnotation annotation="${type.information}"
                       specifier="${specifier}-information"
                       id="${specifier}-information"
                       label="Information"
                       isUnboundedList="${false}"
                       isRequired="${false}"
                       path="${path}.information">
</myTags:editAnnotation>
<myTags:editAnnotation annotation="${type.method}"
                       specifier="${specifier}-method"
                       id="${specifier}-method"
                       label="Method"
                       isUnboundedList="${false}"
                       isRequired="${false}"
                       path="${path}.method">
</myTags:editAnnotation>
<myTags:editAnnotation annotation="${type.platform}"
                       specifier="${specifier}-platform"
                       id="${specifier}-platform"
                       label="Platform"
                       isUnboundedList="${false}"
                       isRequired="${false}"
                       path="${path}.platform">
</myTags:editAnnotation>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${type}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>


