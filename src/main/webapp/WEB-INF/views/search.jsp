<!doctype html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>

<html>
<head>
    <myTags:head title="MIDAS Digital Commons"/>
    <%--<script src="${pageContext.request.contextPath}/resources/js/commons.js"></script>--%>
    <script src="${pageContext.request.contextPath}/resources/js/lodash.min.js"></script>
        <%--pageTitle="Search"--%>
    <myTags:header
            pageTitle="MIDAS Digital Commons"
            loggedIn="${loggedIn}"
            addEntry="${true}"
    />
    <!-- forest-widget.js -->
    <link href="${pageContext.request.contextPath}/resources/css/forest-widget.css" rel="stylesheet">
    <%--<script src="${pageContext.request.contextPath}/resources/js/forest-widget.js"></script>--%>
    <script src="${pageContext.request.contextPath}/resources/js/forest-widget.min.js"></script>
        <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.19/css/dataTables.bootstrap4.min.css">

    <myTags:analytics/>
<body id="commons-body">

<myTags:softwareModal/>

<div class="container-fluid">
    <div id="retrievalTermsContainer">
        <div class=" panel panel-primary">
            <div class="panel-body" ng-hide="searchHidden">
                <div class="row">
                    <%--<div class="col-md-1"></div>--%>
                    <div class="col-md-4 col-sm-6">
                        <h4 class="content-title-font">Location</h4>
                        <div id="location-widget" style="max-height: 250px; height: 200px; min-height: 130px"></div>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <h4 class="content-title-font">Pathogen</h4>
                        <div id="pathogen-widget" style="max-height: 250px; height: 200px; min-height: 130px"></div>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <h4 class="content-title-font">Host</h4>
                        <div id="host-widget" style="max-height: 250px; height: 200px; min-height: 130px"></div>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <h4 class="content-title-font">Control Measure</h4>
                        <div id="control-measure-widget"
                             style="max-height: 250px; height: 200px; min-height: 130px"></div>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <h4 class="content-title-font">Type</h4>
                        <div id="type-widget" style="max-height: 250px; height: 200px; min-height: 130px"></div>
                    </div>
                </div>
            </div>
            <div class="panel-footer">
                <span id="search-query-text" class="pull-left" hidden="true"></span>
                <button id="search-button" type="submit" ng-click="initiateSearch()" class="btn btn-default pull-right">
                    Search
                </button>
                <div class="clearfix"></div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- This is the results panel -->
        <div class="col-md-12 font-size-16">
            <h3 class="title-font" id="subtitle">
                Results
            </h3>
            <table id="resultTable" datatable="ng" class="table table-striped table-bordered" dt-options="dtOptions"
                   dt-columns="dtColumns">
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
        <div class="col-md-12 font-size-16">
            <h3 class="title-font">
                Software matching by input and output formats
            </h3>
            <table id="optionTable" datatable="ng" class="table table-striped table-bordered" dt-options="dtOptions"
                   dt-columns="dtColumns">
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
<br>
<myTags:footer/>
</body>

<script>
    $(document).ready(function (){
        var entryApi = '${pageContext.request.contextPath}/entries/';

        var my = {
            pathogenWidget: FOREST_WIDGET_CREATOR.create('pathogen-widget'),
            hostWidget: FOREST_WIDGET_CREATOR.create('host-widget'),
            locationWidget: FOREST_WIDGET_CREATOR.create('location-widget'),
            controlMeasureWidget: FOREST_WIDGET_CREATOR.create('control-measure-widget'),
            typeWidget: FOREST_WIDGET_CREATOR.create('type-widget'),
            entryPayload: {},
            '$': {
//                softwareMatchButton: $('#software-match-button'),
                searchButton: $('#search-button'),
                searchQueryText: $('#search-query-text')
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
            processing: true,
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
            my.$.searchQueryText.text(text(my.entryPayload));
            my.entryTable.ajax.reload();

            function filter(array) {
                if (! array || array.length === 0)
                    return array;
                return _.map(array, function(o) {
                    return _.pick(o, ['id', 'includeAncestors', 'includeDescendants', 'label']);
                });
            }

            function text(entryPayload) {
                return 'DEBUG: ' + JSON.stringify(entryPayload);
                //return [nodesText('hosts', entryPayload)].join(' + ')
            }

            /*function nodesText(label, entryPayload) {
                nodes = entryPayload[label];
                if (nodes.length == 0)
                    return '(' + label + ': Any' + ')'

            }

            function nodeText(node) {
                return node.lable + '(' description(node) + ')';
            }
            function description(node) {
                if (node.includeAncestors && node.includeDescendants)
                    return 'including both Ancestors and Descendants'

            }*/
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
        }

        function linkHtml(id, rev, name) {
            return '<a href="#" onclick=\'' + "getDataOpenModal(" + id + "," + rev + ")" + '\'>' + name + '</a>';
        }
    });
</script>
</html>
