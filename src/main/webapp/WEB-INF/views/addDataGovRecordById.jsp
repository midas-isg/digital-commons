<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <myTags:favicon></myTags:favicon>

<myTags:head title="MIDAS Digital Commons"/>
<myTags:header
        pageTitle="MIDAS Digital Commons"
        loggedIn="${loggedIn}"
        addEntry="${true}"
/>
    <h1 id="header" class="h1">Add Record from Data.gov by Identifier</h1>
<body id="commons-body">
<div id="content-body">
    <form method="POST" action="add-datagov-entry" name="form">
    <div id="commons-main-body" class="row">
        <div id="add-entry" class="tab-pane active">
            <div class="repeating-enclosing category-div">
                <div class="item-enclosing">
                    <label class="item-label">Enter the catalog URL (using CKan)</label>
                    <div class="item-input">
                        <input name="catalogURL" path="['catalogURL']" id="catalogURL" class="item-input-text full-width" type="text" value="http://catalog.data.gov/" readonly>
                        </input>
                        <div id="item-catalogURL-path" class="item-path" enabled="true"></div>
                    </div>
                </div>
                <label class="item-label">Category</label>
                <div class="item-input">
                    <select class="item-input-text" name="category" value="191" id="categoryValue">
                        <option value="none">None provided</option>
                        <c:forEach items="${categoryPaths}" var="categoryPath">
                            <c:choose>
                                <c:when test="${categoryPath.key==191}"><option selected value="${categoryPath.key}">${categoryPath.value}</option></c:when>
                                <c:otherwise>
                                    <option value="${categoryPath.key}">${categoryPath.value}</option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </div>
                <div class="item-error" style="display: none;">Invalid</div>
            </div>
            <div class="item-enclosing">
                <label class="item-label">Enter the package identifier</label>
                <div class="item-input">
                    <input name="identifier_from_data_gov" path="['identifier']" id="identifier_from_data_gov" class="item-input-text full-width" type="text" required>
                    </input>
                    <div id="item-identifier-path" class="item-path" enabled="true"></div>
                </div>
            </div>
            <span id="identifier-not-found-error" class="error-color" hidden>
                Could not find the given identifier in the repository.
            </span>
            <div class="item-enclosing">
                <label class="item-label">Title</label>
                <div class="item-input">
                    <input name="title" path="['title']" id="title" class="item-input-text full-width" type="text" required>
                    </input>
                    <div id="item-title-path" class="item-path" enabled="true"></div>
                </div>
            </div>
            <span id="title-error" class="error-color" hidden>
                Could not find title from the given identifier.
            </span>
            <div class="item-input">
                <input type="submit" class="submit btn btn-sm btn-default" value="Submit" id="btnSubmit" disabled />
            </div>
            <span id="submit-spinner" style="display:none;">
                <img src="<c:url value='/resources/img/spinner.gif'/>"></img>
           </span>
        </div>
    </div>
    </form>
</div>

    <%--<script src="${pageContext.request.contextPath}/resources/js/bootstrap-treeview/1.2.0/bootstrap-treeview.min.js"></script>--%>
    <%--<script>document.write("<script type='text/javascript' src='${pageContext.request.contextPath}/resources/js/commons.js?v=" + Date.now() + "'><\/script>");</script>--%>
</div>

<!-- uncomment for dev and production -->
<script>
    $( "#identifier_from_data_gov" ).change(function() {
        $.ajax({
            url: "https://catalog.data.gov/api/3/action/package_show?id=" + $("#identifier_from_data_gov").val(),
            dataType: "json",
            type: "GET",
            success:function (data) {
                $("#identifier-not-found-error").hide();
                $("#title-error").hide();
                $("#title").val(data.result.title);
                $("#btnSubmit").removeAttr("disabled");
            },
            error: function(xhr, status, error) {
                if(xhr.status = 404){
                    $("#identifier-not-found-error").show();
                }
                $("#title-error").show();
                console.log(status);
                var err = eval("(" + xhr.responseText + ")");
                $("#btnSubmit").attr("disabled",true);
                console.log(err);
                // alert(err.Message);
            }
        }).done(function () {
        });
    });

</script>

<script>
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-91508504-1', 'auto');
    /*ga('create', 'UA-91508504-1', {
     'cookieDomain': 'none'
     });*/
</script>

</body>

<myTags:footer></myTags:footer>

</html>
