<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>

<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <myTags:favicon></myTags:favicon>

    <link href="${pageContext.request.contextPath}/resources/css/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/v/dt/dt-1.10.15/datatables.min.css"/>
    <title>Search - MIDAS Digital Commons</title>

    <!-- jQuery imports -->
    <script src="https://code.jquery.com/jquery-2.1.3.min.js"
            integrity="sha256-ivk71nXhz9nsyFDoYoGf2sbjrR9ddh+XDkCcfZxjvcM=" crossorigin="anonymous"></script>

    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/resources/js/tether.min.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap/3.3.6/bootstrap.min.js" defer></script>

    <script>var ctx = "${pageContext.request.contextPath}"</script>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script type="text/javascript" src="//cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>


<body>
<%--<myTags:header--%>
        <%--pageTitle="Search"--%>
        <%--loggedIn="${loggedIn}"/>--%>

<div class="container">
    <div id="retrievalTermsContainer">
        <div class=" panel panel-primary">
            <div class="panel-heading clearfix">
        <span class="pull-right">
          <%--<button class="btn btn-info" ng-show="searchHidden" ng-click="searchHidden = false" hidden>Show Controls</button>--%>
        </span>
            </div>
            <div class="panel-body" ng-hide="searchHidden">
                <div class="row">
                    <div class="col-xs-12">
                        <h4>MDC Search</h4>
                        <table class="table">
                            <tbody><tr>
                                <td>Pathogen</td>
                                <td>
                                    <select id="pathogen-select" type="text" class="form-control">
                                        <option value="${null}">Any</option>
                                        <c:forEach var="it" items="${pathogens}">
                                            <option value="${it.id}">${it.name}</option>
                                        </c:forEach>
                                    </select>
                                </td>

                                <td>Host</td>
                                <td>
                                    <select id="host-select" type="text" class="form-control">
                                        <option value="${null}">Any</option>
                                        <c:forEach var="it" items="${hosts}">
                                            <option value="${it.id}">${it.name}</option>
                                        </c:forEach>
                                    </select>
                                </td>

                                <td>Location</td>
                                <td>
                                    <select id="location-select" type="text" class="form-control">
                                        <option value="${null}">Any</option>
                                        <c:forEach var="it" items="${locations}">
                                            <option value="${it.alc}">${it.name}</option>
                                        </c:forEach>
                                    </select>
                                </td>

                                <td>Control measure</td>
                                <td>
                                    <select id="control-measure-select" type="text" class="form-control">
                                        <option value="${null}">Any</option>
                                        <c:forEach var="it" items="${controlMeasures}">
                                            <option value="${it.id}">${it.name}</option>
                                        </c:forEach>
                                    </select>
                                </td>

                                <td>Type</td>
                                <td>
                                    <select id="type-select" type="text" class="form-control">
                                        <option value="${null}">Any</option>
                                        <c:forEach var="it" items="${types}">
                                            <option value="${it[0]}">${it[1]}</option>
                                        </c:forEach>
                                    </select>
                                </td>

                            </tr>
                            </tbody>
                        </table>
                        <button type="submit" ng-click="initiateSearch()" class="btn btn-primary pull-right">Search</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- This is the premade queries -->
        <div>
            <%--<div class=" panel panel-primary">--%>
                <%--<div class="panel-body" ng-hide="searchHidden">--%>
                    <%--<div class="row">--%>
                        <%--<div class="col-xs-12">--%>
                            <%--<h4>Potentially interoperable data and software combinations</h4>--%>
                            <%--<div class="radio">--%>
                                <%--<label><input type="radio" name="option" value="1"> Dataset and software</label>--%>
                                <%--<label><input type="radio" name="option" value="2"> Software matching by input and output formats</label>--%>
                                <%--<br>--%>
                            <%--</div>--%>
                            <%--<button type="submit" ng-click="initiateDefaultSearch()" class="btn btn-primary pull-right">Search</button>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>

            <!-- This is the results panel -->
            <div class="panel panel-primary ng-hide" id="resultsPanel" ng-show="showSearch">
                <div class="panel-heading clearfix">Results
                    <div class="pull-right">
                    </div>
                </div>
                <table id="resultTable" datatable="ng" class="table table-striped table-bordered" dt-options="dtOptions" dt-columns="dtColumns">
                </table>
                <table id="entry-table" class="display table table-striped table-bordered" cellspacing="0" width="100%">
                    <thead>
                    <tr>
                        <th>Title/Name</th>
                        <th>Type</th>
                    </tr>
                    </thead>
                    <tfoot>
                    <tr>
                        <th>Title/Name</th>
                        <th>Type</th>
                    </tr>
                    </tfoot>
                </table>
            </div>

            <!-- Option one table -->
            <div class="panel panel-primary ng-hide" id="option1Panel" ng-show="showOptionSearch">
                <div class="panel-heading clearfix">Results
                    <div class="pull-right">
                    </div>
                </div>
                <table id="optionTable" datatable="ng" class="table table-striped table-bordered" dt-options="dtOptions" dt-columns="dtColumns">
                </table>
                <%--<button id="software-match-button">Software matching by input and output formats</button>--%>
                <table id="software-table" class="display table table-striped table-bordered" cellspacing="0" width="100%">
                    <thead>
                    <tr>
                        <th>Source Software</th>
                        <th>Connected via</th>
                        <th>Sink Software</th>
                    </tr>
                    </thead>
                    <tfoot>
                    <tr>
                        <th>Source Software</th>
                        <th>Connected via</th>
                        <th>Sink Software</th>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>
