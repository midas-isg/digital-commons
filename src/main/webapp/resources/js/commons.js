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

var isSoftwareHardcoded = true;
var softwareDictionary = {};
var softwareSettings = {};

/* Change includes method in IE */
if(!String.prototype.includes) {
    String.prototype.includes = function() {
        'use strict';
        return String.prototype.indexOf.apply(this, arguments) !== -1;
    };
}

function getSoftwareTitle(name, version) {
    var title = name;

    version = version.split(' - ')[0];
    if(isNaN(version[0])) {
        title += ' - ' + version;
    } else {
        title += ' - v' + version;
    }
    return title;
}

function hardcodeSoftwareFromJson(contextPath, location) {
    $.getJSON( contextPath + location, function( data ) {
        softwareSettings = data["settings"];
        var directories = softwareSettings["directories"];

        for(var i = 0; i < directories.length; i++) {
            if(typeof directories[i] === 'string') {
                software.push({
                    "text": "<span class=\"root-break\" onmouseover='toggleTitle(this)'>" + directories[i] + "</span>",
                    "nodes": [],
                    "name": directories[i]
                });
            } else {
                var keys = Object.keys(directories[i]);
                var topDirectory = keys[0];
                var nodes = [];

                for(var x = 0; x < directories[i][topDirectory].length; x++) {
                    nodes.push({
                        "text": "<span class=\"root-break\" onmouseover='toggleTitle(this)'>" + directories[i][topDirectory][x] + "</span>",
                        "nodes": [],
                        "name": directories[i][topDirectory][x]
                    });
                }

                software.push({
                    "text": "<span class=\"root-break\" onmouseover='toggleTitle(this)'>" + topDirectory + "</span>",
                    "nodes": nodes,
                    "name": topDirectory
                });

            }
        }

        for(var key in data) {
            softwareDictionary[key] = data[key];

            if('directory' in softwareDictionary[key]) {
                for(var i = 0; i < software.length; i++) {
                    var subdirectories = [];
                    var subdirectoryContent = [];
                    if('nodes' in software[i]) {
                        for(var x in software[i]['nodes']) {
                            if('nodes' in software[i]['nodes'][x]) {
                                subdirectories.push(software[i]['nodes'][x]['name']);
                                subdirectoryContent.push(software[i]['nodes'][x]);
                            }
                        }
                    }


                    var index = subdirectories.indexOf(softwareDictionary[key]['directory']);

                    if(software[i]['name'] == softwareDictionary[key]['directory'] || index > -1) {
                        var title = key;
                        if('version' in softwareDictionary[key]) {
                            title = getSoftwareTitle(key, softwareDictionary[key]['version']);
                        }

                        var nodeData = {
                            'text': '<span onmouseover="toggleTitle(this)" onclick="openModal(\'' + key + '\')">' + title + '</span>',
                            'name': key
                        };

                        if('redirect' in softwareDictionary[key] && softwareDictionary[key]['redirect'] == true) {
                            var url = '';
                            if('source' in softwareDictionary[key]) {
                                url = softwareDictionary[key]['source'];
                            }

                            if('location' in softwareDictionary[key]) {
                                url = softwareDictionary[key]['location'];
                            }

                            if(url.length > 0) {
                                nodeData['url'] = url;
                                nodeData['text'] = '<span onmouseover="toggleTitle(this)">' + title + '</span>';

                                if('midasSso' in softwareDictionary[key] && softwareDictionary[key]['midasSso'] == true) {
                                    nodeData['midasSso'] = softwareDictionary[key]['midasSso'];
                                }
                            }
                        }

                        if(index > -1) {
                            subdirectoryContent[index].nodes.push(nodeData);
                            subdirectoryContent[index].nodes.sort(compareNodes);
                        } else {
                            software[i].nodes.push(nodeData);
                        }

                        break;
                    }
                }
            }
        }

        buildSoftwareTree(contextPath);
    });
}

