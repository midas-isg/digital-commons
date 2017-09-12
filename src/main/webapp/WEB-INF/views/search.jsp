<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

    <!-- LoDash JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.4/lodash.js"></script>

    <!-- forest-widget.js -->
    <link href="${pageContext.request.contextPath}/resources/css/forest-widget.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/resources/js/forest-widget.js"></script>

<body>
<%--<myTags:header--%>
        <%--pageTitle="Search"--%>
        <%--loggedIn="${loggedIn}"/>--%>

<div >
    <div id="retrievalTermsContainer">
        <div class=" panel panel-primary">
            <div class="panel-heading clearfix">
                <span class="pull-right">
                  <%--<button class="btn btn-info" ng-show="searchHidden" ng-click="searchHidden = false" hidden>Show Controls</button>--%>
                </span>
            </div>
            <div class="panel-body" ng-hide="searchHidden">
                <div class="row">
                    <%--<div class="col-md-1"></div>--%>
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <h4 class="content-title-font">Location</h4>
                        <div id="location-widget" style="max-height: 250px"></div>
                    </div>
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <h4 class="content-title-font">Pathogen</h4>
                        <div id="pathogen-widget" style="max-height: 250px"></div>
                    </div>
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <h4 class="content-title-font">Host</h4>
                        <div id="host-widget" style="max-height: 250px"></div>
                    </div>
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <h4 class="content-title-font">Control Measure</h4>
                        <div id="control-measure-widget" style="max-height: 250px"></div>
                    </div>
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <h4 class="content-title-font">Type</h4>
                        <div id="type-widget" style="max-height: 250px"></div>
                    </div>
                </div>
            </div>
            <div class="panel-footer">
                <button id="search-button" type="submit" ng-click="initiateSearch()" class="btn btn-primary pull-right">Search</button>
                <div class="clearfix"></div>
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
                <div class="panel-heading clearfix">Software matching by input and output formats
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
        var v = {
           /* h: '250px',
            w2: '175px',
            w: '400px'*/
        };
        var my = {
            pathogenWidget: FOREST_WIDGET_CREATOR.create('pathogen-widget', v.w, v.h),
            hostWidget: FOREST_WIDGET_CREATOR.create('host-widget', v.w, v.h),
            locationWidget: FOREST_WIDGET_CREATOR.create('location-widget', v.w, v.h),
            controlMeasureWidget: FOREST_WIDGET_CREATOR.create('control-measure-widget', v.w, v.h),
            typeWidget: FOREST_WIDGET_CREATOR.create('type-widget', v.w, v.h),
            entryPayload: {},
            '$': {
//                softwareMatchButton: $('#software-match-button'),
                searchButton: $('#search-button')
            }
        };

        fillForest(my.pathogenWidget, null, JSON.parse('${pathogens}'));
        fillForest(my.hostWidget, null, JSON.parse('${hosts}'));
        fillForest(my.locationWidget, null, JSON.parse('${locations}'));
        fillForest(my.controlMeasureWidget, null, JSON.parse('${controlMeasures}'));
        <c:forEach var="it" items="${types}">
            my.typeWidget.addNode({id: '${it[0]}', label: '${it[1]}'});
        </c:forEach>

        function fillForest(widget, parent, trees) {
            var node, it, tree;
            var i = 0;
            for (; i < trees.length; i++){
                tree = trees[i];
                it = tree.self;
                node = widget.addNode({id: it.iri || it.id, label: it.name, parent: parent});
                fillForest(widget, node, tree.children);
            }
        }

        //my.$.softwareMatchButton.click(onClickSoftwareMatchButton);
        my.$.searchButton.click(reloadEntryTable);

        my.entryTable = $('#entry-table').DataTable({
            ajax: {
                url: urlSearch(),
                type: "POST",
                dataSrc: dataSrcAvoidingUndefined,
                deferRender: true,
                contentType: 'application/json',
                data: function () {
                    return JSON.stringify(my.entryPayload);
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
            my.entryPayload = {
                hosts:  filter(my.hostWidget.getUserSelectedNodes()),
                pathogens: filter(my.pathogenWidget.getUserSelectedNodes()),
                controlMeasures: filter(my.controlMeasureWidget.getUserSelectedNodes()),
                locations: filter(my.locationWidget.getUserSelectedNodes()),
                types: filter(my.typeWidget.getUserSelectedNodes())
            };
            my.entryTable.ajax.reload();

            function filter(array) {
                if (! array || array.length === 0)
                    return array;
                return _.map(array, function(o) {
                    return _.pick(o, ['id', 'includeAncestors', 'includeDescendants']);
                });
            }
        }

        function urlSearch(size) {
            return entryApi + 'search/via-ontology?size=' + (size || 1000000);
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
