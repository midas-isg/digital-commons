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
    
var dataAugmentedPublications = [];

var software = [];
var softwareDictionary = {};
var softwareSettings = {};

var systemsSoftware = [];
var systemsSoftwareDictionary = {};
var systemsSoftwareSettings = {};

var diseaseTransmissionModel = [];
var diseaseTransmissionModelDictionary = {};
var diseaseTransmissionModelSettings = {};

var modelingPlatforms = [];
var modelingPlatformsDictionary = {};
var modelingPlatformsSettings = {};

var statisticalAnalysis = [];
var statisticalAnalysisDictionary = {};
var statisticalAnalysisSettings = {};

var imageManipulation = [];
var imageManipulationDictionary = {};
var imageManipulationSettings = {};

var webservices = [];
var webservicesDictionary = {};
var webservicesSettings = {};

var dataFormats = [];
var dataFormatsDictionary = {};
var dataFormatsSettings = {};

var standardIdentifiers = [];
var standardIdentifiersDictionary = {};
var standardIdentifiersSettings = {};

var geneticSequence = [];
var geneticSequenceDictionary = {};
var geneticSequenceSettings = {};

var tycho = [];
var tychoDictionary = {};
var tychoSettings = {};

var countryHash = {};
var stateHash =  {
    '01': 'Alabama',
    '02': 'Alaska',
    '04': 'Arizona',
    '05': 'Arkansas',
    '06': 'California',
    '08': 'Colorado',
    '09': 'Connecticut',
    '10': 'Delaware',
    '11': 'District Of Columbia',
    '12': 'Florida',
    '13': 'Georgia',
    '15': 'Hawaii',
    '16': 'Idaho',
    '17': 'Illinois',
    '18': 'Indiana',
    '19': 'Iowa',
    '20': 'Kansas',
    '21': 'Kentucky',
    '22': 'Louisiana',
    '23': 'Maine',
    '24': 'Maryland',
    '25': 'Massachusetts',
    '26': 'Michigan',
    '27': 'Minnesota',
    '28': 'Mississippi',
    '29': 'Missouri',
    '30': 'Montana',
    '31': 'Nebraska',
    '32': 'Nevada',
    '33': 'New Hampshire',
    '34': 'New Jersey',
    '35': 'New Mexico',
    '36': 'New York',
    '37': 'North Carolina',
    '38': 'North Dakota',
    '39': 'Ohio',
    '40': 'Oklahoma',
    '41': 'Oregon',
    '42': 'Pennsylvania',
    '44': 'Rhode Island',
    '45': 'South Carolina',
    '46': 'South Dakota',
    '47': 'Tennessee',
    '48': 'Texas',
    '49': 'Utah',
    '50': 'Vermont',
    '51': 'Virginia',
    '53': 'Washington',
    '54': 'West Virginia',
    '55': 'Wisconsin',
    '56': 'Wyoming'
};
var fipsCodes = Object.keys(stateHash);

var syntheticEcosystemsDictionary = {};
var epidemicsDictionary = {};
var synthiaPopulationsDictionary = {};
var caseSeriesDictionary = {};
var chikungunyaDictionary = {};
var diseaseSurveillanceDictionary = {};
var moralityDataDictionary = {};
var zikaDictionary = {};
var infectiousDiseaseDictionary = {};

function convertToHref(href) {
    var identifier;
    if(href.includes("zenodo")){
        identifier = href.split('https://doi.org/').pop();
    } else {
        identifier = href;
    }
    return '<a class="underline" href="' + href + '">' + identifier + '</a>';
}

function addDatsToDictionary(dictionary, data, code, type) {
    if ("undefined" !== typeof data['identifier']) {
        var identifier = data['identifier']['identifier'];
    } else {
        identifier = null;
    }

    if(identifier == null || identifier == '') {
        if(data['spatialCoverage'] != null && data['spatialCoverage'].length > 0) {
            identifier = data['spatialCoverage'][0]['identifier']['identifier'];
            if(!identifier.includes('http')) {
                identifier = data['spatialCoverage'][0]['identifier']['identifierSource'];
            }
        }
    }

    if(identifier != null && identifier.includes('http')) {
       identifier = convertToHref(identifier);
    }

    if (data['name'] === 'Galapagos CSV') {
        data['title'] = 'Galapagos-CSV';
        data['name'] = 'Galapagos-CSV';
    }


    dictionary[code] = {
        'title': data['title'],
        'description': data['description'],
        'identifier': identifier,
        'json': data
    };


    if(type == 'dataStandard') {
        dictionary[code]['title'] = data['name'];

        if(data['licenses'][0]['name'] != null && data['licenses'][0]['name'] != '') {
            dictionary[code]['license']  = data['licenses'][0]['name'];

            if(dictionary[code]['license'].includes('http')) {
                dictionary[code]['license'] = convertToHref(dictionary[code]['license']);
            }
        }

        if(data['version'] != null && data['version'] != '') {
            dictionary[code]['version'] = [data['version']];
            //dictionary[code]['title'] = getSoftwareTitle(data['name'], dictionary[code]['version']);
        }

        for(var i = 0; i < data["extraProperties"].length; i++) {
            var property = data["extraProperties"][i];

            if(property["category"] == "human-readable specification of data format") {
                dictionary[code]['humanReadableSpecification'] = property["values"][0]["value"];
            } else if(property["category"] == "machine-readable specification of data format") {
                dictionary[code]['machineReadableSpecification'] = property["values"][0]["valueIRI"];
            } else if(property["category"] == "validator") {
                var val = property['values'][0]['value'];
                if(val != '') {
                    dictionary[code]['validator'] = val;
                }
            }
        }
    } else if(type != 'dataStandard') {
        var distributions = data["distributions"];
        if(distributions != null && distributions.length > 0) {
            if(distributions[0]["storedIn"] != null) {
                var storedIn = distributions[0]["storedIn"]["name"];

                if(distributions[0]["storedIn"]['licenses'][0]['name'] != null && distributions[0]["storedIn"]['licenses'][0]['name'] != '') {
                    dictionary[code]['license']  = distributions[0]["storedIn"]['licenses'][0]['name'];

                    if(dictionary[code]['license'].includes('http')) {
                        dictionary[code]['license'] = convertToHref(dictionary[code]['license']);
                    }
                }

                if(storedIn == "MIDAS Digital Commons") {
                    dictionary[code]["availableOnOlympus"] = true;
                }
            }

            dictionary[code]['landingPage'] = distributions[0]['access']['landingPage'];
            dictionary[code]['accessUrl'] = distributions[0]['access']['accessURL'];

            var authData = distributions[0]['access']['authorizations'];
            var authorizations = [];

            /*if(authData != null) {
                for(var i = 0; i < authData.length; i++) {
                    authorizations.push(authData[i]["value"]);
                }
                dictionary[code]['authorizations']= authorizations;
            }*/
        }

        var creators = [];
        for(var i = 0; i < data['creators'].length; i++) {
            var creator = data['creators'][i];
            creator = creator['firstName'] + ' ' + creator['lastName'];
            creators.push(creator);
        }

        dictionary[code]['creator']= creators;
    }
}

function populateSyntheticEcosystemDictionary(count) {
    var fipsCode = fipsCodes[count];
    $.getJSON( ctx + '/resources/spew-dats-json/' + fipsCode + '.json' + '?v=' + Date.now(), function( data ) {
        addDatsToDictionary(syntheticEcosystemsDictionary, data, fipsCode);
        count++;

        if(count < fipsCodes.length) {
            populateSyntheticEcosystemDictionary(count);
        }
    });
}
populateSyntheticEcosystemDictionary(0);

function populateSynthiaPopulationsDictionary(count) {
    var files = ['synthia_us_by_county', 'synthia_us_by_state'];

    $.getJSON( ctx + '/resources/synthia-dats-json/' + files[count] + '.json' + '?v=' + Date.now(), function( data ) {
        var splitFile = files[count].split('_');
        var name = splitFile[splitFile.length - 1];

        addDatsToDictionary(synthiaPopulationsDictionary, data, name);
        count++;

        if(count < files.length) {
            populateSynthiaPopulationsDictionary(count);
        }
    });
}
populateSynthiaPopulationsDictionary(0);

var dsdNodeNames = ["Brazil Ministry of Health", "CDCEpi Zika Github", "Colombia Ministry of Health", "Singapore Ministry of Health", "US MMWR morbidity and mortality tables"];
function populateDiseaseSurveillanceDictionary(count) {
    $.getJSON( ctx + '/resources/disease-surveillance-dats-json/' + dsdNodeNames[count] + '.json' + '?v=' + Date.now(), function( data ) {
        addDatsToDictionary(diseaseSurveillanceDictionary, data, dsdNodeNames[count]);
        count++;

        if(count < dsdNodeNames.length) {
            populateDiseaseSurveillanceDictionary(count);
        }
    })
}
populateDiseaseSurveillanceDictionary(0);

var moralityDataNodeNames = ["CDC WONDER US cause of death 1995-2015", "CDC WONDER US compressed mortality data"];
function populateMortalityDataDictionary(count) {
    $.getJSON( ctx + '/resources/mortality-dats-json/' + moralityDataNodeNames[count] + '.json' + '?v=' + Date.now(), function( data ) {
        addDatsToDictionary(moralityDataDictionary, data, moralityDataNodeNames[count]);
        count++;

        if(count < moralityDataNodeNames.length) {
            populateMortalityDataDictionary(count);
        }
    })
}
populateMortalityDataDictionary(0);

