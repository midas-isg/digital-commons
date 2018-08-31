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
<myTags:editPersonComprisedEntity path="${path}.authors"
                                  specifier="${specifier}-authors"
                                  label="Author"
                                  personComprisedEntities="${publication.authors}"
                                  createPersonOrganizationTags="${true}"
                                  isFirstRequired="${true}"
                                  showAddPersonButton="${true}"
                                  showAddOrganizationButton="${false}">
</myTags:editPersonComprisedEntity>
<myTags:editIdentifier path="${path}.identifier"
                       singleIdentifier="${publication.identifier}"
                       specifier="${specifier}-identifier"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       label="Identifier">
</myTags:editIdentifier>
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            path="${path}.alternateIdentifiers"
                            cardText="Information about an alternate identifier (other than the primary)."
                            listItems="${publication.alternateIdentifiers}"
                            tagName="identifier">
</myTags:editMasterUnbounded>
<myTags:editNonZeroLengthString
        placeholder=" The name of the publication and its funding program."
        label="Title"
        string="${publication.title}"
        path="${path}.title"
        id="${specifier}-title"
        specifier="${specifier}-title">
</myTags:editNonZeroLengthString>
<myTags:editAnnotation path="${path}.type"
                       isUnboundedList="${false}"
                       specifier="${specifier}-type"
                       id="${specifier}-type"
                       cardText="Publication type, ideally delegated to an external vocabulary/resource."
                       annotation="${publication.type}"
                       label="Type">
</myTags:editAnnotation>
<myTags:editNonZeroLengthString path="${path}.publicationVenue"
                                string="${publication.publicationVenue}"
                                specifier="${specifier}-publicationVenue"
                                id="${specifier}-publicationVenue"
                                placeholder=" The name of the publication venue where the document is published if applicable."
                                label="Publication Venue">
</myTags:editNonZeroLengthString>
<myTags:editMasterUnbounded listItems="${publication.dates}"
                            label="Publication Date"
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
                            label="Acknowledges">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${publication}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="A (digital) document made available by a publisher."
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

