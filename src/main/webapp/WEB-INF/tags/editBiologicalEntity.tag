<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="entity" required="false"
              type="edu.pitt.isg.mdc.dats2_2.IsAbout" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>


<div class="form-group edit-form-group control-group">
    <label>${label}</label>
    <c:choose>
        <c:when test="${not empty entity}">
            <div class="form-group control-group">
                <button class="btn btn-danger  ${specifier}-biological-entity-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
                <div class="form-group control-group edit-form-group">
                    <myTags:editIdentifier identifier="${entity.identifier}"
                                           path="${path}.identifier"
                                           specifier="${specifier}"
                                           label="Identifier">
                    </myTags:editIdentifier>
                    <myTags:editIdentifier path="${path}.alternateIdentifiers"
                                           unbounded="${true}"
                                           specifier="${specifier}-alternateIdentifiers"
                                           identifiers="${entity.alternateIdentifiers}"
                                           label="Alternate Identifier">
                    </myTags:editIdentifier>
                    <c:choose>
                        <c:when test="${not empty entity.name}">
                            <myTags:editRequiredNonZeroLengthString placeholder=" The name of the biological entity."
                                                                    label="Name"
                                                                    string="${entity.name}"
                                                                    path="${path}.name">
                            </myTags:editRequiredNonZeroLengthString>
                        </c:when>
                        <c:otherwise>
                            <myTags:editRequiredNonZeroLengthString placeholder=" The name of the biological entity."
                                                                    label="Name"
                                                                    path="${path}.name">
                            </myTags:editRequiredNonZeroLengthString>
                        </c:otherwise>
                    </c:choose>
                    <myTags:editNonRequiredNonZeroLengthString string="${entity.description}"
                                                               path="${path}.description"
                                                               label="Description"
                                                               placeholder="Description"
                                                               specifier="${specifier}">
                    </myTags:editNonRequiredNonZeroLengthString>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="form-group control-group">
                <button class="btn btn-danger  ${specifier}-biological-entity-remove" type="button"><i
                        class="glyphicon glyphicon-remove"></i>
                    Remove
                </button>
                <div class="form-group control-group edit-form-group">
                    <myTags:editIdentifier path="${path}.identifier"
                                           specifier="${specifier}"
                                           label="Identifier">
                    </myTags:editIdentifier>
                    <myTags:editIdentifier path="${path}.alternateIdentifiers"
                                           unbounded="${true}"
                                           specifier="${specifier}-alternateIdentifiers"
                                           label="Alternate Identifier">
                    </myTags:editIdentifier>
                    <myTags:editRequiredNonZeroLengthString placeholder=" The name of the biological entity."
                                                            label="Name"
                                                            path="${path}.name">
                    </myTags:editRequiredNonZeroLengthString>
                    <myTags:editNonRequiredNonZeroLengthString path="${path}.description"
                                                               label="Description"
                                                               placeholder="Description"
                                                               specifier="${specifier}">
                    </myTags:editNonRequiredNonZeroLengthString>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

