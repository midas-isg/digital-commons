<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ attribute name="buttonId" required="true" type="java.lang.String"%>
<%@ attribute name="scriptId" required="true" type="java.lang.String"%>
<%@ attribute name="scriptFilename" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="code" required="false" type="java.lang.String"%>

<div style='margin-top:15px;'>
    <c:if test="${fn:contains(label, 'Example') == false}">
        <label id="label-${scriptId}" style="margin-right:5px; display:inline">${label}
            <span id="span-a-${scriptId}">(<a id="a-${scriptId}" href="#workflows">show example</a>)</span>
        </label>

        <span>[</span>
        <small>
            <icon class="glyphicon glyphicon-minus" onclick="toggleElementById('#${scriptId}-code-block', this)">
            </icon>
        </small>
        <span>]</span>
        <br>

        <script>
            $('#a-${scriptId}').click(function(){
                event.preventDefault();
                toggleElementById('#example-${scriptId}-code-block', this)
            });
        </script>
    </c:if>

    <div id="${scriptId}-code-block" style="position:relative; <c:if test="${fn:contains(label, 'Example') == true}">display:none</c:if>"
         onmouseenter="$('#${buttonId}').fadeIn();"
         onmouseleave="$('#${buttonId}').fadeOut();">
        <c:if test="${fn:contains(label, 'Example') == true}"><label>${label}</label></c:if>
        <pre style="max-height:150px; overflow:scroll"><code style="white-space:pre" id="${scriptId}"></code></pre>

        <div id="${buttonId}" style="display:none">
            <button class="btn btn-xs btn-default"
                    style="top: 4px;right: 30px; position:absolute;"
                    onclick="copyToClipboard('#${scriptId}')">
                <icon class="glyphicon glyphicon glyphicon-copy"></icon>
            </button>
            <button class="btn btn-xs btn-default"
                    style="top: 4px;right: 4px; position:absolute;"
                    onclick="download('${scriptFilename}', '#${scriptId}')">
                <icon class="glyphicon glyphicon glyphicon-download"></icon>
            </button>
        </div>
    </div>
</div>
