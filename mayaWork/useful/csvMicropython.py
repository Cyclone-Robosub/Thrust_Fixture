# Source - https://stackoverflow.com/a/68447343
# Posted by eatmeimadanish, modified by community. See post 'Timeline' for change history
# Retrieved 2026-05-05, License - CC BY-SA 4.0

x = [0, 2, 1]
csvdata = []
delim = ','
with open('trialCalibration.csv','r') as file:
    for line in file:
        csvdata.append(line.rstrip('\n').rstrip('\r').split(delim))
