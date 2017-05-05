<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<script>
    hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-data-formats.json", dataFormats, dataFormatsDictionary, dataFormatsSettings, '#data-formats-treeview', 'expandedDataFormats', 'dataFormats');
</script>