# PolyMapper

![What is popping at PolyMapper? Well, here is the icon!](https://cdn.iconsflow.com/_EVw3_RGZ8ezMuF0wlyAJn0c0XCbMTKZ0bAbcyI_kEFFNM8I.png)

Welcome to PolyMapper!  PolyMapper aims to model and predict drug combinations that will lead to polypharmacy.  Polypharmacy is the condition observed in patients who consume multiple medications.  When a patient is taking multiple medications, the patient will start to develop adverse and unforeseen health effects.  The number of medications that have been reported to provide data for adverse effects range from "2 or more" to "11 or more" medications.  PolyMapper aims to address polypharmacy by determining which combinations of drugs produce adverse effects, selecting biological pathways that are high risk for the combinations of drugs, and providing a platform to model said interactions. 

# Technical Motivation
PolyMapper is an intuitive website that displays medication data relevant to toxic drug combinations.  The drug interactions data is queried from the BioSNAP database.  The drug data and pathway data is queried from both PubChem and DrugBank.  PolyMapper allows for the user to see the toxic side effects for certain drug combinations and highlights biological pathways that are impacted.  


PolyMapper is written in R and Python.  R and Python are two programming languages used for scripting in bioinformatics.  The libraries and methodologies used are well-known and are supported by the platforms where the data is provided.

# Build Status
For the duration of this hackathon, no builds like Travis CI will be included.  

# Code Style 
R Shiny: Shiny modules <https://shiny.rstudio.com/articles/modules.html>

Python: PEP 8 <https://www.python.org/dev/peps/pep-0008/>

Data Files: CSV and JSON

# Tech/Framework Used

APIs used for chemical structure modelling and pathway visualization: PubChem and DrugBank.

# Features
PolyMapper presents drug interaction data and medication data in a straightforward Shiny R application.  

The drug interaction data is queried with Python from BioSNAP.  BioSNAP provides drug interaction data that is used for polypharmacy studies.  The data is stored in a CSV file.  

The medication data is queried with Python from PubChem and DrugBank.  The relevant information (i.e. drug names and pathways) are stored as JSON objects.  

The website allows the user to input up to 5 medications that they are currently on. Based on that selection PolyMapper displays the following:

1) Data for each drug the user has input. Drug data includes things like synonyms, images and descriptions.
2) A list of side effects. The side effects of the drug combinations are displayed with textual summaries.  
3) Drugs that target the same biochemical pathways. In general, if multiple drugs affect the same pathway then there is an increased risk of negative side effects. Affected pathways are provided from clustering pathways impacted by the drugs in the drug combinations.

# Project Goal
hackseq19:

PolyMapper highlights biological pathways impacted by multiple drugs.  The goal for the hackathon is to provide an application that uses factual drug data and show the drug interactions that affect the same biological pathway.

Overall:

The next step for the project is to use the pathway data to model drugs that have negative interactions and are not found in the same pathway.  This will require using drug data found in research papers. The eventual use case is to model chemical interactions of theoretical drugs in a virtualized model of different biological and biochemical pathways.  


# Installation
git clone {link for repository} to your local directory.

> cd hs-pop

> runApp("app.R")

# API Reference:
PubChem: https://pubchemdocs.ncbi.nlm.nih.gov/pug-rest

DrugBank:https://docs.drugbankplus.com/v1/

# Data References:
Interactions: https://snap.stanford.edu/biodata/datasets/10017/10017-ChChSe-Decagon.html

Drug dictionary: https://astro.temple.edu/~tua87106/drug_1626.txt

# Current project members:
Drug database querying:

Maciej Spiegel: @farmaceut

Roshan Noronha: @roshannoronha

Tyler Eakes: @Muuuchem

Website team:

Maggie Fu: @maggie-fu

Paola Pascualli: @paolaap1997

Team lead: 
Veena Ghorakavi: @vghorakavi
