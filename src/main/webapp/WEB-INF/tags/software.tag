<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="software" required="true"
              type="java.lang.Iterable"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
    hardcodeFromJson("${pageContext.request.contextPath}", "/resources/hardcoded-software.json", software, softwareDictionary, softwareSettings, '#algorithm-treeview', 'expandedSoftware', "software");
</script>

