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

function getDataAndKnowledgeTree(libraryData, syntheticEcosystems, libraryViewerUrl) {
    var collections = [];
    libraryViewerUrl = libraryViewerUrl + "main/";

    collections.push(syntheticEcosystems,
        {text: "Disease surveillance data", nodes: [{text: "<div class=\"node-with-margin\">Zika data repository</div>", url:"https://zenodo.org/record/192153#.WIEKNLGZNcA"}, {text: "<div class=\"node-with-margin\">Tycho</div>", url: "https://www.tycho.pitt.edu/data/level1.php"}]});


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
                    // var externalbutton = "<button type='button'  id='" + url+value.urn + "'  class='btn btn-primary pull-right' onclick='openViewer(this.id)'>" +
                    //     "<i class='fa fa-external-link'></i></button>";
                    // var modalbutton = "<button type='button'  id='" + url+value.urn + "'  class='btn btn-primary pull-right' onclick='openModal(this.id)'>" +
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
    $('#libraryViewerModal').modal('show').find('.modal-body').load(url);
}

function formatLocation(location) {
    var splitLocationNames = location.split(' ');

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
