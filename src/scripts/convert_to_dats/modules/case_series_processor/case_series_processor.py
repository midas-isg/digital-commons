import os
import json

def process():
    path = os.path.join(os.path.dirname(__file__), 'apollo_json')
    for filename in os.listdir(os.path.join(os.path.dirname(__file__), 'apollo_json')):
        new_path = os.path.join(path, filename)

        with open(new_path) as f:
            name = os.path.basename(new_path).replace('.json', '')
            json_content = json.loads(f.read())

            if name == "1951 - 2015, United States of America, Rabies cases with documented bat exposures and:or bat strains of rabies":
                title = "United States, 1951 - 2015, Rabies cases with documented bat exposures and/or bat strains of rabies"
                description = "A case series of rabies cases with documented bat exposures and/or bat strains of rabies virus"
            elif name == "1990 - 2015, United States of America, Non-transplant rabies cases with documented bat strains of rabies":
                title = "United States, 1990 - 2015, Non-transplant human rabies cases with documented bat strains of rabies"
                description = "A case series of non-transplant human rabies cases with documented bat strains of rabies"
            elif name == "1990 - 2015, United States of America, Unprotected physical contact with a bat (other than visible bites and scratches) which resulted in a human case of rabies":
                title = "United States, 1990 - 2015, human cases of rabies resulting from unprotected physical contact with a bat (other than visible bites and scratches)"
                description = "A case series of human cases of rabies resulting from unprotected physical contact with a bat (other than visible bites and scratches) verified as being caused by a bat RABV variant"

            identifier = {
                'identifier': 'under development',
                'identifierSource': 'zenodo'
            }

            creator = json_content['curator'].split(' ')
            creators = [{
                'firstName': creator[0],
                'lastName': creator[1],
                'email':''
            }]

            types = [{
            "information": {
                "value": "case series",
                "valueIRI": "http://purl.obolibrary.org/obo/APOLLO_SV_00000559"
            }
            },
            {
                "method": {
                    "value": "systematic literature review",
                    "valueIRI": "http://purl.obolibrary.org/obo/OBI_0001958"
                }
            }]

            is_about = [
                {
                    'name': "Rabies lyssavirus",
                    'identifier': {
                        "identifier": "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=11292",
                        "identifierSource": "https://biosharing.org/bsg-s000154"
                    }
                },
                {
                    "name": "Rabies virus silver-haired bat-associated SHBRV",
                    "identifier": {
                        "identifier": "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=445793",
                        "identifierSource": "https://biosharing.org/bsg-s000154"
                    }
                },
                {
                    "name": "Rabies (disorder)",
                    "identifier": {
                        "identifier": "http://bioportal.bioontology.org/ontologies/SNOMEDCT?p=classes&conceptid=14168008",
                        "identifierSource": "https://biosharing.org/bsg-s000098"
                    }
                }   
            ]

            spatial_coverage = [
                {
                    "name": "United States",
                    "identifier": {
                        "identifier": "http://betaweb.rods.pitt.edu/ls/read-only?id=1216",
                        "identifierSource": "apollo location service"
                    },
                    "alternateIdentifiers": [
                        {
                            "identifier": "US",
                            "identifierSource": "ISO 3166"
                        },
                        {
                            "identifier": "840",
                            "identifierSource": "ISO 3166-1 numeric"
                        },
                        {
                            "identifier": "USA",
                            "identifierSource": "ISO 3166-1 alpha-3"
                        }
                    ]
                }
            ]

            distributions = [{}]
            distributions[0]["identifier"] = {
                "identifier":"1",
                "identifierSource":""
            }

            distributions[0]["dates"] = []

            edit_history = json_content["editHistory"]
            for i in range(len(edit_history)):
                datetype = {
                    "value": "creation",
                    "valueIRI": "http://purl.obolibrary.org/obo/GENEPIO_0001882"
                }

                if i == 0:
                    try:
                        edit_history[i] = edit_history[i].replace('_','-')

                        split_history = edit_history[i].split(' ')
                        for x in range(len(split_history)):
                            if '/' in split_history[x] or '-' in split_history[x]:
                                edit_history[i] = split_history[x]
                                break

                        edit_history[i] = parse(edit_history[i]).strftime("%Y-%m-%d")
                    except ValueError:
                        if 'created on date ' in edit_history[i]:
                            edit_history[i] = parse(edit_history[i].replace('created on date ', '')).strftime("%Y-%m-%d")
                        elif 'created on ' in edit_history[i]:
                            edit_history[i] = parse(edit_history[i].replace('created on ', '')).strftime("%Y-%m-%d")
                        elif 'created ' in edit_history[i]:
                            edit_history[i] = parse(edit_history[i].replace('created ', '')).strftime("%Y-%m-%d")

                elif i == 1:
                    edit_history[i] = edit_history[i].replace(' at ', ' ')
                    edit_history[i] = ' '.join(edit_history[i].split(' ')[0:4])

                    if edit_history[i][-1] == ':':
                        edit_history[i] = edit_history[i][0:-1]

                    edit_history[i] = parse(edit_history[i].replace(' at ', ' ')).strftime("%Y-%m-%d")
                    datetype["value"] = "modification"
                    datetype["valueIRI"] = "http://purl.obolibrary.org/obo/GENEPIO_0001874"

                date = {
                    "date": edit_history[i],
                    "type": datetype
                }
                distributions[0]["dates"].append(date)

                if i == 0 and len(edit_history) == 1:
                    datetype["value"] = "modification"
                    date["type"] = datetype
                    distributions[0]["dates"].append(date)

            produced_by = {
                "name": "RODS Laboratory, University of Pittsburgh",
                "location": {
                    "postalAddress": "RODS Laboratory, Department of Biomedical Informatics, University of Pittsburgh, Pittsburgh, PA, United States"
                }
            }

            if len(distributions[0]["dates"]) > 0:
                produced_by["startDate"] = distributions[0]["dates"][0],
                produced_by["endDate"] = distributions[0]["dates"][1]

            split_access_url = json_content['accessURL'].split('/')
            urn = split_access_url[-1].replace('.xml','')
            urn = urn.replace('?view=true','')

            json_content['accessURL'] = 'http://epimodels.org/apolloLibraryViewer-4.0.1/caseSeries/' + urn + '.xml?view=true'
            json_content['landingPage'] = 'http://epimodels.org/apolloLibraryViewer-4.0.1/main/caseSeries/' + urn

            distributions[0]["access"] = {
                "landingPage": json_content['landingPage'],
                "accessURL": json_content['accessURL'],
                "authorizations": [{
                    "value": "public",
                    "valueIRI": ""
                }]
            }

            distributions[0]["formats"] = ["xml", "json"]

            distributions[0]["conformsTo"] = [{
                "identifier":
                {
                    "identifier": "bsg-s000701",
                    "identifierSource": "https://biosharing.org"
                            
                },
                "name": "Apollo XSD",
                "type": {
                    "value": "xml schema",
                    "valueIRI": "https://github.com/ApolloDev/apollo-xsd-and-types/tree/4.0-upgrade"
                }
            }]

            distributions[0]["storedIn"] = {
                "name": "Apollo Library",
                "version": "4.0.1",
                "description": "A repository of machine-interpretable information in the domain of infectious disease epidemiology. The intent of the collection is to support model building.",
                "identifier": {
                    "identifier": "biodbcore-000938",
                    "identifierSource": "https://biosharing.org"
                },
                "publishers": [
                    {
                        "name": "RODS Laboratory, Department of Biomedical Informatics, University of Pittsburgh"
                    }
                ],
                "scopes": [
                    {
                        "value": "epidemic",
                        "valueIRI": "http://purl.obolibrary.org/obo/APOLLO_SV_00000298"
                    },
                    {
                        "value": "infectious disease scenario",
                        "valueIRI": "http://purl.obolibrary.org/obo/APOLLO_SV_00000184"     
                    },
                    {
                        "value": "case series",
                        "valueIRI": "http://purl.obolibrary.org/obo/apollo_sv.owl"
                    }
                ],
                "types": [
                    {
                        "value": "primary repository",
                        "valueIRI": ""
                    },
                    {
                        "value": "knowledge base",
                        "valueIRI": ""
                    }
                ],
                "licenses": [
                    {
                        "name": "CC BY 4.0"
                    }
                ]
            }

            distributions[0]["size"] = os.path.getsize(new_path) >> 10
            distributions[0]["unit"] = {
                "value": "kilobyte",
                "valueIRI": "http://purl.obolibrary.org/obo/UO_0000235"
            }

            acknowledges = [
                {
                    "identifier": {
                        "identifier": "U24GM110707",
                        "identifierSource": "US National Institutes of Health"
                    },
                    "funders": [ 
                        {
                            "name": "National Institute of General Medical Sciences",
                            "abbreviation": "NIGMS"
                        }
                    ],
                    "name": "MIDAS Informatics Services Group"
                },
                {
                    "identifier": {
                        "identifier": "R01GM101151",
                        "identifierSource": "US National Institutes of Health",
                    },
                    "funders": [ 
                        {
                            "name": "National Institute of General Medical Sciences",
                            "abbreviation": "NIGMS"
                        }
                    ],
                    "name": "Apollo: Increasing Access and Use of Epidemic Models Through the Development and Adoption of Standards"
                }
            ]

            dats_json = {
                'title': title,
                'description': description,
                'identifier': identifier,
                'creators': creators,
                'types':types,
                'isAbout': is_about,
                'spatialCoverage': spatial_coverage,
                'producedBy': produced_by,
                'distributions': distributions,
                'acknowledges': acknowledges
            }

            dats_json_output = json.dumps(dats_json, indent=4)

            output_path = os.path.abspath(os.path.join(os.path.dirname( __file__ ), '../..', 'output'))
            dats_path = os.path.join(output_path, 'case_series_dats_json')
            filepath = os.path.join(dats_path, name + '.json')

            with open(filepath, 'w+') as out:
                out.write(dats_json_output)
