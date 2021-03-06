import os
import re
import json
import csv
import xmltodict
import re

import urllib.request
from dateutil.parser import parse
from bs4 import BeautifulSoup
from unidecode import unidecode

def process():
    dois = []

    with open(os.path.join(os.path.dirname(__file__), 'doi_to_epidemic_mapping.csv')) as f:
        reader = csv.DictReader(f)
        for row in reader:
            dois.append('https://' + row['Zenodo doi'])

    count = 0
    obc_output_list = []
    json_folder = os.path.join(os.path.join(os.path.dirname(__file__), 'apollo_json'))
    for filename in os.listdir(json_folder):
        path = os.path.join(json_folder, filename)

        if '.DS_Store' in path:
            continue

        with open(path) as f:
            original_name = os.path.basename(path).replace('.json', '')
            name = original_name.replace(', Ebola', '')
            json_content = json.loads(f.read())

        title = name + ' Ebola epidemic data and knowledge'

        description =('Information about the ' + name + ' Ebola epidemic curated from multiple publications and reports. ' +
                    'The information is represented in machine-interpretable Apollo-XSD format. ' + 
                    'The terminology is defined by the Apollo-SV ontology and standard identifiers.')

        split_access_url = json_content['accessURL'].split('/')
        urn = split_access_url[-1].replace('.xml','')
        json_content['accessURL'] = 'http://epimodels.org/apolloLibraryViewer-4.0.1/epidemic/' + urn + '.xml?view=true'
        json_content['landingPage'] = 'http://epimodels.org/apolloLibraryViewer-4.0.1/main/epidemic/' + urn

        identifier = {
            'identifier': dois[count],
            'identifierSource': 'zenodo'
        }

        creator = json_content['curator'].split(' ')

        if(creator[0] == 'Virgina'):
            creator[0] = 'Virginia'

        creators = [{
            'firstName': creator[0],
            'lastName': creator[1],
            'email':''
        }]

        types = [{
            "information": {
                "value": "epidemic",
                "valueIRI": "http://purl.obolibrary.org/obo/APOLLO_SV_00000298"
            }
        },
        {
            "method": {
                "value": "systematic literature review",
                "valueIRI": "http://purl.obolibrary.org/obo/OBI_0001958"
            }
        }]

        taxon_id = json_content['infections'][0]['pathogen']['ncbiTaxonId']
        taxon_content = urllib.request.urlopen("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=taxonomy&id=" + taxon_id).read()
        taxon_xml = xmltodict.parse(taxon_content)
        xml_items = taxon_xml["eSummaryResult"]["DocSum"]["Item"]

        scientific_name = ''
        for item in xml_items:
            if item['@Name'] == 'ScientificName':
                scientific_name = item['#text']

        snomed_ct = json_content['infections'][0]['infectiousDiseases'][0]['disease']
        snowmed_content = urllib.request.urlopen('http://www.snomedbrowser.com/Codes/Details/' + snomed_ct).read()
        snowmed_soup = BeautifulSoup(snowmed_content, 'lxml')
        snomed_name = re.sub(' +',' ', snowmed_soup.find("p").text.replace('See more descriptions.', '')).replace('Name: ', '').strip()

        is_about = [
            {
                'name': scientific_name,
                'identifier': {
                    'identifier': taxon_id,
                    'identifierSource': 'https://biosharing.org/bsg-s000154'
                }
            },
            {
                "name": snomed_name,
                "identifier": {
                    "identifier": snomed_ct,
                    "identifierSource": "https://biosharing.org/bsg-s000098"
                }
            },
            {
                "name": "infectious disease control strategy",
                "identifier": {
                    "identifier": "http://purl.obolibrary.org/obo/APOLLO_SV_00000086",
                    "identifierSource": "https://biosharing.org/bsg-s002688"
                }
            }   
        ]

        spatial_coverage = []
        epidemic_zones = json_content["epidemicZones"]

        if len(epidemic_zones) < 1:
            epidemic_zones = json_content["administrativeLocations"]

        for i in range(len(epidemic_zones)):
            spatial_coverage.append({})

            content = urllib.request.urlopen("https://betaweb.rods.pitt.edu/ls/api/locations/" + epidemic_zones[i] + "?format=geojson").read()
            geojson = json.loads(content)

            related_identifiers = []
            features = geojson["features"]
            for feature in features:
                if feature["type"] == "Feature":
                    spatial_coverage[i]["name"] = feature["properties"]["name"]

                    if "locationDescription" in feature["properties"]:
                        spatial_coverage[i]["description"] = feature["properties"]["locationDescription"]

                    spatial_coverage[i]["identifier"] = {
                        "identifier": epidemic_zones[i],
                        "identifierSource": "ApolloLS"
                    }

                    for code_properties in feature["properties"]["codes"]:
                        if code_properties["code"] is not None:
                            related_identifier = {
                                "identifier": code_properties["code"],
                                "identifierSource": code_properties["codeTypeName"]
                            }
                            related_identifiers.append(related_identifier)

                    spatial_coverage[0]["alternateIdentifiers"] = related_identifiers
                    break

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
            },
            "startDate": distributions[0]["dates"][0],
            "endDate": distributions[0]["dates"][1]
        }

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
                    "valueIRI": "http://purl.obolibrary.org/obo/APOLLO_SV_00000184"     },
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

        distributions[0]["size"] = os.path.getsize(os.path.join(json_folder, original_name + '.json')) >> 10
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

        dats_output = {
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

        obc_output = {
            'identifier': identifier,
            'title': title,
            'authors': [json_content['curator']],
            'datePublished': distributions[0]["dates"][0]["date"],
            'startDate': distributions[0]["dates"][0]["date"],
            'endDate': distributions[0]["dates"][1]["date"],
            'url': json_content['landingPage'],
            'spatialCoverage': spatial_coverage,
            'format': distributions[0]["formats"],
            'isAbout': {
                'pathogen': taxon_id,
                'hostSpecies': json_content['infections'][0]['host'],
                'diseases': ['37109004']
            },
            'dataStandard': distributions[0]["conformsTo"],
            "acknowledges": acknowledges
        }

        obc_output_list.append(obc_output)

        dats_json_output = json.dumps(dats_output, indent=4)


        output_path = os.path.abspath(os.path.join(os.path.dirname( __file__ ), '../..', 'output'))
        dats_path = os.path.join(output_path, 'ebola_dats_json')
        filepath = os.path.join(dats_path, unidecode(name).encode("ascii").decode("ascii") + '.json')

        with open(filepath, 'w+') as out:
            out.write(dats_json_output)

        count+=1

    obc_json_output = json.dumps(obc_output_list, indent=4)

    obc_path = os.path.join(os.path.dirname(__file__), 'obc_json')
    filepath = os.path.join(obc_path, 'obc_ebola_epidemics.json')
    with open(filepath, 'w+') as out:
        out.write(obc_json_output)
