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
        <th>Title</th>
        <th>Type</th>
    </tr>
    </thead>
    <tfoot>
    <tr>
        <th>Title</th>
        <th>Type</th>
    </tr>
    </tfoot>
</table>
<script>
    $(document).ready(function (){
        var host = null;
        var pathogen = null;
        var entryTable = null;

        var ontologyEntryUrl = '/digital-commons/entries/search/by-ontology';
        entryTable = $('#ncbi-table').DataTable({
            ajax: {
                url: ontologyEntryUrl,
                dataSrc: '_embedded.entries'
            },
            columns: [ { data: 'content.entry.title'},
                {data: 'content.properties.type'} ],
            processing: true,
            serverSide: true,
            searching: false,

            bSort: false,
            fnServerData: dt2SpringDataRest
        });

        var $hostSelect = $('#host-select');
        $hostSelect.change(onChangeHost);
        var $pathogenSelect = $('#pathogen-select');
        $pathogenSelect.change(onChangePathogen);

        function dt2SpringDataRest(_, aoData, fnCallback, cfg) {
            var paramMap = simplify(aoData);
            var restParams = toPageableParams(paramMap);
            if(host)
                restParams.push({name: 'hostIncluded', value: host});
            if(pathogen)
                restParams.push({name: 'pathogenCoverage', value: pathogen});
            $.ajax({
                dataType: 'json',
                type: "GET",
                url: cfg.ajax.url,
                data: restParams,
                success: function(data) {
                    data.iTotalRecords = data.page.totalElements;
                    data.iTotalDisplayRecords = data.page.totalElements;
                    fnCallback(data);
                }
            });
        }

        function onChangeHost(){
            host = $hostSelect.val();
            entryTable.ajax.reload();
        }

        function onChangePathogen(){
            pathogen = $pathogenSelect.val();
            entryTable.ajax.reload();
        }

        function simplify(aoData) {
            var paramMap = {};
            for (var i = 0; i < aoData.length; i++) {
                paramMap[aoData[i].name] = aoData[i].value;
            }
            return paramMap;
        }

        function toPageableParams(paramMap) {
            var pageSize = paramMap.length;
            var start = paramMap.start;
            var pageNum = start / pageSize;
            return [    {name: "size", value: pageSize},
                        {name: "page", value: pageNum }];
        }
    });
</script>
</body>
</html>
