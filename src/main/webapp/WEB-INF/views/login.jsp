<!DOCTYPE html>
<html lang="en">
<%--<script src="https://cdn.auth0.com/js/auth0/9.7.3/auth0.js"></script>--%>
<script src="https://cdn.auth0.com/js/auth0/9.7.3/auth0.min.js"></script>

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

    <script type="text/javascript"
            src="<c:url value="/resources/js/jquery-1.11.1.min.js"/>"></script>

    <!--[if lt IE 9]>
    <script src="../assets/js/ie8-responsive-file-warning.js"></script>
    <![endif]-->

    <script src="https://cdn.auth0.com/js/lock-9.1.min.js"></script>
</head>

<body class="nav-md">
<!-- /page content -->
</body>

<script type="text/javascript">
    $(document).ready(function () {
        // debugger
        var auth0options = toAuth0Options();
        new auth0.Authentication(auth0options).getSSOData(function (err, data) {
            var loggedInUserId = '${userId}';
            if (data && data.sso === true) {
                console.log('SSO: an Auth0 SSO session already exists');
                console.log('local:', loggedInUserId);
                console.log('SSO:', data.lastUsedUserID);
                if (loggedInUserId !== data.lastUsedUserID) {
                    console.log("SSO Session but NOT locally authenticated ");
                    authorize();
                } else {
                    console.log("SSO Session and locally authenticated ");
                    window.location = '${pageContext.request.contextPath}';
                }
            } else if (loggedInUserId) {
                console.log("NO SSO Session but locally authenticated -> log them out locally");
                window.location = '${logoutUrl}';
            } else {
                console.log("NO SSO Session and NOT locally authenticated ");
                window.location = toMidasAccountsUrl();
            }
        });

        function toAuth0Options() {
            var domain = '${domain}';
            return {
                state: '${state}',
                responseType: 'code',
                clientID: '${clientId}',
                audience: 'https://' + domain + '/userinfo',
                scope: 'openid profile email',
                redirectUri: '${callbackUrl}',
                domain: domain
            };
        }

        function authorize () {
            console.log('Authorizing ...');
            new auth0.WebAuth(auth0options).authorize({
                prompt: 'none'
            });
        }

        function toMidasAccountsUrl() {
            var appName = "Digital Commons";
            var title = appName;
            var message = "Please login to use the services";
//                var hash = window.location.hash.substr(1);
//                if (hash.match('^logout')){
//                    message = "Logged out successfully.";
//                }
            var returnUrl = toReturnUrl();
            var returnTitle = "Back to " + appName;
            return '${ssoLoginUrl}?returnToUrl='
                + encodeURIComponent(window.location) + '&title=' + title + '&message=' + message
                + '&returnUrl=' + encodeURIComponent(returnUrl) + '&returnTitle=' + returnTitle;

        }

        function toReturnUrl() {
            return "${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, '')}${pageContext.request.contextPath}/";
        }
    });


</script>

</html>
