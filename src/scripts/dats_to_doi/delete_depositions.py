# Deletes all deposition forms in your account

import requests
ACCESS_TOKEN = 'PLACE ZENODO TOKEN HERE'

response = requests.get('https://zenodo.org//api/deposit/depositions' , params={'access_token': ACCESS_TOKEN, 'size': 500})

json_response = response.json()
for deposition_index in range(len(json_response)):
    id = json_response[deposition_index]['id']
    print(id)
    r = requests.delete('https://zenodo.org/api/deposit/depositions/' + str(id),
                    params={'access_token': ACCESS_TOKEN})

