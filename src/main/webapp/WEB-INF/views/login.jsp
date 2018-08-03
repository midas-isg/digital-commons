<!DOCTYPE html>
<html lang="en">
<%--<script src="http://cdn.auth0.com/w2/auth0-6.8.js"></script>--%>
<script src="https://cdn.auth0.com/js/auth0/9.0.0/auth0.min.js"></script>

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
        var auth0ClientId = '${clientId}';
        var auth0Domain = '${domain}';
        var callbackUrl = '${callbackUrl}';
        var state = '${state}';
        //var icon = /*[[@{/public/img/logo.png}]]*/ '';
        var loggedInUserId = '${userId}';

        const auth0js = new auth0.WebAuth({
            domain: auth0Domain,
            clientID: auth0ClientId,
            audience: 'https://' + auth0Domain + '/userinfo',
            scope: 'openid profile',
            responseMode: 'form_post',
            responseType: 'code',
            // responseType: 'token',
            redirectUri: callbackUrl
        });

        var hash = window.location.hash.substr(1);
        if (hash.match('^logout')) {
            console.log("Logging out ...")
            logout();
        }

        auth0js.checkSession({},
            function(err, result) {
                if (err) {
                    console.log(err, "Renewing ...");
                    renew();
                    // signOnViaMidasAccounts();
                } else {
                    console.log('checkSession', result);
                    if (loggedInUserId) {
                        let location = '${pageContext.request.contextPath}/main';
                        console.log("user = ("+ loggedInUserId+ "); Going to ", location);
                        window.location = location;
                    } else {
                        renew();
                    }
                }
            }
        );

        function renew () {
            console.log('Renewing ...');
            auth0js.renewAuth({
                redirectUri: callbackUrl,
                responseMode: 'form_post',
                state: state,
                usePostMessage: true
            }, function (err, result) {
                if (err || (result && result.error)) { // For auth0.js version 8.8, the error shows up at result.error
                    if (result)
                        err = {error: result.errorDescription}; // For auth0.js version 8.8, the error message shows up at result.errorDescription
                    <%--alert(`Could not get a new token using silent authentication (${err.error}). Redirecting to login page...`);--%>
                    // auth0js.authorize();
                    signOnViaMidasAccounts();
                } else {
                    console.log('renewAuth', result);
                    //saveAuthResult(result);
                    window.location = '${pageContext.request.contextPath}/main';
                }
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
