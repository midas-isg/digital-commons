<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="function" uri="/WEB-INF/customTag.tld" %>

<%@ attribute name="label" required="true"
              type="java.lang.String" %>
<%@ attribute name="path" required="true"
              type="java.lang.String" %>
<%@ attribute name="specifier" required="true"
              type="java.lang.String" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@attribute name="dataRepository" required="false"
             type="edu.pitt.isg.mdc.dats2_2.DataRepository" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataRepository}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${false}"
                                 cardText="A repository or catalog of datasets. It could be a primary repository or a repository that aggregates data existing in other repositories."
                                 tagName="dataRepository"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editNonZeroLengthString placeholder=" The name of the data repository."
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                label="Name"
                                string="${dataRepository.name}"
                                path="${path}.name"
                                isRequired="${true}">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString path="${path}.description"
                                string="${dataRepository.description}"
                                specifier="${specifier}-description"
                                id="${specifier}-description"
                                isTextArea="${true}"
                                isRequired="${true}"
                                placeholder=" A textual narrative comprised of one or more statements describing the data repository."
                                label="Description">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString label="Version"
                                placeholder=" A release point for the dataset when applicable."
                                specifier="${specifier}-version"
                                id="${specifier}-version"
                                isRequired="${true}"
                                string="${dataRepository.version}"
                                path="${path}.version">
</myTags:editNonZeroLengthString>
<myTags:editIdentifier path="${path}.identifier"
                       singleIdentifier="${dataRepository.identifier}"
                       id="${specifier}-identifier"
                       specifier="${specifier}-identifier"
                       isUnboundedList="${false}"
                       label="Identifier">
</myTags:editIdentifier>
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            path="${path}.alternateIdentifiers"
                            cardText="Information about an alternate identifier (other than the primary)."
                            tagName="identifier"
                            listItems="${dataRepository.alternateIdentifiers}">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.scopes"
                            specifier="${specifier}-scopes"
                            listItems="${dataRepository.scopes}"
                            cardText="Information about the nature of the datasets in the repository, ideally from a controlled vocabulary or ontology (e.g. transcription profile, sequence reads, molecular structure, image, DNA sequence, NMR spectra)."
                            tagName="annotation"
                            label="Scopes">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.types"
                            specifier="${specifier}-types"
                            listItems="${dataRepository.types}"
                            cardText="A descriptor (ideally from a controlled vocabulary) providing information about the type of repository, such as primary resource or aggregator."
                            tagName="annotation"
                            label="Types">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.licenses"
                            listItems="${dataRepository.licenses}"
                            label="License"
                            cardText="The terms of use of the data repository."
                            tagName="license"
                            specifier="${specifier}-licenses">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.publishers"
                                  specifier="${specifier}-publishers"
                                  label="Publisher"
                                  listItems="${dataRepository.publishers}"
                                  isFirstRequired="false"
                                  createPersonOrganizationTags="true"
                            cardText="he person(s) or organization(s) responsible for the repository and its availability."
                            tagName="personComprisedEntity"
                                  showAddPersonButton="true"
                                  showAddOrganizationButton="true">
</myTags:editMasterUnbounded>
<myTags:editMasterUnbounded path="${path}.access"
                            specifier="${specifier}-access"
                            listItems="${dataRepository.access}"
                            cardText="The information about access modality for the data repository."
                            tagName="access"
                            isRequired="${false}"
                            label="Access">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataRepository}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${false}"
                                 cardText="A repository or catalog of datasets. It could be a primary repository or a repository that aggregates data existing in other repositories."
                                 tagName="dataRepository"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>
