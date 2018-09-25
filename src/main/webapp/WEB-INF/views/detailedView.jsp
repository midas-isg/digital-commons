<%--
  Created by IntelliJ IDEA.
  User: mas400
  Date: 5/14/18
  Time: 3:26 PM
  To change this template use File | Settings | File Templates.
--%>
<html>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<myTags:head title="MIDAS Digital Commons"/>
<myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>


<body id="detailed-view-body">
<myTags:detailedViewTag id="${id}" entryID="${entryId}" entryJson="${entryJson}" entryView="${entryView}" lineage="${lineage}" revId="${revisionId}" type="${type}" description="${description}"/>


<myTags:analytics/>

</body>

<myTags:footer/>

</html>