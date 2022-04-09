--[[

        ______            __         ________               __ 
       / ____/_  ______  / /____  __/ ____/ /_  ____ ______/ /_
      / /_  / / / / __ \/ //_/ / / / /   / __ \/ __ `/ ___/ __/
     / __/ / /_/ / / / / ,< / /_/ / /___/ / / / /_/ / /  / /_  
    /_/    \__,_/_/ /_/_/|_|\__, /\____/_/ /_/\__,_/_/   \__/  
                           /____/
    v1.051
    Made with ♥ by accountrev           

    Thanks for downloading and using my script, if you're here to just use it once or plan to use it many times.
    I have put many hours into this as well as my YouTube channel with showcases and such. I don't really care about the views that much,
    but the amount of attention that those videos created have blown my mind. Thank you.

    If at some point you want to fork/modify and re-distribute this script, please give me credit.

    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!
    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!
    !!! Please report any bugs/questions over on the Issues tab on GitHub, I will try to respond ASAP. !!!

    [VERSION 1.051]

    -   Added selection for executors

    [VERSION 1.05]

    -   Added checks for any missing audio
    -   Added error handler

    [VERSION 1.04]

    -   Testing support for the Krnl executor.

    [VERSION 1.03]

    -   Fixed version number.

    [VERSION 1.02]

    -   No changes

    [VERSION 1.01 - DELAYED]

    -   Delayed released due to Roblox's audio privacy update.
    -   Removed functionality of online mode, making this script Synapse X exclusive :(
    -   Added new features and organized sections
    -   Bug fixes

    [VERSION 1.0 - INITIAL RELEASE]

    -   Initial release
    -   Fixed many bugs with the 4v4 update on FF before release.

--]]


_G.customChart = {
    chartNotes = {},
    chartName = "",
    chartNameColor = "<font color='rgb(255, 255, 255)'>%s</font>",
    chartAuthor = "",
    chartDifficulty = "",
    chartConverter = game.Players.LocalPlayer.Name,
    loadedAudioID = "",
    timeOffset = 0,
    side = "Left",
    executor = ""
}


function Announce(messagetitle, messagebody, duration, type)
    startgui = game:GetService("StarterGui")

    typeSounds = {
        ["main"] = 12221967,
        ["error"] = 12221944,
        ["loaded"] = 12222152
    }

    startgui:SetCore("SendNotification", {
        Title = messagetitle;
        Text = messagebody;
        Duration = duration;
        Button1 = "Close";
    })

    local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. typeSounds[type]
    sound.Parent = game.SoundService
	sound:Play()
	sound.Ended:Wait()
	sound:Destroy()
end

function errorHandler(errorMessage)
    Announce("An Oopsie Occurred!", errorMessage .. "\nPlease report this!", 100, "error")
end


function Data(mode)

    local foldername = "FunkyChart"
    local datafilename = "FunkyChart_Data.txt"
    local audiofoldername = "FunkyChart/Audio"
    local chartfoldername = "FunkyChart/Charts"

    if not isfolder("FunkyChart") then
        makefolder("FunkyChart")
        makefolder("FunkyChart/Charts")
        makefolder("FunkyChart/Audio")

        print("Audio Folder made")
    end

    if mode == "s" then
        print("Saving data...")
        local json
        local httpS = game:GetService("HttpService")
        if (writefile) then
            json = httpS:JSONEncode(_G.customChart)
            writefile(datafilename, json)
            print("Data saved")
            Announce("Data Saved", "Your data has been saved with the song: \n" .. _G.customChart.chartName .. "\n" .. _G.customChart.chartAuthor, 10, "main")
        end
    elseif mode == "l" then
        print("Loading data...")
        local httpS = game:GetService("HttpService")
        if (readfile and isfile and isfile(datafilename)) then
            _G.customChart = httpS:JSONDecode(readfile(datafilename))
            print("Data loaded")
            Announce("Data Loaded", _G.customChart.chartName .. " by " .. _G.customChart.chartAuthor .. " has been loaded from your previous save.", 10, "main")
        else
            Announce("First Time?", "Looks like you don't have any save data. Load a song to generate a save file!", 10, "main")
        end
    elseif mode == "w" then

        Announce("Deleting", "Deleting save data...", 10, "main")
        
        delfile(datafilename)

    end
end

function loadChart(chart)
    chart = chart or ""

    if not isfile("FunkyChart/Charts/" .. chart) then
        Announce("Error", chart .. " does not exist!", 10, "error")
        return
    else
        loadstring(readfile('FunkyChart/Charts/' .. chart))()
    end
    
    if not isfile(_G.customChart.loadedAudioID) then
        Announce("No Audio Found!", _G.customChart.loadedAudioID .. " cannot be found for " .. chart .. ".", 10, "error")
        _G.customChart.loadedAudioID = ""
        return
    else
        if _G.customChart.executor == "" then
            Announce("Select an executor", "Select an executor to continue loading.", 10, "error")
            return
        else
            if _G.customChart.executor == "Synapse" then
                _G.customChart.loadedAudioID = getsynasset(_G.customChart.loadedAudioID)
            elseif _G.customChart.executor == "Krnl" then
                _G.customChart.loadedAudioID = getcustomasset(_G.customChart.loadedAudioID)
            end
        end
    end
    game.SoundService.ClientMusic.SoundId = _G.customChart.loadedAudioID
    Announce("Song Loaded", _G.customChart.chartName .. "\n" .. _G.customChart.chartAuthor, 10, "loaded")
    Data("s")
end

function Chart(preventErrorLag)

    preventErrorLag = preventErrorLag or false

    if _G.customChart.loadedAudioID == "" then
        Announce("Load a song", "Load a song first you dummy!", 5, "error")
        return
    end


    for _, core in next, getgc(true) do

        if type(core) == 'table' and rawget(core, 'GameUI') then
            
            Announce("Now Loading", _G.customChart.chartName .. "\n" .. _G.customChart.chartAuthor, 1, "loaded")

            if preventErrorLag == true then
                local currentpos = game.Players.LocalPlayer.Character.HumanoidRootPart
                local stagepos = game:GetService("Workspace").Map.Stages.WoodStage.Zone.CFrame
                currentpos.CFrame = stagepos
            end
            
            core.SongPlayer:StartSong("FNF_Bopeebo", _G.customChart.side, "Hard", {game.Players.LocalPlayer})

            core.SongPlayer.CurrentSongData = _G.customChart.chartNotes
            core.Songs.FNF_Bopeebo.Title = _G.customChart.chartName
            core.Songs.FNF_Bopeebo.TitleFormat = _G.customChart.chartNameColor
            core.SongPlayer.TopbarAuthor = "By: " .. _G.customChart.chartAuthor .. "\nConverted by: " .. _G.customChart.chartConverter
            core.SongPlayer.TopbarDifficulty = _G.customChart.chartDifficulty
            core.SongPlayer.CountDown = true
            
            game:GetService("SoundService").ClientMusic.SoundId = _G.customChart.loadedAudioID
            core.SongPlayer.CurrentlyPlaying = game:GetService("SoundService").ClientMusic
            core.SongPlayer:Countdown()
            core.SongPlayer.CurrentlyPlaying.Playing = true
            
            repeat
                wait()
            until game.SoundService.ClientMusic.IsPlaying == false or core.SongPlayer.CurrentSongData == nil
            
            if game.SoundService.ClientMusic.IsPlaying == false then
                core.SongPlayer:StopSong()
            end

            game.SoundService.ClientMusic.Playing = false
            game.SoundService.ClientMusic.TimePosition = 0
            
            
            
            break
        end 
    end
end

function loadGUI()

    local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua')))()

    local windowMain = library:CreateWindow("Main")
    local windowOpt = library:CreateWindow("Options")
    local windowCredits = library:CreateWindow("Credits")

    local Main = windowMain:CreateFolder("Main")
    local ChartOptions = windowOpt:CreateFolder("Loading")
    local GeneralOptions = windowOpt:CreateFolder("Chart")
    local GUIOptions = windowOpt:CreateFolder("GUI")
    local OtherOptions = windowOpt:CreateFolder("Misc")
    local CreditsTo = windowCredits:CreateFolder("Credits to...")

    Main:Button("Play Chart",function()
        local stat, err = pcall(Chart, errorLagBool)
        if not stat then
            errorHandler(err)
        end
    end)

    Main:Button("AutoPlayer",function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/wally-rblx/funky-friday-autoplay/main/main.lua')))()
    end)

    Main:DestroyGui()

    ChartOptions:Label("Type file name here ⬇️",{
        TextSize = 17.5;
        TextColor = Color3.fromRGB(255,255,255);
        BgColor = Color3.fromRGB(0,0,0);
        
    })

    ChartOptions:Box("Example: Chart.lua","string",function(value)
        chartLink = value
    end)

    ChartOptions:Button("Load Chart",function()
        local stat, err = pcall(loadChart, chartLink)
        if not stat then
            errorHandler(err)
        end
    end)

    ChartOptions:Dropdown("Executor",{"Synapse", "Krnl"},true,function(mob)
        _G.customChart.executor = mob
        Data("s")
    end)

    GeneralOptions:Toggle("Prevent Error Lag",function(bool)
        errorLagBool = bool
    end)

    GeneralOptions:Dropdown("Player Side",{"Left", "Right"},true,function(mob)
        _G.customChart.side = mob
        Data("s")
    end)
    

    GUIOptions:Slider("Title Size",{
        min = 0;
        max = 500;
        precise = true;
        
    },function(value)
        game.Players.LocalPlayer.PlayerGui.GameUI.TopbarLabel.Size = UDim2.new(0.4, 0, 0, value)
    end)

    GUIOptions:Toggle("Full Underlay",function(bool)
        game.Players.LocalPlayer.PlayerGui.GameUI.Arrows.ExtraUnderlay.Visible = bool
    end)

    

    GUIOptions:Toggle("Disable Sick! Judgement",function(bool)
        if bool then
            game:GetService("ReplicatedStorage").Assets.UI.Templates.Hits.Sick.Image = " "
        else
            game:GetService("ReplicatedStorage").Assets.UI.Templates.Hits.Sick.Image = "rbxassetid://6450258128"
        end
    end)

    OtherOptions:Button("Unanchor Player",function()
        game.Players.LocalPlayer.Character.Head.Anchored = false
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 24
    end)

    OtherOptions:Button("Unlock Camera",function()
        game.Workspace.Camera:Destroy()
        wait(0.01)
        game.Workspace.Camera.CameraType = Enum.CameraType.Custom
        game.Workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
    end)

    OtherOptions:Button("!DELETE SAVE DATA!", function()

        Data("w")

        loadstring(game:HttpGet(('https://raw.githubusercontent.com/accountrev/funkychart/master/FunkyChartGUI.lua')))()

    end)

    CreditsTo:Label("wally-rblx: open-source autoplayer that made this possible",{
        TextSize = 14;
        TextColor = Color3.fromRGB(255,255,255);
        BgColor = Color3.fromRGB(69,69,69);
        
    })

    CreditsTo:Label("Aika: GUI that is being used",{
        TextSize = 14;
        TextColor = Color3.fromRGB(255,255,255);
        BgColor = Color3.fromRGB(69,69,69);
        
    })

    CreditsTo:Label("myself: having the motivation to finish this",{
        TextSize = 14;
        TextColor = Color3.fromRGB(255,255,255);
        BgColor = Color3.fromRGB(69,69,69);
        
    })

    CreditsTo:Label("Roblox: fucking up release",{
        TextSize = 14;
        TextColor = Color3.fromRGB(255,255,255);
        BgColor = Color3.fromRGB(69,69,69);
        
    })

    CreditsTo:Button("Problems?",function()
        Announce("Problems?", "Please report any bugs to the Issues tab on GitHub!", 5, "loaded")
    end)


end

function loadSetup()
    if not game.SoundService:FindFirstChild("NotifAudio") then
        clientMusicInstance = Instance.new("Sound")
        clientMusicInstance.Parent = game.SoundService
        clientMusicInstance.Name = "NotifAudio"
        clientMusicInstance.SoundId = 0
        clientMusicInstance.TimePosition = 0
    else
        print("NotifAudio Instance already created.")
    end

    if not game.SoundService:FindFirstChild("ClientMusic") then
        clientMusicInstance = Instance.new("Sound")
        clientMusicInstance.Parent = game.SoundService
        clientMusicInstance.Name = "ClientMusic"
        clientMusicInstance.SoundId = _G.customChart.loadedAudioID
        clientMusicInstance.TimePosition = 0
    else
        print("ClientMusic Instance already created.")
    end

    if not game.Players.LocalPlayer.PlayerGui.GameUI.Arrows:FindFirstChild("ExtraUnderlay") then
        underlay1 = Instance.new("Frame")
        underlay1.Name = "ExtraUnderlay"
        underlay1.AnchorPoint = Vector2.new(0.5, 0.5)
        underlay1.Parent = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Arrows
        underlay1.Size = UDim2.new(2, 0, 2, 0)
        underlay1.Position = UDim2.new(0.5, 0, 0.5, 0)
        underlay1.ZIndex = 0
        underlay1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        underlay1.BackgroundTransparency = 0
        underlay1.Visible = false
    else
        print("Underlay already created")
    end
end



function Init()
    loadSetup()
    loadGUI()

    Announce("Script Loaded", "Welcome! Remember to read the instructions on the GitHub.", 10, "main")
    Data("l")
end

local errorLagBool
local chartListName
local chartLink

Init()

