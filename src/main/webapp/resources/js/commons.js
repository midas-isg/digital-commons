/**
 * Created by jdl50 on 1/6/17.
 */

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


var webservicesDictionary = {};

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

/* Change includes method in IE */
if(!String.prototype.includes) {
    String.prototype.includes = function() {
        'use strict';
        return String.prototype.indexOf.apply(this, arguments) !== -1;
    };
}

function hardcodeFromJson(contextPath, location, treeArray, treeDictionary, treeSettings, treeviewTag, expandedInfo, name) {
    $.getJSON( contextPath + location + '?v=' + Date.now(), function( data ) {
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

        var uniqueTreeArray = [];
        $.each(treeArray, function(i, el){
            if($.inArray(el, uniqueTreeArray) == -1) uniqueTreeArray.push(el);
        });

        addTreeDirectories(directories, uniqueTreeArray);
        addTreeNodes(name, data, treeDictionary, uniqueTreeArray);
        buildBootstrapTree(name, contextPath, uniqueTreeArray, treeviewTag, expandedInfo, treeDictionary, openByDefault);

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
        } else if(key !== "settings" && key !== "EpiCaseMap") {
            var nodeData = getNodeData(name, key, treeDictionary);
            nodeData["nodes"] = [];
            treeArray.push(nodeData);
        }
    }

    for(var i = 0; i < treeArray.length; i++) {
        var rootSoftwareLength = 0;
        for(var x = 0; x < treeArray[i].nodes.length; x++) {
            if(treeArray[i].nodes[x].nodes != null && treeArray[i].nodes[x].nodes.length > 0) {
                rootSoftwareLength += (treeArray[i].nodes[x].nodes.length-1);
                treeArray[i].nodes[x].text += " [" + treeArray[i].nodes[x].nodes.length + "]";
            }
        }

        if(treeArray[i].nodes.length > 0) {
            rootSoftwareLength += treeArray[i].nodes.length;
            treeArray[i].text += " [" + rootSoftwareLength + "]";
        }

    }
}

