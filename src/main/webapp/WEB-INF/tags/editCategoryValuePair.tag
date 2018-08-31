<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>
<%@ attribute name="categoryValuePair" required="false"
              type="edu.pitt.isg.mdc.dats2_2.CategoryValuePair" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="cardText" required="false"
              type="java.lang.String" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${categoryValuePair}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${cardText}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString label="Category"
                                placeholder=" A characteristic or property about the entity this object is associated with."
                                specifier="${specifier}-category"
                                path="${path}.category"
                                string="${categoryValuePair.category}">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString label="CategoryIRI"
                                placeholder=" The IRI corresponding to the category, if associated with an ontology term."
                                specifier="${specifier}-categoryIRI"
                                path="${path}.categoryIRI"
                                string="${categoryValuePair.categoryIRI}">
</myTags:editNonZeroLengthString>
<myTags:editMasterUnbounded path="${path}.values"
                            specifier="${specifier}-values"
                            label="Value"
                            cardText="A set of (annotated) values associated with the cateogory."
                            tagName="annotation"
                            listItems="${categoryValuePair.values}">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${categoryValuePair}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${cardText}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

