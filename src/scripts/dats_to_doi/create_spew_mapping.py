# Reads SPEW metadata and creates a csv mapping of the location code, spew version, and landing page url to an anonymous identifier

import os
import json
import csv
import re
import sys


if len(sys.argv) < 2:
    print('DESCRIPTION:\n\tReads SPEW metadata and creates a CSV mapping of the location code, SPEW version, and landing page URL to an anonymous identifier\n\tA directory path is required\n')
    print('USAGE:\n\tpython create_spew_mapping.py <path_to_dats_directory>\n')
else:
    dats_folder = sys.argv[1]

    if os.path.isfile('spew_mapping.csv'):
        file = open('spew_mapping.csv', 'a+')
        interval = sum(1 for line in open('spew_mapping.csv'))-1
        wr = csv.writer(file, quoting=csv.QUOTE_ALL)

    else:
        interval = 0
        file = open('spew_mapping.csv', 'w')
        wr = csv.writer(file, quoting=csv.QUOTE_ALL)
        wr.writerow(['Apollo Location Code', 'SPEW Version', 'Landing Page', 'Anonymous Identifier', 'Title'])

    for filename in os.listdir(dats_folder):
        if filename.endswith(".json"):
            interval += 1

            # Read metadata as json
            with open(os.path.join(dats_folder, filename)) as json_file:
                json_data = json.load(json_file);

            # Get title
            title = json_data['title']

            # Get landing page
            landing_page = json_data['distributions'][0]['access']['landingPage']

            # Get apollo location code
            ls_url = json_data['spatialCoverage'][0]['identifier']['identifier']
            location_code = int(re.search(r'\d+', ls_url).group())

            # Get spew version
            version = json_data['types'][2]['platform']['value']

            wr.writerow([location_code, version, landing_page, str(interval).zfill(7), title])

    file.close()