function populateDataFormatsDictionary(count) {
    var keys = Object.keys(dataFormatsDictionary);

    var fileNames = [];
    for(var i = 0; i < keys.length; i++) {
        fileNames.push(dataFormatsDictionary[keys[i]]['filename']);
    }

    $.getJSON( ctx + '/resources/data-formats-dats-json/' + fileNames[count] + '?v=' + Date.now(), function( data ) {
        addDatsToDictionary(dataFormatsDictionary, data, count, 'dataStandard');
        count++;

        if(count < fileNames.length) {
            populateDataFormatsDictionary(count);
        }
    });
}

function populateTycho(ids, count) {
    $.getJSON( ctx + '/resources/tycho-dats-json/' + ids[count] + '.json?v=' + Date.now(), function( datsJson ) {
        addDatsToDictionary(tychoDictionary, datsJson, ids[count]);
        count++;

        if(count < ids.length) {
            populateTycho(ids, count);
        }
     });
}

/* Change includes method in IE */
if(!String.prototype.includes) {
    String.prototype.includes = function() {
        'use strict';
        return String.prototype.indexOf.apply(this, arguments) !== -1;
    };
}

function hardcodeFromJson(contextPath, location, treeArray, treeDictionary, treeSettings, treeviewTag, expandedInfo, name) {
    $.getJSON( contextPath + location + '?v=' + Date.now(), function( data ) {
        //treeSettings = data["settings"];
        //var name = treeSettings["name"];
        //var directories = treeSettings["directories"];

        var directories = new Set();
        var subdirectories = new Set();
        for(var i = 0; i < data.length; i ++) {
            directories.add(data[i]["subtype"]);
            if(data[i].hasOwnProperty("product")) {
                subdirectories.add(data[i]["subtype"] + "-->" + data[i]["product"]);
            }
        }
        directories = Array.from(directories);
        subdirectories = Array.from(subdirectories);

        if(directories[0] == null) {
            directories = [];
        }

        if(subdirectories[0] == null) {
            subdirectories = [];
        }

        var openByDefault = JSON.parse(JSON.stringify(directories));
        for(var i = 0; i < subdirectories.length; i++) {
            var directoryAndSubdirectory = subdirectories[i].split('-->');
            for(var x = 0; x < directories.length; x++) {
                var directoryName = directories[x];
                if(typeof directories[x] !== 'string') {
                    directoryName = Object.keys(directories[x])[0];
                }

                if(directoryAndSubdirectory[0] == directoryName) {
                    if(typeof directories[x] === 'string') {
                        directories[x] = {};
                        directories[x][directoryAndSubdirectory[0]] = [directoryAndSubdirectory[1]];
                    } else {
                        directories[x][directoryName].push(directoryAndSubdirectory[1]);
                    }
                }
            }
            openByDefault.push(directoryAndSubdirectory[1].replace(/\s*\(.*?\)\s*/g, ''));
        }

        if(location.includes('hardcoded-software.json')) {
            for(var i in directories) {
                var category = directories[i];

                if(typeof category !== 'string') {
                    category = Object.keys(category)[0];
                }

                $('#category-select').append($('<option>', {
                    value: category,
                    text: 'Software - ' + category
                }));
            }
        }

        addTreeDirectories(directories, treeArray);
        addTreeNodes(name, data, treeDictionary, treeArray);
        buildBootstrapTree(name, contextPath, treeArray, treeviewTag, expandedInfo, treeDictionary, openByDefault);

        if(name == 'dataFormats') {
            populateDataFormatsDictionary(0);
        }

        $('[data-toggle="tooltip"]').tooltip({
            trigger : 'hover',
            delay: 350
        });
    });
}

function addTreeDirectories(directories, treeArray) {
    for(var i = 0; i < directories.length; i++) {
        if(typeof directories[i] === 'string') {
            treeArray.push({
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
                    "text": "<span class=\"root-break\" onmouseover='toggleTitle(this)'>" + directories[i][topDirectory][x],
                    "nodes": [],
                    "name": directories[i][topDirectory][x]
                });
            }

            treeArray.push({
                "text": "<span class=\"root-break\" onmouseover='toggleTitle(this)'>" + topDirectory + "</span>",
                "nodes": nodes,
                "name": topDirectory
            });
        }
    }
}

function addTreeNodes(name, data, treeDictionary, treeArray) {
    for(var key in data) {
        treeDictionary[key] = data[key];

        if('subtype' in treeDictionary[key]) {
            addNodesToDirectory(name, key, treeArray, treeDictionary);
        } else if(key != "settings" && key != "EpiCaseMap") {
            var nodeData = getNodeData(name, key, treeDictionary);
            nodeData["nodes"] = [];
            treeArray.push(nodeData);
        }
    }

    for(var i = 0; i < treeArray.length; i++) {
        var rootSoftwareLength = 0;
        for(var x = 0; x < treeArray[i].nodes.length; x++) {
            if(treeArray[i].nodes[x].nodes != null && treeArray[i].nodes[x].nodes.length > 0) {
                rootSoftwareLength += (treeArray[i].nodes[x].nodes.length-1)
                treeArray[i].nodes[x].text += "<span class='badge'>[" + treeArray[i].nodes[x].nodes.length + "]</span>";
            }
        }

        if(treeArray[i].nodes.length > 0) {
            rootSoftwareLength += treeArray[i].nodes.length;
            treeArray[i].text += "<span class='badge'>[" + rootSoftwareLength + "]</span>";
        }

    }

    /*for(var key in data) {
        if(key != "settings") {
            treeDictionary[key] = data[key];

            treeArray.push({
                text: "<span data-placement='auto right' data-container='body' data-toggle='tooltip' title='" + treeDictionary[key]["description"] + "'>" + key + "</span>"
            });
        }
     }*/
}

function buildBootstrapTree(name, contextPath, treeArray, treeviewTag, expandedInfo, treeDictionary, openByDefault) {
    for(var i = 0; i < treeArray.length; i++) {
        if('nodes' in treeArray[i]) {
            treeArray[i].nodes.sort(compareNodes);
        }
    }

    if(name != "software") {
        treeArray.sort(compareNodes);
    }

    var treeviewInfo = {
        data: treeArray,
        showBorder: false,
        collapseAll: true,

        expandIcon: "glyphicon glyphicon-chevron-right",
        collapseIcon: "glyphicon glyphicon-chevron-down",

        onNodeSelected: function(event, data) {
            if(typeof data['nodes'] != undefined) {
                $(treeviewTag).treeview('toggleNodeExpanded', [data.nodeId, { levels: 1, silent: true } ]).treeview('unselectNode', [data.nodeId, {silent: true}]);
            }
            
            var expandedSoftware = $.parseJSON(sessionStorage.getItem(expandedInfo));

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

            sessionStorage.setItem(expandedInfo, JSON.stringify(expandedSoftware));


            if(data.url != null && data.state.selected == true) {
                ga('send', {
                    hitType: 'event',
                    eventCategory: 'Clickthrough',
                    eventAction: data.url
                });

                if('signInRequired' in data && data['signInRequired'] == true) {
                    window.location.href = data.url;
                }
            }
        }
    };

    if(name == "diseaseTransmissionModels" || name == "systemSoftware" || name == "tools") {
        treeviewInfo['expandIcon'] = "bullet-point	";
        treeviewInfo['collapseIcon'] = "bullet-point	";
        treeviewInfo['highlightSelected'] = false;
        treeviewInfo['onNodeSelected'] = function(event, data) {
            $('[data-toggle="tooltip"]').tooltip('destroy');
            event.stopPropagation();
        };
        $(treeviewTag).treeview(treeviewInfo);
        $(treeviewTag).treeview('expandAll', { silent: true });
    } else {
        if(name == "webServices" || name == "dataFormats" || name == "standardIdentifiers") {
            treeviewInfo['expandIcon'] = "bullet-point	";
            treeviewInfo['collapseIcon'] = "bullet-point	";
        }

        $(treeviewTag).treeview(treeviewInfo);
        $(treeviewTag).treeview('collapseAll', { silent: true });
    }

    /*if(name != "software" && name != "tools" && name != "diseaseTransmissionModels" && name != "systemSoftware") {
     treeviewInfo['emptyIcon'] = "bullet-point	";
     }*/

    var expandedSoftware = $.parseJSON(sessionStorage.getItem(expandedInfo));
    var toRemove = [];

    if(expandedSoftware == null) {
        var openByDefaultIds = [];
        for(var i = 0; i < openByDefault.length; i++) {
            var matchingNode = $(treeviewTag).treeview('search', [ openByDefault[i], {
                ignoreCase: false,     // case insensitive
                exactMatch: false,    // like or equals
                revealResults: false  // reveal matching nodes
            }])[0];
            $(treeviewTag).treeview('clearSearch');
            if(matchingNode != null) {
                openByDefaultIds.push(matchingNode.nodeId);
            }
        }

        expandedSoftware = openByDefaultIds;
        sessionStorage.setItem(expandedInfo, JSON.stringify(openByDefaultIds));
    }

    if(expandedSoftware != null) {
        for(var i = 0; i < expandedSoftware.length; i++) {
            try {
                $(treeviewTag).treeview('expandNode', [ expandedSoftware[i], { silent: true } ]);
            } catch(err) {
                toRemove.push(i);
            }
        }

        if(toRemove.length > 0) {
            for(var i = 0; i < toRemove.length; i++) {
                expandedSoftware.splice(toRemove[i], 1);
            }

            sessionStorage.setItem(expandedInfo, JSON.stringify(expandedSoftware));
        }
    }
}

function addNodesToDirectory(name, key, treeArray, treeDictionary) {
    for(var i = 0; i < treeArray.length; i++) {
        var subdirectories = [];
        var subdirectoryContent = [];

        addNodesToSubdirectories(treeArray[i], subdirectories, subdirectoryContent);

        var index = subdirectories.indexOf(treeDictionary[key]['product']);

        if(treeArray[i]['name'] == treeDictionary[key]['subtype'] || index > -1) {
            var nodeData = getNodeData(name, key, treeDictionary);
            //console.log(nodeData);

            /* Add node to directory or subdirectory */
            if(index > -1) {
                subdirectoryContent[index].nodes.push(nodeData);
                subdirectoryContent[index].nodes.sort(compareNodes);
            } else {
                treeArray[i].nodes.push(nodeData);
            }

            break;
        }
    }
}

function addNodesToSubdirectories(treeArrayItem, subdirectories, subdirectoryContent) {
    if('nodes' in treeArrayItem) {
        for(var x in treeArrayItem['nodes']) {
            if('nodes' in treeArrayItem['nodes'][x]) {
                subdirectories.push(treeArrayItem['nodes'][x]['name']);
                subdirectoryContent.push(treeArrayItem['nodes'][x]);
            }
        }
    }
}

function getNodeData(name, key, treeDictionary) {
    var title = key;
    if('version' in treeDictionary[key]) {
        title = getSoftwareTitle(treeDictionary[key]['title'], treeDictionary[key]['version'].join(', '));
    } else {
        title = treeDictionary[key]['title'];
    }

    var nodeData = {
        'text': '<span onmouseover="toggleTitle(this)" onclick="openModal(\'' + name + '\',' + '\'' + key + '\')">' + title + '</span>',
        'name': title
    };

    if('availableOnOlympus' in treeDictionary[key] && treeDictionary[key]['availableOnOlympus'] == true) {
        nodeData.text += ' <b><i class="olympus-color"><sup>AOC</sup></i></b>';
    }

    if('availableOnUIDS' in treeDictionary[key] == true) {
        nodeData.text += ' <b><i class="udsi-color"><sup>UIDS</sup></i></b>';
    }

    if('signInRequired' in treeDictionary[key] && treeDictionary[key]['signInRequired'] == true) {
        nodeData.text += ' <b><i class="sso-color"><sup>SSO</sup></i></b>';
    }

    if('redirect' in treeDictionary[key] && treeDictionary[key]['redirect'] == true) {
        var url = '';
        if('source' in treeDictionary[key]) {
            url = treeDictionary[key]['source'];
        }

        if('website' in treeDictionary[key]) {
            url = treeDictionary[key]['website'];
        }

        if(url.length > 0) {
            nodeData['url'] = url;
            nodeData['text'] = '<span onmouseover="toggleTitle(this)">' + title + '</span>';

            if('availableOnOlympus' in treeDictionary[key] && treeDictionary[key]['availableOnOlympus'] == true) {
                nodeData.text += ' <b><i class="olympus-color"><sup>AOC</sup></i></b>';
            }

            if('availableOnUIDS' in treeDictionary[key] && treeDictionary[key]['availableOnOlympus'] == true) {
                nodeData.text += ' <b><i class="udsi-color"><sup>UIDS</sup></i></b>';
            }

            if('signInRequired' in treeDictionary[key] && treeDictionary[key]['signInRequired'] == true) {
                nodeData.text += ' <b><i class="sso-color"><sup>SSO</sup></i></b>';
                nodeData['signInRequired'] = treeDictionary[key]['signInRequired'];
            }
        }
    }

    if(name != "software" && name != "webServices" && name != "dataFormats" && name != "standardIdentifiers") {
        nodeData.text = "<span data-placement='auto right' data-container='body' data-toggle='tooltip' title='" + treeDictionary[key]["description"] + "'>" + title + "</span>";
    }

    return nodeData;
}

function getSoftwareTitle(name, version) {
    var title = name;

    var splitTitle = title.split(' ');
    var titleEnd = splitTitle[splitTitle.length - 1];
    if(titleEnd.length == 3 && titleEnd.startsWith('[') && titleEnd.endsWith(']')) {
        title = splitTitle.slice(0, splitTitle.length - 1).join(' ');
    }

    version = version.split(' - ')[0];

    if(version != '') {
        if(isNaN(version[0]) || version == '2010 U.S. Synthesized Population') {
            title += ' - ' + version;
        } else {
            title += ' - v' + version;
        }
    }
    return title;
}

/*var standardIdentifierTree = {
    text: "Standard identifiers",
    nodes: [
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
            text: "<span onmouseover='toggleTitle(this)'>Apollo Location Codes (for locations) <b><i class='sso-color'><sup>SSO</sup></i></b></span>",
            url: "https://betaweb.rods.pitt.edu/ls"
        }
    ]
};

var dataFormatsTree = {
    text: "Data formats",
    nodes: [
        {
            text: "<span onmouseover='toggleTitle(this)'>Synthia</span>",
            url: ""
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>Spew.US</span>",
            url: ""
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>Spew.IPUMS</span>",
            url: ""
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>Spew.CANADA</span>",
            url: ""
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>Omnivore output format</span>",
            url: ""
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>Galapagos output format</span>",
            url: ""
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>Tycho 2.0</span>",
            url: ""
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>Apollo XSD v4.0.1</span>",
            url: "https://github.com/ApolloDev/apollo-xsd-and-types"
        },
        {
            text: "<span onmouseover='toggleTitle(this)'>PHYSIS</span>",
            url: ""
        }
    ]
};
dataFormatsTree.nodes.sort(function(a,b) {
    if (a.text > b.text) return 1;
    if (a.text < b.text) return -1;
    return 0
});*/

