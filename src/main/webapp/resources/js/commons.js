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

function hardcodeSoftware() {
    var name = 'FluTE – V. 1.12, 1.15, & 1.16';
    softwareDictionary[name] = {};
    var attrs = softwareDictionary[name];

    attrs['diseaseCoverage'] = 'influenza';
    attrs['locationCoverage'] = 'Los Angeles and Seattle';
    attrs['speciesIncluded'] = 'Homo sapiens';
    attrs['controlMeasures'] = 'vaccination, antivirals';
    attrs['source'] = 'https://github.com/dlchao/FluTE';

    software[0].nodes.push({
        'text': '<div class="node-with-margin" onmouseover="toggleTitle(this)" onclick="openModal(\'' + name + '\')">' + name + '</div>',
        'name': name
    });

    name = 'GLEAM 2.0';
    softwareDictionary[name] = {};
    attrs = softwareDictionary[name];

    attrs['title'] = 'Global Epidemic and Mobility Model (GLEAM)';
    attrs['diseaseCoverage'] = 'Communicable human-to-human';
    attrs['locationCoverage'] = 'Worldwide';
    attrs['speciesIncluded'] = 'Homo sapiens';
    attrs['location'] = 'http://www.gleamviz.org';

    software[2].nodes.push({
        'text': '<div class="node-with-margin" onmouseover="toggleTitle(this)" onclick="openModal(\'' + name + '\')">' + name + '</div>',
        'name': name
    });

    for(var i = 0; i < software[2].nodes.length; i++) {
        if(software[2].nodes[i].name == 'GLEAMViz') {
            delete software[2].nodes[i];
            break;
        }
    }

    software.splice(1, 0, {'text': 'Population dynamics model', nodes: []});

    name = 'Skeeter Buster';
    softwareDictionary[name] = {};
    attrs = softwareDictionary[name];

    attrs['generalInfo'] = '<p>Skeeter Buster is a detailed model of Aedes aegypti populations, developed at NC State University by a team led by Fred Gould (Entomology Dept.) and Alun Lloyd (Mathematics Dept.)</p> It is a stochastic, spatially-explicit model that models cohorts of mosquitoes at a very fine spatial scale, down to the level of individual breeding sites for immature cohorts, or individual houses for adults. The biology of Ae. aegypti is described with great detail on the previously developed CIMSiM model (Focks et al., 1993). Skeeter Buster additionally includes a detailed genetic component, and can therefore model the genetics of Ae. aegypti populations, making it a crucial tool in the evaluation and development of genetic control strategies.';
    attrs['location'] = 'http://www.skeeterbuster.net/';
    attrs['sourceCodeRelease'] = 'on request.  E-mail <a href="mailto:info@skeeterbuster.net?Subject=Source%20code%20release" target="_top" style="text-decoration: underline">info@skeeterbuster.net</a>';

    software[1].nodes.push({
        'text': '<div class="node-with-margin" onmouseover="toggleTitle(this)" onclick="openModal(\'' + name + '\')">' + name + '</div>',
        'name': name
    });
}

var standardEncodingTree = {
    text: "Standards for encoding data",
    nodes: [{
        text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>Apollo location codes (for locations)</div>",
        url: "https://betaweb.rods.pitt.edu/ls"
    },
        {
            text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>LOINC codes (for lab tests)</div>",
            url: "http://loinc.org/"
        },
        {
            text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>NCBI Taxon identifiers (for host and pathogen taxa)</div>",
            url: "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi"
        },
        {
            text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>RxNorm codes (for drugs)</div>",
            url: "https://www.nlm.nih.gov/research/umls/rxnorm/"
        },
        {
            text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>SNOMED CT codes (for diagnoses)</div>",
            url: "https://nciterms.nci.nih.gov/ncitbrowser/pages/vocabulary.jsf?dictionary=SNOMED%20Clinical%20Terms%20US%20Edition"
        },
        {
            text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>Vaccine Ontology identifiers (for vaccines)</div>",
            url: "http://www.violinet.org/vaccineontology/"
        },
        {
            text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>Apollo XSD (for data types)</div>",
            url: "https://github.com/ApolloDev/apollo-xsd-and-types"
        }
    ]
};

