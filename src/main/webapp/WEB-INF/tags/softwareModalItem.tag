<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="id" required="true"
              type="java.lang.String"%>
<%@ attribute name="title" required="true"
              type="java.lang.String"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<div class="sub-title-font font-size-16 modal-software-item" id="software-${id}-container">
    <h4 class="inline bold" id="software-${id}-tag">${title}: </h4><br>
    <span id="software-${id}"></span>
</div>