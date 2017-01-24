<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="pageTitle" type="java.lang.String" %>
<%@ attribute name="subTitle" type="java.lang.String" %>
<%@ attribute name="loggedIn" type="java.lang.Boolean" %>

<div class="container-fluid" id="header-top">
    <div class="row">
        <h1 class="title-font commons-header">
            ${pageTitle}
            <c:if test="${loggedIn == true}">
                <div class="pull-right">
                    <myTags:logoutbutton/>
                </div>
            </c:if>

        </h1>
        <h2 class="sub-title-font commons-subheader commons-header">
            ${subTitle}
        </h2>

    </div>
</div>
