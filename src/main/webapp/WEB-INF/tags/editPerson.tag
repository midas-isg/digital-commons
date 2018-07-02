<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="people" required="true"
              type="java.util.ArrayList" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="isFirstRequired" required="true"
              type="java.lang.Boolean" %>


<c:choose>
    <c:when test="${not empty people}">
        <spring:bind path="${path}[0]">
            <div class=" ${status.error ? 'has-error' : ''}">
            <c:forEach items="${people}" varStatus="varStatus" var="person">
                <c:choose>
                    <c:when test="${varStatus.first}">
                        <div class="form-group edit-form-group ${specifier}-add-more">
                        <label>${label}</label>
                        <button class="btn btn-success add-${specifier}" type="button"><i
                                class="glyphicon glyphicon-plus"></i> Add ${label}
                        </button>
                        <c:choose>
                            <c:when test="${isFirstRequired}">
                                <myTags:editRequiredNonZeroLengthString label="First Name" placeholder=" The given name of the person."
                                                                        path="${path}[0].firstName"></myTags:editRequiredNonZeroLengthString>
                                <myTags:editRequiredNonZeroLengthString label="Last Name" placeholder=" The person's family name."
                                                                        path="${path}[0].lastName"></myTags:editRequiredNonZeroLengthString>
                                <myTags:editRequiredNonZeroLengthString label="Email" placeholder=" An electronic mail address for the person."
                                                                        path="${path}[0].email"></myTags:editRequiredNonZeroLengthString>
                            </c:when>
                            <c:otherwise>
                                <myTags:editNonRequiredNonZeroLengthString label="First Name" placeholder=" The given name of the person."
                                                                           specifier="${specifier}-${varStatus.count-1}-firstName"
                                                                           path="${path}[${varStatus.count-1}].firstName"
                                                                           string="${path}[${varStatus.count-1}].firstName"></myTags:editNonRequiredNonZeroLengthString>
                                <myTags:editNonRequiredNonZeroLengthString label="Last Name" placeholder=" The person's family name."
                                                                           specifier="${specifier}-${varStatus.count-1}-lastName"
                                                                           path="${path}[${varStatus.count-1}].lastName"
                                                                           string="${path}[${varStatus.count-1}].lastName"></myTags:editNonRequiredNonZeroLengthString>
                                <myTags:editNonRequiredNonZeroLengthString label="Email" placeholder=" An electronic mail address for the person."
                                                                           specifier="${specifier}-${varStatus.count-1}-email"
                                                                           path="${path}[${varStatus.count-1}].email"
                                                                           string="${path}[${varStatus.count-1}].email"></myTags:editNonRequiredNonZeroLengthString>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>

                        <div class="form-group control-group edit-form-group">
                        <label>${label}</label>
                        <button class="btn btn-danger person-remove" type="button"><i
                                class="glyphicon glyphicon-remove"></i> Remove
                        </button>
                        <myTags:editNonRequiredNonZeroLengthString label="First Name" placeholder=" The given name of the person."
                                                                   specifier="${specifier}-${varStatus.count-1}-firstName"
                                                                   path="${path}[${varStatus.count-1}].firstName"
                                                                   string="${path}[${varStatus.count-1}].firstName"></myTags:editNonRequiredNonZeroLengthString>
                        <myTags:editNonRequiredNonZeroLengthString label="Last Name" placeholder=" The person's family name."
                                                                   specifier="${specifier}-${varStatus.count-1}-lastName"
                                                                   path="${path}[${varStatus.count-1}].lastName"
                                                                   string="${path}[${varStatus.count-1}].lastName"></myTags:editNonRequiredNonZeroLengthString>
                        <myTags:editNonRequiredNonZeroLengthString label="Email" placeholder=" An electronic mail address for the person."
                                                                   specifier="${specifier}-${varStatus.count-1}-email"
                                                                   path="${path}[${varStatus.count-1}].email"
                                                                   string="${path}[${varStatus.count-1}].email"></myTags:editNonRequiredNonZeroLengthString>
                    </c:otherwise>
                </c:choose>

                <c:if test="${varStatus.first}">

                    <form:errors path="${path}[0]" class="error-color"/>
                </c:if>

                </div>
                <c:set var="unboundedPersonCount" scope="page" value="${varStatus.count}"/>

            </c:forEach>
            </div>
        </spring:bind>
    </c:when>
    <c:otherwise>
        <spring:bind path="${path}[0]">
            <div class="form-group edit-form-group ${specifier}-add-more ${status.error ? 'has-error' : ''}">
                <label>${label}</label>
                <button class="btn btn-success add-${specifier}" type="button"><i class="glyphicon glyphicon-plus"></i> Add
                        ${label}
                </button>
                <c:choose>
                    <c:when test="${isFirstRequired}">
                        <myTags:editRequiredNonZeroLengthString label="First Name" placeholder=" The given name of the person."
                                                                path="${path}[0].firstName"></myTags:editRequiredNonZeroLengthString>
                        <myTags:editRequiredNonZeroLengthString label="Last Name" placeholder=" The person's family name."
                                                                path="${path}[0].lastName"></myTags:editRequiredNonZeroLengthString>
                        <myTags:editRequiredNonZeroLengthString label="Email" placeholder=" An electronic mail address for the person."
                                                                path="${path}[0].email"></myTags:editRequiredNonZeroLengthString>
                    </c:when>
                    <c:otherwise>
                        <myTags:editNonRequiredNonZeroLengthString label="First Name" placeholder=" The given name of the person."
                                                                   specifier="${specifier}-firstName"
                                                                   path="${path}[0].firstName"></myTags:editNonRequiredNonZeroLengthString>
                        <myTags:editNonRequiredNonZeroLengthString label="Last Name" placeholder=" The person's family name."
                                                                   specifier="${specifier}-lastName"
                                                                   path="${path}[0].lastName"></myTags:editNonRequiredNonZeroLengthString>
                        <myTags:editNonRequiredNonZeroLengthString label="Email" placeholder=" An electronic mail address for the person."
                                                                   specifier="${specifier}-email"
                                                                   path="${path}[0].email"></myTags:editNonRequiredNonZeroLengthString>
                    </c:otherwise>
                </c:choose>
                <form:errors path="${path}[0]" class="error-color"/>
            </div>
            <c:set var="unboundedPersonCount" scope="page" value="1"/>

        </spring:bind>
    </c:otherwise>
