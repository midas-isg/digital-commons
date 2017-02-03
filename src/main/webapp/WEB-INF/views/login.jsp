<!DOCTYPE html>
<html lang="en">
<script src="http://cdn.auth0.com/w2/auth0-6.8.js"></script>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Digital Commons</title>
    <myTags:favicon></myTags:favicon>

    <!-- Bootstrap core CSS -->
    <script src="resources/js/jquery-1.11.1.min.js"></script>


    <!--[if lt IE 9]>
    <script src="../assets/js/ie8-responsive-file-warning.js"></script>
    <![endif]-->

    <script src="https://cdn.auth0.com/js/lock-9.1.min.js"></script>
</head>

<body class="nav-md">
<!-- /page content -->
<form name="ignore_me">
    <input type="hidden" id="page_is_dirty" name="page_is_dirty" value="0" />
</form>
</body>

<script type="text/javascript">
    var dirty_bit = document.getElementById('page_is_dirty');
    console.log(dirty_bit);
    if (dirty_bit.value == '1') {
        console.log("here");
        window.location = '${pageContext.request.contextPath}/preview';
    }else {
        mark_page_dirty();
        $(document).ready(function() {
            var auth0 = new Auth0({
                clientID: '${clientId}',
                domain: '${domain}',
                callbackURL: '${callbackUrl}'
            });

            auth0.getSSOData(function (err, data) {
                var loggedInUserId = '${userId}';
                if (data && data.sso === true) {
                    console.log('SSO: an Auth0 SSO session already exists');
                    console.log(loggedInUserId);
                    console.log(data.lastUsedUserID);
                    if (loggedInUserId !== data.lastUsedUserID) {
                        console.log("SSO Session but NOT locally authenticated ");
                        auth0.login({
                            scope: 'openid name email picture offline_access',
                            state: '${state}'
                        }, function (err) {
                            console.error('Error logging in: ' + err);
                        });
                    } else {
                        console.log("SSO Session and locally authenticated ");
                        window.location = '${pageContext.request.contextPath}';
                    }
                } else if (loggedInUserId){
                    console.log("NO SSO Session but locally authenticated -> log them out locally");
                    window.location = '${logoutUrl}';
                } else {
                    console.log("NO SSO Session and NOT locally authenticated ");
                    var title = "Digital Commons";
                    var message = "Please login to use the services";
//                var hash = window.location.hash.substr(1);
//                if (hash.match('^logout')){
//                    message = "Logged out successfully.";
//                }
                    window.location = '${ssoLoginUrl}?returnToUrl='
                        + encodeURIComponent(window.location) + '&title=' + title + '&message=' + message;
                }
            });
        });
    }
    function mark_page_dirty() {
        dirty_bit.value = '1';
    }

</script>

</html>
