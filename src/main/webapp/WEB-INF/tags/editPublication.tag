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
<%@ attribute name="publication" required="false"
              type="edu.pitt.isg.mdc.dats2_2.Publication" %>
<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="false"
              type="java.lang.String" %>
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${publication}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="A (digital) document made available by a publisher."
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>

<myTags:editNonZeroLengthString
        placeholder=" The name of the publication and its funding program."
        label="Title"
        string="${publication.title}"
        path="${path}.title"
        isRequired="${true}"
        isInputGroup="${true}"
        id="${specifier}-title"
        specifier="${specifier}-title">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.publicationVenue"
                                string="${publication.publicationVenue}"
                                specifier="${specifier}-publicationVenue"
                                id="${specifier}-publicationVenue"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                placeholder=" The name of the publication venue where the document is published if applicable."
                                label="Publication Venue">
</myTags:editNonZeroLengthString>
<myTags:editMasterUnbounded path="${path}.authors"
                                  specifier="${specifier}-authors"
                                  label="Authors"
                            addButtonLabel="Author"
                                  listItems="${publication.authors}"
                                  createPersonOrganizationTags="${true}"
                            tagName="personComprisedEntity"
                            cardText="The person(s) and/or organisation(s) responsible for the publication."
                                  isFirstRequired="${true}"
                                  showAddPersonButton="${true}"
                                  showAddOrganizationButton="${false}">
</myTags:editMasterUnbounded>
<myTags:editIdentifier path="${path}.identifier"
                       singleIdentifier="${publication.identifier}"
                       specifier="${specifier}-identifier"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       label="Identifier">
</myTags:editIdentifier>
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            addButtonLabel="Alternate Identifier"
                            path="${path}.alternateIdentifiers"
                            cardText="Information about an alternate identifier (other than the primary)."
                            listItems="${publication.alternateIdentifiers}"
                            tagName="identifier">
</myTags:editMasterUnbounded>
<myTags:editAnnotation path="${path}.type"
                       isUnboundedList="${false}"
                       specifier="${specifier}-type"
                       id="${specifier}-type"
                       cardText="Publication type, ideally delegated to an external vocabulary/resource."
                       annotation="${publication.type}"
                       label="Type">
</myTags:editAnnotation>

<myTags:editMasterUnbounded listItems="${publication.dates}"
                            label="Publication Dates"
                            addButtonLabel="Publication Date"
                            path="${path}.dates"
                            cardText="Relevant dates, the date of the publication must be provided."
                            tagName="date"
                            specifier="${specifier}-dates">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.acknowledges"
                            specifier="${specifier}-acknowledges"
                            listItems="${publication.acknowledges}"
                            cardText="The grant(s) which funded and supported the work reported by the publication."
                            tagName="grant"
                            addButtonLabel="Acknowledgment"
                            label="Acknowledges">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${publication}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="A (digital) document made available by a publisher."
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

