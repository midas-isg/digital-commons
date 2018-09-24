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
<%@ attribute name="tagName" required="true"
              type="java.lang.String" %>
<%@ attribute name="dataStandard" required="false"
              type="edu.pitt.isg.mdc.dats2_2.DataStandard" %>
<%@ attribute name="id" required="true"
              type="java.lang.String" %>
<%@ attribute name="isUnboundedList" required="true"
              type="java.lang.Boolean" %>


<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataStandard}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="top">
</myTags:editMasterElementWrapper>
<myTags:editIdentifier singleIdentifier="${dataStandard.identifier}"
                       label="Identifier"
                       specifier="${specifier}-identifier"
                       id="${specifier}-identifier"
                       isUnboundedList="${false}"
                       path="${path}.identifier">
</myTags:editIdentifier>
<myTags:editMasterUnbounded specifier="${specifier}-alternateIdentifiers"
                            label="Alternate Identifiers"
                            path="${path}.alternateIdentifiers"
                            listItems="${dataStandard.alternateIdentifiers}"
                            isRequired="${false}"
                            tagName="identifier">
</myTags:editMasterUnbounded>
<myTags:editNonZeroLengthString placeholder=" Name"
                                label="Name"
                                string="${dataStandard.name}"
                                specifier="${specifier}-name"
                                id="${specifier}-name"
                                isRequired="${true}"
                                isUnboundedList="${false}"
                                path="${path}.name">
</myTags:editNonZeroLengthString>
<myTags:editNonZeroLengthString specifier="${specifier}-description"
                                id="${specifier}-description"
                                string="${dataStandard.description}"
                                path="${path}.description"
                                label="Description"
                                isTextArea="${true}"
                                isRequired="${false}"
                                placeholder="Description">
</myTags:editNonZeroLengthString>
<myTags:editAnnotation annotation="${dataStandard.type}"
                       isRequired="${true}"
                       path="${path}.type"
                       specifier="${specifier}-type"
                       id="${specifier}-type"
                       isUnboundedList="${false}"
                       label="Type">
</myTags:editAnnotation>
<myTags:editMasterUnbounded listItems="${dataStandard.licenses}"
                            tagName="license"
                            specifier="${specifier}-licenses"
                            isRequired="${false}"
                            label="License"
                            path="${path}.licenses">
</myTags:editMasterUnbounded>
<myTags:editNonZeroLengthString label="Version"
                                placeholder=" Version"
                                specifier="${specifier}-version"
                                id="${specifier}-version"
                                string="${dataStandard.version}"
                                isUnboundedList="${false}"
                                isRequired="${false}"
                                path="${path}.version">
</myTags:editNonZeroLengthString>
<myTags:editMasterUnbounded listItems="${dataStandard.extraProperties}"
                            tagName="categoryValuePair"
                            isRequired="${false}"
                            specifier="${specifier}-extraProperties"
                            path="${path}.extraProperties"
                            label="Extra Properties">
</myTags:editMasterUnbounded>
<myTags:editMasterElementWrapper path="${path}"
                                 specifier="${specifier}"
                                 object="${dataStandard}"
                                 label="${label}"
                                 id="${id}"
                                 isUnboundedList="${isUnboundedList}"
                                 tagName="${tagName}"
                                 showTopOrBottom="bottom">
</myTags:editMasterElementWrapper>