<myTags:footer/>
</body>

<script>
    $(document).ready(function (){
        var entryApi = '${pageContext.request.contextPath}/entries/';
        var my = {
            '$': {
//                softwareMatchButton: $('#software-match-button'),
                hostSelect: $('#host-select'),
                pathogenSelect: $('#pathogen-select'),
                controlMeasureSelect: $('#control-measure-select'),
                locationSelect: $('#location-select'),
                typeSelect: $('#type-select')
            }
        };

        //my.$.softwareMatchButton.click(onClickSoftwareMatchButton);
        my.$.hostSelect.change(reloadEntryTable);
        my.$.pathogenSelect.change(reloadEntryTable);
        my.$.controlMeasureSelect.change(reloadEntryTable);
        my.$.locationSelect.change(reloadEntryTable);
        my.$.typeSelect.change(reloadEntryTable);

        my.entryTable = $('#entry-table').DataTable({
            ajax: {
                url: urlSearch(),
                dataSrc: dataSrcAvoidingUndefined,
                deferRender: true,
                data: function (param) {
                    if(my.host)
                        param.hostId = my.host;
                    if(my.pathogen)
                        param.pathogenId = my.pathogen;
                    if(my.controlMeasure)
                        param.controlMeasureId = my.controlMeasure;
                    if(my.location)
                        param.locationId = my.location;
                    if(my.type)
                        param.type = my.type;
                }
            },
            columns: [
                 { data: wholeRow, render: renderLinkWithTitleOrName },
                { data: 'content.properties.type', render: function(data){
                    return data.replace(/.*\./, '').replace(/([A-Z])/g, ' $1').trim();
                } }
            ],
            processing: true
        });

        $('#software-table').DataTable({
            ajax: {
                url: entryApi + 'software-matched',
                deferRender: true,
                dataSrc: function (data) {
                    return data;
                }
            },
            columns: [
                { data: 'sourceSoftwareName'},
                { data: 'linkDataFormatName'},
                { data: 'sinkSoftwareName'}
            ],
            processing: true
        });

        function dataSrcAvoidingUndefined(data) {
            var result = data.content;
            if (result)
                return result;
            return [];
        }

//        function onClickSoftwareMatchButton(){
//        }
//
        function reloadEntryTable(){
            my.host = my.$.hostSelect.val();
            my.pathogen = my.$.pathogenSelect.val();
            my.controlMeasure = my.$.controlMeasureSelect.val();
            my.location = my.$.locationSelect.val();
            my.type = my.$.typeSelect.val();
            my.entryTable.ajax.reload();
        }

        function urlSearch(size) {
            return entryApi + 'search/by-ontology?size=' + (size || 1000000);
        }

        function wholeRow(row){
            return row;
        }

        function renderLinkWithTitleOrName(data) {
            var entry = data.content.entry;
            var name = entry.title || entry.name || '<i>N/A</i>';
            return linkHtml(data.id.entryId, data.id.revisionId, name);

            function linkHtml(id, rev, name) {
                return '<a href="' + entryApi + id + '/' + rev + '">' + name + '</a>';
            }
        }
    });
</script>
</html>