function getDataAndKnowledgeTree(libraryData, syntheticEcosystems, libraryViewerUrl, contextPath) {
    var collections = [];
    libraryViewerUrl = libraryViewerUrl + "main/";

    collections.push(
        syntheticEcosystems,
        {
            text: "Synthia™ synthetic populations <span class='badge'>["+ Object.keys(syntheticEcosystems).length + "]</span>",
            nodes: [
                {
                    text: "<span onmouseover='toggleTitle(this)' onclick='openModal(\"syntheticPopulations\",\"county\")'>2010 U.S. Synthetic Populations by County</span> <b><i class=\"olympus-color\"><sup>AOC</sup></i></b>"
                },
                {
                    text: "<span onmouseover='toggleTitle(this)' onclick='openModal(\"syntheticPopulations\",\"state\")'>2010 U.S. Synthetic Populations by State</span> <b><i class=\"olympus-color\"><sup>AOC</sup></i></b>"
                }
            ]
        }
    );

    var dsd = {
        text: "Disease surveillance data",
        nodes: []
    };

    for(var i = 0; i < dsdNodeNames.length; i++) {
        dsd.nodes.push({
            text: "<span onmouseover='toggleTitle(this)' onclick='openModal(\"diseaseSurveillance\",\"" + dsdNodeNames[i] + "\")'>" + dsdNodeNames[i] + "</span>",
            name: dsdNodeNames[i]
        });
    }

    dsd.nodes.push({
        text: "<span onmouseover='toggleTitle(this)'>Project Tycho repository v2.0</span>",
        name: "Tycho 2.0",
        nodes: []
    });

    var tychoIds = [];
    var tychoNodes = dsd.nodes[dsd.nodes.length - 1].nodes;
    $.getJSON( ctx + '/resources/hardcoded-tycho.json?v=' + Date.now(), function( data ) {
        var currentCountryCode = '';
        var currentTychoNode = null;
        var continentTychoNode = null;
        var continents = [];
        for(var i = 0; i < data.length; i++) {
            if(!continents.includes(data[i]['continent'])) {
                tychoNodes.push({
                    'name': data[i]['continent'],
                    'text': "<span onmouseover='toggleTitle(this)'>" + data[i]['continent'] + "</span>",
                    'nodes': []
                });

                continents.push(data[i]['continent']);
                continentTychoNode = tychoNodes[tychoNodes.length - 1].nodes;
            } else {
                continentTychoNode = tychoNodes[continents.indexOf(data[i]['continent'])].nodes;
            }

            if(data[i]['countryIso'] != currentCountryCode) {
                currentCountryCode = data[i]['countryIso'];
                continentTychoNode.push({
                    'name': data[i]['subtype'],
                    'text': "<span onmouseover='toggleTitle(this)'>" + data[i]['subtype'] + "</span>",
                    'nodes': []
                });

                if(currentTychoNode != null) {
                    currentTychoNode.sort(compareNodes);
                }

                currentTychoNode = continentTychoNode[continentTychoNode.length - 1].nodes;
            }

            currentTychoNode.push({
                'name': data[i]['product'],
                'text': "<span onmouseover='toggleTitle(this)' onclick='openModal(\"tycho\",\"" + data[i]['id'] + "\")'>" + data[i]['product'] + " (" + data[i]['dateRange'] + ")" + "</span>"
            });

            tychoIds.push(data[i]['id']);
        }
        for(var i=0; i<tychoNodes.length; i++) {
            var upperLevelCount = 0;
            for(var x=0; x<tychoNodes[i].nodes.length; x++) {
                tychoNodes[i].nodes[x].text += "<span class='badge'>["+ tychoNodes[i].nodes[x].nodes.length +"]</span>";
                upperLevelCount += tychoNodes[i].nodes[x].nodes.length;
            }
            tychoNodes[i].text += "<span class='badge'>["+ upperLevelCount +"]</span>";
            tychoNodes[i].nodes.sort(compareNodes);
        }
        dsd.nodes[dsd.nodes.length-1].text += "<span class='badge'>[" + tychoIds.length +"]</span>";
        var dsdLength = dsdNodeNames.length + tychoIds.length;
        dsd.text += "<span class='badge'>["+dsdLength+"]</span>"

        tychoNodes[tychoNodes.length - 1].nodes.sort(compareNodes);
    }).then(function() {
        dsd.nodes.sort(compareNodes);
        tychoNodes.sort(compareNodes);
        populateTycho(tychoIds, 0);

        collections.push(dsd);

        var mortalityData = {
            text: "Mortality data <span class='badge'>["+moralityDataNodeNames.length+"]</span>",
            nodes: []
        };

        for(var i = 0; i < moralityDataNodeNames.length; i++) {
            mortalityData.nodes.push({
                text: "<span onmouseover='toggleTitle(this)' onclick='openModal(\"mortalityData\",\"" + moralityDataNodeNames[i] + "\")'>" + moralityDataNodeNames[i] + "</span>",
                name: moralityDataNodeNames[i]
            });
        }

        collections.push(mortalityData);

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
                var libraryEntryLength = 0;

                $.each(value, function (index, value) {
                    var nodeLevel2 = [];

                    var ebolaEpidemics = false;
                    var caseListings = false;
                    var chikungunyaEpidemics = false;
                    var zikaEpidemics = false;
                    var infectiousDisease = false;
                    if(index == "Ebola epidemics") {
                        ebolaEpidemics = true;
                    } else if(index == "Rabies case listings") {
                        caseListings = true;
                    } else if(index == "Chikungunya epidemics") {
                        chikungunyaEpidemics = true;
                    } else if(index == "Zika epidemics") {
                        zikaEpidemics = true;
                    } else if(index == 'H1N1 infectious disease scenarios') {
                        infectiousDisease = true;
                    }

                    $.each(value, function (index, value) {
                        libraryEntryLength++;

                        if(ebolaEpidemics || caseListings || chikungunyaEpidemics || zikaEpidemics || infectiousDisease) {
                            var dictionaryKey = value.name.trim();
                            if(dictionaryKey.includes('É')) {
                                dictionaryKey = dictionaryKey.replace('É', 'E');
                            } else if(dictionaryKey.includes('/')) {
                                dictionaryKey = dictionaryKey.replace('/', ':');
                            } else if(dictionaryKey.includes('é')) {
                                dictionaryKey = dictionaryKey.replace('é', 'e');
                            }

                            if(ebolaEpidemics) {
                                nodeLevel2.push({
                                    name: value.name,
                                    text: "<span onmouseover='toggleTitle(this)' onclick='openModal(\"epidemics\",\"" + dictionaryKey + "\")'>" + value.name + " <b><i class=\"ae-color\"><sup>AE</sup></i><b></span>"
                                });

                                $.getJSON( ctx + '/resources/ebola-dats-json/' + dictionaryKey + '.json' + '?v=' + Date.now(), function( data ) {
                                    addDatsToDictionary(epidemicsDictionary, data, dictionaryKey);
                                })
                                    .error(function(data) {
                                        console.log('error');
                                    });
                            } else if(caseListings) {
                                nodeLevel2.push({
                                    name: value.name,
                                    text: "<span onmouseover='toggleTitle(this)' onclick='openModal(\"caseSeries\",\"" + dictionaryKey + "\")'>" + value.name + " <b><i class=\"ae-color\"><sup>AE</sup></i><b></span>"
                                });

                                $.getJSON( ctx + '/resources/case-series-dats-json/' + dictionaryKey + '.json' + '?v=' + Date.now(), function( data ) {
                                    addDatsToDictionary(caseSeriesDictionary, data, dictionaryKey);
                                })
                                    .error(function(data) {
                                        console.log(dictionaryKey);
                                    });
                            } else if(chikungunyaEpidemics) {
                                nodeLevel2.push({
                                    name: value.name,
                                    text: "<span onmouseover='toggleTitle(this)' onclick='openModal(\"chikungunya\",\"" + dictionaryKey + "\")'>" + value.name + " <b><i class=\"ae-color\"><sup>AE</sup></i><b></span>"
                                });

                                $.getJSON( ctx + '/resources/chikungunya-dats-json/' + dictionaryKey + '.json' + '?v=' + Date.now(), function( data ) {
                                    addDatsToDictionary(chikungunyaDictionary, data, dictionaryKey);
                                })
                                    .error(function(data) {
                                        console.log(dictionaryKey);
                                    });
                            } else if(zikaEpidemics) {
                                nodeLevel2.push({
                                    name: value.name,
                                    text: "<span onmouseover='toggleTitle(this)' onclick='openModal(\"zika\",\"" + dictionaryKey + "\")'>" + value.name + " <b><i class=\"ae-color\"><sup>AE</sup></i><b></span>"
                                });

                                $.getJSON( ctx + '/resources/zika-dats-json/' + dictionaryKey + '.json' + '?v=' + Date.now(), function( data ) {
                                    addDatsToDictionary(zikaDictionary, data, dictionaryKey);
                                })
                                    .error(function(data) {
                                        console.log(dictionaryKey);
                                    });
                            } else if(infectiousDisease) {
                                nodeLevel2.push({
                                    name: value.name,
                                    text: "<span onmouseover='toggleTitle(this)' onclick='openModal(\"infectiousDisease\",\"" + dictionaryKey + "\")'>" + value.name + " <b><i class=\"ae-color\"><sup>AE</sup></i><b></span>"
                                });

                                $.getJSON( ctx + '/resources/infectious-disease-dats-json/' + dictionaryKey + '.json' + '?v=' + Date.now(), function( data ) {
                                    addDatsToDictionary(infectiousDiseaseDictionary, data, dictionaryKey);
                                })
                                    .error(function(data) {
                                        console.log(dictionaryKey);
                                    });
                            }

                        } else {
                            nodeLevel2.push({
                                text: "<span onmouseover='toggleTitle(this)'>" + value.name + " <b><i class=\"ae-color\"><sup>AE</sup></i><b> </span> ",
                                url: url + value.urn
                            });
                        }
                    });
                    if(index.includes("Zika") || index.includes("Chikungunya")) {
                        index += " (under development)";
                    }
                    if(index.includes("H1n1 infectious disease scenarios"))
                        index = "H1N1 infectious disease scenarios";
                    nodeLevel1.push({text: "<span onmouseover='toggleTitle(this)'>" + index + " <b><i class=\"ae-color\"><sup>AE</sup></i><b> </span> <span class='badge'>["+value.length+"]</span>", nodes: nodeLevel2});
                });

                collections.push({text: "<span onmouseover='toggleTitle(this)'>" + index + "</span> <span class='badge'>["+libraryEntryLength +"]</span>", nodes: nodeLevel1});
            });
        }

        //collections.push(dataFormatsTree);
        //collections.push(standardIdentifierTree);

        $('#data-and-knowledge-treeview').treeview({
            data: collections,
            showBorder: false,

            expandIcon: "glyphicon glyphicon-chevron-right",
            collapseIcon: "glyphicon glyphicon-chevron-down",
        });
        $('#data-and-knowledge-treeview').treeview('collapseAll', { silent: true });
        $('#data-and-knowledge-treeview').on('nodeSelected', function(event, data) {
            if(typeof data['nodes'] != undefined) {
                $('#data-and-knowledge-treeview').treeview('toggleNodeExpanded', [data.nodeId, { levels: 1, silent: true } ]).treeview('unselectNode', [data.nodeId, {silent: true}]);
            }

            var expandedDataAndKnowledge = $.parseJSON(sessionStorage.getItem("expandedDataAndKnowledge"));

            if(data.state.expanded) {
                if(expandedDataAndKnowledge != null) {
                    var index = expandedDataAndKnowledge.indexOf(data.nodeId);
                    if (index > -1) {
                        expandedDataAndKnowledge.splice(index, 1);
                    }
                }
            } else {
                if(expandedDataAndKnowledge != null) {
                    var index = expandedDataAndKnowledge.indexOf(data.nodeId);
                    if (index <= -1) {
                        expandedDataAndKnowledge.push(data.nodeId);
                    }
                } else {
                    expandedDataAndKnowledge = [];
                    expandedDataAndKnowledge.push(data.nodeId);
                }
            }

            sessionStorage.setItem("expandedDataAndKnowledge", JSON.stringify(expandedDataAndKnowledge));

            if(data.url != null && data.state.selected == true) {
                ga('send', {
                    hitType: 'event',
                    eventCategory: 'Clickthrough',
                    eventAction: data.url
                });

                var url  = data.url;
                if(url.search("apolloLibraryViewer") > -1) {
//                        if($.contains(data.url, "apolloLibraryViewer")) {
                    $(location).attr('href', "${pageContext.request.contextPath}" + "/midas-sso/view?url=" + encodeURIComponent(data.url));
                } else {
                    $(location).attr('href', data.url);
                }
            }
        });
        var expandedDataAndKnowledge = $.parseJSON(sessionStorage.getItem("expandedDataAndKnowledge"));
        var toRemove = [];

        if(expandedDataAndKnowledge == null) {
            var openByDefault = ["SPEW synthetic ecosystems", "Disease surveillance data", "US notifiable diseases", "Mortality data", "Case series", "Rabies case listings", "Epidemics", "Infectious disease scenarios", "H1N1 infectious disease scenarios", "Standards for encoding data", "Synthia", "Data formats", "Standard identifiers"];
            var openByDefaultIds = [];
            for(var i = 0; i < openByDefault.length; i++) {
                var matchingNode = $('#data-and-knowledge-treeview').treeview('search', [ openByDefault[i], {
                    ignoreCase: false,     // case insensitive
                    exactMatch: false,    // like or equals
                    revealResults: false  // reveal matching nodes
                }])[0];
                $('#data-and-knowledge-treeview').treeview('clearSearch');

                if(matchingNode != null) {
                    openByDefaultIds.push(matchingNode.nodeId);
                }
            }

            expandedDataAndKnowledge = openByDefaultIds;
            sessionStorage.setItem("expandedDataAndKnowledge", JSON.stringify(openByDefaultIds));
        }

        if(expandedDataAndKnowledge != null) {
            for (var i = 0; i < expandedDataAndKnowledge.length; i++) {
                try {
                    $('#data-and-knowledge-treeview').treeview('expandNode', [expandedDataAndKnowledge[i], {silent: true}]);
                } catch(err) {
                    toRemove.push(i);
                }
            }

            if(toRemove.length > 0) {
                for(var i = 0; i < toRemove.length; i++) {
                    expandedDataAndKnowledge.splice(toRemove[i], 1);
                }

                sessionStorage.setItem("expandedDataAndKnowledge", JSON.stringify(expandedDataAndKnowledge));
            }
        }
    });
}

