<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<div class="metadata-table"><h5 class="sub-title-font">Examples of their application across types of digital
    resource: </h5>
    <div class="metadata-table"><h6 class="sub-title-font">my Zenodo Deposit for polyA (<a class="underline" target="_blank"
                                                                                           href="https://doi.org/10.5281/zenodo.47641">https://doi.org/10.5281/zenodo.47641</a>)
    </h6>
        <div class="border">
            <div class="metadata-table edit-form-group">
                <h7 class="sub-title-font">Test Query: '10.5281/zenodo.47641 orthology'</h7>
                <table class="table table-condensed table-borderless table-discrete table-striped">
                    <tbody>
                    <tr>
                        <td>
                            GOOGLE:
                        </td>
                        <td>
                            Pass (#1 hit)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            BING:
                        </td>
                        <td>
                            Fail (no hits)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Yahoo:
                        </td>
                        <td>
                            Fail (no hits)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Baidu:
                        </td>
                        <td>
                            Pass (#1 hit)
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="border">
            <div class="metadata-table edit-form-group">
                <h7 class="sub-title-font">Test Query: 'protein domain orthology RNA Processing'</h7>
                <table class="table table-condensed table-borderless table-discrete table-striped">
                    <tbody>
                    <tr>
                        <td>
                            GOOGLE:
                        </td>
                        <td>
                            Pass (Hit #13 )
                        </td>
                    </tr>
                    <tr>
                        <td>
                            BING:
                        </td>
                        <td>
                            Fail (not in top 40)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Yahoo:
                        </td>
                        <td>
                            Fail: (Not in top 40)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Baidu:
                        </td>
                        <td>
                            Pass (#1 Hit)
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="metadata-table"><h6 class="sub-title-font">myExperiment Workflow (<a class="underline" target="_blank"
                                                                                     href="http://www.myexperiment.org/workflows/2969.html">http://www.myexperiment.org/workflows/2969.html</a>)
    </h6>
        <div class="border">
            <div class="metadata-table edit-form-group">
                <h7 class="sub-title-font">Test Query: 'workflow common identifiers EMC ontology'</h7>
                <table class="table table-condensed table-borderless table-discrete table-striped">
                    <tbody>
                    <tr>
                        <td>
                            GOOGLE:
                        </td>
                        <td>
                            Pass (#2 and #5 hit)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            BING:
                        </td>
                        <td>
                            Fail (not in top 40, though OTHER workflows were found in top 10!)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Yahoo:
                        </td>
                        <td>
                            Fail (not in top 40, though other workflows found in top 10)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Baidu:
                        </td>
                        <td>
                            Pass (5/10 pages contained a link to the workflow, but the workflow itself was not
                            discovered)
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="metadata-table"><h6 class="sub-title-font">Jupyter notebook on GitHub (<a class="underline" target="_blank"
                                                                                          href="https://github.com/VidhyasreeRamu/GlobalClimateChange/blob/master/GlobalWarmingAnalysis.ipynb">https://github.com/VidhyasreeRamu/GlobalClimateChange/blob/master/GlobalWarmingAnalysis.ipynb</a>)
    </h6>
        <div class="border">
            <div class="metadata-table edit-form-group">
                <h7 class="sub-title-font">Test Query: 'github python climate change earth surface temperature'</h7>
                <table class="table table-condensed table-borderless table-discrete table-striped">
                    <tbody>
                    <tr>
                        <td>
                            GOOGLE:
                        </td>
                        <td>
                            Fail (not in top 40; other similar Jupyter notebooks found in github)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            BING:
                        </td>
                        <td>
                            Fail (not in top 40<%--... but MANY links to Microsoft Surface! LOL!--%>)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Yahoo:
                        </td>
                        <td>
                            Fail (not in top 40)
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Baidu:
                        </td>
                        <td>
                            Fail (not<%-- even a github hit--%> in top 40)
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
