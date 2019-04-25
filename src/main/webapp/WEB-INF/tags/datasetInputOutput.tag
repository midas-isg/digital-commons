<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entryView" required="true"
              type="edu.pitt.isg.dc.entry.classes.EntryView" %>
<%@ attribute name="title" required="true"
              type="java.lang.String" %>
<%@ attribute name="items" required="true"
              type="java.util.List" %>
<div class="metadata-table">
    <h4 class="sub-title-font">${title}</h4>
    <c:if test="${title eq 'Inputs'}">
        <table class="table table-condensed table-borderless table-discrete table-striped">
            <tbody>
            <tr>
                <td>Is list of ${fn:toLowerCase(title)} complete?</td>
                <td style="text-transform: capitalize">${fn:toLowerCase(entryView.entry.inputs[0].isListOfDataFormatsComplete)}</td>
            </tr>
            </tbody>
        </table>
    </c:if>
    <c:if test="${title eq 'Outputs'}">
        <table class="table table-condensed table-borderless table-discrete table-striped">
            <tbody>
            <tr>
                <td>Is list of ${fn:toLowerCase(title)} complete?</td>
                <td style="text-transform: capitalize">${fn:toLowerCase(entryView.entry.outputs[0].isListOfDataFormatsComplete)}</td>
            </tr>
            </tbody>
        </table>
    </c:if>


    <table class="table table-condensed table-borderless table-discrete">
        <tbody>
        <c:forEach items="${items}" var="inputOutput" varStatus="varStatus">

            <tr>
                <td>
                    <h4 class="sub-title-font">
                        <c:if test="${title eq 'Inputs'}">
                            Input ${inputOutput.inputNumber}
                        </c:if>
                        <c:if test="${title eq 'Outputs'}">
                            Output ${inputOutput.outputNumber}
                        </c:if>
                    </h4>
                    <table class="table table-condensed table-borderless table-discrete table-striped">
                        <tbody>
                        <c:if test="${not empty inputOutput.description}">
                            <tr>
                                <td>Description</td>
                                <td>${inputOutput.description}</td>
                            </tr>
                        </c:if>
                        <c:if test="${not empty inputOutput.dataFormats}">
                            <tr>
                                <td>Data formats</td>
                                <td>
                                    <c:forEach items="${inputOutput.dataFormats}" var="dataFormat"
                                               varStatus="varStatus">

                                        ${dataFormat}${!varStatus.last ? ',' : ''}

                                    </c:forEach>
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
