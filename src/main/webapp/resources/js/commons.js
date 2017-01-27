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
var softwareDictionary = {};


var standardEncodingTree = {
   text: "Standards for encoding data",
    nodes: [{
        text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>Apollo location codes (for location data)</div>",
        url: "https://betaweb.rods.pitt.edu/ls"
    },
        {
            text: "<div class=\"node-with-margin\" onmouseover='toggleTitle(this)'>Apollo XSD (for data types)</div>",
            url: "https://github.com/ApolloDev/apollo-xsd-and-types"
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
        }]
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
                            text: "<div class=\"grandnode-with-margin\" onmouseover='toggleTitle(this)'>MMWR Morbidity and Mortality Tables through Data.cdc.gov</div>",
                            url:"https://data.cdc.gov/browse?category=MMWR"
                        },
                        {
                            text: "<div class=\"grandnode-with-margin\" onmouseover='toggleTitle(this)'>Colombia Ministry of Health Routine Infectious Disease Surveillance Tables</div>",
                            url:"http://www.ins.gov.co/lineas-de-accion/Subdireccion-Vigilancia/sivigila/Paginas/vigilancia-rutinaria.aspx"
                        },
                        {
                            text: "<div class=\"grandnode-with-margin\" onmouseover='toggleTitle(this)'>Brazil Ministry of Health Routine Infectious Diseases Surveillance Databases</div>",
                            url:"http://www2.datasus.gov.br/DATASUS/index.php?area=0203"
                        },
                        {
                            text: "<div class=\"grandnode-with-margin\" onmouseover='toggleTitle(this)'>Singapore Ministry of Health Infectious Disease Surveillance Data</div>",
                            url:"https://www.moh.gov.sg/content/moh_web/home/diseases_and_conditions.html"
                        }
                    ]
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

function openModal(softwareName) {
    var attrs = softwareDictionary[softwareName];

    if(softwareName != null) {
        $('#software-name').text(softwareName);
    } else {
        $('#software-name').hide();
    }

    if('developer' in attrs) {
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
        $('#software-doi').text(attrs['doi']);
    } else {
        $('#software-doi-container').hide();
    }

    if('type' in attrs) {
        $('#software-type').text(attrs['type']);
    } else {
        $('#software-type-container').hide();
    }

    if('version' in attrs) {
        $('#software-version').text(attrs['version']);
    } else {
        $('#software-version-container').hide();
    }

    if('location' in attrs) {
        $('#software-location').text(attrs['location']);
        $('#software-location').attr('href', attrs['location']);
    } else {
        $('#software-location-container').hide();
    }

    if('source' in attrs) {
        $('#software-source-code').text(attrs['source']);
        $('#software-source-code').attr('href', attrs['source']);
    } else {
        $('#software-source-code-container').hide();
    }

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