function hardcodeSoftware() {
    for(var i = 0; i < software[2].nodes.length; i++) {
        if(software[2].nodes[i].name == 'GLEAMViz') {
            delete software[2].nodes[i];
            break;
        }
    }

    software.splice(1, 0, {'text': "<span class=\"root-break\" onmouseover='toggleTitle(this)'>Population dynamics models</span>", nodes: [], "name": "Population dynamics models"});

    software.splice(6, 0, {'text': "<span class=\"root-break\" onmouseover='toggleTitle(this)'>Modeling platforms</span>", nodes: [], "name": "Modeling platforms"});
}

function buildSoftwareTree(contextPath) {
    for(var i = 0; i < software.length; i++) {
        software[i].nodes.sort(compareNodes);
    }

    var $softwareTree = $('#algorithm-treeview').treeview({
        data: software,
        showBorder: false,
        collapseAll: true,

        expandIcon: "glyphicon glyphicon-chevron-right",
        collapseIcon: "glyphicon glyphicon-chevron-down",

        onNodeSelected: function(event, data) {
            if(typeof data['nodes'] != undefined) {
                $('#algorithm-treeview').treeview('toggleNodeExpanded', [data.nodeId, { levels: 1, silent: true } ]).treeview('unselectNode', [data.nodeId, {silent: true}]);
            }

            if(data.parentId == null) {
                var expandedSoftware = $.parseJSON(sessionStorage.getItem("expandedSoftware"));

                if(data.state.expanded) {
                    if(expandedSoftware != null) {
                        var index = expandedSoftware.indexOf(data.nodeId);
                        if (index > -1) {
                            expandedSoftware.splice(index, 1);
                        }
                    }
                } else {
                    if(expandedSoftware != null) {
                        var index = expandedSoftware.indexOf(data.nodeId);
                        if (index <= -1) {
                            expandedSoftware.push(data.nodeId);
                        }
                    } else {
                        expandedSoftware = [];
                        expandedSoftware.push(data.nodeId);
                    }
                }

                sessionStorage.setItem("expandedSoftware", JSON.stringify(expandedSoftware));
            }

            if(data.url != null && data.state.selected == true) {
                if('midasSso' in data && data['midasSso'] == true) {
                    $(location).attr('href', contextPath + "/main/view?url=" + encodeURIComponent(data.url));
                } else {
                    window.location.href = data.url;
                }
            }
        }
    });

    $('#algorithm-treeview').treeview('collapseAll', { silent: true });
    var expandedSoftware = $.parseJSON(sessionStorage.getItem("expandedSoftware"));
    var toRemove = [];

    if(expandedSoftware == null) {
        var openByDefault = softwareDictionary["settings"]["openDirectories"];
        var openByDefaultIds = [];
        for(var i = 0; i < openByDefault.length; i++) {
            var matchingNode = $('#algorithm-treeview').treeview('search', [ openByDefault[i], {
                ignoreCase: false,     // case insensitive
                exactMatch: false,    // like or equals
                revealResults: false  // reveal matching nodes
            }])[0];
            $('#algorithm-treeview').treeview('clearSearch');

            openByDefaultIds.push(matchingNode.nodeId);
        }

        expandedSoftware = openByDefaultIds;
        sessionStorage.setItem("expandedSoftware", JSON.stringify(openByDefaultIds));
    }

    if(expandedSoftware != null) {
        for(var i = 0; i < expandedSoftware.length; i++) {
            try {
                $('#algorithm-treeview').treeview('expandNode', [ expandedSoftware[i], { silent: true } ]);
            } catch(err) {
                toRemove.push(i);
            }
        }

        if(toRemove.length > 0) {
            for(var i = 0; i < toRemove.length; i++) {
                expandedSoftware.splice(toRemove[i], 1);
            }

            sessionStorage.setItem("expandedSoftware", JSON.stringify(expandedSoftware));
        }
    }
}

