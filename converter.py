# this isnt as clean as funkychart
# i am also not that good at python lol

import json
import os

print("Insert username")
user = input()
print("Choose color (In RGB)")
print("EXAMPLE: 192, 0, 255")
color = input()
print("Insert chart author (leave empty if unknown)")
chartauthor = input()
print("Insert audio name (with file extension)")
audioname = input()
print("Insert FNF Chart file location")
print("EXAMPLE: C:\\Users\\name\\some random mod\\assets\\data\\a song\\a-song-hard.json")
print("If you want to quickly get chart location, ctrl+click on the json file and paste it (make sure to remove quotations)")
location = input()
print("How to handle chart data?")
print("INSERT NUMBER")
print("1. Combine both sides")
print("2. Player 1 only")
print("3. Player 2 only")
choice = input()
notedata = []
with open(location,"r") as file:
    chartdata = json.loads(file.read())
chartdatabf = {}
chartdataopp = {}
chartdatacombined = {}
# god forgive me for what im about to do
globalnotes = {}
globalsectiondata = {}
nc = 0
for v in chartdata["song"]["notes"]:
    if len(v["sectionNotes"]) != 0:
        for b in v["sectionNotes"]:
            globalnotes[nc] = b
            globalsectiondata[nc] = v
            nc = nc + 1
del nc
for i, v in globalnotes.items():
    noten = globalnotes[i][1]+1
    side = 0
    if noten >= 5:
        side = 1
        noten = noten - 4
    if globalsectiondata[i]["mustHitSection"] == True:
        if side == 1:
            side = 0
        else:
            side = 1
    if side == 1:
        chartdatabf[i] = v
    else:
        chartdataopp[i] = v
    chartdatacombined[i] = v
# forgive me

def fixcombineddata():
    #removes duplicates
    delindexlist = []
    for i, v in chartdatacombined.items():
        for j, b in chartdatacombined.items():
            fixedpos = v[2]
            if fixedpos >= 5:
                fixedpos -= 4
            if b[0] == v[0] and b[2] == fixedpos and i != j:
                delindexlist.append(j)
    for v in delindexlist:
        if v in chartdatacombined:
            del chartdatacombined[v]

fixcombineddata()

def proccessdata(tab):
    # NOTE i am not good in string manipulation in python at all
    final = ""
    for i, v in tab.items():
        pos = v[1]
        if pos >= 5:
            pos -= 4
        final += "[{}]={{Side = data.options.side,Length = {}, Time = {}+data.options.timeOffset,Position = {}}}".format(
            i-1, v[2]/1000,v[0]/1000,pos)
        if i != len(tab):
            final += ","
        final += "\n"
    return final[0:len(final)-2]    

# Its time to make file.
with open(user + "_" + os.path.splitext(os.path.basename(location))[0].replace("-","_") + ".lua","w") as file:
    split = os.path.basename(location).split("-")
    chartname = ""
    i = 0
    for v in split:
        if i == len(split)-1:
            break
        chartname += split[i] + " "
        i += 1
    difficulty = split[-1].split(".")[0]
    if chartauthor == "":
        truechartauthor = "Unknown"
    else:
        truechartauthor = chartauthor
    namecolor = "<font color='rgb({})'>%s</font>".format(color)
    if choice == "1":
        truetab = chartdatacombined
    elif choice == "2":
        truetab = chartdataopp
    elif choice == "3":
        truetab = chartdatabf
    finale = 'data.chartData = {{\nchartName = "{}",\nchartAuthor = "{}",\nchartNameColor="{}",\nchartDifficulty = "{}",\nchartConverter = "{}",\n\nloadedAudioID = "FunkyChart/Audio/{}",\n\nchartNotes = {{\n{}\n}}\n}}'.format(
        chartname[0:len(chartname)-1], truechartauthor, namecolor, difficulty, user, audioname, proccessdata(truetab))
    file.write(finale)
print("Done, you are free to close this now")
input()
