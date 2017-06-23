# Used to upload datasets to Zenodo

import requests


import json
import urllib.request as URLLIB
import xml.dom.minidom as XML
import os
from os import system
from pathlib import Path

ACCESS_TOKEN = 'PLACE ZENODO TOKEN HERE'
dats_folder = 'DATS FOLDER LOCATION'

headers = {"Content-Type": "application/json"}

# iterate over every file in this directory
for filename in os.listdir(dats_folder):
    if filename.endswith(".json"):
        # Read metadata as json
        with open(os.path.join(dats_folder, filename)) as json_file:
            json_data = json.load(json_file);

        # Get url from json metadata
        url_identifier = (json_data['identifier']['identifier'])

        # If apollo library entry
        if  url_identifier:
            # Parse url to xml to string to file
            xml = XML.parse(URLLIB.urlopen(url_identifier))
            xml_string = xml.toprettyxml()
            xml_filename = 'data.xml'
            xml_file = open(xml_filename, "w")
            xml_file.writelines(xml_string)
            xml_file.close()

            # Parse URL to json to string to file
            with URLLIB.urlopen(url_identifier.replace("xml", "json")) as url:
                data_as_json = json.loads(url.read().decode())
            json_filename = 'data.json'
            json_file = open(json_filename, "w")
            json_file.writelines(json.dumps(data_as_json))
            json_file.close()

        # If spew entry
        else:
            access_url = json_data['distributions'][0]['access']['accessURL']
            identifier = access_url.split('/')[-2]

            # Check if spew data already exists, otherwise download it
            spew_output_file = Path(dats_folder + identifier + ".tar.gz")
            if not spew_output_file.is_file():
                hrefs = access_url.split('edu')[1]
                post_request = access_url.split(identifier)[0]
                system(
                    'curl -X POST -F "action=download" -F "as=' + identifier + '.tar" -F "type=php-tar" -F "hrefs=' + hrefs + '" ' + post_request + ' | gzip  -vc > ' + dats_folder + identifier + '.tar.gz')

        # Create empty upload
        r = requests.post('https://zenodo.org/api/deposit/depositions',
                          params={'access_token': ACCESS_TOKEN}, json={},
                          headers=headers)

        # get deposition id from previous response
        deposition_id = r.json()['id']

        # add metadata
        creators = []
        for name_index in range(len(json_data['creators'])):
            creators.append({'name': json_data['creators'][name_index]['lastName'] + ', ' + json_data['creators'][name_index]['firstName']},)

        # funders = []
        # for grant_index in range(len(json_data['acknowledges'])):
        #     funders.append({'id' : json_data['acknowledges'][grant_index]['identifier']['identifier']},)

        data = {
            "metadata": {
                "title": json_data['title'],
                "upload_type": "dataset",
                "creators":
                    creators,
                "description": json_data['description'],
                "access_right": "open",
                # "grants":
                #     funders,

                # license for Creative Commons Attribution 4.0
                "license": {
                    "domain_content": "true",
                    "domain_data": "true",
                    "domain_software": "false",
                    "family": "",
                    "id": "CC-BY-4.0",
                    "od_conformance": "approved",
                    "osd_conformance": "not reviewed",
                    "maintainer": "Creative Commons",
                    "status": "active",
                    "title": "Creative Commons Attribution 4.0",
                    "url": "https://creativecommons.org/licenses/by/4.0/"
                }
            }
        }
        r = requests.put('https://zenodo.org/api/deposit/depositions/%s' % deposition_id,
                         params={'access_token': ACCESS_TOKEN}, data=json.dumps(data),
                         headers=headers)

         #upload files for library viewer
        if url_identifier:
            # upload new file (xml)
            data = {'filename': json_data['title']+'.xml'}
            files = {'file': open(xml_filename, "rb")}
            r = requests.post('https://zenodo.org/api/deposit/depositions/%s/files' % deposition_id,
                              params={'access_token': ACCESS_TOKEN}, data=data,
                              files=files)

            # upload new file (json)
            data = {'filename': json_data['title']+'.json'}
            files = {'file' : open(json_filename,"rb")}
            r = requests.post('https://zenodo.org/api/deposit/depositions/%s/files' % deposition_id,
                              params={'access_token': ACCESS_TOKEN}, data=data,
                              files=files)

            print(r.status_code)
            print(r.json())

            # delete temp files
            os.remove(xml_filename)
            os.remove(json_filename)

        else:
            data = {'filename' : 'output.tar.gz'}
            files = {'file' : open(dats_folder + identifier + ".tar.gz", "rb")}
            file_size = os.path.getsize(dats_folder + identifier + ".tar.gz")
            if file_size < 1e+8:
                r = requests.post('https://zenodo.org/api/deposit/depositions/%s/files' % deposition_id,
                              params={'access_token': ACCESS_TOKEN}, data=data,
                              files=files)

            print(spew_output_file)

            print(r.status_code)
            print(r.json())


        continue
    else:
        continue
