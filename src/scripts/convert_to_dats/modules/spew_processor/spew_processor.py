import os
import sys
import re
import json
import xmltodict

import urllib.request
from dateutil.parser import parse

def process(region_type):
    spew_regions_content = urllib.request.urlopen("http://spew.olympus.psc.edu/syneco/api/regions").read()
    spew_regions = json.loads(spew_regions_content)

    count = 28
    regions = {}
    for region in spew_regions["resources"]:
        if region["code"] == 'americas' and region_type == 'us':
            for child_region in region["children"]:
                if child_region == 'northern_america' and region_type:
                    for childs_child_region in region["children"][child_region]["children"]:
                        if(childs_child_region == 'united states of america'):
                            regions = region["children"][child_region]["children"][childs_child_region]["children"]
        elif region_type == 'ipums':
            for child_region in region["children"]:
                for childs_child_region in region["children"][child_region]["children"]:
                    region_info = region["children"][child_region]["children"][childs_child_region]
                    regions[region_info["code"]] = region_info

    alc_mapping = {}
    if region_type == 'us':
        with open(os.path.join(os.path.dirname(__file__), 'fips_to_alc.json')) as f:
            records = json.loads(f.read())['RECORDS']
            for record in records:
                alc_mapping[record['fips']] = record['alc']
    elif region_type == 'ipums':
        with open(os.path.join(os.path.dirname(__file__), 'isoAlpha3_to_alc.json')) as f:
            records = json.loads(f.read())['RECORDS']
            for record in records:
                code = record['code'].lower()
                alc_mapping[code] = record['alc']

    location_errors = []
    for location_code in regions:
        region = regions[location_code]
        try:
            alc = alc_mapping[location_code]

            content = urllib.request.urlopen("https://betaweb.rods.pitt.edu/ls/api/locations/" + alc + "?format=geojson&_onlyFeatureFields=properties.name,properties.codes").read()
            geojson = json.loads(content)
            properties = geojson["features"][0]["properties"]
            name = properties["name"]
            codes = properties["codes"]

            title = name + " Synthetic Ecosystem"
            description = name

            if region_type == 'ipums':
                if name == 'Canada':
                    description += " synthetic ecosystem dataset consisting of tables for persons and households. This dataset was created by the SPEW R Package using the following input data sources: Public Use Microdata Files (PUMFS), National Household Survey, 2011."
                else:
                    description += " synthetic ecosystem dataset consisting of tables for persons and households. This dataset was created by the SPEW R Package using the following input data sources: GeoHive counts and IPUMS-I shapefiles and microdata."
            elif region_type == 'us':
                description += " synthetic population dataset consisting of tables for persons, households, schools, and workplaces.  This dataset was created by the SPEW program from 2010 ACS SF 5-Year counts;  2010 US TIGER Roads; ACS PUMS 1-Year micro data; 2013 and 2011 NCES schools; and 2009 ESRI workplaces."

            identifier = {
                "identifier":"",
                "identifierSource":"n/a"
            }

            creators = [
                {
                    "firstName": "Lee",
                    "lastName": "Richardson",
                    "email": ""
                },
                {
                    "firstName": "Shannon",
                    "lastName": "Gallagher",
                    "email": ""
                },
                {
                    "firstName": "Samuel",
                    "lastName": "Ventura",
                    "email": ""
                },
                {
                    "firstName": "Bill",
                    "lastName": "Eddy",
                    "email": ""
                }
            ]

            types = [
                {
                    "information": {
                        "value": "agent level population and environment census",
                        "valueIRI": "http://purl.obolibrary.org/obo/APOLLO_SV_00000197"
                    }
                },
                {
                    "method": {
                        "value": "agent-level ecosystem data generation",
                        "valueIRI": "http://purl.obolibrary.org/obo/APOLLO_SV_00000164"
                    }
                },
                {
                    "platform": {
                        "value": "SPEW 1.20",
                        "valueIRI": "https://github.com/leerichardson/spew"
                    }
                }
            ]


            alc_identifier_url = "http://purl.obolibrary.org/obo/APOLLO_SV_00000259"
            is_about = [
                {
                    "name": "Individual",
                    "identifier": {
                        "identifier": "http://purl.obolibrary.org/obo/OBI_0100026l",
                        "identifierSource": "https://biosharing.org/bsg-s000070"
                    }
                },
                {
                    "name": "Homo sapiens",
                    "identifier": {
                        "identifier": "http://purl.obolibrary.org/obo/NBCITaxon_9606",
                        "identifierSource": "https://biosharing.org/bsg-s000154"
                    }
                },
                {
                    "name": "Household",
                    "identifier": {
                        "identifier": "http://purl.obolibrary.org/obo/OMRSE_0000007",
                        "identifierSource": "https://biosharing.org/bsg-s000097"
                    }
                }
            ]

            if region_type == 'us':
                is_about.append({
                    "name": "Schools",
                    "identifier": {
                        "identifier": "http://purl.obolibrary.org/obo/OMRSE_00000064",
                        "identifierSource": "https://biosharing.org/bsg-s000097"
                    }
                })

                is_about.append({
                    "name": "Workplace facility",
                    "identifier": {
                        "identifier": "http://purl.obolibrary.org/obo/OMRSE_00000078",
                        "identifierSource": "https://biosharing.org/bsg-s000097"
                    }
                })

            is_about.append({
                "name": name,
                "identifier": {
                    "identifier": alc,
                    "identifierSource": alc_identifier_url
                }
            })

            spatial_coverage = [{
                "name":name,
                "description":"",
                "identifier": {
                    "identifier": alc_identifier_url,
                    "identifierSource": alc_identifier_url
                },
                "alternateIdentifiers":[]
            }]

            for code in codes:
                spatial_coverage[0]["alternateIdentifiers"].append({
                    "identifier":code["code"],
                    "identifierSource":code["codeTypeName"]
                })

            produced_by = {
                "name": "Carnegie Mellon University, Department of Statistics",
                "location": {
                    "postalAddress": "5000 Forbes Ave., Baker Hall 132, Pittsburgh, PA, United States"
                },
                "startDate": {
                    "date": "2017",
                    "type": {}
                },
                "endDate": {
                    "date": "2017",
                    "type": {}
                }
            }

            access = {
                "landingPage":"",
                "accessURL":""
            }

            code_index = region["url"].index(location_code) + len(location_code) + 1
            access["accessURL"] = region["url"][0:code_index]
            access["landingPage"] = region["url"]

            conforms_to = []
            if region_type == 'us':
                conforms_to.append({
                    "identifier": {
                        "identifier": "SPEW.US format",
                        "identifierSource": "RODS Laboratory, University of Pittsburgh"
                    },
                    "name": "SPEW.US format",
                    "type": {
                        "value": "SPEW.US-File-Formats",
                        "valueIRI": " https://github.com/midas-isg/data-format-repository/wiki/SPEW.US-File-Formats"
                    }
                })
            elif region_type == 'ipums':
                if name == 'Canada':
                    conforms_to.append({
                        "identifier": {
                            "identifier": "SPEW.CANADA format",
                            "identifierSource": "RODS Laboratory, University of Pittsburgh"
                        },
                        "name": "SPEW.CANADA format",
                        "type": {
                            "value": "SPEW.CANADA-File-Formats",
                            "valueIRI": "https://github.com/midas-isg/data-format-repository/wiki/SPEW.CANADA-File-Formats"
                        }
                    })
                else:
                    conforms_to.append({
                        "identifier": {
                            "identifier": "SPEW.IPUMS format",
                            "identifierSource": "RODS Laboratory, University of Pittsburgh"
                        },
                        "name": "SPEW.IPUMS format",
                        "type": {
                            "value": "SPEW.IPUMS-File-Formats",
                            "valueIRI": "https://github.com/midas-isg/data-format-repository/wiki/SPEW.IPUMS-File-Formats"
                        }
                    })

            distributions = [{
                "identifier": {
                    "identifier": "1",
                    "identifierSource": ""
                },
                "dates": [
                    {
                        "date": "2016-11-05",
                        "type": {
                            "value": "creation",
                            "valueIRI": ""
                        }
                    }
                ],
                "access": access,
                "conformsTo": conforms_to,
                "storedIn": {
                    "name": "MIDAS Digital Commons",
                    "identifier": {
                        "identifier": "",
                        "identifierSource": "http"
                    },
                    "licenses": [
                        {
                            "name": ""
                        }
                    ],
                    "types": [
                        {
                            "value": "primary repository",
                            "valueIRI": ""
                        }
                    ],
                    "version": ""
                },
                "size": -1,
                "unit": {
                    "value": "megabyte",
                    "valueIRI": "http://purl.obolibrary.org/obo/UO_0000235"
                }
            }]

            dats_dict = {
                "title": title,
                "description": description,
                "identifier": identifier,
                "creators": creators,
                "types": types,
                "isAbout": is_about,
                "spatialCoverage": spatial_coverage,
                "producedBy": produced_by,
                "distributions": distributions
            }

            dats_json = json.dumps(dats_dict, indent=4)

            output_path = os.path.abspath(os.path.join(os.path.dirname( __file__ ), '../..', 'output'))
            dats_dir = os.path.join(output_path, 'spew_' + region_type + '_dats_json')
            dats_file = os.path.join(dats_dir, location_code + ".json")

            with open(dats_file, 'w+') as out:
                out.write(dats_json)
                #print("def test_validate_dataset_%d(self):" % count)
                #print("\tself.assertTrue(dats_model.validate_dataset(\"/Users/amd176/Documents/scripts/spew_us_processor/dats_json\", \"%s.json\", 0))\n" % location_code)
                #count+=1

        except KeyError:
            location_errors.append(location_code)