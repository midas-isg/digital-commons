<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="libraryViewerUrl" required="true"
              type="java.lang.String"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<script>
    $(document).ready(function () {
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : ${libraryViewerUrl} + "collectionsJson/",
            dataType : 'json',
            headers : {
                "Authorization" : "JWT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJadzRjM1FiMzBNQ2w3eUpsNjNjWHppbGR1RTdOb05SdSIsImlhdCI6MTQ3Njg5MzM4MiwianRpIjoiMzExZGE3MDJkM2QzMTNkMDY3N2Y0NjVhYzliZDk2ODQ5IiwiaXNzIjoiWnc0YzNRYjMwTUNsN3lKbDYzY1h6aWxkdUU3Tm9OUnUiLCJzdWIiOiJsaWJyYXJ5Vmlld2VyIiwicm9sZXMiOlsiSVNHX1VTRVIiLCJJU0dfQURNSU4iXX0.yN5JJjGUF15WCwnvw084B-4AGi7cMMRU5qI6ZiT5C1o"
            },
            timeout : 100000,
            success : function(data) {
                var $dataAndKnowledgeTree = $('#data-and-knowledge-treeview').treeview({
                    data: getDataAndKnowledgeTree(data, ${libraryViewerUrl}),
                });
                return data;
            },
            error : function(e) {
                console.log(data);
                console.log("ERROR: ", e);
            },
            complete : function(e) {
                $('#data-and-knowledge-treeview').on('nodeSelected', function(event, data) {
                    if(data.url != null && data.state.selected == true) {
                        window.location.href = data.url, '_blank';
                    }
                });
                console.log("DONE");
            }
        });
    });

</script>

