/**
 * Created by jdl50 on 1/6/17.
 */
//https://github.com/jonmiles/bootstrap-treeview

//https://raw.githubusercontent.com/jonmiles/bootstrap-treeview/master/public/js/bootstrap-treeview.js
//https://rawgit.com/jonmiles/bootstrap-treeview/master/public/js/bootstrap-treeview.js

//https://raw.githubusercontent.com/jonmiles/bootstrap-treeview/master/public/css/bootstrap-treeview.css
//https://rawgit.com/jonmiles/bootstrap-treeview/master/public/css/bootstrap-treeview.css

// Dependencies
//Bootstrap v3.3.4 (>= 3.0.0)
//jQuery v2.1.3 (>= 1.9.0)

/*var dataAugmentedPublications = [{
    text: "Drake Paper 1"}, {text:"Drake Paper 2"}
];*/

var dataAugmentedPublications = [];
var software = [];


var standardEncodingTree = {
   text: "Standards for encoding data",
    nodes: [{
        text: "<div class=\"node-with-margin\">Apollo location codes</div>",
        url: "https://betaweb.rods.pitt.edu/ls"
    },
        {
            text: "<div class=\"node-with-margin\">Apollo XSD</div>",
            url: "https://github.com/ApolloDev/apollo-xsd-and-types"
        },
        {
            text: "<div class=\"node-with-margin\">NCBI Taxon identifiers</div>",
            url: "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi"
        },
        {
            text: "<div class=\"node-with-margin\">SNOMED CT codes</div>",
            url: "https://nciterms.nci.nih.gov/ncitbrowser/pages/vocabulary.jsf?dictionary=SNOMED%20Clinical%20Terms%20US%20Edition"
        },
        {
            text: "<div class=\"node-with-margin\">LOINC codes</div>",
            url: "http://loinc.org/"
        },
        {
            text: "<div class=\"node-with-margin\">Vaccine Ontology identifiers</div>",
            url: "http://www.violinet.org/vaccineontology/"
        },
        {
            text: "<div class=\"node-with-margin\">RxNorm codes</div>",
            url: "https://www.nlm.nih.gov/research/umls/rxnorm/"
    }]
};

function getDataAndKnowledgeTree(libraryData, syntheticEcosystems, syntheticEcosystemsByRegion, libraryViewerUrl, contextPath) {
    var collections = [];
    libraryViewerUrl = libraryViewerUrl + "main/";

    collections.push(syntheticEcosystems, syntheticEcosystemsByRegion,
        {text: "Disease surveillance data", nodes: [{text: "<div class=\"node-with-margin\">Zika data repository</div>", url:"https://zenodo.org/record/192153#.WIEKNLGZNcA"}, {text: "Tycho", nodes:[{text: "<div class=\"grandnode-with-margin\">" + getPopover(contextPath + "/resources/img/tycho.jpg", 'Measles incidence') + "</div>"}]}]});


    if(libraryData != null) {
        $.each(libraryData, function (index, value) {
            var url;
            if (index.includes("Epidemic")) {
                url = libraryViewerUrl + "epidemic/";
            } else if (index.includes("Case series")) {
                url = libraryViewerUrl + "caseSeries/"
            } else {
                url = libraryViewerUrl + "infectiousDiseaseScenario/";
            }
            var nodeLevel1 = [];
            $.each(value, function (index, value) {
                var nodeLevel2 = [];
                $.each(value, function (index, value) {
                    //var externalbutton = "<button type='button'  id='" + url+value.urn + "'  class='btn btn-primary pull-right' onclick='openViewer(this.id)'>" +
                    //     "<i class='fa fa-external-link'></i></button>";
                    //var modalbutton = "<button type='button'  id='" + url+value.urn + "'  class='btn btn-primary pull-right' onclick='openModal(this.id)'>" +
                    //     "<i class='fa fa-info-circle'></i></button>";

                    nodeLevel2.push({
                        text: "<div class=\"grandnode-with-margin\">" + value.name + "<div>",
                        url: url + value.urn
                    });
                });
                nodeLevel1.push({text: index, nodes: nodeLevel2});
            });

            collections.push({text: index, nodes: nodeLevel1});

        });
    }

    collections.push(standardEncodingTree);

    return collections;
}

