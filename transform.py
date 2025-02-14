import json
import pandas as pd

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


def json_to_dataframe(json_file_path):
    """
    Loads a JSON file, flattens each item in the 'items' list,
    and creates a Pandas DataFrame.

    Args:
        json_file_path (str): The path to the JSON file.

    Returns:
        pandas.DataFrame: A DataFrame containing the flattened data, or None if there's an error.
    """
    try:
        with open(json_file_path, 'r', encoding='utf-8') as f:  # Handle potential encoding issues
            data = json.load(f)

        if 'items' not in data or not isinstance(data['items'], list):
            print("The JSON file must contain an 'items' list.")
            return None

        flattened_data = []
        for item in data['items']:
            flattened_item = flatten_json(item)
            flattened_data.append(flattened_item)

        df = pd.DataFrame(flattened_data)
        return df

    except FileNotFoundError:
        print(f"Error: File not found at {json_file_path}")
        return None
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON format in {json_file_path}")
        return None
    except Exception as e:  # Catch any other potential errors
        print(f"An error occurred: {e}")
        return None


# Example usage:
file_path = 'songs/songs_1.json'  # Replace with the actual path to your JSON file
df = json_to_dataframe(file_path)

if df is not None:
    print(df.head()) # prints the first 5 rows
    # Now you can work with the DataFrame 'df'
    # For instance, save it to a CSV file:
    df.to_csv('output.csv', index=False)