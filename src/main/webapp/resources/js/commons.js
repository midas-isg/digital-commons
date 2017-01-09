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

var dataAndKnowledgeTree = [{
    text: "SPEW synthetic ecosystems",
    nodes: [{text: "USA"}] },
    {text:"Disease surveillance data", nodes:[{text:"Ebola"}, {text:"Chik-V"}, {text:"Zika"}]}, {text:"Epidemics", nodes:[{text:"Ebola Zaire 1976"}, {text:"..."}]}

];

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

function getDataAndKnowledgeTree() {
    return dataAndKnowledgeTree;
}

var $dataAndKnowledgeTree = $('#data-and-knowledge-treeview').treeview({
    data: getDataAndKnowledgeTree(),
});

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
