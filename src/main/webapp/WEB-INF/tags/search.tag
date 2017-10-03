<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="col-md-12">
    <h3 class="title-font" id="subtitle">
        Search
    </h3>

    <iframe class="frame" scrolling="yes" allowfullscreen id="searchFrame"></iframe>


    <script>
        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            var target = $(e.target).attr("href") // activated tab
            if(target == '#search') {
                $('iframe#searchFrame').attr('src', 'http://mdcsearchdev.onbc.io/#/');
            }
        });
    </script>
</div>