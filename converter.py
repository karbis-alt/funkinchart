# this isnt as clean as funkychart
# i am also not that good at python lol

import json
import os

print("Insert username (for conversion)")
user = input()
print("Choose color (In RGB)")
print("EXAMPLE: 192, 0, 255")
color = input()
print("Insert chart author (leave empty if unknown)")
chartauthor = input()
print("Insert song name (leave empty for auto selection)")
songname = input()
print("Insert difficulty (leave empty for auto selection)")
difficultyname = input()
print("Insert audio name (with file extension)")
audioname = input()
print("Insert file name (leave empty for auto selection)")
filename = input()
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
    if noten >= 4:
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
    c1 = 0
    c2 = 0
    for i, v in chartdatacombined.items():
        for j, b in chartdatacombined.items():
            if not (c2 in delindexlist): continue
            fixedpos = v[1]
            if fixedpos >= 4:
                fixedpos -= 4
            if b[0] == v[0] and b[1] == fixedpos and c1 != c2:
                delindexlist.append(c2)
            c2 += 1
        c1 += 1
        c2 = 0
    for v in delindexlist:
        if v in chartdatacombined:
            del chartdatacombined[v]

print("Proccessing...")
if choice == "1":
    fixcombineddata()

def proccessdata(tab):
    # NOTE i am not good in string manipulation in python at all
    final = ""
    count = 0
    for i, v in tab.items():
        pos = v[1]
        if pos >= 4:
            pos -= 4
        final += "[{}]={{Side = data.options.side,Length = {}, Time = {}+data.options.timeOffset,Position = {}}},\n".format(
            count, v[2]/1000,v[0]/1000,pos)
        count += 1
    return final[0:len(final)-2]    

# Its time to make file.
split = os.path.basename(location).split("-")
chartname = ""
i = 0
for v in split:
    if i == len(split)-1:
        break
    chartname += split[i] + " "
    i += 1
if songname != "":
    chartname = songname
if songname == "":
    chartname = chartname[0:len(chartname)-1]
afilename = ""
if filename != "":
    afilename = filename + ".lua"
else:
    user + "_" + chartname.replace(" ","_") + ".lua"
with open(afilename,"w") as file:
    split = os.path.basename(location).split("-")
    difficulty = split[-1].split(".")[0]
    if difficultyname != "":
        difficulty = difficultyname
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
    finale = 'data.versions.loadingVersion = "v1.11"\n\ndata.chartData = {{\nchartName = [[{}]],\nchartAuthor = [[{}]],\nchartNameColor="{}",\nchartDifficulty = [[{}]],\nchartConverter = [[{}]],\n\nloadedAudioID = "FunkyChart/Audio/{}",\n\nchartNotes = {{\n{}\n}}\n}}'.format(
        chartname, truechartauthor, namecolor, difficulty, user, audioname, proccessdata(truetab))
    file.write(finale)
print("Done, you are free to close this now")
input()