function getDataAndKnowledgeTree(libraryData, syntheticEcosystems, libraryViewerUrl, contextPath) {
    var collections = [];
    libraryViewerUrl = libraryViewerUrl + "main/";

    collections.push(syntheticEcosystems,
        {
            text: "Disease surveillance data",
            nodes: [
                {
                    text: "<span onmouseover='toggleTitle(this)'>CDCEpi Zika Github</span>",
                    url:"https://zenodo.org/record/192153#.WIEKNLGZNcA"
                },
                {
                    text: "<span onmouseover='toggleTitle(this)'>US notifiable diseases</span>",
                    nodes: [
                        {
                            text: "<div class=\"grandnode-with-margin\" onmouseover='toggleTitle(this)'>Tycho level 1</div>",
                            url:"https://www.tycho.pitt.edu/data/level1.php"
                        },
                        {
                            text: "<div class=\"grandnode-with-margin\" onmouseover='toggleTitle(this)'>Tycho level 2</div>",
                            url:"https://www.tycho.pitt.edu/data/level2.php"
                        },
                        {
                            text: "<div class=\"grandnode-with-margin\" onmouseover='toggleTitle(this)'>MMWR morbidity and mortality tables through data.cdc.gov</div>",
                            url:"https://data.cdc.gov/browse?category=MMWR"
                        },
                        {
                            text: "<div class=\"grandnode-with-margin\" onmouseover='toggleTitle(this)'>Colombia Ministry of Health routine infectious disease surveillance tables</div>",
                            url:"http://www.ins.gov.co/lineas-de-accion/Subdireccion-Vigilancia/sivigila/Paginas/vigilancia-rutinaria.aspx"
                        },
                        {
                            text: "<div class=\"grandnode-with-margin\" onmouseover='toggleTitle(this)'>Brazil Ministry of Health routine infectious diseases surveillance databases</div>",
                            url:"http://www2.datasus.gov.br/DATASUS/index.php?area=0203"
                        },
                        {
                            text: "<div class=\"grandnode-with-margin\" onmouseover='toggleTitle(this)'>Singapore Ministry of Health infectious disease surveillance data</div>",
                            url:"https://www.moh.gov.sg/content/moh_web/home/diseases_and_conditions.html"
                        }
                    ]
                }
            ]
        },
        {
            text: "Mortality data",
            nodes: [

                {
                    text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>CDC WONDER US cause of death 1995-2015</div>",
                    url: "https://wonder.cdc.gov/controller/datarequest/D76"
                },
                {
                    text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>CDC WONDER US compressed mortality files</div>",
                    url: "https://wonder.cdc.gov/mortSQL.htm"
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
                        text: "<div class=\"grandnode-with-margin\">" + value.name + "<div>",
                        url: url + value.urn
                    });
                });
                if(index.includes("Zika") || index.includes("Chikungunya")) {
                    index += " (under development)";
                }
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
        $('#software-name').text(softwareName);
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

    toggleModalItem('doi', attrs, 'doi', false, false);

    toggleModalItem('type', attrs, 'type', false, false);

    toggleModalItem('version', attrs, 'version', false, false);

    toggleModalItem('location', attrs, 'location', true, false);

    toggleModalItem('source', attrs, 'source-code', true, false);

    toggleModalItem('diseaseCoverage', attrs, 'disease-coverage', false, false);

    toggleModalItem('locationCoverage', attrs, 'location-coverage', false, false);

    toggleModalItem('speciesIncluded', attrs, 'species-included', false, false);

    toggleModalItem('controlMeasures', attrs, 'control-measures', false, false);

    toggleModalItem('title', attrs, 'title', false, false);

    toggleModalItem('generalInfo', attrs, 'general-info', false, true);

    toggleModalItem('sourceCodeRelease', attrs, 'source-code-release', false, true);

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
    if (a.name < b.name)
        return -1;
    if (a.name > b.name)
        return 1;
    return 0;
}

function toggleTitle(element) {
    var $this = $(element);

    console.log($this[0].offsetWidth, $this[0].scrollWidth);
    console.log($this[0].parentNode.offsetWidth, $this[0].parentNode.scrollWidth);

    if($this[0].parentNode.offsetWidth < $this[0].parentNode.scrollWidth || $this[0].offsetWidth < $this[0].scrollWidth){
        $this.attr('title', $this.text());
    } else {
        $this.attr('title', '');
    }
}