# Creates a .htaccess file that rewrites the anonymous identifier to the landing page url

import csv

spew_dict = {}
file_name = 'spew_mapping.csv'
purl_id_cell = 3
purl_url_cell = 2

f = open('.htaccess', 'w')
f.write('RewriteEngine on\n')

with open(file_name) as csv_file:
    #skips header line
    next(csv_file)
    reader = csv.reader(csv_file, delimiter=',')
    for row in reader:
        if "#" not in row[0] and row[0]:
            f.write('RewriteRule ' + row[purl_id_cell] + ' ' + row[purl_url_cell] + ' [R=302,L]\n')

f.close()
