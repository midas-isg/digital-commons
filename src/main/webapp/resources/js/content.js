var digitalObjs = {
    "software": []
};

function getEntryFromJson(jsonString) {
    var entryViewObj = JSON.parse(jsonString);
    return entryViewObj["entry"];
}

function createBootstrapTree(entries, treeId, sessionVariable) {
    var subtypes = [];
    var entriesData = [];

    for(var x = 0; x < entries.length; x++) {
        var entryObj = entries[x];

        var subtype = entryObj["subtype"];
        var subtypeIndex = -1;
        if(!subtypes.includes(subtype)) {
            var treeNode = {
                text: subtype,
                nodes: []
            };

            entriesData.push(treeNode);
            subtypes.push(subtype);
            subtypeIndex = entriesData.length - 1;
        } else {
            subtypeIndex = subtypes.indexOf(subtype);
        }

        var product = entryObj["product"];
        if(product !== undefined && product.length > 0) {
            var containsProduct = false;
            for(var i = 0; i < entriesData[subtypeIndex].nodes.length; i++) {
                var currProduct = entriesData[subtypeIndex].nodes[i].product;

                if(currProduct !== undefined && currProduct === product) {
                    entriesData[subtypeIndex].nodes[i].nodes.push(
                        getSoftwareNode(entryObj)
                    );
                    containsProduct = true;
                    break;
                }
            }

            if(!containsProduct) {
                entriesData[subtypeIndex].nodes.push({
                    text: product,
                    nodes: [getSoftwareNode(entryObj)],
                    product: product,
                    name: product
                });
            }
        } else {
            entriesData[subtypeIndex].nodes.push(
                getSoftwareNode(entryObj)
            );
        }
    }

    entriesData = sortAndCountSoftware(entriesData);
    $(treeId).treeview(getTreeviewInfo(entriesData, treeId, sessionVariable));
}

function expandNodesInSessionVariable(treeId, sessionVariable) {
    var expanded = $.parseJSON(sessionStorage.getItem(sessionVariable));
    var toRemove = [];

    /*if(expanded === null) {
        var openByDefaultIds = [];
        for(var i = 0; i < openByDefault.length; i++) {
            var matchingNode = $(treeId).treeview('search', [ openByDefault[i], {
                ignoreCase: false,     // case insensitive
                exactMatch: false,    // like or equals
                revealResults: false  // reveal matching nodes
            }])[0];
            $(treeId).treeview('clearSearch');
            if(matchingNode !== null) {
                openByDefaultIds.push(matchingNode.nodeId);
            }
        }

        expanded = openByDefaultIds;
        sessionStorage.setItem(expandedInfo, JSON.stringify(openByDefaultIds));
    }*/

    if(expanded !== null) {
        for(var j = 0; j < expanded.length; j++) {
            try {
                $(treeId).treeview('expandNode', [ expanded[j], { silent: true } ]);
            } catch(err) {
                toRemove.push(j);
            }
        }

        if(toRemove.length > 0) {
            for(var k = 0; k < toRemove.length; k++) {
                expanded.splice(toRemove[k], 1);
            }

            sessionStorage.setItem(sessionVariable, JSON.stringify(expanded));
        }
    }
}

function getTreeviewInfo(entriesData, treeId, sessionVariable) {
    return {
        data: entriesData,
        showBorder: false,
        collapseAll: true,

        expandIcon: "glyphicon glyphicon-chevron-right",
        collapseIcon: "glyphicon glyphicon-chevron-down",

        onNodeSelected: function(event, data) {
            var info = data['info'];
            if(info !== undefined && info.hasOwnProperty('entry')) {
                if(info['entry'] !== undefined) {
                    showModal(info, "software");
                }
            }
            if(typeof data['nodes'] !== undefined) {
                $(treeId).treeview('toggleNodeExpanded', [data.nodeId, { levels: 1, silent: true } ])
                    .treeview('unselectNode', [data.nodeId, {silent: true}]);
            }
            
            var expanded = $.parseJSON(sessionStorage.getItem(sessionVariable));

            var index;
            if(data.state.expanded) {
                if(expanded !== null) {
                    index = expanded.indexOf(data.nodeId);
                    if (index > -1) {
                        expanded.splice(index, 1);
                    }
                }
            } else {
                if(expanded !== null) {
                    index = expanded.indexOf(data.nodeId);
                    if (index <= -1) {
                        expanded.push(data.nodeId);
                    }
                } else {
                    expanded = [];
                    expanded.push(data.nodeId);
                }
            }

            sessionStorage.setItem(sessionVariable, JSON.stringify(expanded));


            if(data.url !== null && data.state.selected === true) {
                ga('send', {
                    hitType: 'event',
                    eventCategory: 'Clickthrough',
                    eventAction: data.url
                });

                if('signInRequired' in data && data['signInRequired'] === true) {
                    window.location.href = data.url;
                }
            }
        }
    };
}

