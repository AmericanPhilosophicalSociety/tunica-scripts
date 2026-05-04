# Setup

Install [EditionCrafter](https://editioncrafter.org/guide/#installing-the-editioncrafter-cli).

Set up [XSLT processing in VSCode](https://docs.google.com/document/d/11QClk7hU5S3CS9OMv-EqRBB_sMVXSCO591you_E5eJI/edit?usp=sharing).

You should already have access to the APS Tunica FLEx database.

Open the tunica-scripts directory in VSCode.

Create and activate a virtual environment, then install dependencies from requirements.txt:

```
pip install -r requirements.txt
```

In the VSCode terminal, navigate to the editioncrafter subdirectory.

# Export and process FLEx data

## Export notebook data from FLEx

In FLEx, click into Texts & Words, click on a page from the notebook you want to export, and click into the "Analyze" pane.

Click File -> Export Interlinear. Choose "Verifiable generic XML" format and click Export.

Scroll up to the top-level header for the notebook (e.g. "Haas Notebook 05"). Uncheck the box next to it, then check it again. All pages of this notebook should now be checked. Click "OK."

Give your notebook a descriptive name (e.g. "notebook-5-flex") and click Save.


## Process FLEx data into big HTML file with XSL

In VSCode, open full-notebook-xml-to-html.xsl. Click the rectangular bar with the magnifying class icon at the top of your VSCode window. Click Run task -> xslt-js -> xslt-js: Saxon-JS Transform. You’ll then be prompted to select which XSL file to run (the one you currently have open), and which XML file to run it on (your FLEx export).

Once you’ve selected your files, if everything is configured properly, the task should run automatically. The XSL file will generate a directory called xsl-out, and your XML will appear as result1.xml. (I haven't been able to figure out how to change where this directory appears or what the output file is named.)

Open this file in the browser to verify that output looks normal. You should see a transcription, followed by linguistic info for each page appearing in FLEx.

If output looks good, rename the file something descriptive (e.g. notebook-5-html.xml) and move it into the directory you're working in.

**NOTE: If you rerun the XSL script, any subsequent output will be saved as result1.xml. If you haven't renamed your output file, this will cause it to be overwritten.**


## Process big HTML file into small HTML files with Python

In VSCode, open process-xml-output.py. At the top of the file, insert the correct notebook number and the name of the big HTML file you created in the previous step. (This is necessary because the script includes special logic to deal with the different numbering schemes used for different notebooks in FLEx.)

Create two blank directories called "text" and "linguistic".

Run the script:

```
python process-xml-output.py
```

Your text and linguistic directories should now be populated with HTML files for individual notebook pages. (If no linguistic information has been recorded in FLEx, the linguistic folder may be empty.)

Spot check these to make sure that the page numbers given in the file names correspond to the scanned notebook pages. If you notice any issues, you may need to tweak the code in process-xml-output.py to produce the desired output.


# Display data in EditionCrafter

Depending on your needs, follow one of the two processes below. Unless something has gone horribly wrong, this should be option one. (All extant notebooks are already displaying on the site, so you should only need to export fresh data to display with the scans.)

If you need to add a new notebook or are using these instructions to create a fresh project from scratch, scroll down to option two.


## OPTION ONE: Export data to a notebook whose scans are already displaying on the site

Follow these steps to either export notebook data for the first time OR export a revised version of notebook data after changes have been made in FLEx.

In the "Process big HTML file into small HTML files with Python" step, you created the directories editioncrafter/text and editioncrafter/linguistic.

In a separate window, open the directory containing your Jekyll site. Copy the contents of editioncrafter/text and editioncrafter/linguistic into assets/editioncrafter/notebook-X/html/text and assets/editioncrafter/notebook-X/html/linguistic, respectively. When your file manager asks if you want to replace files with the same names, select Replace the files in the destination.

Your site will probably take some time to regenerate. Once it has, hit ctrl-F5 and check that your notebook data is displaying properly.


## OPTION TWO: Create a new notebook display

**NOTE: this part of the process has already been run for all extant notebooks. If you're trying to export or re-export data to load into a notebook whose scans already display on the site, follow the process laid out in option one (above) instead.**


### Create blank .txt files corresponding to notebook pages

To create an EditionCrafter project in the next step, you'll need some dummy text files to load in before generating files with your actual transcriptions and linguistic data. These should already exist in the directory blank-txt-files. However, if you need to regenerate them, use the Python script create-blank-txt-files.py.


### Create EditionCrafter project

We're now going to create an EditionCrafter project from the IIIF manifest for the notebook you're processing. In the command line, run the following command:

```
editioncrafter iiif -i MANIFEST-URL-HERE -o XML-FILE-TO-CREATE -t blank-txt-files
```

e.g.

```
editioncrafter iiif -i https://diglib.amphilsoc.org/node/233520/manifest -o notebook-5-ec.xml -t blank-txt-files
```

After a few seconds, if your process has run successfully, you should get the message "Edition Crafter finished." You should see that a new XML file has been created with the name you specified above.

Open the XML file. You should see an element that looks like this:

```
<text xml:id="text">
... <pb> elements corresponding to notebook pages
</text>
```

Copy this entire element and paste it below the original element. Change

```
<text xml:id="text">
```

to

```
<text xml:id="linguistic">
```

Save your file.

### Create EditionCrafter artifacts

Now it's time to create the HTML and other files that let EditionCrafter display your data. In the command line, run the following command:

```
editioncrafter process -i XML-FILE-TO-PROCESS -o NAME-OF-DIRECTORY-TO-CREATE -u 
```

e.g.

```
editioncrafter process -i notebook-5-ec.xml -o notebook-5 -u
```

After some time, you should get the notice "Edition Crafter finished" and see that a new notebook-5 directory has been created.

Click through these directories until you get to one called "iiif." Open the manifest.json file inside. In this file, EditionCrafter has auto-generated some URLs that are not accurate to where the relevant files will actually be stored in your Jekyll site. Find the following text:

```
http://localhost:8080/notebook-5-ec
```

And replace with the following text:

```
/assets/editioncrafter/notebook-5
```

(Filling in the correct number for your notebook.)

You can also do find/replace to find "Tunica Notebook 0X , " with a blank string so that page numbers are more easily visible. Do this ONLY in manifest.json.

EditionCrafter has created some files that we won't need. Go through and delete the following:

+ notebook-5/tei
+ notebook-5/html/index.html
+ notebook-5/html/linguistic/index.html
+ notebook-5/html/text/index.html


### Drop files into Jekyll

In the "Process big HTML file into small HTML files with Python" step, you created the directories editioncrafter/text and editioncrafter/linguistic. Take the contents of each of these directories and drop them into notebook-5/html/text and notebook-5/html/linguistic, respectively. 

Take the contents of each of these directories and drop them into html/text and html/linguistic, respectively. 

In a separate window, open your Jekyll site. In assets/editioncrafter, create a directory for your notebook (e.g. notebook-5).

Take the html and iiif directories generated by EditionCrafter and drop them in.

Final step: in _notebooks, create a .md file for your notebook if one doesn't already exist.

Your site will probably take some time to regenerate. Once it has, hit ctrl-F5 and check that your notebook is displaying properly.