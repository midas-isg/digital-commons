import sys

from modules.case_series_processor import case_series_processor
from modules.chikungunya_zika_processor import chikungunya_zika_processor
from modules.data_formats_processor import data_formats_processor
from modules.ebola_processor import ebola_processor
from modules.spew_processor import spew_processor
from modules.tycho_processor import tycho_processor

def generate_case_series():
	print("GENERATING CASE SERIES DATASETS")
	case_series_processor.process()

def generate_zika(api_key):
	print("GENERATING ZIKA DATASETS")
	chikungunya_zika_processor.process("zika", api_key)

def generate_chikungunya(api_key):
	print("GENERATING CHIKUNGUNYA DATASETS")
	chikungunya_zika_processor.process("chikungunya", api_key)

def generate_data_formats():
	print("GENERATING DATA FORMATS")
	data_formats_processor.process()

def generate_ebola():
	print("GENERATING EBOLA DATASETS")
	ebola_processor.process()

def generate_spew_us():
	print("GENERATING SPEW US DATASETS")
	spew_processor.process("us")

def generate_spew_ipums():
	print("GENERATING SPEW IPUMS DATASETS")
	spew_processor.process("ipums")

def generate_tycho():
	print("GENERATING TYCHO DATASETS")
	tycho_processor.process()

if len(sys.argv) < 2:
	print('DESCRIPTION:\n\tGenerate DATS JSON metadata for MIDAS DIGITAL COMMONS by type\n\tAn Apollo Library Viewer API key is required to generate Zika and Chikungunya datasets\n')
	print('USAGE:\n\tpython convert.py <type>\n\tpython convert.py <type> <api_key>\n')
	print('TYPES:\n\tall\n\tcase_series\n\tzika\n\tchikungunya\n\tdata_formats\n\tebola\n\tspew_us\n\tspew_ipums\n\ttycho')
else:
	argument = sys.argv[1].lower()

	api_key = None
	if(len(sys.argv) > 2):
		api_key = sys.argv[2].lower()

	if argument == 'case_series' or argument == 'all':
		generate_case_series()
	if (argument == 'zika' or argument == 'all') and api_key:
		generate_zika(api_key)
	if (argument == 'chikungunya' or argument == 'all') and api_key:
		generate_chikungunya(api_key)
	if argument == 'ebola' or argument == 'all':
		generate_ebola()
	if argument == 'spew_us' or argument == 'all':
		generate_spew_us()
	if argument == 'spew_ipums' or argument == 'all':
		generate_spew_ipums()
	if argument == 'tycho' or argument == 'all':
		generate_tycho()
	if argument == 'data_formats' or argument == 'all':
		generate_data_formats()

	print("\nMETADATA GENERATION COMPLETE")
