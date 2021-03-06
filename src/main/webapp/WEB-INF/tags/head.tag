<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="title" required="false" type="java.lang.String"%>
<jsp:useBean id="systemProperties" class="edu.pitt.isg.dc.utils.SystemProperties" scope="application" />

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <myTags:favicon></myTags:favicon>

    <title>${title}</title>
    <script>var ctx = "${pageContext.request.contextPath}"</script>

    <c:choose>
        <c:when test="${systemProperties['EXPAND_JS'] != null}">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css">

            <link href="${pageContext.request.contextPath}/resources/css/header.css" rel="stylesheet">
            <%--<link href="${pageContext.request.contextPath}/resources/css/font-awesome-5.3.1/all.min.css" rel="stylesheet">--%>
            <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">


            <link href="${pageContext.request.contextPath}/resources/css/feather/style.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/resources/css/bootstrap-extended/bootstrap-extended.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/resources/css/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/resources/DataTables/datatables.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />

            <!-- jQuery imports -->
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
            <!-- Bootstrap CSS -->
            <link href="${pageContext.request.contextPath}/resources/css/bootstrap/4.1.2/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/resources/css/bootstrap-treeview/1.2.0/bootstrap-treeview.min.css" rel="stylesheet">

            <!-- Bootstrap JS -->
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>

            <script>document.write("<link href='${pageContext.request.contextPath}/resources/css/main.css?v=" + Date.now() + "'rel='stylesheet'>");</script>
            <script src="${pageContext.request.contextPath}/resources/js/bootstrap/4.1.2/bootstrap.min.js" defer></script>
            <script src="//cdn.jsdelivr.net/jquery.shadow-animation/1/mainfile"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>

            <script src="${pageContext.request.contextPath}/resources/js/bootstrap-treeview/1.2.0/bootstrap-treeview.min.js"></script>

            <script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/commons.js?v=" + Date.now() + "'><\/script>");</script>
            <script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/compute-platform.js?v=" + Date.now() + "'><\/script>");</script>
            <script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/workflows.js?v=" + Date.now() + "'><\/script>");</script>
            <script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/content.js?v=" + Date.now() + "'><\/script>");</script>
            <script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/editForms.js?v=" + Date.now() + "'><\/script>");</script>

            <script src="${pageContext.request.contextPath}/resources/DataTables/datatables.min.js"></script>
            <%--<script defer type="text/javascript" src="${pageContext.request.contextPath}/resources/js/dataTables.bootstrap.min.js"></script>--%>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>

            <%--Datepicker--%>
            <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
            <script defer type="text/javascript" src="${pageContext.request.contextPath}/resources/js/datepicker/bootstrap-datepicker.min.js"></script>
            <link href="${pageContext.request.contextPath}/resources/css/datepicker/bootstrap-datepicker3.min.css" rel="stylesheet">

            <%--Bootstrap select--%>
            <script defer type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-select.min.js"></script>
            <link href="${pageContext.request.contextPath}/resources/css/bootstrap-select.min.css" rel="stylesheet">

            <%--<!-- LoDash JS -->--%>
            <%--<script src="${pageContext.request.contextPath}/resources/js/lodash.min.js"></script>--%>
        </c:when>
        <c:otherwise>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css">

            <link defer rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/bootstrap/4.1.2/bootstrap.min.css">

            <link href="${pageContext.request.contextPath}/resources/css/combined.css" rel="stylesheet">

            <!-- jQuery imports -->
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.concat.min.js"></script>

            <script defer type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.dataTables.min.js"></script>

            <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/combined.min.js"></script>

        </c:otherwise>
    </c:choose>

</head>