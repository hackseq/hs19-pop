import requests
import json
import wget
import csv
import pandas as pd

# base url for pubchem
baseURL = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/"
# default compound number is 2244 for asprin
compoundNum = "5362124/"

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
synList = synList[1:11]

# 2D image of each drug
# specify folder where images are stored
folderPath = "/home/roshann/Documents/hackseq19-p14/drugImages/"
imageURL = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/" + compoundNum + "/PNG"

imagePath = folderPath + drugName + ".png"

with open(imagePath, "wb") as code:
    code.write(requests.get(imageURL).content)

'''
# pathways for each drug
compoundNum = compoundNum.split("/")[0]
#pathwayURL = "https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi?infmt=json&outfmt=csv&query={%22download%22:%22*%22,%22collection%22:%22pathway%22,%22where%22:{%22ands%22:[{%22cid%22:%222244%22},{%22core%22:%221%22}]},%22order%22:[%22name,asc%22],%22start%22:1,%22limit%22:10000000,%22downloadfilename%22:%22CID_" + compoundNum + "_pathway%22}"
pathwayURL = "https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi?infmt=json&outfmt=csv&query={%22download%22:%22*%22,%22collection%22:%22dgidb%22,%22where%22:{%22ands%22:[{%22cid%22:%225362124%22}]},%22order%22:[%22relevancescore,desc%22],%22start%22:1,%22limit%22:10000000,%22downloadfilename%22:%22CID_" + compoundNum + "_dgidb%22}"
pathway = csv.reader(requests.get(pathwayURL).text)


pathwayData = pd.read_csv(pathwayURL)


#get pathways and the number of times they show up
pathwayCount = pathwayData["name"].value_counts()
#join pathway/pathway count together and store as a list
pathways = []

for pathway in pathwayCount.index.values:
    pathways.append(pathway + "-" + str(pathwayCount[pathway]))

'''
# Name, compound id, IUPAC, SMILES, molecular formula, description, synonyms, Pathways
drugInfo = {
    drugName: {
        "cid": cid,
        "iupac": iupac,
        "smile": smile,
        "molecularformula": molecularFormula,
        #"pathways": pathways,
        "synonyms": synList
    }
}

#print(drugInfo[drugName])
print(str(drugName) + "\t" + str(cid) + "\t" + str(iupac) + "\t" + str(smile) + "\t" + str(molecularFormula) + "\t" + str(synList))
