import csv
import json
import urllib
import xmltodict
import os
from datetime import datetime

def process():
    with open(os.path.join(os.path.dirname(__file__), 'isoAlpha2_to_Alpha3.xml')) as f:
        alpha2_to_alpha3 = xmltodict.parse(f.read())['plist']['dict']

    alpha3_to_alc = {}
    with open(os.path.join(os.path.dirname(__file__), 'isoAlpha3_to_alc.json')) as f:
            records = json.loads(f.read())['RECORDS']
            for record in records:
                code = record['code']
                alpha3_to_alc[code] = record['alc']

    country_to_continent = {}
    with open(os.path.join(os.path.dirname(__file__), 'continent_mapping.csv')) as f:
        reader = csv.DictReader(f)
        for row in reader:
            country = row['Country'].upper()
            continent = row['Continent'].strip()
            country_to_continent[country] = continent

    with open(os.path.join(os.path.dirname(__file__), 'countries.csv')) as f:
        reader = csv.reader(f, delimiter="\t")
        for row in reader:
            country_to_continent[row[0]] = row[1]

    def convert_to_alpha3(alpha2):
        index = alpha2_to_alpha3['key'].index(alpha2)
        alpha3 = alpha2_to_alpha3['string'][index]
        return alpha3

    def convert_to_alc(alpha2):
        alpha3 = convert_to_alpha3(alpha2)
        return alpha3_to_alc[alpha3]

    iso_info = {}
    with open(os.path.join(os.path.dirname(__file__), 'datasets.csv')) as f:
        reader = csv.DictReader(f)

        child_id = 0
        prev_unique_id = ''
        prev_row = None
        new_dict = []
        unique_id_dates = {}
        for row in reader:
            snomed_ct = row['snomedct_code'].strip()
            country_iso = row['country_iso'].strip()
            unique_id = country_iso + '.' + snomed_ct

            period_start = row['min_from_date'].strip()
            period_end = row['max_to_date'].strip()

            start_date = datetime.strptime(period_start, '%Y-%d-%M')
            end_date = datetime.strptime(period_end, '%Y-%d-%M')

            if prev_unique_id != unique_id:
                child_id = 0
                unique_id_dates[unique_id] = {'start': start_date, 'end': end_date}
            else:
                child_id += 1

                if prev_row['child_id'] == '0':
                    prev_row['has_children'] = True
                elif prev_row is not None:
                    prev_row['has_children'] = False

                if unique_id_dates[unique_id]['start'] > start_date:
                    unique_id_dates[unique_id]['start'] = start_date

                if unique_id_dates[unique_id]['end'] < end_date:
                    unique_id_dates[unique_id]['end'] = end_date

            row['child_id'] = str(child_id)
            new_dict.append(row)

            prev_unique_id = unique_id
            prev_child_id = child_id
            prev_row = row

        #print(unique_id_dates)
        broken = set()
        has_part = False
        dats_json = {}
        mdc_out = []
        for row in new_dict:
            #parent_id = row['Parent_id'].strip()
            child_id = row['child_id'].strip()
            disease_name = row['condition'].strip()
            snomed_ct = row['snomedct_code'].strip()
            country_name = row['country_name'].strip()
            country_iso = row['country_iso'].strip()
            source_name = row['source_name'].strip()
            period_start = row['min_from_date'].strip()
            period_end = row['max_to_date'].strip()

            try:
                continent = country_to_continent[country_name.upper()]
            except:
                broken.add(country_name.upper())

            if 'NOT' in disease_name or 'OR' in disease_name:
                continue

            if 'has_children' in row:
                has_children = row['has_children']
            else:
                has_children = False

            #creation_date = row['CreationDate'].strip()
            if country_iso == 'US':
                creators = "Willem G. van Panhuis, John Grefenstette, Su Yon Jung, Nian Shong Chok, Anne Cross, Heather Eng, Bruce Y. Lee, Vladimir Zadorozhny, Shawn Brown, Derek Cummings, Donald S. Burke"
            else:
                creators = "Willem G. van Panhuisa, Marc Choisy, Xin Xionga, Nian Shong Choka, Pasakorn Akarasewi, Sopon Iamsirithaworn, Sai K. Lam, Chee K. Chong, Fook C. Lam, Bounlay Phommasak, Phengta Vongphrachanh, Khamphaphongphane Bouaphanh, Huy Rekol, Nguyen Tran Hien, Pham Quang Thai, Tran Nhu Duong, Jen-Hsiang Chuang, Yu-Lun Liu, Lee-Ching Ng, Yuan Shi, Enrique A. Tayag, Vito G. Roque, Jr., Lyndon L. Lee Suy, Richard G. Jarman, Robert V. Gibbons, John Mark S. Velasco, In-Kyu Yoon, Donald S. Burke, and Derek A. T. Cummings"

            creators = creators.strip().split(',')

            #print("def test_validate_dataset_%s(self):" % parent_id)
            #print("\tself.assertTrue(dats_model.validate_dataset(\"/Users/amd176/Documents/scripts/tycho_processor/tycho_dats_json\", \"%s.json\", 0))\n" % parent_id)

            unique_id = country_iso + '.' + snomed_ct

            try:
                alc = convert_to_alc(country_iso)
            except:
                not_found.add(convert_to_alpha3(country_iso))
                continue

            if country_iso not in iso_info:
                content = urllib.request.urlopen("https://betaweb.rods.pitt.edu/ls/api/locations/" + alc + "?format=geojson&_onlyFeatureFields=properties.name,properties.codes").read()
                geojson = json.loads(content)
                properties = geojson["features"][0]["properties"]
                country_name = properties["name"]
                codes = properties["codes"]

                iso_info[country_iso] = {
                    "name": country_name,
                    "codes": codes
                }
            else:
                country_name = iso_info[country_iso]["name"]
                codes = iso_info[country_iso]["codes"]

            if child_id != 'NA':
                child_id = int(child_id)
                if child_id > 0:
                    has_part = True
                else:
                    has_part = False
            else:
                has_part = False

            if not has_part:
                start_date = unique_id_dates[unique_id]['start'].strftime('%Y-%d-%M')
                end_date = unique_id_dates[unique_id]['end'].strftime('%Y-%d-%M')

            identifier = {
                "identifier": "TYCHO:%s.v2" % unique_id,
                "identifierSource": "Project Tycho, Graduate School of Public Health, University of Pittsburgh"
            }

            to_remove = []
            for i in range(len(creators)):
                creators[i] = creators[i].replace("and", "").strip()
                split_creator = creators[i].split(' ')

                if len(split_creator) == 1:
                    to_remove.append(i)
                else:
                    first_name = split_creator[0]
                    last_name = split_creator[-1]
                    email = ""

                    if "Panhuis" in last_name:
                        first_name = "Wilbert"
                        last_name = "van Panhuis"
                        email = "wilbert.van.panhuis@pitt.edu"

                    creators[i] = {
                        "firstName": first_name,
                        "lastName": last_name,
                        "email": email
                    }

            for index in to_remove:
                creators.pop(index)

            alternate_country_identifiers = []
            for code in codes:
                alternate_country_identifiers.append({
                    "identifier": code['code'],
                    "identifierSource": code['codeTypeName']
                })

            is_about = [{
                "name": disease_name,
                "identifier": 
                    {
                    "identifier": "http://bioportal.bioontology.org/ontologies/SNOMEDCT?p=classes&conceptid=" + snomed_ct,
                    "identifierSource": "https://biosharing.org/bsg-s000098"
                }
            },
            {
                "name": country_name,
                "identifier": 
                    {
                    "identifier": "http://betaweb.rods.pitt.edu/ls/browser?id=" + alc,
                    "identifierSource": "apollo location service"
                    },
                "alternateIdentifiers": alternate_country_identifiers
            }]

            spatial_coverage = [
            {
                "name": country_name,
                "description": "%s, but may be incomplete for some areas" % country_name,
                "identifier": {
                    "identifier": "http://betaweb.rods.pitt.edu/ls/browser?id=" + alc,
                    "identifierSource": "apollo location service"
                },
                "alternateIdentifiers": alternate_country_identifiers
            }
        ]

            types = [
                {
                    "information": {
                        "value": "disease surveillance data",
                        "valueIRI": "http://purl.obolibrary.org/obo/APOLLO_SV_00000554"
                    }
                },
                {
                    "method": {
                        "value": "disease surveillance",
                        "valueIRI": "http://purl.obolibrary.org/obo/APOLLO_SV_00000545"
                    }
                }
            ]

            produced_by = {
                "name": "Project Tycho",
                "location": {
                    "postalAddress": "130 DeSoto Street, Pittsburgh, PA 15262, USA"
                }
            }

            distributions = [
                {
                    "title": "CSV file of counts of people diagnosed with %s in %s as reported by public health surveillance" % (disease_name, country_name),
                    "description": "Project Tycho downloadable CSV file for counts of people diagnosed with %s, one file per surveillance system." % disease_name,
                    "identifier": identifier,
                    "dates": [],
                    "access": {
                        "landingPage": "http://www.tycho.pitt.edu/",
                        "accessURL": "http://www.tycho.pitt.edu/data/%s.%s" % (country_iso, snomed_ct)
                    },
                    "formats": [
                        "csv"
                    ],
                    "conformsTo": [
                        {
                            "identifier": {
                                "identifier": "Project Tycho 2.0 format",
                                "identifierSource": "Project Tycho"
                            },
                            "name": "Tycho 2.0 format",
                            "type": {
                                "value": "Tycho-determined variables in long CSV format",
                                "valueIRI": "" #Web page of data format, to be generated#
                            }
                        }
                    ],
                    "storedIn": {
                        "name": "Project Tycho data repository",
                        "identifier": {
                            "identifier": "",
                            "identifierSource": ""
                        },
                        "licenses": [
                            {
                                "name": "CCPL",
                                "extraProperties": [
                                    {
                                        "category": "LicenseURL",
                                        "categoryIRI": "",
                                        "values": [
                                            "https://www.tycho.pitt.edu/legal/license_agreement.html"
                                        ]
                                    }
                                ]
                            }
                        ],
                        "types": [
                            {
                                "value": "primary repository",
                                "valueIRI": ""
                            }
                        ],
                        "version": "2.0"
                    },
                    "size": -1,
                    "unit": {
                        "value": "megabyte",
                        "valueIRI": "http://purl.obolibrary.org/obo/UO_0000235"
                    }
                }
            ]

            acknowledges =[{
                "name":"Bill and Melinda Gates Foundation",
                "identifier": {
                        "identifier": "Bill and Melinda Gates Foundation (Grant 49276, Evaluation of Candidate Vaccine Technologies Using Computational Models)",
                        "identifierSource": "https://www.vaccinemodeling.org/"
                    }
                },
                {
                    "name":"Project Tycho", 
                    "identifier": {
                        "identifier": "US National Institute of General Medical Sciences (Grant 5U54GM088491, Computational Models of Infectious Disease Threats)",
                        "identifierSource": "https://midas.pitt.edu/"
                    },
                },
                {
                    "name":"Benter Foundation Pittsburgh",
                    "identifier": {
                        "identifier": "Benter Foundation Pittsburgh",
                        "identifierSource": "http://www.benterfoundation.com/"
                }
            }]

            title = "Counts of people diagnosed with %s in %s as reported by public health surveillance from %s to %s" % (disease_name, country_name, start_date, end_date)
            description = "Counts of people diagnosed with %s in %s as reported by " % (disease_name, country_name)

            if has_part:
                title = "Counts of people diagnosed with %s in %s as reported by the %s between %s and %s" % (disease_name, country_name, source_name, start_date, end_date)

            if country_iso == 'US':
                title = "Counts of people diagnosed with %s in the United States as reported by public health surveillance from %s to %s" % (disease_name, start_date, end_date)
                description = "Counts of people diagnosed with %s for US states and/or cities as reported by " % (disease_name)
                distributions[0]['title'] = "CSV file of counts of people diagnosed with %s in the United States as reported by public health surveillance" % disease_name

                if has_part:
                    title = "Counts of people diagnosed with %s in the United States as reported by the %s between %s and %s" % (disease_name, source_name, period_start, period_end)

            if has_children:
                description += "multiple surveillance systems. "
            else:
                description += "the %s. " % source_name

            description += "These counts have been curated by the Project Tycho data team at the University of Pittsburgh."
            if not has_part:
                dats_json = {
                    "title": title,
                    "description": description,
                    "identifier": identifier,
                    "creators": creators,
                    "types": types,
                    "isAbout": is_about,
                    "hasPart": [],
                    "spatialCoverage": spatial_coverage,
                    "producedBy": produced_by,
                    "distributions": distributions,
                    "acknowledges": acknowledges
                }

                mdc_out.append({
                    'subtype': country_name,
                    'product': disease_name,
                    'id': unique_id,
                    'countryIso': country_iso,
                    'continent': continent
                })
            else:
                dats_json["hasPart"].append({
                    "title": title,
                    "creators": creators,
                    "types": types
                })

            if has_children:
                title = "Counts of people diagnosed with %s in %s as reported by the %s between %s and %s" % (disease_name, country_name, source_name, period_start, period_end)
                dats_json["hasPart"].append({
                    "title": title,
                    "creators": creators,
                    "types": types
                })

            output_path = os.path.abspath(os.path.join(os.path.dirname( __file__ ), '../..', 'output'))
            dats_dir = os.path.join(output_path, 'tycho_dats_json')
            dats_file = os.path.join(dats_dir, unique_id + '.json')

            with open(dats_file, 'w+') as out:
                out.write(json.dumps(dats_json, indent=4))

            with open(os.path.join(os.path.dirname(__file__), 'mdc_out.json'), 'w+') as out:
                out.write(json.dumps(mdc_out, indent=4))




