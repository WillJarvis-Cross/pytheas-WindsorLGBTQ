import os
import json

def list_files_in_directory(directory):
    file_paths = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            full_path = os.path.relpath(os.path.join(root, file), directory)
            file_paths.append(full_path)
    return file_paths

if __name__ == "__main__":
    # Replace 'dist' with the relative path from the script's location
    directory = os.path.join(os.path.dirname(__file__), '../dist')

    files = list_files_in_directory(directory)
    
    # Terraform expects a JSON object with string keys and values
    result = {
        "files": json.dumps(files)  # Convert the list to a JSON string
    }
    
    # Print the result as JSON
    print(json.dumps(result))
