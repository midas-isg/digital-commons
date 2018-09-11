<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="entity" required="false"
              type="edu.pitt.isg.mdc.dats2_2.IsAbout" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="false"
              type="java.lang.Boolean" %>
<%@ attribute name="isRequired" required="false"
              type="java.lang.Boolean" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${entity}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="A biological entity is a recognized entity covering biological process, molecular functions or cellular components (from: http://geneontology.org/)."
                                 tagName="biological-entity"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString placeholder=" The name of the biological entity."
                                label="Name"
                                isRequired="true"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                string="${entity.name}"
                                path="${path}.name">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString string="${entity.description}"
                                path="${path}.description"
                                label="Description"
                                placeholder="Description"
                                isTextArea="true"
                                isRequired="${true}"
                                id="${specifier}-description"
                                specifier="${specifier}-description">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier singleIdentifier="${entity.identifier}"
                       path="${path}.identifier"
                       specifier="${specifier}-identifier"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       label="Identifier">
</myTags:editIdentifier>
<myTags:editMasterUnbounded path="${path}.alternateIdentifiers"
                            specifier="${specifier}-alternateIdentifiers"
                            listItems="${entity.alternateIdentifiers}"
                            cardText="Alternate identifiers for the biological entity."
                            tagName="identifier"
                            addButtonLabel="Alternate Identifier"
                            label="Alternate Identifier">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${entity}"
                                 label="${label}"
                                 id="${specifier}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="A biological entity is a recognized entity covering biological process, molecular functions or cellular components (from: http://geneontology.org/)."
                                 showCardFooter="${true}"
                                 tagName="biological-entity"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