var standardEncodingTree = {
    text: "Standards for encoding data",
    nodes: [{
        text: "<span onmouseover='toggleTitle(this)'>Apollo location codes (for locations)</span>",
        url: "https://betaweb.rods.pitt.edu/ls"
    },
        {
            text: "<span onmouseover='toggleTitle(this)'>LOINC codes (for lab tests)</span>",
            url: "http://loinc.org/"
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>NCBI Taxon identifiers (for host and pathogen taxa)</span>",
            url: "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi"
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>RxNorm codes (for drugs)</span>",
            url: "https://www.nlm.nih.gov/research/umls/rxnorm/"
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>SNOMED CT codes (for diagnoses)</span>",
            url: "https://nciterms.nci.nih.gov/ncitbrowser/pages/vocabulary.jsf?dictionary=SNOMED%20Clinical%20Terms%20US%20Edition"
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>Vaccine Ontology identifiers (for vaccines)</span>",
            url: "http://www.violinet.org/vaccineontology/"
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>Apollo XSD (for standard data types)</span>",
            url: "https://github.com/ApolloDev/apollo-xsd-and-types"
        }
    ]
};

function getDataAndKnowledgeTree(libraryData, syntheticEcosystems, libraryViewerUrl, contextPath) {
    var collections = [];
    libraryViewerUrl = libraryViewerUrl + "main/";

    collections.push(
        {
            text: "Disease surveillance data",
            nodes: [
                {
                    text: "<span onmouseover='toggleTitle(this)'>Brazil Ministry of Health routine diseases surveillance databases</span>",
                    url:"http://www2.datasus.gov.br/DATASUS/index.php?area=0203"
                },
                {
                    text: "<span onmouseover='toggleTitle(this)'>CDCEpi Zika Github</span>",
                    url:"https://zenodo.org/record/192153#.WIEKNLGZNcA"
                },
                {
                    text: "<span onmouseover='toggleTitle(this)'>Colombia Ministry of Health routine disease surveillance tables</span>",
                    url:"http://www.ins.gov.co/lineas-de-accion/Subdireccion-Vigilancia/sivigila/Paginas/vigilancia-rutinaria.aspx"
                },
                {
                    text: "<span onmouseover='toggleTitle(this)'>Singapore Ministry of Health disease surveillance data</span>",
                    url:"https://www.moh.gov.sg/content/moh_web/home/diseases_and_conditions.html"
                },
                {
                    text: "<span onmouseover='toggleTitle(this)'>US notifiable diseases</span>",
                    nodes: [
                        {
                            text: "<span onmouseover='toggleTitle(this)'>MMWR morbidity and mortality tables through data.cdc.gov</span>",
                            url:"https://data.cdc.gov/browse?category=MMWR"
                        },

                        {
                            text: "<span onmouseover='toggleTitle(this)'>Tycho level 1</span>",
                            url:"https://www.tycho.pitt.edu/data/level1.php"
                        },
                        {
                            text: "<span onmouseover='toggleTitle(this)'>Tycho level 2</span>",
                            url:"https://www.tycho.pitt.edu/data/level2.php"
                        },
                    ]
                },
            ]
        },
        {
            text: "Mortality data",
            nodes: [

                {
                    text: "<span onmouseover='toggleTitle(this)'>CDC WONDER US cause of death 1995-2015</span>",
                    url: "https://wonder.cdc.gov/controller/datarequest/D76"
                },
                {
                    text: "<span onmouseover='toggleTitle(this)'>CDC WONDER US compressed mortality files</span>",
                    url: "https://wonder.cdc.gov/mortSQL.html"
                }
            ]
        }
    );


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
                        text: "<span>" + value.name + "<span>",
                        url: url + value.urn
                    });
                });
                if(index.includes("Zika") || index.includes("Chikungunya")) {
                    index += " (under development)";
                }
                if(index.includes("H1n1 infectious disease scenarios"))
                    index = "H1N1 infectious disease scenarios";
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

function toggleModalItem(key, attrs, name, hasHref, renderHtml) {
    if(key in attrs) {
        $('#software-' + name + '-container').show();

        if(renderHtml) {
            $('#software-' + name).html(attrs[key]);
        } else {
            $('#software-' + name).text(attrs[key]);
        }

        if(hasHref) {
            $('#software-' + name).attr('href', attrs[key]);
        }
    } else {
        $('#software-' + name + '-container').hide();
    }
}

