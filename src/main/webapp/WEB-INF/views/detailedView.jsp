<%--
  Created by IntelliJ IDEA.
  User: mas400
  Date: 5/14/18
  Time: 3:26 PM
  To change this template use File | Settings | File Templates.
--%>
<html>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<myTags:head title="MIDAS Digital Commons"/>

<myTags:header
        pageTitle="MIDAS Digital Commons"
        loggedIn="${loggedIn}"/>

<body id="detailed-view-body">
<div class="container">
    <div class="row">
        <div class="col-sm-12">
            <h3>${title}</h3>
            <hr>
            <h4>Description</h4>
            <span>${entryView.entry.description}</span>
        </div>


        <%--<div class="col-md-4 col-sm-12">--%>
        <%--<h4>Updated</h4>--%>
        <%--<h2>${entryView.entry.producedBy.startDate.date}</h2>--%>
        <%--</div>--%>

        <%--<div class="col-md-8 col-sm-12">--%>

        <%--</div>--%>
    </div>
</div>

<div class="container metadata-container">
    <div class="metadata-wrapper">
        <section>
            <div class="metadata-header-wrapper">
                <h2>About this Dataset</h2>
            </div>
            <div class="section-content">
                <dl class="metadata-column fancy">
                    <div>
                        <div class="metadata-section">
                            <div class="metadata-row">
                                <div class="metadata-pair">
                                    <dt class="metadata-pair-key">Updated</dt>
                                    <dd class="metadata-pair-value">August 27, 2015</dd>
                                </div>
                            </div>
                            <div class="metadata-row middle metadata-flex metadata-detail-groups">
                                <div class="metadata-detail-group">
                                    <dt class="metadata-detail-group-title">Data Last Updated</dt>
                                    <dd class="metadata-detail-group-value">June 19, 2013</dd>
                                </div>
                                <div class="metadata-detail-group">
                                    <dt class="metadata-detail-group-title">Metadata Last Updated</dt>
                                    <dd class="metadata-detail-group-value">August 27, 2015</dd>
                                </div>
                            </div>
                            <div class="metadata-row metadata-detail-groups">
                                <div class="metadata-detail-group">
                                    <dt class="metadata-detail-group-title">Date Created</dt>
                                    <dd class="metadata-detail-group-value">June 19, 2013</dd>
                                </div>
                            </div>
                        </div>
                        <hr aria-hidden="true">
                    </div>
                    <div class="metadata-section">
                        <div class="metadata-row metadata-flex">
                            <div class="metadata-pair">
                                <dt class="metadata-pair-key">Views</dt>
                                <dd class="metadata-pair-value">2,241</dd>
                            </div>
                            <div class="metadata-pair download-count">
                                <dt class="metadata-pair-key">Downloads</dt>
                                <dd class="metadata-pair-value">8,317</dd>
                            </div>
                        </div>
                    </div>
                    <hr aria-hidden="true">
                    <div class="metadata-section">
                        <div class="metadata-row metadata-flex metadata-detail-groups">
                            <div class="metadata-detail-group">
                                <dt class="metadata-detail-group-title">Data Provided by</dt>
                                <dd class="metadata-detail-group-value">PRAMS</dd>
                            </div>
                            <div class="metadata-detail-group">
                                <dt class="metadata-detail-group-title">Dataset Owner</dt>
                                <dd class="metadata-detail-group-value">Helen Ding</dd>
                            </div>
                        </div>
                        <button class="btn btn-sm btn-primary btn-block contact-dataset-owner"
                                data-modal="contact-form">Contact Dataset Owner
                        </button>
                    </div>
                </dl>
                <div class="metadata-column tables" style="padding-bottom: 0px;">
                    <div class="metadata-table"><h3 class="metadata-table-title">Common Core</h3>
                        <table class="table table-condensed table-borderless table-discrete table-striped">
                            <tbody>
                            <tr>
                                <td>Contact Email</td>
                                <td><span class="Linkify"><a href="mailto:cdcinfo@cdc.gov" rel="nofollow"
                                                             target="_blank">cdcinfo@cdc.gov</a></span></td>
                            </tr>
                            <tr>
                                <td>Contact Name</td>
                                <td><span class="Linkify">CDC INFO</span></td>
                            </tr>
                            <tr>
                                <td>Program Code</td>
                                <td><span class="Linkify">009:020</span></td>
                            </tr>
                            <tr>
                                <td>Bureau Code</td>
                                <td><span class="Linkify">009:00</span></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="metadata-table"></div>
                    <div class="metadata-table"><h3 class="metadata-table-title">Topics</h3>
                        <table class="table table-condensed table-borderless table-discrete table-striped">
                            <tbody>
                            <tr>
                                <td>Category</td>
                                <td>Pregnancy &amp; Vaccination</td>
                            </tr>
                            <tr>
                                <td>Tags</td>
                                <td>
                                    <div class="tag-list-container collapsible">
                                        <div class="tag-list" style="word-wrap: break-word;"><span><a
                                                href="/browse?tags=prams">prams</a><!-- react-text: 218 -->,
                                            <!-- /react-text --></span><span><a
                                                href="/browse?tags=flu shot">flu shot</a><!-- react-text: 221 -->,
                                            <!-- /react-text --></span><span><a href="/browse?tags=pregnant women">pregnant women</a>
                                            <!-- react-text: 224 -->, <!-- /react-text --></span><span><a
                                                href="/browse?tags=immunization">immunization</a>
                                            <!-- react-text: 227 --><!-- /react-text --></span>
                                            <button class="collapse-toggle more" style="display: none;">Show More
                                            </button>
                                            <button class="collapse-toggle less" style="display: none;">Show Less
                                            </button>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="metadata-table"><h3 class="metadata-table-title">Licensing and Attribution</h3>
                        <table class="table table-condensed table-borderless table-discrete table-striped">
                            <tbody>
                            <tr>
                                <td>License</td>
                                <td class="empty">The license for this dataset is unspecified</td>
                            </tr>
                            <tr>
                                <td>Source Link</td>
                                <td class="attribution"><a href="http://www.cdc.gov/prams/" target="_blank"
                                                           rel="nofollow external"><!-- react-text: 241 -->
                                    http://www.cdc.gov/prams/<!-- /react-text --><span
                                            class="icon-external-square"></span></a></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="metadata-table-toggle-group desktop" style="display: none;"><a
                            class="metadata-table-toggle more" tabindex="0" role="button">Show More</a><a
                            class="metadata-table-toggle less" tabindex="0" role="button">Show Less</a></div>
                    <div class="metadata-table-toggle-group mobile" style="display: none;">
                        <button class="btn btn-block btn-default metadata-table-toggle more mobile">Show More</button>
                        <button class="btn btn-block btn-default metadata-table-toggle less mobile">Show Less</button>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>


<script>
    $(document).ready(function () {
        toggleModalItems(${entryJson}, "${type}");
    });


</script>

<myTags:analytics/>

</body>

<myTags:footer/>

</html>
</title>
</head>
<body>

</body>
</html>
