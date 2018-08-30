<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%@ attribute name="number" required="false"
              type="java.lang.Float" %>
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
                                 object="${number}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${false}"
                                 isInputGroup="${true}"
                                 isRequired="${true}"
                                 tagName="float"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editInputBlock path="${path}"
                       specifier="${specifier}-number"
                       number="${number}"
                       isFloat="${true}"
                       placeholder="${placeholder}">
</myTags:editInputBlock>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${number}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${false}"
                                 isInputGroup="${true}"
                                 isRequired="${false}"
                                 tagName="float"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

