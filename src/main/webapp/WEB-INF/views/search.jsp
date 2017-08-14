<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/v/dt/dt-1.10.15/datatables.min.css"/>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script type="text/javascript" src="//cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>

</head>
<body>
<span>Host:</span>
<select id="host-select">
    <option value="${null}">Any</option>
    <c:forEach var="it" items="${hosts}">
        <option value="${it.id}">${it.name}</option>
    </c:forEach>
</select>

<span>Pathogen:</span>
<select id="pathogen-select">
    <option value="${null}">Any</option>
    <c:forEach var="it" items="${pathogens}">
        <option value="${it.id}">${it.name}</option>
    </c:forEach>
</select>

<span>Type:</span>
<select id="type-select">
    <option value="${null}">Any</option>
    <c:forEach var="it" items="${types}">
        <option value="${it[0]}">${it[1]}</option>
    </c:forEach>
</select>

<table id="entry-table" class="display" cellspacing="0" width="100%">
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
<%--<button id="software-match-button">Software matching by input and output formats</button>--%>
<table id="software-table" class="display" cellspacing="0" width="100%">
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
        <th>Type</th>
        <th>Sink Software</th>
    </tr>
    </tfoot>
</table>
<script>
    $(document).ready(function (){
        var entryApi = '${pageContext.request.contextPath}/entries/';
        var my = {
            '$': {
//                softwareMatchButton: $('#software-match-button'),
                hostSelect: $('#host-select'),
                pathogenSelect: $('#pathogen-select'),
                typeSelect: $('#type-select')
            }
        };

        //my.$.softwareMatchButton.click(onClickSoftwareMatchButton);
        my.$.hostSelect.change(reloadEntryTable);
        my.$.pathogenSelect.change(reloadEntryTable);
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
            var result = data._embedded && data._embedded.entries;
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
</body>
</html>
