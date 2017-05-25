import csv
import json

elements = []
with open('data_formats.csv') as f:
    reader = csv.DictReader(f)
    cnt = 1
    for row in reader:
        name = row['data-format name'].strip()
        version = row['data-format version'].strip()
        identifier_source = row['identifierSource (can only be String)']
        identifier = row['identifier (can be string or IRI)'].strip()
        description = row['Human-readable synopsis'].strip()
        landing_page = row['Landing page (IRI to Human readable format specification)'].strip()
        access_url = row['Machine readable (accessURL)'].strip()
        validator = row['validator'].strip()
        license = row['license'].strip()
        format_type_value = row['type value'].strip().strip("\"")
        format_type_value_iri = row['type valueIRI'].strip().strip("\"")

        extra_properties = []

        #print("def test_validate_dataset_%s(self):" % cnt)
        #print("\tself.assertTrue(dats_model.validate_data_standard(\"/Users/amd176/Documents/scripts/data_formats_processor/data_formats_dats_json\", \"%s.json\", 0))\n" % name)
        #cnt += 1

        elements.append({"title": name, "version":[version]})

        if landing_page is not None and landing_page != '':
            extra_properties.append({
                "category": "human-readable specification of data format",
                "categoryIRI": "",
                "values": [
                    {
                        "value": landing_page,
                        "valueIRI": ""
                    }
                ]
            })

            if access_url != None and access_url != '':
                extra_properties.append({
                    "category": "machine-readable specification of data format",
                    "categoryIRI": "",
                    "values": [
                        {
                            "value": landing_page,
                            "valueIRI": access_url
                        }
                    ]
                })

            extra_properties.append({
                "category": "validator",
                "categoryIRI": "",
                "values": [
                    {
                        "value": "",
                        "valueIRI": ""
                    }
                ]
            })

        dats_json = {
            "identifier": {
                "identifier": identifier,
                "identifierSource": identifier_source
            },
            "name": name,
            "type": {
                "value":format_type_value,
                "valueIRI":format_type_value_iri
            },
            "description": description,
            "licenses": [{"name": license}],
            "version": version,
            "extraProperties": extra_properties
        }

        with open('data_formats_dats_json/' + name + '.json', 'w+') as out:
            out.write(json.dumps(dats_json, indent=4))

print(json.dumps(elements, indent=4))
        
