# PolyMapper

![What is popping at PolyMapper? Well, here is the icon!](https://cdn.iconsflow.com/_EVw3_RGZ8ezMuF0wlyAJn0c0XCbMTKZ0bAbcyI_kEFFNM8I.png)

Welcome to Polymapper!  PolyMapper aims to model and predict drug combinations that will lead to polypharmacy.  Polypharmacy is the condition observed in patients who are taking five or more medications.  When a patient is taking five or more drugs, the patient will start developing adverse health effects that are not known side-effects for the medications they are taking.  PolyMapper aims to address polypharmacy by determining which combinations of drugs produce adverse effects, determining which pathways are high risk for the combinations of drugs, and providing a platform to model said interactions. 

# Motivation
This needs to discuss what is going on for the project.  Why we decided to use what we did.  RShiny is simpler to deploy for majority of members.  --> For example. 

# Build Status
For the duration of this hackathon, no builds like Travis CI will be included.  

# Code Style 
R Shiny: Shiny modules (https://shiny.rstudio.com/articles/modules.html)


# Tech/Framework Used
Website: https://paola-arguello-pascualli.shinyapps.io/hackseq19/
APIs used for chemical structure modelling and pathway visualization: PubChem and DrugBank

# Features
The website has a predictive modelling interface that utilizes both computer generated chemical structure images and structure name inputs to provide a forecast of the chemical reactions that occur in pathways.  The textual input will utilize a simple LASSO regression model to determine features of polypharmacy between seemingly unrelated drug compounds.  The visual models will reflect the findings of the LASSO regression model.  (Edit this)

# Project Goal


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
