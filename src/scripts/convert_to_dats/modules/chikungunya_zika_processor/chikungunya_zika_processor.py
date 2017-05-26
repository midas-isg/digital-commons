import urllib.request
import json
import sys
import base64
import re
import xmltodict

from bs4 import BeautifulSoup
from dateutil.parser import parse

def process(epidemic_type, api_key):
    headers = {'Authorization': "JWT=" + api_key}
    url = "http://epimodels.org/apolloLibraryViewer-4.0.1/collectionsJson/"
    req = urllib.request.Request(url, headers=headers)
    response = urllib.request.urlopen(req)
    collections_json = json.loads(response.read())
    epidemics = []

    if epidemic_type == 'chikungunya':
        epidemics = collections_json['Epidemics']['Chikungunya epidemics']
    elif epidemic_type == 'zika':
        epidemics = collections_json['Epidemics']['Zika epidemics']

    failed = []
    data = []
    for i in range(len(epidemics)):
        epidemic = epidemics[i]
        url = 'http://epimodels.org:80/apolloLibraryViewer-4.0.1/api/v2/epidemic/' + epidemic['urn']
        req = urllib.request.Request(url, headers=headers)
        try:
            response = urllib.request.urlopen(req)
        except:
            failed.append(epidemic['urn'])
            continue

        epidemic_json = json.loads(response.read())['data']

        data.append(
            {
                'name': epidemic_json['name'],
                'json': epidemic_json['item'],
                'accessURL': 'http://epimodels.org/apolloLibraryViewer-4.0.1/epidemic/%s.xml?view=true' % epidemic['urn'],
                'landingPage': 'http://epimodels.org/apolloLibraryViewer-4.0.1/main/epidemic/%s' % epidemic['urn'],
            }
        )

    for i in range(len(data)):
        entry = data[i]
        json_content = entry['json']

        description_epidemic = ''
        if epidemic_type == 'chikungunya':
            description_epidemic = 'Chikungunya'
        elif epidemic_type == 'zika':
            description_epidemic = 'Zika virus'
        
        title = entry['name'] + ', ' + description_epidemic + ' epidemic data and knowledge'
        
        description = ('Information about the ' + entry['name'] + ' ' + description_epidemic + ' epidemic curated from multiple publications and reports. ' +
                    'The information is represented in machine-interpretable Apollo-XSD format. ' + 
                    'The terminology is defined by the Apollo-SV ontology and standard identifiers.')

        identifier = {
            "identifier": "under development",
            "identifierSource": ""
        }

        creators = [
            {
                "firstName": "Wilbert",
                "lastName": "van Panhuis",
                "email": ""
            }
        ]

        types = [
            {
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
            }
        ]

        taxon_id = json_content['causalPathogens'][0]['ncbiTaxonId']
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
                "name": scientific_name,
                "identifier": {
                    "identifier": "https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=" + taxon_id,
                    "identifierSource": "https://biosharing.org/bsg-s000154"
                }
            },
            {
                "name": snomed_name,
                "identifier": {
                    "identifier": "http://bioportal.bioontology.org/ontologies/SNOMEDCT?p=classes&conceptid=" + snomed_ct,
                    "identifierSource": "https://biosharing.org/bsg-s000098"
                }
            }
        ]

        if epidemic_type == 'zika':
            is_about.append({
                "name": "Fetal microcephaly",
                "identifier": {
                    "identifier": "http://bioportal.bioontology.org/ontologies/SNOMEDCT?p=classes&conceptid=431265009",
                    "identifierSource": "https://biosharing.org/bsg-s000098"
                }
            })

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
                        "identifierSource": "http://betaweb.rods.pitt.edu/ls/read-only?id=" + epidemic_zones[i]
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
        if len(edit_history) == 1 and ',' in edit_history[0]:
            edit_history = edit_history[0].split(',')

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
                edit_history[i] = edit_history[i].replace(' updated ', ' ')
                edit_history[i] = edit_history[i].replace('on ', ' ')
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

        #print(distributions[0])

        produced_by = {
            "name": "RODS Laboratory, University of Pittsburgh",
            "location": {
                "postalAddress": "RODS Laboratory, Department of Biomedical Informatics, University of Pittsburgh, Pittsburgh, PA, United States"
            }
        }

        if(len(distributions[0]["dates"]) > 0):
            produced_by["startDate"] = distributions[0]["dates"][0]

        if(len(distributions[0]["dates"]) > 1):
            produced_by["endDate"] = distributions[0]["dates"][1]

        distributions[0]["access"] = {
            "landingPage": entry['landingPage'],
            "accessURL": entry['accessURL'],
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

        distributions[0]["size"] = sys.getsizeof(json.dumps(json_content, indent=4)) >> 10
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

        dats_json_output = json.dumps(dats_output, indent=4)

        output_path = os.path.abspath(os.path.join(os.path.dirname( __file__ ), '../..', 'output'))
        dats_path = os.path.join(output_path, epidemic_type + '_dats_json/')
        filepath = os.path.join(dats_path, entry['name'] + '.json')

        with open(filepath, 'w+') as out:
            out.write(dats_json_output)

