import requests
import csv
import json
import collections

ACCESS_TOKEN = 'SvxcV0O7kHohjkBVHcHZ3iZmgtJvKeZPN85ZFtgrc5wa0Uup1MtYWl2HzWTw'
dats_folder = '/Users/amd176/Documents/Repositories/digital-commons/src/scripts/convert_to_dats/output/spew_ipums_dats_json/'

data = csv.reader(open('spew_mapping.csv'))
# Read the column names from the first line of the file
fields = next(data)
csv_dict = {}
for row in data:
    # Zip together the field names and values
    items = zip(fields, row)
    item = {}
    key = ()
    # Add the value to our dictionary
    for (name, value) in items:
        item[name] = value.strip()

    key = item['Title']
    csv_dict[key] = item

response = requests.get('https://zenodo.org//api/deposit/depositions', params={'access_token': ACCESS_TOKEN, 'size': 200, 'status': 'published'})
json_response = response.json()
for deposition_index in range(len(json_response)):
    id = json_response[deposition_index]['id']

    r = requests.get("https://zenodo.org/api/deposit/depositions/" + str(id),
                    params={'access_token': ACCESS_TOKEN})

    deposition_json = r.json()

    # Get download link for access url
    access_url = "https://zenodo.org/record/" + str(deposition_json['record_id']) + "/files/" + deposition_json['files'][0]['filename']

    # Get title to cross reference with spew_mapping.csv
    title = deposition_json['title']
    if not "RABIES" in title.upper() and not "H1N1" in title:
        try:
            landing_url = "http://w3id.org/spew/" + csv_dict[title]['Anonymous Identifier']
        except KeyError:
            continue

        # Extract the name  from the landing page in spew_mapping, this will allow us to access the json file
        file_name = ()
        old_landing_page = csv_dict[title]['Landing Page'].split('/')
        if len(old_landing_page) > 10:
            file_name = old_landing_page[8] + ".json"
        else:
            file_name = old_landing_page[7] + ".json"

        # Update the dats file with the correct identifier information and the access and landing URLs
        try:
            with open(dats_folder+file_name) as json_file:
                old_meta_data = json.load(json_file, object_pairs_hook=collections.OrderedDict)
        except FileNotFoundError:
            continue


        old_meta_data['identifier']['identifier'] = deposition_json['doi_url']
        old_meta_data['identifier']['identifierSource'] = "zenodo"
        old_meta_data['distributions'][0]['access']['accessURL'] = access_url
        old_meta_data['distributions'][0]['access']['landingPage'] = landing_url

        with open(dats_folder+file_name, 'w') as outfile:
            json.dump(old_meta_data, outfile, indent=4)
        print("created " + file_name)