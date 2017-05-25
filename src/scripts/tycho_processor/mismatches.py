import csv
import re
import urllib.request

from bs4 import BeautifulSoup

snomeds = set()
with open('datasets_new_4.csv') as f:
    reader = csv.DictReader(f)

    for row in reader:
        snomed_ct = row['snomedct_code'].strip()
        snomeds.add(snomed_ct)

snomed_to_name = {}
for snomed_ct in snomeds:
    snowmed_content = urllib.request.urlopen('http://www.snomedbrowser.com/Codes/Details/' + snomed_ct).read()
    snowmed_soup = BeautifulSoup(snowmed_content, 'lxml')
    snomed_name = re.sub(' +',' ', snowmed_soup.find("p").text.replace('See more descriptions.', '')).replace('Name: ', '').strip()
    snomed_to_name[snomed_ct] = snomed_name.lower()

mismatches = set()
with open('datasets_new_4.csv') as f:
    reader = csv.DictReader(f)

    for row in reader:
        country_iso = row['country_iso'].strip()
        snomed_ct = row['snomedct_code'].strip()
        disease_name = row['condition'].strip()

        if 'NOT' in disease_name or 'OR' in disease_name:
            continue

        disease_name = disease_name.lower()

        if disease_name.lower()[0] not in snomed_to_name[snomed_ct][0]:
            mismatches.add((country_iso, snomed_ct))

for mismatch in mismatches:
    print(mismatch)