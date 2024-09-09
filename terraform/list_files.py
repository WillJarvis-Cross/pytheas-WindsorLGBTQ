import os
import json

# This file collects all the files in the dist folder and returns them as a list of strings
# The list is then used to create a json object that can be used by the terraform script

def get_file_size(file_path):
    return os.path.getsize(file_path)
def list_files_in_directory(directory):
    file_paths = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            full_path = os.path.relpath(os.path.join(root, file), directory)
            file_paths.append(full_path)
    return file_paths

if __name__ == "__main__":
    directory = os.path.join(os.path.dirname(__file__), '../dist')

    files = list_files_in_directory(directory)
    
    result = {
        "files": json.dumps(files)
    }
    
    print(json.dumps(result))