</c:choose>


<div class="${specifier}-copy hide">
    <div class="form-group  control-group edit-form-group">
        <label>${label}</label>
        <button class="btn btn-danger person-remove" type="button"><i class="glyphicon glyphicon-remove"></i> Remove
        </button>

        <myTags:editNonRequiredNonZeroLengthString label="First Name" placeholder=" The given name of the person."
                                                   specifier="${specifier}-firstName"
                                                   path="${path}[0].firstName"></myTags:editNonRequiredNonZeroLengthString>
        <myTags:editNonRequiredNonZeroLengthString label="Last Name" placeholder=" The person's family name."
                                                   specifier="${specifier}-lastName"
                                                   path="${path}[0].lastName"></myTags:editNonRequiredNonZeroLengthString>
        <myTags:editNonRequiredNonZeroLengthString label="Email" placeholder=" An electronic mail address for the person."
                                                   specifier="${specifier}-email"
                                                   path="${path}[0].email"></myTags:editNonRequiredNonZeroLengthString>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        var unboundedPersonCount =${unboundedPersonCount};
        //Add section
        $(".add-${specifier}").click(function () {

            //var html = $(".copy-person").html();
            // html = html.replace('name="firstName"', 'name="creators[' + creatorCount + '].firstName"').replace('name="lastName"', 'name="creators[' + creatorCount + '].lastName"').replace('name="email"', 'name="creators[' + creatorCount + '].email"');
            var specifier = "${specifier}";
            var path = "${path}";
            var html = $(".${specifier}-copy").html();
            path = path.replace('[','\\[').replace(']','\\]');
            var regexPath = new RegExp(path + '\\[0\\]', "g");
            var regexSpecifier = new RegExp(specifier + '\\-', "g");
            html = html.replace(regexPath, '${path}['+ unboundedPersonCount + ']').replace(regexSpecifier,'${specifier}-' + unboundedPersonCount + '-');
            unboundedPersonCount += 1;

            $(".${specifier}-add-more").after(html);
        });

        //Remove section
        $("body").on("click", ".person-remove", function () {
            $(this).parents(".control-group").remove();
        });
    });
</script>