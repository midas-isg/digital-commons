<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>
<fmt:setBundle basename="cardText" />

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

<fmt:message key="dataset.publication" var="publicationPlaceHolder" />
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${publication}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 cardText="${publicationPlaceHolder}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>


<fmt:message key="dataset.publication.title" var="titlePlaceHolder" />
<myTags:editNonZeroLengthString
        placeholder="${titlePlaceHolder}"
        label="Title"
        string="${publication.title}"
        path="${path}.title"
        isRequired="${true}"
        isInputGroup="${true}"
        id="${specifier}-title"
        updateCardTabTitleText="${isUnboundedList}"
        specifier="${specifier}-title">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.publication.publicationVenue" var="venuePlaceHolder" />
<myTags:editNonZeroLengthString path="${path}.publicationVenue"
                                string="${publication.publicationVenue}"
                                specifier="${specifier}-publicationVenue"
                                id="${specifier}-publicationVenue"
                                isRequired="${true}"
                                isInputGroup="${true}"
                                placeholder="${venuePlaceHolder}"
                                label="Publication Venue">
</myTags:editNonZeroLengthString>

<fmt:message key="dataset.publication.authors" var="authorsPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.authors"
                            specifier="${specifier}-authors"
                            label="Authors"
                            addButtonLabel="Author"
                            listItems="${publication.authors}"
                            createPersonOrganizationTags="${true}"
                            tagName="personComprisedEntity"
                            cardText="${authorsPlaceHolder}"
                            cardIcon="fas fa-users"
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

<fmt:message key="dataset.alternateIdentifier" var="alternateIdentifierPlaceHolder" />
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            addButtonLabel="Alternate Identifier"
                            path="${path}.alternateIdentifiers"
                            cardText="${alternateIdentifierPlaceHolder}"
                            cardIcon="fa fa-id-card"
                            listItems="${publication.alternateIdentifiers}"
                            tagName="identifier">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.publication.annotation" var="annotationPlaceHolder" />
<myTags:editAnnotation path="${path}.type"
                       isUnboundedList="${false}"
                       specifier="${specifier}-type"
                       id="${specifier}-type"
                       cardText="${annotationPlaceHolder}"
                       cardIcon="far fa-bookmark"
                       annotation="${publication.type}"
                       label="Type">
</myTags:editAnnotation>

<fmt:message key="dataset.publication.dates" var="datesPlaceHolder" />
<myTags:editMasterUnbounded listItems="${publication.dates}"
                            label="Publication Dates"
                            addButtonLabel="Publication Date"
                            path="${path}.dates"
                            cardText="${datesPlaceHolder}"
                            cardIcon="far fa-calendar-alt"
                            tagName="date"
                            specifier="${specifier}-dates">
</myTags:editMasterUnbounded>

<fmt:message key="dataset.publication.acknowledges" var="acknowledgesPlaceHolder" />
<myTags:editMasterUnbounded path="${path}.acknowledges"
                            specifier="${specifier}-acknowledges"
                            listItems="${publication.acknowledges}"
                            cardText="${acknowledgesPlaceHolder}"
                            cardIcon="fas fa-university"
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
                                 cardText="${publicationPlaceHolder}"
                                 showCardFooter="${true}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

