import csv

pathwaysDict = {}
with open('drugInfo.csv', 'r') as drugInfo:
    next(drugInfo)
    csv_reader = csv.reader(drugInfo)
    for row in csv_reader:
        if len(row[-1]) != 0:
            row[-1] = row[-1].strip("{}").replace("'", "")
            for path in row[-1].split(','):
                if path not in pathwaysDict.keys():
                    pathwaysDict[path] = [row[0].strip("{}".replace("'", ""))]
                else:
                    pathwaysDict[path].append(row[0].strip("{}".replace("'", "")))

with open('drugClustered.csv','w') as drugClustered:
    w = csv.writer(drugClustered)
    for k,v in pathwaysDict.items():
        w.writerow([k, v])