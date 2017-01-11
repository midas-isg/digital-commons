<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags"%>
<%@ attribute name="libraryViewerUrl" required="true"
              type="java.lang.String"%>
<%@ attribute name="libraryViewerToken" required="true"
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
                "Authorization" : ${libraryViewerToken}
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

