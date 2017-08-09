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

<table id="ncbi-table" class="display" cellspacing="0" width="100%">
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
<script>
    $(document).ready(function (){
        var entryApi = '${pageContext.request.contextPath}/entries/';
        var my = {
            '$': {
                hostSelect: $('#host-select'),
                pathogenSelect: $('#pathogen-select')
            }
        };

        my.$.hostSelect.change(onChangeHost);
        my.$.pathogenSelect.change(onChangePathogen);

        my.entryTable = $('#ncbi-table').DataTable({
            ajax: {
                url: urlSearch(),
                dataSrc: '_embedded.entries',
                deferRender: true,
                data: function (param) {
                    if(my.host)
                        param.hostIncluded = my.host;
                    if(my.pathogen)
                        param.pathogenCoverage = my.pathogen;
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

        function onChangeHost(){
            my.host = my.$.hostSelect.val();
            my.entryTable.ajax.reload();
        }

        function onChangePathogen(){
            my.pathogen = my.$.pathogenSelect.val();
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
            return linkHtml(data.id, name);

            function linkHtml(id, name) {
                return '<a href="' + entryApi + id + '">' + name + '</a>';
            }
        }
    });
</script>
</body>
</html>
