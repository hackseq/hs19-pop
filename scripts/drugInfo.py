# base url for pubchem
import csv
import json
import random

import pandas as pd
import requests

baseURL = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/"

drug_set = set()
dict_data = {}

with open('../datasets/cid.csv', newline='') as cid:
    csvread = csv.reader(cid)
    batch_data = list(csvread)
    chosen_drugs = random.sample(batch_data, 100)
    for drug in chosen_drugs:
        drug_set.add(drug[0])

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
    IUPAC = properties["PropertyTable"]["Properties"][0]["IUPACName"]
    SMILES = properties["PropertyTable"]["Properties"][0]["CanonicalSMILES"]
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
    folderPath = "../images/"
    imageURL = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/" + compoundNum + "/PNG"

    imagePath = folderPath + drugName.replace('/', '').replace('\\', '').title() + ".png"

    with open(imagePath, "wb") as code:
        try:
            code.write(requests.get(imageURL).content)
        except Exception:
            print(f"Some error occured with " + imagePath)
            pass

    # pathways for each drug
    compoundNum = compoundNum.split("/")[0]
    pathwayURL = "https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi?infmt=json&outfmt=csv&query={" \
                 "%22download%22:%22*%22,%22collection%22:%22pathway%22,%22where%22:{%22ands%22:[{%22cid%22:%22" + \
                 compoundNum + "%22},{%22core%22:%221%22}]},%22order%22:[%22name,asc%22],%22start%22:1," \
                               "%22limit%22:10000000,%22downloadfilename%22:%22CID_" + compoundNum + "_pathway%22}"

    pathwayData = pd.read_csv(pathwayURL)

    dict_data[drugName] = {
        'CID': cid,
        'IUPACName': IUPAC,
        'CanonicalSMILES': SMILES,
        'MolecularFormula': molecularFormula,
        'Synonyms': synList,
    }

    try:
        pathwaySet = set(pathwayData["name"].unique())
        dict_data[drugName]["Pathways"] = pathwaySet
        print(f"Pathway found for {drugName}")
    except Exception:
        print(f"No pathway for {drugName}!")
        pass

try:
    with open('drugInfo.csv', 'w', newline='') as csvfile:
        csv_columns = ['drugName', 'CID', 'IUPACName', 'CanonicalSMILES', 'MolecularFormula', 'Synonyms', 'Pathways']
        writer = csv.DictWriter(csvfile, fieldnames=csv_columns)
        writer.writeheader()
        for key, val in sorted(dict_data.items()):
            row = {'drugName': key}
            row.update(val)
            writer.writerow(row)
except IOError:
    print("I/O error")