function showModal(info, type) {
    var entry = info["entry"];

    $('#display-json').text(JSON.stringify(entry, null, "\t"));
    
    toggleModalItems(entry, type);

    $('#pageModal').modal('show');
}

function sortAndCountSoftware(softwareData) {
    for(var i = 0; i < softwareData.length; i++) {
        var nodeLength = softwareData[i].nodes.length;
        for(var h = 0; h < softwareData[i].nodes.length; h++) {
            if(softwareData[i].nodes[h].nodes !== undefined) {
                var innerNodeLength = softwareData[i].nodes[h].nodes.length;
                nodeLength += innerNodeLength - 1;

                softwareData[i].nodes[h].text += getCountBadge(innerNodeLength);
                softwareData[i].nodes[h].text = wrapInSpan(softwareData[i].nodes[h].text);

                softwareData[i].nodes[h].nodes.sort(compareNodes);
            }
        }
        softwareData[i].text += getCountBadge(nodeLength);
        softwareData[i].text = wrapInSpan(softwareData[i].text);

        softwareData[i].nodes.sort(compareNodes);
    }
    return softwareData;
}

function getCountBadge(count) {
    return " <span class='badge'>[" + count + "]</span>";
}

function addLegendBadge(entryObj, title) {
    var availableOnOlympus = entryObj["availableOnOlympus"];
    var availableOnUIDS = entryObj["availableOnUIDS"];
    var signInRequired = entryObj["signInRequired"];

    if(availableOnOlympus !== undefined && availableOnOlympus) {
        title += " <b><i class=\"olympus-color\"><sup>AOC</sup></i></b>";
    }

    if(availableOnUIDS !== undefined && availableOnUIDS) {
        title += " <b><i class=\"udsi-color\"><sup>UIDS</sup></i></b>";
    }

    if(signInRequired !== undefined && signInRequired) {
        title += " <b><i class=\"sso-color\"><sup>SSO</sup></i></b>";
    }

    return title;
}

function wrapInSpan(str) {
    return "<span onmouseover=\"toggleTitle(this)\">" + str + "</span>";
}

function getSoftwareNode(entryObj) {
    var title = entryObj["title"];
    var version = entryObj["version"];

    if(version !== undefined) {
        version = version.join(", ");
        title = getSoftwareTitle(title, version);
    }

    title = addLegendBadge(entryObj, title);

    title = wrapInSpan(title);
    return {
        text: title,
        name: entryObj["title"],
        info: {
            entry: entryObj
        }
    };
}

