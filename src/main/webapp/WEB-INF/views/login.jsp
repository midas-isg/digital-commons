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
        debugger
        var hash = window.location.hash.substr(1);
        if (hash.match('^logout')) {
            console.log("Logging out ...");
            logout();
        }

        var auth0ClientId = '${clientId}';
        var auth0Domain = '${domain}';
        var callbackUrl = '${callbackUrl}';
        var state = '${state}';
        //var icon = /*[[@{/public/img/logo.png}]]*/ '';
        var loggedInUserId = '${userId}';

        var auth0Options = {
            clientID: auth0ClientId,
            audience: 'https://' + auth0Domain + '/userinfo',
            scope: 'openid profile email',
            // responseMode: 'form_post',
            // responseType: 'token',
            redirectUri: callbackUrl,
            domain: auth0Domain
        };
        var webAuth = new auth0.WebAuth(auth0Options);
        var a1 = new auth0.Authentication(auth0Options);

        function isSso(result) {
            return result.appState;
        }

        function sso() {
            a1.getSSOData(function (err, data) {
                var loggedInUserId = '${userId}';
                if (data && data.sso === true) {
                    console.log('SSO: an Auth0 SSO session already exists');
                    console.log(loggedInUserId);
                    console.log(data.lastUsedUserID);
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
                    var title = "Digital Commons";
                    var message = "Please login to use the services";
//                var hash = window.location.hash.substr(1);
//                if (hash.match('^logout')){
//                    message = "Logged out successfully.";
//                    message = "Logged out successfully.";
//                }
                    var returnUrl = ("${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, '')}${pageContext.request.contextPath}/");
                    var returnTitle = "Back to Digital Commons"
                    window.location = '${ssoLoginUrl}?returnToUrl='
                        + encodeURIComponent(window.location) + '&title=' + title + '&message=' + message + '&returnUrl=' + encodeURIComponent(returnUrl) + '&returnTitle=' + returnTitle;
                }
            });
        }

        webAuth.checkSession({responseType: 'token'},
            function(err, result) {
                if (err) {
                    console.log(err, "Renewing ...");
                    signOnViaMidasAccounts();
                } else {
                    console.log('checkSession', result);
                    if (isSso(result)) {
                        sso();
                    } else { // No SSO
                        signOnViaMidasAccounts();
                    }
                }
            }
        );

        function authorize () {
            console.log('Authorizing ...');
            webAuth.authorize({
                prompt: 'none',
                responseType: 'code',
                // redirectUri: callbackUrl,
                // responseMode: 'form_post',
                state: state,
                // usePostMessage: true
            });
        }

        function signOnViaMidasAccounts() {
            localStorage.setItem('sso', true);
            window.location.href = toMidasAccountsUrl();
        }

        function logout() {
            localStorage.setItem('sso', false);
            window.location.href = toMidasAccountsUrl("Logged out successfully.");
        }

        function toMidasAccountsUrl(message, title) {
            title = title || "Digital Commons";
            message = message || "Please sign on to use the services";
            return '${ssoLoginUrl}' + '?returnToUrl='
                + encodeURIComponent(window.location) + '&title=' + title + '&message=' + message;
        }
    });


</script>

</html>
