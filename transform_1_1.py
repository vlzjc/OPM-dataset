import json
import pandas as pd
import os

def flatten_json(y):
    out = {}

    def flatten(x, name=""):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + "_")
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + "_")
                i += 1
        else:
            out[name[:-1]] = x

    flatten(y)
    return out


def json_to_dataframe(json_file_path, output_csv='output.csv'):
    try:
        with open(json_file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        if 'items' not in data or not isinstance(data['items'], list):
            print(f"Warning: No 'items' list found in {json_file_path}. Skipping.")
            return  # Skip this file if no 'items'

        flattened_data = []
        for item in data['items']:
            flattened_item = flatten_json(item)
            flattened_data.append(flattened_item)

        df = pd.DataFrame(flattened_data)

        if not os.path.exists(output_csv):
            df.to_csv(output_csv, mode='w', index=False, header=True)
        else:
            df.to_csv(output_csv, mode='a', index=False, header=False)

        print(f"Data from {json_file_path} appended to {output_csv}")

    except FileNotFoundError:
        print(f"Error: File not found at {json_file_path}")
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON format in {json_file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")



# Generate the list of file names
songs_folder = 'songs'  # Name of your folder
json_files = [os.path.join(songs_folder, f'songs_{i}.json') for i in range(2, 48)]
output_file = 'output.csv'

for file in json_files:
    json_to_dataframe(file, output_file)

if os.path.exists(output_file):
    complete_df = pd.read_csv(output_file)
    print("\nComplete CSV:")
    print(complete_df.head())
else:
    print(f"The file {output_file} was not created.")