function openModal(softwareName) {
    var attrs = softwareDictionary[softwareName];

    if(softwareName != null) {
        $('#software-name').show();
        if('version' in attrs) {
            $('#software-name').text(getSoftwareTitle(softwareName, attrs['version']));
        } else {
            $('#software-name').text(softwareName);
        }
    } else {
        $('#software-name').hide();
    }

    if('developer' in attrs) {
        $('#software-developer-container').show();
        $('#software-developer').text(attrs['developer']);

        if(attrs['developer'].includes(',')) {
            $('#software-developer-tag').text('Developers:');
        } else {
            $('#software-developer-tag').text('Developer:');
        }
    } else {
        $('#software-developer-container').hide();
    }

    if('doi' in attrs) {
        $('#software-doi-container').show();
        $('#software-doi').html(attrs['doi']);
    } else {
        $('#software-doi-container').show();
        $('#software-doi').html('N/A');
    }

    if('version' in attrs) {
        $('#software-version-container').show();
        $('#software-version').text(attrs['version']);

        if(attrs['version'].includes(',')) {
            $('#software-version-tag').text('Software versions:');
        } else {
            $('#software-version-tag').text('Software version:');
        }
    } else {
        $('#software-version-container').hide();
    }

    //toggleModalItem('doi', attrs, 'doi', false, false);

    toggleModalItem('type', attrs, 'type', false, false);

    toggleModalItem('populationSpecies', attrs, 'population-species', false, false);

    //toggleModalItem('version', attrs, 'version', false, false);

    toggleModalItem('location', attrs, 'location', true, false);

    toggleModalItem('source', attrs, 'source-code', true, false);

    toggleModalItem('diseaseCoverage', attrs, 'disease-coverage', false, false);

    toggleModalItem('locationCoverage', attrs, 'location-coverage', false, false);

    toggleModalItem('speciesIncluded', attrs, 'species-included', false, false);

    toggleModalItem('controlMeasures', attrs, 'control-measures', false, false);

    toggleModalItem('title', attrs, 'title', false, false);

    toggleModalItem('generalInfo', attrs, 'general-info', false, true);

    toggleModalItem('sourceCodeRelease', attrs, 'source-code-release', false, true);

    toggleModalItem('publicationsAboutRelease', attrs, 'publications-about-release', false, true);

    toggleModalItem('publicationsThatUsedRelease', attrs, 'publications-that-used-release', false, true);

    toggleModalItem('webApplication', attrs, 'web-application', true, false);

    toggleModalItem('userGuidesAndManuals', attrs, 'user-guides-and-manuals', true, false);

    toggleModalItem('executables', attrs, 'executables', false, true);

    toggleModalItem('license', attrs, 'license', false, true);

    toggleModalItem('documentation', attrs, 'documentation', false, true);

    $('#pageModal').modal('show');

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

function getPopover(imgPath, title, modalImgPath, softwareName) {
    var guid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
        return v.toString(16);
    });

    var img = "'<img src = \"" + imgPath + "\" id = \"" + guid +"-img\" style=\"max-width:100%; min-height:150px\">'";

    return '<span id="' + guid + '" class="bs-popover">' + title + '</span>' + '<script>$("#' + guid + '-img").click(function(){openModal("' + softwareName + '")});$("#' + guid + '").popover({container: "body", html: true, trigger: "click", content: function() {return ' + img + '}}).on("show.bs.popover", function(e){$("[rel=popover]").not(e.target).popover("destroy");$(".popover").remove();});</script>';
}

function compareNodes(a,b) {
    if (a.name.toLowerCase() < b.name.toLowerCase())
        return -1;
    if (a.name.toLowerCase() > b.name.toLowerCase())
        return 1;
    return 0;
}

function toggleTitle(element) {
    var $this = $(element);

    if($this[0].parentNode.offsetWidth < $this[0].parentNode.scrollWidth || $this[0].offsetWidth < $this[0].scrollWidth){
        $this.attr('title', $this.text());
    } else {
        $this.attr('title', '');
    }
}

function activeTab(tab) {
    $('.tabs a[href="#' + tab + '"]').tab('show');
    location.hash = tab;
};