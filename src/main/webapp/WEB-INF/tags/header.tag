<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="pageTitle" type="java.lang.String" %>
<%@ attribute name="subTitle" type="java.lang.String" %>

<div class="container-fluid" id="header-top">
    <div class="row">
        <h1 class="commons-header">
            ${pageTitle}
            <div class="pull-right">
                <myTags:logoutbutton/>
            </div>
        </h1>
        <h2 class="commons-subheader commons-header">
            ${subTitle}
        </h2>

    </div>
</div>
