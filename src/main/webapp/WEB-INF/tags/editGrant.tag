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
<%@ attribute name="grant" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Grant" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${grant}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="An allocated sum of funds given by a government or other organization for a particular purpose."
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString placeholder=" The name of the grant and its funding program."
                                label="Name"
                                string="${grant.name}"
                                isUnboundedList="${false}"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                isRequired="${true}"
                                path="${path}.name">
</myTags:editNonZeroLengthString>
<myTags:editMasterUnbounded path="${path}.funders"
                                  specifier="${specifier}-funders"
                                  label="Funder"
                                  listItems="${grant.funders}"
                                  createPersonOrganizationTags="${true}"
                            tagName="personComprisedEntity"
                            cardText="The person(s) or organization(s) which has awarded the funds supporting the project."
                                  isFirstRequired="true"
                                  showAddPersonButton="true"
                                  showAddOrganizationButton="true">
</myTags:editMasterUnbounded>
<myTags:editIdentifier path="${path}.identifier"
                       singleIdentifier="${grant.identifier}"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       specifier="${specifier}-identifier"
                       label="Identifier">
</myTags:editIdentifier>
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            path="${path}.alternateIdentifiers"
                            cardText="Information about an alternate identifier (other than the primary)."
                            tagName="identifier"
                            listItems="${grant.alternateIdentifiers}">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.awardees"
                                  specifier="${specifier}-awardees"
                                  label="Awardee"
                                  listItems="${grant.awardees}"
                                  createPersonOrganizationTags="${true}"
                            cardText="The person(s) or organization(s) which received the funds supporting the project."
                            tagName="personComprisedEntity"
                                  isFirstRequired="false"
                                  showAddPersonButton="true"
                                  showAddOrganizationButton="true">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${grant}"
                                 label="${label}"
                                 id="${id}"
                                 cardText="An allocated sum of funds given by a government or other organization for a particular purpose."
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>


