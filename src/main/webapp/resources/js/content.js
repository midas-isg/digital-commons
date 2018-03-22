function expandNodesInSessionVariable(treeId, sessionVariable) {
    var expanded = $.parseJSON(sessionStorage.getItem(sessionVariable));
    var toRemove = [];

    if(expanded === null) {
        var defaultExpandedNodes = $(treeId).treeview('getExpanded');
        var defaultExpandedNodeIds = [];
        for(var i = 0; i < defaultExpandedNodes.length; i++) {
            defaultExpandedNodeIds.push(defaultExpandedNodes[i].nodeId);
        }
        sessionStorage.setItem(sessionVariable, JSON.stringify(defaultExpandedNodeIds));
        expanded = $.parseJSON(sessionStorage.getItem(sessionVariable));
    }

    $(treeId).treeview('collapseAll', { silent: true });
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
    var expandIcon = "glyphicon glyphicon-chevron-right";
    var collapseIcon = "glyphicon glyphicon-chevron-down";

    var jsonEntries = JSON.parse(entriesData);
    var entryType = jsonEntries[0]["type"];
    if(entryType != null && entryType.includes("DataStandard")) {
        var emptyIcon = "bullet-point";
    }

    return {
        data: entriesData,
        showBorder: false,
        collapseAll: true,

        expandIcon: expandIcon,
        collapseIcon: collapseIcon,
        emptyIcon: emptyIcon,

        onNodeSelected: function(event, data) {
            if(data !== undefined) {
                // if(data['json'] !== undefined) {
                //     showModal(JSON.parse(data['json']), data['type'], data['xml']);
                // }
                if(data["entryId"] !== undefined) {
                    var idArr = data["entryId"].split("r");
                    var id = idArr[0];
                    var rev = idArr[1];
                    getDataAndOpenModal(id, rev);
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

function showModal(entry, type, xml) {
    if(!type.includes('Dataset') && !type.includes('DataStandard')) {
        $('#dats-json').hide();
        $('#mdc-json').show();
    } else {
        $('#dats-json').show();
        $('#mdc-json').hide();
    }

    if(xml !== null && xml.length > 0) {
        $('#display-json').text(xml);
    } else {
        $('#display-json').text(JSON.stringify(entry, null, "\t"));
    }

    toggleModalItems(entry, type);

    $('#pageModal').modal('show');
}

function capitalizeFirst(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function setModalHeader(entry, type) {
    var title = entry["title"];
    if(title === undefined && Object.keys(entry['name']).length !== 0) {
        title = entry['name'];
    }
    var version = entry["version"];

    var modalHeaderId = '#software-name';
    var modalHeaderText = title;
    if(title !== undefined) {
        modalHeaderText = title;
        if(version !== undefined) {
            if(Object.prototype.toString.call( version ) === '[object Array]') {
                modalHeaderText = getSoftwareTitle(title, version.join(', '));
            } else {
                modalHeaderText = getSoftwareTitle(title, version);
            }
        }

        ga('send', {
            hitType: 'event',
            eventCategory: 'User Activity',
            eventAction: type + ' - ' + modalHeaderText
        });

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

    var pluralKey = key+'s';
    var singular = capitalizeFirst(elementName);
    var plural = singular + 's';

    var attribute;
    var length;
    if(key in entry) {
        attribute = entry[key];
        length = attribute.length;

        if(Object.prototype.toString.call( attribute ) === '[object Array]') {
            attribute = attribute.join(', ');
            if(length > 1) {
                $(tagId).text(plural + ':');
            } else {
                $(tagId).text(singular + ':');
            }
        } else {
            $(tagId).text(singular + ':');
        }

        if(attribute.length > 0) {
            $(containerId).show();
            $(elementId).html(attribute);
        } else {
            $(containerId).hide();
        }
    } else if(pluralKey in entry) {
        attribute = entry[pluralKey];
        length = attribute.length;

        attribute = attribute.map(function(elem){
            if('name' in elem) {
                if ('description' in elem.name) {
                    plural = singular;
                    return elem.name.description;

                }
                return elem.name;
            }
            return elem.firstName + " " + elem.lastName;
        }).join(", ");

        $(containerId).show();
        $(elementId).html(attribute);

        $(tagId).text(plural + ':');

    } else{
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
    setModalHeader(entry, type);

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
    toggleModalItem('producedBy', entry, 'produced-by', false, false);
    toggleModalItem('description', entry, 'description', false, true);
    toggleModalItem('landingPage', entry, 'landing-page', true, false);
    toggleModalItem('accessURL', entry, 'access-url', true, false);
    toggleModalItem('authorizations', entry, 'authorizations', false, false);
    toggleModalItem('humanReadableSpecification', entry, 'human-readable-specification', true, false);
    toggleModalItem('machineReadableSpecification', entry, 'machine-readable-specification', true, false);
    toggleModalItem('validator', entry, 'validator', true, false);
    toggleModalItem('spatialCoverage', entry, 'spatial-coverage', false, false);
}

function getDataAndOpenModal(id, rev) {
    event.preventDefault();
    event.stopPropagation();

    $.post(ctx + "/entryInfo/" + id + '/' + rev, function(data){
        var entry = JSON.parse(data.json);
        //console.log(data, entry);
        showModal(entry, data.type, data.xml);
    });
}

function replaceNewlineChars() {
    $("#software-description").text(function() {
        var text = $(this).text();
        text = text.replace("\n", "<br>");
        $(this).text(text);
    });
}