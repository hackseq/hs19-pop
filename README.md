# PolyMapper

![alt text](https://cdn.iconsflow.com/_EVw3_RGZ8ezMuF0wlyAJn0c0XCbMTKZ0bAbcyI_kEFFNM8I.png)

Polypharmacy is the description of the untoward effects that arise when multiple medications are consumed by a person. The limit currently recorded for viewing the drug impacts is five.  Five is a seemingly arbitrary number that has been assigned for when any number of drugs, innocuous or not, seems to be a deadly mixture.  Polypharmacy is not well-studied or well-understood.  PolyMapper aims to determine untoward reactions prior to prescribing drugs in order to provide doctors and pharmacists a database to refer to prior to doling out medications.  

# Motivation
Polypharmacy is the description of the untoward effects that arise when multiple medications are prescribed to a person.  PolyMapper aims to determine untoward reactions prior to prescribing drugs in order to provide doctors and pharmacists a database to refer to prior to doling out medications.  

# Build Status

# Code Style 

# Tech/Framework Used
Website is being developed in R-Shiny.
APIs used for chemical structure modelling and pathway visualization: PubChem.

# Features
The website has a predictive modelling interface that utilizes both computer generated chemical structure images and structure name inputs to provide a forecast of the chemical reactions that occur in pathways.  The textual input will utilize a simple LASSO regression model to determine features of polypharmacy between seemingly unrelated drug compounds.  The visual models will reflect the findings of the LASSO regression model.  

# Installation
Clone repository to your laptop.  
> library(shiny)

> runApp("my_app")

Link for Shiny Apps:  

The application will then be usable.  

# API Reference:
PubChem: https://pubchemdocs.ncbi.nlm.nih.gov/pug-rest

# Data References:
https://snap.stanford.edu/biodata/datasets/10017/10017-ChChSe-Decagon.html

# Current project members:
