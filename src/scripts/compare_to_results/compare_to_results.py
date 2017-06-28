import json
import sys
import os

def ordered(obj):
    if isinstance(obj, dict):
        return sorted((k, ordered(v)) for k, v in obj.items())
    if isinstance(obj, list):
        return sorted(ordered(x) for x in obj)
    else:
        return obj

if len(sys.argv) < 2:
    print('DESCRIPTION:\n\tCompare generated DATS JSON metadata with the gold standard used in the MIDAS Digital Commons')
    print('USAGE:\n\tpython compare_to_results.py <filepath to directory containing generated metadata>')
else:
    results_directory_location = sys.argv[1]
    gold_standard_directory_location = os.path.abspath(os.path.join(os.path.dirname( __file__ ), 'gold_standard'))

    ignore = ['.DS_Store', 'ApolloFlute.json', 'Tycho output format.json', 'data_formats_dats_json']
    for directory in os.listdir(gold_standard_directory_location):
        if directory not in ignore:
            gold_standard_path = os.path.join(gold_standard_directory_location, directory)
            results_path = os.path.join(results_directory_location, directory)

            correct = 0
            total = 0
            mismatch_str = ''
            for filename in os.listdir(gold_standard_path):
                if filename not in ignore:
                    gold_standard_file = os.path.join(gold_standard_path, filename)
                    results_file = os.path.join(results_path, filename)
                    with open(gold_standard_file) as f:
                        gold_standard_json = json.loads(f.read())

                    with open(results_file) as f:
                        results_json = json.loads(f.read())

                    if 'identifier' in gold_standard_json:
                        if 'identifier' in gold_standard_json['identifier']:
                            if 'zenodo' in gold_standard_json['identifier']['identifier']:
                                results_json.pop('identifier', None)
                                gold_standard_json.pop('identifier', None)

                    if ordered(gold_standard_json) == ordered(results_json):
                        correct += 1
                    else:
                        mismatch_str += "\n\t%s does not match" % filename

                    total += 1

            print(directory, "- %d%% matching %s" % (((correct/total) * 100), mismatch_str))




