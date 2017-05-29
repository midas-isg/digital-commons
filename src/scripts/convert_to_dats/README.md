## Convert to DATS metadata
The Python program for generating the DATS Dataset and DataStandard metadata.

In order to run the program, ensure that Python 3 or above is installed and issue the following commands from the “convert_to_dats” directory:
1.	`pip install –r requirements.txt`
2.	`python convert.py all`

This will install the necessary requirements and run the program. Using the argument “all” generates all of the DATS metadata for every type of digital object indexed in the MDC. Optionally, the arguments “case_series”, “zika”, “chikungunya”, “data_formats”, “ebola”, “spew_us”, “spew_ipums”, or “tycho” can be used to generate DATS metadata for a single type of digital object. Generating either Chikungunya or Zika epidemic metadata requires an Apollo Library Viewer API key to access and retrieve information pertaining to epidemic instances of these types. Please specify the API key as the second command line argument as follows: `python convert.py <type> <api_key>`.
