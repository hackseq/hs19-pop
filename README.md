# PolyMapper

![What is popping at PolyMapper? Well, here is the icon!](https://cdn.iconsflow.com/_EVw3_RGZ8ezMuF0wlyAJn0c0XCbMTKZ0bAbcyI_kEFFNM8I.png)

Welcome to Polymapper!  PolyMapper aims to model and 

Polypharmacy is the description of the adverse effects that arise when multiple medications are consumed by a person. The limit currently recorded for viewing the drug impacts is five.  Five is a seemingly arbitrary number that has been assigned for when any number of drugs, innocuous or not, seems to be a deadly mixture.  Polypharmacy is not well-studied or well-understood.  PolyMapper aims to determine untoward reactions prior to prescribing drugs in order to provide doctors and pharmacists a database to refer to prior to doling out medications.  (Edit this)

# Motivation
This needs to discuss what is going on for the project.  Why we decided to use what we did.  RShiny is simpler to deploy for majority of members.  --> For example. 

# Build Status
For the duration of this hackathon, no builds like Travis CI will be included.  

# Code Style 
R Shiny: Shiny modules.

# Tech/Framework Used
Website: https://paola-arguello-pascualli.shinyapps.io/hackseq19/
APIs used for chemical structure modelling and pathway visualization: PubChem and DrugBank

# Features
The website has a predictive modelling interface that utilizes both computer generated chemical structure images and structure name inputs to provide a forecast of the chemical reactions that occur in pathways.  The textual input will utilize a simple LASSO regression model to determine features of polypharmacy between seemingly unrelated drug compounds.  The visual models will reflect the findings of the LASSO regression model.  (Edit this)

# Project Goal


# Installation
git clone <link for repository> to your local directory.
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
Roshan Noronha: @roshannoronha
Tyler Eakes: @Muuuchem
Maciej Spiegel: @farmaceut

Website team:
Paola Pascualli: @paolaap1997
Maggie Fu: @maggie-fu

Team lead: 
Veena Ghorakavi: @vghorakavi
