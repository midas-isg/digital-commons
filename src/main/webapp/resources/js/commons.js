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
        text: "Apollo Location Service",
        url: "https://betaweb.rods.pitt.edu/ls"
    },
        {
            text: "NCBI Taxon Id",
            url: "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi"
        },
        {
            text: "SNOMED CT",
            url: "https://nciterms.nci.nih.gov/ncitbrowser/pages/vocabulary.jsf?dictionary=SNOMED%20Clinical%20Terms%20US%20Edition"
        },
        {
            text: "LOINC",
            url: "http://loinc.org/"
        },
        {
            text: "Vaccine Ontology",
            url: "http://www.violinet.org/vaccineontology/"
        },
        {
            text: "RxNorm",
            url: "https://www.nlm.nih.gov/research/umls/rxnorm/"
    }]
};

var algorithmsTree = [{
    text: "Disease transmission simulators",
    href: "#node-1",
    selectable: true,
    state: {
        checked: true,
        disabled: false,
        expanded: true,
        selected: true
    },
    tags: [''],
    nodes: [{
        text: "PSC FRED"
    }, {
        text: "PHDL FRED"
    }, {
        text: "GLEAM"
    }, {
        text: "FluTE"
    }]
}, {
    text: "Disease transmission models",
    nodes: [{
        text: "2009 H1N1 Influenza, PSC FRED",
    }, {
        text: "2014 Sierra Leone, Steve B Ebola Simulator"
    }]
},

    {
        text: "Viral and bacterial evolution simulators",
        nodes: [{
            text: "HyPhy",
        }, {
            text: "SEEDY",
        }, {
            text: "HIV-TRACE"
        }],
    },

    {
        text: "Data pipeline algorithms and systems",
        nodes: [{text:"Omnivore"}]
    }, {
        text: "Disease Surveillance algorithms and systems",
        nodes: [{text:"Shaman ILI"}, {text:"Rosenfeld Influenza"}]
    }, {
        text: "Data visualizers",
        nodes: [{text:"Galapagos"}, {text:"Roni R. visualizer"}]
    }
];

function getDataAndKnowledgeTree(libraryData, libraryViewerUrl) {
    var collections = [];
    libraryViewerUrl = libraryViewerUrl + "main/";

    collections.push({
            text: "Synthetic ecosystems",
            nodes: [{text: "USA"}]
        },
        {text: "Disease surveillance data", nodes: [{text: "Ebola"}, {text: "Chik-V"}, {text: "Zika"}]});

    $.each(libraryData, function (index, value) {
        var url;
        if (index.includes("Epidemic")) {
            url = libraryViewerUrl + "epidemic/";
        } else if (index.includes("Case Series")) {
            url = libraryViewerUrl + "caseSeries/"
        } else {
            url = libraryViewerUrl + "infectiousDiseaseScenario/";
        }
        var nodeLevel1 = [];
        $.each(value, function (index, value) {
            var nodeLevel2 = [];
            $.each(value, function (index, value) {
                // var externalbutton = "<button type='button'  id='" + url+value.urn + "'  class='btn btn-primary pull-right' onclick='openViewer(this.id)'>" +
                //     "<i class='fa fa-external-link'></i></button>";
                // var modalbutton = "<button type='button'  id='" + url+value.urn + "'  class='btn btn-primary pull-right' onclick='openModal(this.id)'>" +
                //     "<i class='fa fa-info-circle'></i></button>";

                nodeLevel2.push({text:  "<div class=\"grandnode-with-margin\">" + value.name +"<div>" , url: url+value.urn});
            });
            nodeLevel1.push({text: index, nodes: nodeLevel2});
        });

        collections.push({text: index, nodes: nodeLevel1});

    });

    collections.push(standardEncodingTree);

    return collections;
}

function openViewer(url) {
    window.open(url);
}

function openModal(url) {
    $('#libraryViewerModal').modal('show').find('.modal-body').load(url);
}

// var $standardEncodingTree = $('#encoding-treeview').treeview( {
//     data: getStandardEncodingsTree(),
// });
//
// function getStandardEncodingsTree() {
//     return standardEncodingTree;
// }

function getDataAugmentedPublicationsTree() {
    return dataAugmentedPublications;
}

var $dataAugmentedPublicationsTree = $('#publications-treeview').treeview({
    data: getDataAugmentedPublicationsTree(),
});


var $searchableTree = $('#algorithm-treeview').treeview({
    data: getTree(),
});

function getTree() {
    // Some logic to retrieve, or generate tree structure
    return algorithmsTree;
}