function buildBootstrapTree(name, contextPath, treeArray, treeviewTag, expandedInfo, treeDictionary, openByDefault) {
    for(var i = 0; i < treeArray.length; i++) {
        if('nodes' in treeArray[i]) {
            treeArray[i].nodes.sort(compareNodes);
        }
    }

    treeArray.sort(compareNodes);

    var treeviewInfo = {
        data: treeArray,
        showBorder: false,
        collapseAll: true,

        expandIcon: "fa fa-chevron-right",
        collapseIcon: "fa fa-chevron-down",

        onNodeSelected: function(event, data) {
            if(typeof data['nodes'] !== undefined) {
                $(treeviewTag).treeview('toggleNodeExpanded', [data.nodeId, { levels: 1, silent: true } ]).treeview('unselectNode', [data.nodeId, {silent: true}]);
            }

            var expandedSoftware = $.parseJSON(sessionStorage.getItem(expandedInfo));

            if(data.state.expanded) {
                if(expandedSoftware !== null) {
                    var index = expandedSoftware.indexOf(data.nodeId);
                    if (index > -1) {
                        expandedSoftware.splice(index, 1);
                    }
                }
            } else {
                if(expandedSoftware !== null) {
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

            if(data.url !== null && data.state.selected === true) {
                ga('send', {
                    hitType: 'event',
                    eventCategory: 'Clickthrough',
                    eventAction: data.url
                });

                window.location.href = data.url;

            }
        }
    };

    if(name === "diseaseTransmissionModels" || name === "systemSoftware" || name === "tools" || name === "standardIdentifiers") {
        treeviewInfo['expandIcon'] = "bullet-point";
        treeviewInfo['collapseIcon'] = "bullet-point";
        treeviewInfo['highlightSelected'] = false;
        treeviewInfo['onNodeSelected'] = function(event, data) {
            $('[data-toggle="tooltip"]').tooltip('destroy');
            event.stopPropagation();
        };
        $(treeviewTag).treeview(treeviewInfo);
        $(treeviewTag).treeview('expandAll', { silent: true });
    } else {
        if(name === "standardIdentifiers") {
            treeviewInfo['expandIcon'] = "";
            treeviewInfo['collapseIcon'] = "";
        }

        $(treeviewTag).treeview(treeviewInfo);
        $(treeviewTag).treeview('collapseAll', { silent: true });
    }

    var expandedSoftware = $.parseJSON(sessionStorage.getItem(expandedInfo));
    var toRemove = [];

    if(expandedSoftware === null) {
        var openByDefaultIds = [];
        for(var i = 0; i < openByDefault.length; i++) {
            var matchingNode = $(treeviewTag).treeview('search', [ openByDefault[i], {
                ignoreCase: false,     // case insensitive
                exactMatch: false,    // like or equals
                revealResults: false  // reveal matching nodes
            }])[0];
            $(treeviewTag).treeview('clearSearch');
            if(matchingNode !== null) {
                openByDefaultIds.push(matchingNode.nodeId);
            }
        }

        expandedSoftware = openByDefaultIds;
        sessionStorage.setItem(expandedInfo, JSON.stringify(openByDefaultIds));
    }

    if(expandedSoftware !== null) {
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

    if('availableOnOlympus' in treeDictionary[key] && treeDictionary[key]['availableOnOlympus'] === true) {
        nodeData.text += ' <b><i class="olympus-color"><sup>AOC</sup></i></b>';
    }

    if('availableOnUIDS' in treeDictionary[key] && treeDictionary[key]['availableOnUIDS'] === true) {
        nodeData.text += ' <b><i class="udsi-color"><sup>UIDS</sup></i></b>';
    }

    if('signInRequired' in treeDictionary[key] && treeDictionary[key]['signInRequired'] === true) {
        nodeData.text += ' <b><i class="sso-color"><sup>SSO</sup></i></b>';
    }

    if('redirect' in treeDictionary[key] && treeDictionary[key]['redirect'] === true) {
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

            if('availableOnOlympus' in treeDictionary[key] && treeDictionary[key]['availableOnOlympus'] === true) {
                nodeData.text += ' <b><i class="olympus-color"><sup>AOC</sup></i></b>';
            }

            if('availableOnUIDS' in treeDictionary[key] && treeDictionary[key]['availableOnOlympus'] === true) {
                nodeData.text += ' <b><i class="udsi-color"><sup>UIDS</sup></i></b>';
            }

            if('signInRequired' in treeDictionary[key] && treeDictionary[key]['signInRequired'] === true) {
                nodeData.text += ' <b><i class="sso-color"><sup>SSO</sup></i></b>';
                nodeData['signInRequired'] = treeDictionary[key]['signInRequired'];
            }
        }
    }

    if(name !== "software" && name !== "webServices" && name !== "dataFormats" && name !== "standardIdentifiers") {
        nodeData.text = "<span data-placement='auto right' data-container='body' data-toggle='tooltip' title='" + treeDictionary[key]["description"] + "'>" + title + "</span>";
    }

    return nodeData;
}

function getSoftwareTitle(name, version) {
    var title = name;

    var splitTitle = title.split(' ');
    var titleEnd = splitTitle[splitTitle.length - 1];
    if(titleEnd.length === 3 && titleEnd.startsWith('[') && titleEnd.endsWith(']')) {
        title = splitTitle.slice(0, splitTitle.length - 1).join(' ');
    }

    version = version.split(' - ')[0];

    if(version !== '') {
        if(isNaN(version[0]) || version === '2010 U.S. Synthesized Population') {
            title += ' - ' + version;
        } else {
            title += ' - v' + version;
        }
    }
    return title;
}

identifierCodes = {
    "12637": "Dengue virus",
    "114727": "H1N1 virus",
    "333278": "H7N9 virus",
    "12721": "Human immunodeficiency virus",
    "64320": "Zika virus",
    "12066": "Coxsackievirus",
    "1570291": "Ebola virus",
    "1392": "Bacillus anthracis",
    "119210": "H3N2 virus",
    "11309": "Influenza virus",
    "10345": "Suid alphaherpesvirus 1",
    "418103": "Plasmodium",
    "9606": "Homo sapiens",
    "7157": "Culicidae",
    "7159": "Aedes aegypti",
    "476836": "San Juan, Puerto Rico",
    "366188": "Los Angeles, California",
    "5196": "Denmark",
    "5622": "Yucatan, Mexico",
    "11": "Sierra Leone",
    "1216": "United States of America",
    "510873": "Seattle, Washington",
    "542924": "Cairns, Australia",
    "544694": "Worldwide",
    "544695": "The Americas",
    "544287": "Iquitos, Peru",
    "544696": "The Caribbean",
    "544697": "Latin America",
    "542920": "South America"
};

function identifierToString(attribute) {
    if(attribute.hasOwnProperty('identifier')) {
        var identifier = attribute['identifier'];
        if(identifierCodes.hasOwnProperty(identifier['identifier'])) {
            attribute = identifierCodes[identifier['identifier']];
        } else if(identifier.hasOwnProperty('identifierDescription') ) {
            attribute = identifier['identifierDescription'];
        }
    }
    return attribute;
}

function nameToString(attribute) {
    var name = {};
    if(attribute.hasOwnProperty('name')) {
        name = attribute['name'];
    }

    if(attribute.hasOwnProperty('location')) {
        name += ", " + attribute['location'];
    }

    if(Object.keys(name).length === 0){
        return attribute;
    }
    return name;
}

function listToHtmlString(attributeList) {
    var htmlStr = '<ul style="padding-left:19px"><li>';
    attributeList = attributeList.join('</li><li>');
    htmlStr += attributeList + '</ul>';
    return htmlStr;
}

function displayList(attributeList) {
    for(var i=attributeList.length-1; i>=0; i--) {
        if(Object.prototype.toString.call( attributeList[i] ) === '[object Object]') {
            attributeList.splice(i, 1);
        }
    }
    var attribute = attributeList.join(', ');
    if(!attribute.includes('http')) {
        attribute = attribute.charAt(0).toUpperCase() + attribute.slice(1);
    }
    return attribute;
}

function parseAttributeList(attributeList, hasNulls) {
    for(var i = 0; i < attributeList.length; i++) {
        attributeList[i] = identifierToString(attributeList[i]);
        if(attributeList[i] !== null && attributeList[i].length > 0) {
            hasNulls = false;
        }
    }
}

var convertToHtml = [
    "publicationsThatUsedRelease",
    "publicatoinsAboutRelease",
    "forecasts",
    "executables",
    "dataInputFormats",
    "dataOutputFormats"
];

function toggleModalItem(key, attrs, name, hasHref, renderHtml) {
    var elementId = '#software-' + name;
    var containerId = elementId + '-container';

    if((key in attrs && attrs[key] !== null) || (key === 'accessURL' || key === 'landingPage')) {
        var attribute;
        if(key in attrs) {
            attribute = attrs[key];
        } else if(attrs['distributions'] !== null) {
            try {
                if(key == "accessURL") {
                    if(attrs['distributions'].length > 1) {
                        attribute = new Array();
                        for (var i = 0; i < attrs['distributions'].length; i++) {
                            if(attrs['distributions'][i]['formats'][0] != null) {
                                attribute.push('<a class="underline" href="' + attrs['distributions'][i]['access'][key] + '">' + attrs['distributions'][i]['formats'][0] + '</a>');
                            } else {
                                attribute.push('<a class="underline" href="' + attrs['distributions'][i]['access'][key] + '">' + attrs['distributions'][i]['access'][key] + '</a>');
                            }
                        }
                        attribute = uniqueArray(attribute);
                    } else {
                        if(attrs['distributions'][0]['formats'][0] != null) {
                            attribute = '<a class="underline" href="' + attrs['distributions'][0]['access'][key] + '">' + attrs['distributions'][0]['formats'][0] + '</a>';
                        } else {
                            attribute = '<a class="underline" href="' + attrs['distributions'][0]['access'][key] + '">' + attrs['distributions'][0]['access'][key] + '</a>';
                        }
                    }
                } else {
                    attribute = attrs['distributions'][0]['access'][key];
                }
            } catch (err) {
                $(containerId).hide();
                return;
            }

            if(attribute === null || attribute === undefined) {
                $(containerId).hide();
                return;
            }
        } else {
            $(containerId).hide();
            return;
        }
        var hasNulls = true;
        if(Object.prototype.toString.call( attribute ) === '[object Array]') {
            for(var i = 0; i < attribute.length; i++) {
                attribute[i] = identifierToString(attribute[i]);
                if (attribute[i] !== null && attribute[i].length > 0) {
                    hasNulls = false;
                }

                attribute[i] = nameToString(attribute[i]);
                if (attribute[i] !== null && attribute[i].length > 0) {
                    hasNulls = false;
                }


            }

            if(hasNulls) {
                $(containerId).hide();
            }

            if(convertToHtml.indexOf(key) > -1 && attribute.length > 1) {
                attribute = listToHtmlString(attribute);
            }  else {
                attribute = displayList(attribute);
            }
        } else if(key === 'producedBy') {
            if(Object.keys(attribute).length !== 0) {
                if(Object.keys(attribute).includes('location') && Object.keys(attribute['location']).length !== 0) {
                    attribute = attribute['name'] + ", " + attribute['location']['postalAddress'];
                } else {
                    attribute = attribute['name'];
                }
                hasNulls = false;
            } else {
                $(containerId).hide();
            }
        } else if (key === 'type') {
            if(Object.keys(attribute).length !== 0) {
                if(Object.prototype.toString.call( attribute ) === "[object Object]") {
                    attribute = attribute['value'];
                }
                if(attribute.length > 0) {
                    hasNulls = false;
                }
            } else {
                $(containerId).hide();
            }
        } else {
            hasNulls = false;
        }

        if (!hasNulls) {
            if(renderHtml) {
                if(elementId === '#software-description'){
                    attribute = replaceAll(attribute,'\n', '<br>');
                }
                $(elementId).html(attribute);
            } else {
                $(elementId).text(attribute);
            }

            if(hasHref) {
                $(elementId).attr('href', attribute);
            }

            $(containerId).show();
        } else {
            $(containerId).hide();
        }
    } else {
        $(containerId).hide();
    }
}

function escapeRegExp(str) {
    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

function replaceAll(str, find, replace) {
    return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}

function toggleRequiredModalItem(key, attrs, name, hasHref, renderHtml, type) {
    var elementId = '#software-' + name;
    var containerId = elementId + '-container';

    if(key in attrs) {
        var attribute = attrs[key];
        var hasNulls = true;

        if (key === 'identifier') {
            if (Object.prototype.toString.call( attribute ) === '[object Array]') {
                for(var i = 0; i < attribute.length; i++) {
                    attribute[i] = identifierToString(attribute[i]);
                    if(attribute[i].identifier !== 'undefined') {
                        attribute = attribute[i].identifier;
                        hasNulls = false;
                        break;
                    }
                }
            } else {
                attribute = attribute['identifier'];
            }
            hasNulls = attribute === null;
        } else if (Object.prototype.toString.call( attribute ) === '[object Array]')  {
            for(var i = 0; i < attribute.length; i++) {
                attribute[i] = identifierToString(attribute[i]);
                if(attribute[i] !== null && attribute[i].length > 0) {
                    hasNulls = false;
                }
            }

            if(hasNulls) {
                $(containerId).hide();
            }

            if(convertToHtml.indexOf(key) > -1 && attribute.length > 1) {
                attribute = listToHtmlString(attribute);
            } else {
                attribute = displayList(attribute);
            }
        } else {
            hasNulls = false;
        }

        if(!hasNulls) {
            if(attribute.startsWith('http') && !attribute.includes(' ')) {
                attribute = "<a class='underline' href='" + attribute + "'>" + attribute + "</a>";
            }

            if(renderHtml) {
                $(elementId).html(attribute);
            } else {
                $(elementId).text(attribute);
            }

            if(hasHref) {
                $(elementId).attr('href', attribute);
            }

        //    $(containerId).show();
        //} else if(!type.includes('Dataset') && !type.includes('DataStandard')) {
        //    $(containerId).show();
        //    $(elementId).html('N/A');
        }
        //else {
//      }
        //let's always show the identifier and see how it goes
        $(containerId).show();
    } else if(!type.includes('Dataset') && !type.includes('DataStandard')) {
        $(containerId).show();
        $(elementId).html('N/A');
    } else {
        $(containerId).hide();
    }
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

$('#commons-body').on('click', function (e) {
    //did not click a popover toggle or popover
    if ($(e.target).attr('class') !== 'bs-popover') {
        $("[rel=popover]").not(e.target).popover("destroy");
        $(".popover").remove();
    }

    $('[data-toggle="tooltip"]').tooltip({trigger : 'hover', delay: 350});
});

$(document).ready(function() {
    if ($(window).width() < 768) {
        $('.navbar-toggle').click();
    }

    var hashElement = $("a[href='" + location.hash + "']");
    if (location.hash && hashElement.length > 0) {
        try {
            hashElement.tab("show");
        } catch (e) {}
        if(location.hash === "#workflows") {
            setTimeout(function(){drawDiagram()}, 300);
        } else if(location.hash === "#modal-json") {
            $('#modal-html-link').click();
            location.hash = '_';
        }

        var elementText = $("a[href='" + location.hash + "']").text();

        if(elementText === '') {
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

        if(href!=undefined && nulhref.includes('http')) {
            ga('send', {
                hitType: 'event',
                eventCategory: 'Clickthrough',
                eventAction: href
            });
        }
    });

    $('#navbar-collapse').collapse('hide');

    $('#pageModal').on('hidden.bs.modal', function () {
        $('#modal-switch-btn').text('Switch to Metadata View');
        $('#modal-html-link').click();
        location.hash = '_';
    });

});

// Collapsible Card
$(document).on('click', 'a[data-action="collapse"]', function (e) {
    e.preventDefault();
    $(this).closest(".card").children(".card-content").collapse("toggle");
    $(this).closest(".card").find('[data-action="collapse"] i').toggleClass("ft-minus ft-plus");
});

// Toggle fullscreen
$(document).on('click', 'a[data-action="expand"]', function (e) {
    e.preventDefault();
    $(this).closest('.card').find('[data-action="expand"] i').toggleClass('ft-maximize ft-minimize');
    $(this).closest('.card').toggleClass('card-fullscreen');
});

function rearrangeCards(parentDiv) {
    if($('#'+parentDiv).children('.card-button').length > 0 ) {
        $('#'+parentDiv).children('.card-button').each(function () {
            $($(this)[0]).appendTo("#" + parentDiv + "-card-row");
        });
    } else {
        $('#' + parentDiv).children().children('.card-button').each(function () {
            $($(this)[0]).appendTo("#" + parentDiv + "-card-row");
        });
    }
}

function makeAllTabsInactive(specifier) {
    $("#"+ specifier+"-card-header").find("a").each(function () {
        $(this).removeClass("active");
    });
}

function closeTab(e, div, specifier) {

    //find closest tab to the left tab to make it active (we don't just want to use the first tab)
    var prevDiv = undefined;
    var takeNext = false;
    $("#"+specifier+"-card-header").find("a").each(function () {
        if (takeNext) {
            prevDiv = $(this.parentElement);
            return false;
        }
        if ($(div.parentElement.parentElement).attr("for") == $(this.parentElement).attr("for")) {
            if ($(this).hasClass("active")) {
                takeNext = true;
            }
        } else if ($(this).hasClass("active")) {
            prevDiv = $(this.parentElement);
            return false;
        } else prevDiv = $(this.parentElement);


    });
    var divToClose = $(div.parentElement.parentElement).attr("for")
    $("#" + divToClose).remove();
    $(div.parentElement.parentElement).remove();

    $("#" + $(prevDiv).attr("for")).show();
    $($(prevDiv).find("a")[0]).addClass("active")

    e.preventDefault();
    e.stopPropagation();
};

//find each card header in the section and subsections and close all tabs
function closeAllTabs(e, div) {
    $(div).find(".card-header").each(function() {
        closeAllTabs(e, $(this));
        $(this).find("a").each(function(){
            if ($(this).hasClass("nav-link")) {
                $(this.parentElement).remove();
            }
        });
    });
};

function showTab(e, div, specifier) {
    makeAllTabsInactive(specifier);
    console.log("calling showTab");
    var divToShow = $(div.parentElement).attr('for');

    $(div).addClass("active");

    $('#'+specifier+'-card .card-content').each(function (index) {
        if ($(this).attr("id") != divToShow) {
            $(this).addClass("hide");
        }
    });

    $('#' + divToShow).removeClass("hide");
    $('#' + divToShow + ' .card-content').each(function (index) {
        //if card is unbounded list we find the 'active' tab and unhide that input block
        var inputBlockID = $(this).attr("id");
        var tabID = inputBlockID.replace("input-block", "tab");

        //the card is not an unbounded list so display the input block

        if ($("#" + tabID).length == 0) {
            $(this).removeClass("hide");
        }

        if ($("#" + tabID).children().hasClass("active")) {
            $(this).removeClass("hide");
        }
    });
};

function showTabNamed(tabToActivate, divToShow, specifier) {
    makeAllTabsInactive(specifier);
    console.log("calling showTabNamed");
    // var divToShow = $(div.parentElement).attr('for');

    $('#' + divToShow).removeClass("hide");
    //   $(tabToActivate).addClass("active");
    $($("[for='" + divToShow + "'] .nav-link")[0]).addClass("active");
    $('#'+specifier+'-card .card-content').each(function (index) {
        if ($(this).attr("id") != divToShow) {
            $(this).addClass("hide");
        }
    });

    $('#' + divToShow + ' .card-content').each(function (index) {
        //if card is unbounded list we find the 'active' tab and unhide that input block
        var inputBlockID = $(this).attr("id");
        var tabID = inputBlockID.replace("input-block", "tab");

        //the card is not an unbounded list so display the input block
        if ($("#" + tabID).length == 0) {
            $(this).removeClass("hide");
        }

        if ($("#" + tabID).children().hasClass("active")) {
            $(this).removeClass("hide");
        }
    });
};

function createNewTab(thisObject, specifier, path, tagName, label, isFirstRequired, listItemCount) {
    var html, regexEscapeOpenBracket, regexEscapeClosedBracket, newDivId, regexPath, regexSpecifier;

    $("#"+specifier+"-add-input-button").addClass("hide");
    $("#"+specifier+"-card").removeClass("hide");
    if (tagName == 'personComprisedEntity') {
        if (thisObject.id == ""+specifier+"-add-"+tagName+"-person") {
            if (listItemCount === 0 && isFirstRequired) {
                html = $("#" + specifier+"-person-required-copy-tag").html();
            } else html = $("#" + specifier+"-person-copy-tag").html();
        } else if (thisObject.id == specifier+"-add-"+tagName+"-organization") {
            if (listItemCount === 0 && isFirstRequired) {
                html = $("#" + specifier+"-organization-required-copy-tag").html();
            } else html = $("#" + specifier+"-organization-copy-tag").html();
        }
    } else if (tagName == 'isAbout') {
        if (thisObject.id == specifier+"-add-"+tagName+"-annotation") {
            html = $("#" + specifier+"-annotation-copy-tag").html();
        } else if (thisObject.id == specifier+"-add-"+tagName+"-biologicalEntity") {
            html = $("#" + specifier+"-biologicalEntity-copy-tag").html();
        }
    } else {
        html = $("#" + specifier + "-"+tagName+"-copy-tag").html();
    }


    regexEscapeOpenBracket = new RegExp('\\[', "g");
    regexEscapeClosedBracket = new RegExp('\\]', "g");
    path = path.replace(regexEscapeOpenBracket, '\\[').replace(regexEscapeClosedBracket, '\\]');
    regexPath = new RegExp(path + '\\[0\\]', "g");
    regexSpecifier = new RegExp(specifier + '\\-00', "g");
    html = html.replace(regexPath, path+'[' + listItemCount + ']')
        .replace(regexSpecifier, specifier+'-' + listItemCount);

    newDivId = html.match(specifier+"-\\d*[A-Za-z\-]*")[0];
    $("."+specifier+"-"+tagName+"-add-more").before(html);
    $("#"+specifier+"-" + listItemCount + "-date-picker").datepicker({
        forceParse: false,
        orientation: 'top auto',
        todayHighlight: true,
        format: 'yyyy-mm-dd',
        uiLibrary: 'bootstrap4',
    });

    makeAllTabsInactive(specifier);
    //create a new tab
    $("#" + specifier + "-card").find(".card-header-tabs").first().append("<li  for=" + newDivId + " id=\""+specifier+"-" + listItemCount + "-tab\" class=\"nav-item\">" +
        " <a onclick=\"showTab(event, this, '"+specifier+"')\" class=\"wizard-nav-link nav-link active\" >"+label+ " " + listItemCount +
        "<i onclick=\"closeTab(event, this, '"+specifier+"')\" class=\"ft-x\"></i></a></li>");


    //switch to newly created tab
    showTabNamed(specifier+"-" + listItemCount + "-tab", newDivId, specifier);

    $("#"+specifier+"-"+listItemCount+"-input-block").addClass("collapse");
    $("#"+specifier+"-"+listItemCount+"-input-block").addClass("show");
    //move card buttons to the bottom
    rearrangeCards(specifier+'-' + listItemCount + '-input-block');
}

$(window).on("popstate", function() {
    var anchor = location.hash || $("a[data-toggle='tab']").first().attr("href");
    try {
        $("a[href='" + anchor + "']").tab("show");
    } catch (e) {

    }

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

function toggleModalView() {
    if($('#modal-html').hasClass('active')) {
        // $('#modal-code-block').css('max-height', $('#modal-html').height() - 25 + 'px');
        $('#modal-json-link').click();
        $('#modal-switch-btn').text('Switch to HTML View');
    } else {
        $('#modal-html-link').click();
        $('#modal-switch-btn').text('Switch to Metadata View');
    }
}

function toggleLegend(cmd) {
    if(cmd === "hide") {
        $('#main-legend').hide();
        $('#show-legend').show();
    } else if(cmd === "show") {
        $('#show-legend').hide();
        $('#main-legend').show();
    }
}

function uniqueArray(arrArg) {
    return arrArg.filter(function(elem, pos,arr) {
        return arr.indexOf(elem) == pos;
    });
};