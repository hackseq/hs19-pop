import requests
import json
import random
import csv
import pandas as pd
from selenium import webdriver
from selenium.webdriver.common.by import By
import time

def downloadPathwayCSV(url):
    driver = webdriver.Firefox()
    driver.get(url)
    #download_button = driver.find_element_by_class_name("btn-text")
    time.sleep(20)
    download_button = driver.find_element_by_xpath("//button[@id='Download']")
    time.sleep(20)
    download_button.click()
    time.sleep(20)
    save_button = driver.find_element_by_xpath("//span[.='Save']")
    time.sleep(20)
    save_button.click()
    time.sleep(20)
    driver.close()

# base url for pubchem
baseURL = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/"

drug_set = set()

with open('cid.csv', newline='') as cid:
    csvread = csv.reader(cid)
    batch_data = list(csvread)
    chosen_drugs = random.sample(batch_data, 20)
    for drug in chosen_drugs:
        drug_set.add(drug[0])

#create an empty text file and append data to it
f = open("drugInfo.txt", "a+")
f.write("drugName" + "\t" + "cid" + "\t" + "iupac" + "\t" + "smile" + "\t" + "molecularFormula" + "\t" + "synList"  + "\t" + "pathways" + "\n")

for item in drug_set:
    compoundNum = f"{item}/"

    # get properties for each drug
    # iupac, SMILES, molecular MolecularFormula
    # as .json
    operationParams = "property/IUPACName,CanonicalSMILES,MolecularFormula/"
    outputParam = "JSON"

    propertiesURL = baseURL + compoundNum + operationParams + outputParam
    properties = json.loads(requests.get(propertiesURL).text)

    cid = properties["PropertyTable"]["Properties"][0]["CID"]
    iupac = properties["PropertyTable"]["Properties"][0]["IUPACName"]
    smile = properties["PropertyTable"]["Properties"][0]["CanonicalSMILES"]
    molecularFormula = properties["PropertyTable"]["Properties"][0]["MolecularFormula"]

    # synonyms for each drug
    # as txt file
    synURL = baseURL + compoundNum + "synonyms/TXT"
    synData = requests.get(synURL).text.split("\n")

    synList = []
    for line in synData:
        synList.append(line)

    drugName = synList[0]
    synList = synList[1:6]

    # 2D image of each drug
    # specify folder where images are stored
    folderPath = "/home/roshann/Documents/hackseq19-p14/drugImages/"
    imageURL = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/" + compoundNum + "/PNG"

    imagePath = folderPath + drugName + ".png"

    with open(imagePath, "wb") as code:
        code.write(requests.get(imageURL).content)

    # pathways for each drug
    compoundNum = compoundNum.split("/")[0]
    pathwayURL = "https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi?infmt=json&outfmt=csv&query={%22download%22:%22*%22,%22collection%22:%22pathway%22,%22where%22:{%22ands%22:[{%22cid%22:%222244%22},{%22core%22:%221%22}]},%22order%22:[%22name,asc%22],%22start%22:1,%22limit%22:10000000,%22downloadfilename%22:%22CID_" + compoundNum + "_pathway%22}"
    pathway = requests.get(pathwayURL).text

    # This will download the code to the pathway
    downloadpathwayURL = "https://pubchem.ncbi.nlm.nih.gov/compound/"+ compoundNum +"#section=Pathways&fullscreen=true"
    pathwayCSV = downloadPathwayCSV(downloadPathwayURL)

    pathwayData = pd.read_csv(pathwayURL)

    # drop duplicate names in list
    pathwayList = pathwayData["name"].tolist()
    pathways = []
    for pathway in pathwayList:
        if pathway in pathways:
            continue
        else:
            pathways.append(pathway)

    # Name, compound id, IUPAC, SMILES, molecular formula, description, synonyms, Pathways
    drugInfo = {
        drugName: {
            "cid": cid,
            "iupac": iupac,
            "smile": smile,
            "molecularformula": molecularFormula,
            "pathways": pathways,
            "synonyms": synList
        }
    }

    f.write(str(drugName) + "\t" + str(cid) + "\t" + str(iupac) + "\t" + str(smile) + "\t" + str(molecularFormula) + "\t" + str(synList)  + "\t" + str(pathways) + "\n")

f.close()