function openViewer(url) {
    window.open(url);
}

function toggleModalItem(key, attrs, name, hasHref, renderHtml) {
    if(key in attrs && attrs[key] != null) {
        var attribute = attrs[key];
        if(Object.prototype.toString.call( attribute ) === '[object Array]') {
            if((key == 'publicationsThatUsedRelease' || key == "publicatoinsAboutRelease" || key == "forecasts" || key == 'executables') && attribute.length > 1) {
                var htmlStr = '<ul style="padding-left:19px"><li>';
                attribute = attribute.join('</li><li>');
                htmlStr += attribute + '</ul>';
                attribute = htmlStr;
            }  else {
                attribute = attribute.join(', ');
            }
        }

        $('#software-' + name + '-container').show();

        if(renderHtml) {
            $('#software-' + name).html(attribute);
        } else {
            $('#software-' + name).text(attribute);
        }

        if(hasHref) {
            $('#software-' + name).attr('href', attribute);
        }
    } else {
        $('#software-' + name + '-container').hide();
    }
}

function toggleRequiredModalItem(key, attrs, name, hasHref, renderHtml, type) {
    if(key in attrs) {
        var attribute = attrs[key];
        if(Object.prototype.toString.call( attribute ) === '[object Array]') {
            if((key == 'dataInputFormats' || key == 'dataOutputFormats') && attribute.length > 1) {
                var htmlStr = '<ul style="padding-left:19px"><li>';
                attribute = attribute.join('</li><li>');
                htmlStr += attribute + '</ul>';
                attribute = htmlStr;
            } else {
                attribute = attribute.join(', ');
            }
        }

        $('#software-' + name + '-container').show();

        if(renderHtml) {
            $('#software-' + name).html(attribute);
        } else {
            $('#software-' + name).text(attribute);
        }

        if(hasHref) {
            $('#software-' + name).attr('href', attribute);
        }
    } else if(type == 'software') {
        $('#software-' + name + '-container').show();
        if(key == 'dataInputFormats' || key == 'dataOutputFormats') {
            $('#software-' + name).html('N/A');
        } else {
            $('#software-' + name).html('N/A');
        }
    } else {
        $('#software-' + name + '-container').hide();
    }
}

function openModal(type, name, json) {
    var attrs = {};

    var softwareIndex = -1;
    if(json != null) {
        attrs = JSON.parse(json);
        name = attrs['title'];

        type = type.toLowerCase();

        $('#display-json').text(JSON.stringify(attrs, null, "\t"));
    } else if(type == 'software') {
        attrs = softwareDictionary[name];
        softwareIndex = parseInt(name);
        name = attrs['title'];

        ga('send', {
            hitType: 'event',
            eventCategory: 'User Activity',
            eventAction: 'Software - ' + name
        });
    } else if(type == 'webServices') {
        attrs = webservicesDictionary[name];
        name = attrs['title'];

        ga('send', {
            hitType: 'event',
            eventCategory: 'User Activity',
            eventAction: 'Web Services - ' + name
        });
    } else if(type == 'syntheticEcosystems' || type == 'epidemics' || type == "syntheticPopulations" || type == "caseSeries" || type == "chikungunya" || type == "diseaseSurveillance" || type == "mortalityData" || type == "zika" || type == "infectiousDisease" || type == "tycho") {
        if(type == 'syntheticEcosystems') {
            attrs = syntheticEcosystemsDictionary[name];

            if(stateHash.hasOwnProperty(name)) {
                name = stateHash[name];
            } else if(countryHash.hasOwnProperty(name)) {
                name = countryHash[name];
            }
        } else if(type == 'epidemics') {
            attrs = epidemicsDictionary[name];
            name = attrs['title'].replace(' data and knowledge', '');
        } else if(type == 'syntheticPopulations') {
            attrs = synthiaPopulationsDictionary[name];
            name = attrs['title'];
        } else if(type == 'caseSeries') {
            attrs = caseSeriesDictionary[name];
            name = attrs['title'];
        } else if(type == 'chikungunya') {
            attrs = chikungunyaDictionary[name];
            name = attrs['title'];
        } else if(type == 'diseaseSurveillance') {
            attrs = diseaseSurveillanceDictionary[name];
            name = attrs['title'];
        } else if(type == 'mortalityData') {
            attrs = moralityDataDictionary[name];
            name = attrs['title'];
        } else if(type == 'zika') {
            attrs = zikaDictionary[name];
            name = attrs['title'];
        } else if(type == 'infectiousDisease') {
            attrs = infectiousDiseaseDictionary[name];
            name = attrs['title'];
        } else if(type == 'tycho') {
            attrs = tychoDictionary[name];
            name = attrs['title'];
        }

        $('#mdc-json').hide();
        $('#dats-json').show();
        $('#modal-switch-btn').show();
        $('#display-json').text(JSON.stringify(attrs['json'], null, "\t"));
    } else if(type == 'dataFormats'){
        attrs = dataFormatsDictionary[name];
        name = attrs['title'];
        $('#mdc-json').hide();
        $('#dats-json').show();
        $('#modal-switch-btn').show();
        $('#display-json').text(JSON.stringify(attrs['json'], null, "\t"));
    } else if(type == 'standardIdentifiers') {
        attrs = standardIdentifiersDictionary[name];
    }

    if(type == 'software' || type == 'webServices' || type == 'standardIdentifiers') {
        $('#dats-json').hide();
        $('#mdc-json').show();
        $('#modal-switch-btn').show();
        if(type == 'software') {
            $.get(ctx + '/getSoftwareXml?index=' + softwareIndex, function(data) {
                $('#display-json').text(new XMLSerializer().serializeToString(data.documentElement));
            });
        } else {
            $('#display-json').text(JSON.stringify(attrs, null, 4));
        }
    }

    if(name != null) {
        $('#software-name').show();
        if('version' in attrs) {
            $('#software-name').text(getSoftwareTitle(name, attrs['version'].join(', ')));
        } else {
            $('#software-name').text(name);
        }
    } else {
        $('#software-name').hide();
    }

    if(attrs.hasOwnProperty('identifier') && attrs['identifier'].hasOwnProperty('identifier')) {
        attrs['identifier'] = attrs['identifier']['identifier']
    }

    if('developers' in attrs) {
        var attribute = attrs['developers'];
        var length = attribute.length;

        attribute = attribute.join(', ');

        $('#software-developer-container').show();
        $('#software-developer').html(attribute);

        if(length > 1) {
            $('#software-developer-tag').text('Developers:');
        } else {
            $('#software-developer-tag').text('Developer:');
        }
    } else {
        $('#software-developer-container').hide();
    }

    if('creator' in attrs) {
        var attribute = attrs['creator'];
        var length = attribute.length;

        attribute = attribute.join(', ');

        $('#software-creator-container').show();
        $('#software-creator').html(attribute);

        if(length > 1) {
            $('#software-creator-tag').text('Creators:');
        } else {
            $('#software-creator-tag').text('Creator:');
        }
    } else {
        $('#software-creator-container').hide();
    }

    if('version' in attrs) {
        var attribute = attrs['version'];
        var length = attribute.length;

        attribute = attribute.join(', ');

        $('#software-version-container').show();
        $('#software-version').text(attribute);

        if(length > 1 && type == 'software') {
            $('#software-version-tag').text('Software versions:');
        } else {
            $('#software-version-tag').text('Software version:');
        }

        if(length > 1 && type == 'webServices') {
            $('#software-version-tag').text('Versions:');
        } else {
            $('#software-version-tag').text('Version:');
        }
    } else if(type != 'syntheticEcosystems' && type != 'epidemics' && type != "syntheticPopulations" && type != "dataFormats" && type != "chikungunya" && type != "caseSeries" && type != "diseaseSurveillance" && type != "mortalityData" && type != "zika" && type != "infectiousDisease" && type != "tycho") {
        $('#software-version').text('N/A');
    } else {
        $('#software-version-container').hide();
    }

    if('dataServiceDescription' in attrs) {
        var descriptions = attrs['dataServiceDescription'];
        for(var i = 0; i < descriptions.length; i++) {
            if(Object.keys(descriptions[i]).includes('accessPointType') && descriptions[i]['accessPointType'] != 'custom') {
                if(descriptions[i]['accessPointType'] == 'REST') {
                    attrs['restDocumentation'] = descriptions[i]['accessPointDescription'];
                } else if(descriptions[i]['accessPointType'] == 'SOAP') {
                    attrs['soapDocumentation'] = descriptions[i]['accessPointDescription'];
                }
            }

            if(descriptions[i]['accessPointUrl'] != null && descriptions[i]['accessPointUrl'] != '') {
                attrs['endpointPrefix'] = descriptions[i]['accessPointUrl'];
            }
        }
    }

    //toggleRequiredModalItem('doi', attrs, 'doi', false, true, type);

    toggleRequiredModalItem('identifier', attrs, 'identifier', false, true, type);

    toggleRequiredModalItem('dataInputFormats', attrs, 'data-input-formats', false, true, type, true);

    toggleRequiredModalItem('dataOutputFormats', attrs, 'data-output-formats', false, true, type, true);

    toggleModalItem('type', attrs, 'type', false, false);

    toggleModalItem('populationSpeciesIncluded', attrs, 'population-species', false, false);

    toggleModalItem('source', attrs, 'source-code', true, false);

    toggleModalItem('pathogenCoverage', attrs, 'pathogen-coverage', false, false);

    toggleModalItem('locationCoverage', attrs, 'location-coverage', false, false);

    toggleModalItem('speciesIncluded', attrs, 'species-included', false, false);

    toggleModalItem('hostSpeciesIncluded', attrs, 'host-species-included', false, false);

    toggleModalItem('controlMeasures', attrs, 'control-measures', false, false);

    toggleModalItem('title', attrs, 'title', false, false);

    toggleModalItem('humanReadableSynopsis', attrs, 'human-readable-synopsis', false, true);

    toggleModalItem('sourceCodeRelease', attrs, 'source-code-release', false, true);

    toggleModalItem('publicationsAboutRelease', attrs, 'publications-about-release', false, true);

    toggleModalItem('publicationsThatUsedRelease', attrs, 'publications-that-used-release', false, true);

    toggleModalItem('webApplication', attrs, 'web-application', true, false);

    toggleModalItem('userGuidesAndManuals', attrs, 'user-guides-and-manuals', true, false);

    toggleModalItem('executables', attrs, 'executables', false, true);

    toggleModalItem('license', attrs, 'license', false, true);

    toggleModalItem('endpointPrefix', attrs, 'end-point-prefix', true, false);

    toggleModalItem('documentation', attrs, 'documentation', false, true);

    toggleModalItem('restDocumentation', attrs, 'rest-documentation', true, false);

    toggleModalItem('soapDocumentation', attrs, 'soap-documentation', true, false);

    toggleModalItem('soapEndpoint', attrs, 'soap-endpoint', true, false);

    toggleModalItem('projectSource', attrs, 'project-source-code', true, false);

    toggleModalItem('soapSource', attrs, 'rest-source-code', true, false);

    toggleModalItem('restSource', attrs, 'soap-source-code', true, false);

    toggleModalItem('exampleQueries', attrs, 'example-queries', false, true);

    toggleModalItem('diseases', attrs, 'diseases', false, false);

    toggleModalItem('region', attrs, 'region', false, true);

    toggleModalItem('locations', attrs, 'locations', false, true);

    toggleModalItem('pathogens', attrs, 'pathogens', false, true);

    toggleModalItem('outcomes', attrs, 'outcomes', false, true);

    toggleModalItem('forecasts', attrs, 'forecasts', false, true);

    toggleModalItem('nowcasts', attrs, 'nowcasts', false, true);

    toggleModalItem('website', attrs, 'website', true, false);

    toggleModalItem('forecastFrequency', attrs, 'forecast-frequency', false, false);

    toggleModalItem('visualizationType', attrs, 'visualization-type', false, false);

    toggleModalItem('grants', attrs, 'grant', false, false);

    toggleModalItem('platform', attrs, 'platform', false, false);

    toggleModalItem('description', attrs, 'description', false, false);

    toggleModalItem('landingPage', attrs, 'landing-page', true, false);

    toggleModalItem('accessUrl', attrs, 'access-url', true, false);

    toggleModalItem('authorizations', attrs, 'authorizations', false, false);

    toggleModalItem('humanReadableSpecification', attrs, 'human-readable-specification', true, false);

    toggleModalItem('machineReadableSpecification', attrs, 'machine-readable-specification', true, false);

    toggleModalItem('validator', attrs, 'validator', true, false);

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

function compareNodes(a,b) {
    if (a.name.trim().toLowerCase() < b.name.trim().toLowerCase())
        return -1;
    if (a.name.trim().toLowerCase() > b.name.trim().toLowerCase())
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

    if(!tab.includes('publication')) {
        $('#data-and-knowledge-tab').removeClass('highlighted-item');
    } else {
        $('#data-and-knowledge-tab').addClass('highlighted-item');
    }
}

function getWebServicesTreeview() {
    var collections = [];
    collections.push(
        {
            text: "WebServices placeholder",
            nodes: []
        }
    );
    return collections;
}

function getSoftwareEnvironmentTreeview() {
    var collections = [];
    collections.push(
        {
            text: "Software environment placeholder",
            nodes: []
        }
    );
    return collections;
}

function getDiseaseTransmissionModelTreeview() {
    var collections = [];
    collections.push(
        {
            text: "Disease transmission model placeholder",
            nodes: []
        }
    );
    return collections;
}

function getToolsTreeview() {
    var collections = [];
    collections.push(
        {
            text: "Statistical analysis software"
        },
        {
            text: "Image manipulation"
        }
    );
    return collections;
}

$('#commons-body').on('click', function (e) {
    //did not click a popover toggle or popover
    if ($(e.target).attr('class') !== 'bs-popover') {
        $("[rel=popover]").not(e.target).popover("destroy");
        $(".popover").remove();
    }

    /*if($(e.target).attr('data-toggle') == 'tab') {
     if($(e.target).attr('href') == '#data-and-knowledge') {
     $('#data-and-knowledge-tab').addClass('highlighted-item');
     } else {
     $('#data-and-knowledge-tab').removeClass('highlighted-item');
     }
     }*/
    //$('[data-toggle="tooltip"]').not(e.target).popover("destroy");
    $('[data-toggle="tooltip"]').tooltip({trigger : 'hover', delay: 350});
});

$(document).ready(function() {
    if ($(window).width() < 768) {
        $('.navbar-toggle').click();
    }
  
    if (location.hash) {
        $("a[href='" + location.hash + "']").tab("show");

        if(location.hash == "#workflows") {
            setTimeout(function(){drawDiagram()}, 300);
        } else if(location.hash == "#modal-json") {
            $('#modal-html-link').click();
            location.hash = '_';
        }

        var elementText = $("a[href='" + location.hash + "']").text();

        if(elementText == '') {
            elementText = 'Data-augmented Publication';
        }

        ga('send', {
            hitType: 'pageview',
            page: location.pathname,
            title: elementText
        });

        if(location.hash.includes('publication')) {
            $('#content-tab').addClass('highlighted-item');
        }
    } else {
        $("#content-tab").click();
        ga('send', {
            hitType: 'pageview',
            page: location.pathname,
            title: 'Content'
        });
    }

    $(document.body).on("click", "a[data-toggle]", function(event) {
        location.hash = this.getAttribute("href");
        ga('send', {
            hitType: 'pageview',
            page: location.pathname,
            title: $(this).text()
        });
    });

    $(document.body).on("click", "a", function(event) {
        var href = this.getAttribute("href");

        if(href.includes('http')) {
            ga('send', {
                hitType: 'event',
                eventCategory: 'Clickthrough',
                eventAction: href
            });
        }
    });

    $('#navbar-collapse').collapse('hide');
});

$(window).on("popstate", function() {
    var anchor = location.hash || $("a[data-toggle='tab']").first().attr("href");
    $("a[href='" + anchor + "']").tab("show");

    if(location.hash.includes('publication')) {
        $('#content-tab').addClass('highlighted-item');
    } else {
        $('#content-tab').removeClass('highlighted-item');
    }
});

function init() {
    var vidDefer = document.getElementsByTagName('iframe');
    for (var i=0; i<vidDefer.length; i++) {
        if(vidDefer[i].getAttribute('data-src')) {
            vidDefer[i].setAttribute('src',vidDefer[i].getAttribute('data-src'));
        } } }
window.onload = init;

function convertDateNumToString(num) {
    if(num < 10) {
        num = '0' + num;
    } else {
        num += ''
    }

    return num;
}

function getFormattedDate() {
    var date = new Date();
    var year = date.getYear()-100;
    var month = date.getMonth() + 1;
    var day = date.getDate();
    var minutes = date.getMinutes();
    var seconds = date.getSeconds();

    year = convertDateNumToString(year);
    month = convertDateNumToString(month);
    day = convertDateNumToString(day);
    minutes = convertDateNumToString(minutes);
    seconds = convertDateNumToString(seconds);

    var formattedDate = year + month + day + minutes + seconds;

    return formattedDate;
}

function drawDiagram() {

    $('#workflow-none-img').hide();
    $('#workflow-spew-img').hide();
    $('#workflow-synthia-img').hide();

    var synthpop = $('input[name=synthpop]:checked').val();
    var dtm = $('input[name=dtm]:checked').val();
    var olympusUsername =$('#olympus-username').val();

    var locationValues = $('#location-select').val().split('_');
    var formattedLocation = formatLocation(locationValues[0]);
    var locationCode = locationValues[1];

    if(synthpop == 'spew') {
        $('#workflow-spew-img').show();
    } else if(synthpop == 'synthia') {
        $('#workflow-synthia-img').show();
    } else {
        $('#workflow-none-img').show();
    }

    if(locationCode != null && synthpop != null && dtm != null) {
        var username = "<username>";
        if(olympusUsername != null && olympusUsername.trim() != '') {
            username = olympusUsername;
        }

        var outputDirectory = locationCode + "_" + dtm + "_" + getFormattedDate();

        if(synthpop == 'spew' ) {
            $('#submit-lsdtm-script').text("/mnt/lustre0/data/shared_group_data/syneco/spew2synthia/scripts/lsdtm.sh -p 2010_ver1_" + locationCode + " -o " + outputDirectory);
        } else {
            $('#submit-lsdtm-script').text("/mnt/lustre0/data/shared_group_data/syneco/spew2synthia/scripts/lsdtm.sh -p 2010_ver1_" + locationCode + " -o " + outputDirectory + " -e fred_populations/United_States_2010_ver1");
        }
        //$('#submit-lsdtm-script').text("/mnt/lustre0/data/shared_group_data/syneco/spew2synthia/scripts/lsdtm.sh -p spew_1.2.0_" + locationCode + " -o " + outputDirectory);
        $('#example-submit-lsdtm-script').text("-bash-4.2$ /mnt/lustre0/data/shared_group_data/syneco/spew2synthia/scripts/lsdtm.sh -p spew_1.2.0_" +
            locationCode + " -o /home/" + username + "/test\n557925.pbs.olympus.psc.edu");

        $('#status-lsdtm-script').text("qstat | grep " + username);
        $('#example-status-lsdtm-script').text("-bash-4.2$ qstat | grep " + username + "\n557925.pbs.olympus.psc.edu ...synthia-1.2.0 " + username + "        00:33:37 R batch");

        $('#view-output-lsdtm-script').text("ls " + outputDirectory);
        $('#example-view-output-lsdtm-script').text("-bash-4.2$ ls /home/" + username + "/test\nspew2synthia-1.2.0.e557925  spew2synthia-1.2.0.o557925  OUT  params");

        if(synthpop == 'spew') {
            $('#view-error-lsdtm-script').text("cat " + outputDirectory + "/spew2synthia-1.2.0.e######");
            $('#example-view-error-lsdtm-script').text("-bash-4.2$ cat /home/" + username + "/spew2synthia-1.2.0.e557925\n\nThe following have been reloaded with a version change:\n1) gcc/4.8.3 => gcc/6.1.0");

        } else {
            $('#view-error-lsdtm-script').text("cat " + outputDirectory + "/United_States_2010_ver1.e######");
            $('#example-view-error-lsdtm-script').text("-bash-4.2$ cat /home/" + username + "/United_States_2010_ver1.e557925\n\nThe following have been reloaded with a version change:\n1) gcc/4.8.3 => gcc/6.1.0");
        }

        if(synthpop == 'spew') {
            $('#view-stdout-lsdtm-script').text("tail " + outputDirectory + "/spew2synthia-1.2.0.o######");
            $('#example-view-stdout-lsdtm-script').text("-bash-4.2$ tail /home/" + username + "/spew2synthia-1.2.0.o557925\n\nday 239 report population took 0.000115 seconds\n" +
                "day 239 maxrss 4068524\nday 239 finished Fri Apr  7 14:53:10 2017\nDAY_TIMER day 239 took 0.002799 seconds\n\n\n" +
                "FRED simulation complete. Excluding initialization, 240 days took 0.493485 seconds\nFRED finished Fri Apr  7 14:53:10 2017\nFRED took 52.511174 seconds");
        } else {
            $('#view-stdout-lsdtm-script').text("tail " + outputDirectory + "/United_States_2010_ver1.o######");
            $('#example-view-stdout-lsdtm-script').text("-bash-4.2$ tail /home/" + username + "/United_States_2010_ver1.o557925\n\nday 239 report population took 0.000115 seconds\n" +
                "day 239 maxrss 4068524\nday 239 finished Fri Apr  7 14:53:10 2017\nDAY_TIMER day 239 took 0.002799 seconds\n\n\n" +
                "FRED simulation complete. Excluding initialization, 240 days took 0.493485 seconds\nFRED finished Fri Apr  7 14:53:10 2017\nFRED took 52.511174 seconds");
        }
        $('#view-fred-out-lsdtm-script').text("cat " + outputDirectory + "/OUT/out1.txt");
        $('#example-view-fred-out-lsdtm-script').text("-bash-4.2$ cat /home/" + username + "/OUT/out1.txt\nDay 0 Date 2012-01-02 WkDay Tue C 10 College 0 Cs 0 E 10 GQ 0 I 0 Is 0 M 0" +
            "Military 0 N 2278377 Nursing_Home 0 P 10 Prison 0 R 0 S 2278367 Week 1 Year 2012 AR 0.00 ARs 0.00 RR 0.00\nDay 1 Date 2012-01-03 WkDay Wed C 0 College 0 Cs 1 E" +
            "9 GQ 0 I 1 Is 1 M 0 Military 0 N 2278377 Nursing_Home 0 P 10 Prison 0 R 0 S 2278367 Week 1 Year 2012 AR 0.00 ARs 0.00 RR 0.00\n.\n.\n.\nDay 238 Date 2012-08-27" +
            "WkDay Tue C 127 College 0 Cs 81 E 232 GQ 0 I 570 Is 376 M 0 Military 0 N 2278377 Nursing_Home 0 P 802 Prison 0 R 2904 S 2274671 Week 35 Year 2012 AR 0.23 ARs 0.14 RR 0.95\n" +
            "Day 239 Date 2012-08-28 WkDay Wed C 108 College 0 Cs 75 E 228 GQ 0 I 593 Is 389 M 0 Military 0 N 2278377 Nursing_Home 0 P 821 Prison 0 R 2966 S 2274590 Week 35 Year 2012 AR 0.23 ARs 0.15 RR 1.20");

        $('#lsdtm-script-container').show();
    } else {
        $('#lsdtm-script-container').hide();
    }
}

function sortSelect(selectId) {
    var options = $(selectId + " option");
    var selected = $(selectId).val();

    options.sort(function(a,b) {
        if (a.text > b.text) return 1;
        if (a.text < b.text) return -1;
        return 0
    });

    $(selectId).empty().append(options);
    $(selectId).val(selected);
}

function checkLocationSelect() {
    if($("#location-select").val() != '') {
        $("#synthpop-radios").children().each(function(index, child) {
            var text = $(child).text();

            $(child).removeAttr("disabled");

            $(child).children().each(function(index, childsChild) {
                $(childsChild).removeAttr("disabled");
                /*if(text == "SPEW") {
                    $(childsChild).click();
                }*/
            });
            drawDiagram();
        });
    } else {
        $("#synthpop-radios").children().each(function(index, child) {
            var text = $(child).text();
            $(child).attr("disabled", "disabled");

            if(text == "SPEW") {
                $(child).children().each(function(index, childsChild) {
                    $(childsChild).attr("disabled", "disabled");
                    $(childsChild).removeAttr("checked");
                });
                drawDiagram();
            }
        });
    }
}

function copyToClipboard(elementId) {
    var $temp = $("<textarea>");
    $("body").append($temp);
    $temp.val($(elementId).text()).select();
    document.execCommand("copy");
    $temp.remove();
}

function download(filename, elementId) {
    var text = $(elementId).text();
    var element = document.createElement('a');

    if(text.includes('xmlns')) {
        filename = filename.replace('.json', '.xml');
    }

    element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
    element.setAttribute('download', filename);

    element.style.display = 'none';
    document.body.appendChild(element);

    element.click();

    document.body.removeChild(element);
}

function openJsonInNewTab(elementId) {
    var text = $(elementId).text();
    var type = 'application/json';
    if(text.includes('xmlns')) {
        type = 'application/xml';
    }
    window.open('data:' + type + ';charset=utf-8,' + encodeURIComponent(text), '_blank');
}

function openJsonStringInNewTab(text) {
    var type = 'application/json';
    if(text.includes('xmlns')) {
        type = 'application/xml';
    }
    window.open('data:' + type + ';charset=utf-8,' + encodeURIComponent(text), '_blank');
}

function toggleElementById(id, element) {
    event.preventDefault();
    var example = $(element).text().indexOf('example') > -1;
    var isVisible = $(id).is(":visible");

    if(isVisible) {
        $(id).fadeOut();

        if(!example) {
            $(element).toggleClass('glyphicon-minus glyphicon-plus');
            $('#example-' + id.replace('#','')).fadeOut();

            var spanId = "#span-a-" + id.replace('#','').replace('-code-block', '');
            var hrefId = "#a-" + id.replace('#','').replace('-code-block', '');

            $(spanId).hide();
            $(hrefId).text('show example');
        } else {
            $(element).text('show example');
        }
    } else {
        $(id).fadeIn();

        if(!example) {
            $(element).toggleClass('glyphicon-plus glyphicon-minus');
            $('#example-' + id.replace('#','')).fadeOut();

            var spanId = "#span-a-" + id.replace('#','').replace('-code-block', '');
            $(spanId).show();
        } else {
            $(element).text('hide example');
        }
    }
}

$('#pageModal').on('hidden.bs.modal', function () {
    $('#modal-switch-btn').text('Switch to Metadata View');
    $('#modal-html-link').click();
    location.hash = '_';
});

function populateFieldValues() {
    var field = $('#field-select').val();
    var valueSet = new Set();

    $('#value-select').empty().append($('<option>', {
        value: '',
        text: ''
    }));

    if(field != null && field != '') {
        var keys = Object.keys(softwareDictionary);
        for(var i = 0; i < keys.length; i ++) {
            var key = keys[i];
            if(key != 'settings') {
                if(softwareDictionary[key]['subtype'] == 'Disease transmission models') {
                    for(var x = 0; x < softwareDictionary[key][field].length; x++) {
                        var value = softwareDictionary[key][field][x];
                        if(value != 'N/A') {
                            valueSet.add(value.toLowerCase());
                        }
                    }
                }
            }
        }

        var valueArray = Array.from(valueSet).sort();
        for(var i = 0; i < valueArray.length; i++) {
            $('#value-select').append($('<option>', {
                value: valueArray[i],
                text: toTitleCase(valueArray[i])
            }));
        }
    }
}

function toTitleCase(str) {
    return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}

function unCamelCase(str){
    return str
        // insert a space between lower & upper
        .replace(/([a-z])([A-Z])/g, '$1 $2')
        // space before last upper in a sequence followed by lower
        .replace(/\b([A-Z]+)([A-Z])([a-z])/, '$1 $2$3')
        // uppercase the first character
        .replace(/^./, function(str){ return str.toUpperCase(); })
}

function changeQueryCategory() {
    var category = $("#category-select").val();
    if(category != null && category != '') {
        if(category == 'software') {
            $('#human-readable-query-text').html('Find every entry in the <i>' + toTitleCase(category) + '</i> category in the MDC.');
        } else {
            $('#human-readable-query-text').html('Find every entry classified as <i>' + toTitleCase(category).slice(0,-1) + '</i> in the <i>Software</i> category in the MDC.');
        }

        $('#human-readable-query').show();
    } else {
        $('#human-readable-query-text').html('');
        $('#human-readable-query').hide();
    }
}

function changeQueryField() {
    var field = $("#field-select").val();
    var value = $("#value-select").val();
    var operator = $('input[name=fieldOperator]:checked').val();

    if(field != null && field != '') {
        if(operator != null && operator != '' && operator == 'hasValue') {
            $('#human-readable-query-text').html('Find every entry classified as <i>Disease Transmission Model</i> in the <i>Software</i> category in the MDC that has the <i>' +  unCamelCase(field) + '</i> field.');
            $('#human-readable-query').show();
        } else if(operator != null && operator != '') {
            if(value != null && value != '') {
                if(operator == 'equals') {
                    $('#human-readable-query-text').html('Find every entry classified as <i>Disease Transmission Model</i> in the <i>Software</i> category in the MDC whose <i>' +  unCamelCase(field) + '</i> is <i>' + toTitleCase(value) + '</i>.');
                } else {
                    $('#human-readable-query-text').html('Find every entry classified as <i>Disease Transmission Model</i> in the <i>Software</i> category in the MDC that contains a <i>' +  unCamelCase(field) + '</i> of <i>' + toTitleCase(value) + '</i>.');
                }
                $('#human-readable-query').show();
            } else {
                $('#human-readable-query-text').html('');
                $('#human-readable-query').hide();
            }
        } else {
            $('#human-readable-query-text').html('');
            $('#human-readable-query').hide();
        }
    } else {
        $('#human-readable-query-text').html('');
        $('#human-readable-query').hide();
    }
}
function getNumConstraints() {
    var numConstraints = $('#constraints-listed li').size();
    return numConstraints;
}
function removeConstraint(element) {
    $(element).closest('li').remove();

    var numConstraints = getNumConstraints();
    if(numConstraints == 0) {
        $('#constraints-listed').hide();
        $('#no-constraints-listed').show();
        $('#run-query').hide();
    }
}

function addConstraintToList() {
    removeDuplicateError();

    if($('#human-readable-query-text').html() != '') {
        var newConstraintHtml = $('#human-readable-query-text').html() + ' <button class="btn btn-default btn-xs" onclick="removeConstraint(this)">Delete</button>';

        var duplicate = false;
        $('#constraints-listed li').each(function(i) {
            if($(this).html() == newConstraintHtml) {
                duplicate = true;
            }
        });

        if(!duplicate) {
            $('#constraints-listed').append($('<li>', {
                'html': newConstraintHtml
            }));

            var numConstraints = getNumConstraints();
            if(numConstraints > 0) {
                $('#no-constraints-listed').hide();
                $('#constraints-listed').show();
                $('#run-query').show();
            }
        } else {
            $('#human-readable-query').addClass('error-color');
            $('#human-readable-query-feedback').text('Error: Duplicate constraint.');
        }
    } else {
        var categoryContainer = $('#category-select-container');
        var fieldContainer = $('#field-select-container');
        var valueContainer = $('#value-select-container');

        if(categoryContainer.is(":visible")) {
            var category = $("#category-select").val();

            if(category == null || category == '') {
                categoryContainer.addClass('has-error');
                $('#category-select-feedback').text('Error: Please select a category.');
            }
        } else if(fieldContainer.is(":visible")) {
            var field = $("#field-select").val();
            var value = $("#value-select").val();

            if(field == null || field == '') {
                fieldContainer.addClass('has-error');
                $('#field-select-feedback').text('Error: Please select a field.');
            }

            if(value == null || value == '') {
                valueContainer.addClass('has-error');
                $('#value-select-feedback').text('Error: Please select a value.');
            }
        }
    }
}

function removeDuplicateError() {
    $('#human-readable-query').removeClass('error-color');
    $('#human-readable-query-feedback').text('');
}

function removeError(element) {
    $('#' + element  + '-container').removeClass('has-error');
    $('#' + element  + '-feedback').text('');
}

function removeErrors() {
    removeError('category-select');
    removeError('field-select');
    removeError('value-select');

    removeDuplicateError();
}

function toggleModalView() {
    if($('#modal-html').hasClass('active')) {
        $('#modal-code-block').css('max-height', $('#modal-html').height() - 25 + 'px')
        $('#modal-json-link').click();
        $('#modal-switch-btn').text('Switch to HTML View');
    } else {
        $('#modal-html-link').click();
        $('#modal-switch-btn').text('Switch to Metadata View');
    }
}

function openUrl(element) {
    event.preventDefault();
    var url = $(element)[0].href;
    if(url.search("apolloLibraryViewer") > -1) {
        $(location).attr('href', ctx + "/midas-sso/view?url=" + encodeURIComponent(url));
    } else {
        $(location).attr('href', url);
    }
}

function addConstraint() {
    if(!$('#new-constraint-1').is(':visible')) {
        $('#new-constraint-1').show();
    } else {
        var newConstraint = $('div[id^="new-constraint-"]:last');
        var num = parseInt( newConstraint.prop("id").match(/\d+/g), 10 ) + 1;

        if(!$('#constraint-operator-1-2').is(':visible')) {
            $('#constraint-operator-1-2').show();
        } else {
            $('#constraints-container').append($('#constraint-operator-1-2').clone().prop('id', 'constraint-operator-' + (num-1) + '-' + num));
        }

        $('#constraints-container').append(newConstraint.clone().prop('id', 'new-constraint-' + num));
        $('#new-constraint-' + num + ' .constraint-header').text('Constraint #' + num);
    }
}

function deleteConstraint(element) {
    var constraintContainer = $(element).parent().parent().parent().parent()[0];
    var containerId = constraintContainer.id;
    var splitContainer = containerId.split('-');
    var num = parseInt(splitContainer[splitContainer.length - 1]);

    var numContainers = $('div[id^="new-constraint-"]').length;
    if(num == 1 && numContainers == 1) {
        $('#new-constraint-' + num).hide();
        $('#constraint-operator-1-2').hide();
    } else {
        var constraintOperator = '#constraint-operator-' + (num-1) + '-' + num;

        if((num % 2) != 0) {
            constraintOperator = '#constraint-operator-' + num + '-' + (num+1);
        }

        $(constraintOperator).remove();
        $('#new-constraint-' + num).remove();
    }

    reindexConstraints();
}

function reindexConstraints() {
    var constraints = $('div[id^="new-constraint-"]');
    var operators = $('div[id^="constraint-operator-"]');

    for(var i = 0; i < constraints.length; i++) {
        $(constraints[i]).prop("id", "new-constraint-" + (i+1));
        $('#new-constraint-' + (i+1) + ' .constraint-header').text('Constraint #' + (i+1));
    }

    for(var i = 0; i < operators.length; i++) {
        $(operators[i]).prop("id", "constraint-operator-" + (i+1) + '-' + (i+2));
    }
}