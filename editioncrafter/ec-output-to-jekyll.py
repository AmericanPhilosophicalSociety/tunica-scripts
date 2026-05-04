"""
one-time script
designed to be run after running the two editioncrafter command line prompts to generate ec artifact files
this automatically: deletes TEI directory; deletes index.html files; does necessary find/replace on manifest files
from here, copy contents of notebook-{num}-jekyll directly into appropriate directory in jekyll site
"""

from pathlib import Path
import os
import shutil
import re

path_to_notebook_folders = r"U:\\tunica-files\\create-jekyll-ec-files"
notebook_dir_regex = re.compile(r'notebook-\d{1,2}$')

def get_notebook_folders():
    notebook_dirs = []
    for item in os.listdir(path_to_notebook_folders):
        item_path = os.path.join(path_to_notebook_folders, item)

        if os.path.isdir(item_path) and re.search(notebook_dir_regex, item):
            # print(item_path)
            for inner_dir in os.listdir(item_path):
                # print(inner_dir)
                inner_dir_path = os.path.join(item_path, inner_dir)
                notebook_dirs.append(inner_dir_path)
            
    return notebook_dirs

def copy_files(dirs):
    files_to_ignore = re.compile(r'tei|index.html')
    
    for dir in dirs:
        source_dir = Path(dir)
        
        notebook_num = source_dir.parts[-1].replace("notebook-", "").replace("-ec", "")
        destination_dir_base = Path(path_to_notebook_folders) / Path(f"notebook-{notebook_num}-jekyll")
        
        text_path_partial = Path(r"html\\text")
        linguistic_path_partial = Path(r"html\\linguistic")
        iiif_path_partial = Path(r"iiif")
        
        # print(destination_dir)
        
        # create destination dir if it doesn't already exist
        try:
            os.mkdir(destination_dir_base)
            print(f"Directory '{destination_dir_base}' created successfully.")
        except FileExistsError:
            print(f"Directory '{destination_dir_base}' already exists.")
            
        # create subdirectories of destination dir
        try:
            iiif_path_destination = Path(destination_dir_base) / Path(iiif_path_partial)
            os.mkdir(iiif_path_destination)
            
            text_path_destination = Path(destination_dir_base) / Path(text_path_partial)
            os.makedirs(text_path_destination)
            
            linguistic_path_destination = Path(destination_dir_base) / Path(linguistic_path_partial)
            os.makedirs(linguistic_path_destination)

            print(f"Subdirectories created successfully.")
        except FileExistsError:
            print(f"Subdirectories already exist.")
        
        # print(text_path)
        
        text_path = Path(source_dir) / Path(text_path_partial)
        linguistic_path = Path(source_dir) / Path(linguistic_path_partial)
            
        # copy non-index text files
        for file in os.listdir(text_path):
            if file != "index.html":
                file_path = Path(text_path) / Path(file)
                destination_dir = Path(destination_dir_base) / Path(text_path_partial)
                shutil.copy(file_path, destination_dir)
        
        # copy non-index text files        
        for file in os.listdir(linguistic_path):
            if file != "index.html":
                file_path = Path(linguistic_path) / Path(file)
                destination_dir = Path(destination_dir_base) / Path(linguistic_path_partial)
                shutil.copy(file_path, destination_dir)

        path_to_manifest = source_dir / iiif_path_partial / Path("manifest.json")
        with open(path_to_manifest, 'r', encoding='utf8') as inputfile:
            contents_list = inputfile.readlines()
            contents = ''.join(contents_list)
            
            if len(notebook_num) == 1:
                notebook_num_padded = "0" + notebook_num
            else:
                notebook_num_padded = notebook_num
                
            contents = contents.replace(f"Tunica Notebook {notebook_num_padded} , ", "")
            
            url_to_find = f"http://localhost:8080/notebook-{notebook_num}-ec"
            url_to_replace = f"http://127.0.0.1:4000/tunicalanguageresources/assets/editioncrafter/notebook-{notebook_num}"
            
            contents = contents.replace(url_to_find, url_to_replace)
            
            manifest_destination = destination_dir_base / Path("iiif")
            
            with open(f'{manifest_destination}/manifest.json', 'w', encoding="utf8") as outputfile:
                outputfile.write(contents)
                print("manifest generated")
        # print(path_to_manifest)
        
        
        # get iiif/manifest
        # read in file
        # do some replaces
        # write contents to destination dir
        
        # if os.path.exists(destination_dir):
        #     print(f"Error: Destination directory '{destination_dir}' already exists. "
        #   "shutil.copytree requires the destination to not exist.")
        # else:
        #     shutil.copytree(source_dir, destination_dir)
        #     print(f"Successfully copied '{source_dir}' to '{destination_dir}'.")
        
        pass


def handle_manifest():
    pass

def run_program():
    notebook_dirs = get_notebook_folders()
    print(notebook_dirs)
    
    copy_files(notebook_dirs)

if __name__ == '__main__':
    run_program()