function capitalizeFirst(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function setModalHeader(entry) {
    var title = entry["title"];
    var version = entry["version"];

    var modalHeaderId = '#software-name';
    var modalHeaderText = title;
    if(title !== undefined) {
        modalHeaderText = title;
        if(version !== undefined) {
            modalHeaderText = getSoftwareTitle(title, version.join(', '));
        }
        $(modalHeaderId).text(modalHeaderText);
        $(modalHeaderId).show();
    } else {
        $(modalHeaderId).hide();
    }
}

function setSingularOrPluralModalItem(entry, key, elementName) {
    var elementId = '#software-' + elementName;
    var containerId = elementId + '-container';
    var tagId = elementId + '-tag';

    var singular = capitalizeFirst(elementName);
    var plural = singular + 's';

    if(key in entry) {
        var attribute = entry[key];
        var length = attribute.length;

        attribute = attribute.join(', ');

        $(containerId).show();
        $(elementId).html(attribute);

        if(length > 1) {
            $(tagId).text(plural + ':');
        } else {
            $(tagId).text(singular + ':');
        }
    } else {
        $(containerId).hide();
    }
}

function setDataServiceDescription(entry) {
    if('dataServiceDescription' in entry) {
        var descriptions = entry['dataServiceDescription'];
        for(var i = 0; i < descriptions.length; i++) {
            if(Object.keys(descriptions[i]).includes('accessPointType') && descriptions[i]['accessPointType'] !== 'custom') {
                if(descriptions[i]['accessPointType'] === 'REST') {
                    entry['restDocumentation'] = descriptions[i]['accessPointDescription'];
                } else if(descriptions[i]['accessPointType'] === 'SOAP') {
                    entry['soapDocumentation'] = descriptions[i]['accessPointDescription'];
                }
            }

            if(descriptions[i]['accessPointUrl'] !== null && descriptions[i]['accessPointUrl'] !== '') {
                entry['endpointPrefix'] = descriptions[i]['accessPointUrl'];
            }
        }
    }
    return entry;
}

function toggleModalItems(entry, type) {
    setModalHeader(entry);

    setSingularOrPluralModalItem(entry, 'developers', 'developer');
    setSingularOrPluralModalItem(entry, 'creator', 'creator');
    setSingularOrPluralModalItem(entry, 'version', 'version');

    entry = setDataServiceDescription(entry);

    toggleRequiredModalItem('identifier', entry, 'identifier', false, true, type);
    toggleRequiredModalItem('dataInputFormats', entry, 'data-input-formats', false, true, type, true);
    toggleRequiredModalItem('dataOutputFormats', entry, 'data-output-formats', false, true, type, true);

    toggleModalItem('type', entry, 'type', false, false);
    toggleModalItem('populationSpeciesIncluded', entry, 'population-species', false, false);
    toggleModalItem('source', entry, 'source-code', true, false);
    toggleModalItem('pathogenCoverage', entry, 'pathogen-coverage', false, false);
    toggleModalItem('locationCoverage', entry, 'location-coverage', false, false);
    toggleModalItem('speciesIncluded', entry, 'species-included', false, false);
    toggleModalItem('hostSpeciesIncluded', entry, 'host-species-included', false, false);
    toggleModalItem('controlMeasures', entry, 'control-measures', false, false);
    toggleModalItem('title', entry, 'title', false, false);
    toggleModalItem('humanReadableSynopsis', entry, 'human-readable-synopsis', false, true);
    toggleModalItem('sourceCodeRelease', entry, 'source-code-release', false, true);
    toggleModalItem('publicationsAboutRelease', entry, 'publications-about-release', false, true);
    toggleModalItem('publicationsThatUsedRelease', entry, 'publications-that-used-release', false, true);
    toggleModalItem('webApplication', entry, 'web-application', true, false);
    toggleModalItem('userGuidesAndManuals', entry, 'user-guides-and-manuals', true, false);
    toggleModalItem('executables', entry, 'executables', false, true);
    toggleModalItem('license', entry, 'license', false, true);
    toggleModalItem('endpointPrefix', entry, 'end-point-prefix', true, false);
    toggleModalItem('documentation', entry, 'documentation', false, true);
    toggleModalItem('restDocumentation', entry, 'rest-documentation', true, false);
    toggleModalItem('soapDocumentation', entry, 'soap-documentation', true, false);
    toggleModalItem('soapEndpoint', entry, 'soap-endpoint', true, false);
    toggleModalItem('projectSource', entry, 'project-source-code', true, false);
    toggleModalItem('soapSource', entry, 'rest-source-code', true, false);
    toggleModalItem('restSource', entry, 'soap-source-code', true, false);
    toggleModalItem('exampleQueries', entry, 'example-queries', false, true);
    toggleModalItem('diseases', entry, 'diseases', false, false);
    toggleModalItem('region', entry, 'region', false, true);
    toggleModalItem('locations', entry, 'locations', false, true);
    toggleModalItem('pathogens', entry, 'pathogens', false, true);
    toggleModalItem('outcomes', entry, 'outcomes', false, true);
    toggleModalItem('forecasts', entry, 'forecasts', false, true);
    toggleModalItem('nowcasts', entry, 'nowcasts', false, true);
    toggleModalItem('website', entry, 'website', true, false);
    toggleModalItem('forecastFrequency', entry, 'forecast-frequency', false, false);
    toggleModalItem('visualizationType', entry, 'visualization-type', false, false);
    toggleModalItem('grants', entry, 'grant', false, false);
    toggleModalItem('platform', entry, 'platform', false, false);
    toggleModalItem('description', entry, 'description', false, false);
    toggleModalItem('landingPage', entry, 'landing-page', true, false);
    toggleModalItem('accessUrl', entry, 'access-url', true, false);
    toggleModalItem('authorizations', entry, 'authorizations', false, false);
    toggleModalItem('humanReadableSpecification', entry, 'human-readable-specification', true, false);
    toggleModalItem('machineReadableSpecification', entry, 'machine-readable-specification', true, false);
    toggleModalItem('validator', entry, 'validator', true, false);
}