<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>


<%--<myTags:softwareModalItem id="title" title="Title" hasHref="false"></myTags:softwareModalItem>--%>

<myTags:softwareModalItem id="identifier" title="Identifier" hasHref="false"></myTags:softwareModalItem>

<%--<myTags:softwareModalItem id="doi" title="DOI"></myTags:softwareModalItem>--%>

<myTags:softwareModalItem id="human-readable-synopsis" title="Human-readable synopsis"
                          hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="description" title="Description" hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="creator" title="" hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="landing-page" title="Landing page" hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="access-url" title="Access URL" hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="authorizations" title="Authorizations" hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="pathogens" title="Pathogens"></myTags:softwareModalItem>

<myTags:softwareModalItem id="locations" title="Locations"></myTags:softwareModalItem>

<myTags:softwareModalItem id="pathogen-coverage" title="Pathogen coverage"></myTags:softwareModalItem>

<myTags:softwareModalItem id="location-coverage" title="Location coverage"></myTags:softwareModalItem>

<myTags:softwareModalItem id="species-included" title="Species included"></myTags:softwareModalItem>

<myTags:softwareModalItem id="host-species-included" title="Host species included"></myTags:softwareModalItem>

<myTags:softwareModalItem id="population-species" title="Population species"></myTags:softwareModalItem>

<myTags:softwareModalItem id="control-measures" title="Control measures"></myTags:softwareModalItem>

<myTags:softwareModalItem id="developer" title=""></myTags:softwareModalItem>

<myTags:softwareModalItem id="version" title="Software version"></myTags:softwareModalItem>

<myTags:softwareModalItem id="human-readable-specification" title="Human readable specification"
                          hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="machine-readable-specification" title="Machine readable specification"
                          hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="validator" title="Validator" hasHref="true"></myTags:softwareModalItem>

<%--<myTags:softwareModalItem id="type" title="Type"></myTags:softwareModalItem>--%>

<myTags:softwareModalItem id="forecast-frequency" title="Frequency of forecast"></myTags:softwareModalItem>

<myTags:softwareModalItem id="diseases" title="Diseases"></myTags:softwareModalItem>

<myTags:softwareModalItem id="outcomes" title="Outcomes"></myTags:softwareModalItem>

<myTags:softwareModalItem id="region" title="Locations"></myTags:softwareModalItem>

<myTags:softwareModalItem id="forecasts" title="Forecasts"></myTags:softwareModalItem>

<myTags:softwareModalItem id="nowcasts" title="Nowcasts"></myTags:softwareModalItem>

<myTags:softwareModalItem id="web-application" title="Web application" hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="website" title="Website" hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="executables" title="Executables" hasHref="false"></myTags:softwareModalItem>

<%--<myTags:softwareModalItem id="data-input-formats" title="Formats for data input"></myTags:softwareModalItem>--%>

<myTags:softwareModalItem id="inputs" title="Inputs"></myTags:softwareModalItem>

<myTags:softwareModalItem id="isListOfInputsComplete" title="Is list of inputs complete"></myTags:softwareModalItem>

<%--<myTags:softwareModalItem id="data-output-formats" title="Formats for data output"></myTags:softwareModalItem>--%>

<myTags:softwareModalItem id="outputs" title="Outputs"></myTags:softwareModalItem>

<myTags:softwareModalItem id="isListOfOutputsComplete" title="Is list of outputs complete"></myTags:softwareModalItem>

<myTags:softwareModalItem id="visualization-type" title="Types of visualizations"></myTags:softwareModalItem>

<myTags:softwareModalItem id="platform" title="Platform, environment, and dependencies"></myTags:softwareModalItem>

<myTags:softwareModalItem id="grant" title="Associated grants"></myTags:softwareModalItem>

<myTags:softwareModalItem id="produced-by" title="Produced by"></myTags:softwareModalItem>

<myTags:softwareModalItem id="source-code" title="Link to code repository" hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="source-code-release" title="Source code release"
                          hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="documentation" title="Documentation" hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="rest-documentation" title="REST documentation" hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="end-point-prefix" title="REST endpoint prefix" hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="rest-source-code" title="REST service source code repository"
                          hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="soap-documentation" title="SOAP documentation" hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="soap-endpoint" title="SOAP endpoint" hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="soap-source-code" title="SOAP service source code repository"
                          hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="example-queries" title="Example queries" hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="project-source-code" title="Associated project source code repository"
                          hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="user-guides-and-manuals" title="User guides and manuals"
                          hasHref="true"></myTags:softwareModalItem>

<myTags:softwareModalItem id="license" title="License" hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="publications-about-release" title="Publications about this version"
                          hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="publications-that-used-release" title="Publications that used this version"
                          hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="spatial-coverage" title="Spatial coverage" hasHref="false"></myTags:softwareModalItem>

<myTags:softwareModalItem id="is-about" title="Is About" hasHref="false"></myTags:softwareModalItem>