function openViewer(url) {
    window.open(url);
}

function openModal(url) {
    $('#pageModal').modal('show').find('.modal-body').attr('src', url);
    // $('#pageModal').modal('show').find('.modal-body').load(url);

}

function formatLocation(location) {
    if(location.includes('_')) {
        var splitLocationNames = location.split('_');
    } else {
        var splitLocationNames = location.split(' ');
    }

    for(var i = 0; i < splitLocationNames.length; i++) {
        var characterIndex = 0;
        if(splitLocationNames[i].charAt(0) == '(') {
            characterIndex = 1;
        }

        if(splitLocationNames[i].replace(/["'\(\)]/g, "") != 'of') {        // remove parentheses and check for 'of'
            splitLocationNames[i] = splitLocationNames[i].charAt(characterIndex).toUpperCase() + splitLocationNames[i].slice(characterIndex + 1);

            if(characterIndex == 1) {       // add back leading parentheses if we removed it
                splitLocationNames[i] = '(' + splitLocationNames[i];
            }
        }
    }

    return splitLocationNames.join(' ');
}

function openSoftwareInfo(contextPath, id) {
    location.href = contextPath + "/main/software/" + id;
}

function openLibraryFrame(url) {
    document.getElementById("libraryFrame").parentNode.style.display='';
    document.getElementById("commons-main-body").style.display='none';
    document.getElementById("commons-main-tabs").style.display='none';

    window.open(url, "libraryFrame");
}

function collapsableNode(contextPath, title, text) {
    var guid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
        return v.toString(16);
    });

    return '<div id="' + guid + '-panel" class="panel panel-default" style="margin-bottom: 0">' +
        '<div class="panel-heading" role="tab" id="' + guid + '-heading" style="padding:1px 3px">' +
        '<span class="panel-title" style="font-size:12px;">' +
        '<a role="button" data-toggle="collapse" data-parent="#accordion" aria-expanded="false" aria-controls="' + guid + '-collapse" style="text-decoration: none">' +
        title + '</a></span></div><div id="' + guid + '-collapse" class="panel-collapse collapse" role="tabpanel" aria-labelledby="' + guid + '-heading">' +
        '<div class="panel-body" style="padding:1px 3px; font-size:12px">' + text + '<img src = "' + contextPath + '/resources/img/fred.png' + '" style="max-width:100%; max-height:100%;">' + '</div></div></div>' + '<script>' +
        '$("#' + guid + '-panel").hover(function() {$("#' + guid + '-collapse").collapse("show");}, function() {$("#' + guid + '-collapse").collapse("hide");}); </script>';
}

function getPopover(imgPath, title, modalImgPath) {
    var guid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
        return v.toString(16);
    });

    var img = "'<img src = \"" + imgPath + "\" style=\"max-width:100%; max-height:100%;\">'";

    /*var modalbutton = "<a href='#' type='button'  id='" + guid + "-modal" + "' style='margin-left:10px; margin-right:5px'>" +
        
        "<i class='fa fa-info-circle'></i></a>";

    var externalbutton = "<a href='' type='button'  id='" + guid + "-external" + "'>" +
        "<i class='fa fa-arrow-right'></i></a>";

    var paramsStr = '';
    for(var i = 0; i < params.length; i++) {
        if(i==0) {
            paramsStr += '"' + params[i] + '"';
        } else {
            paramsStr += ',"' + params[i] + '"';
        }
    }

    var externalClick = '$("#' + guid + '-external").click(function () {' + funcName + '(' + paramsStr + ')}' + ');';*/

    return '<span id="' + guid + '">' + title + '</span>' + '<script>' + '$("#' + guid + '").click(function(e) {e.preventDefault(); e.stopPropagation();}).popover({container: "body", html: true, trigger: "click", content: function() {return ' + img + '}});</script>';
}