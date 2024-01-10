-- / / Client, created by KingCreoo on 12/11/23

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TweenService = game:GetService("TweenService")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))
local _Pickaxe = require(script.Pickaxe)
local _Button = require(script.Button)
local _Interacts = require(script.Interacts)
local _UI = require(script.UI)

-- / / VARIABLES

local LocalPlayer: Player = Players.LocalPlayer
local LocalGui: PlayerGui = LocalPlayer.PlayerGui
local LoadingScreen: ScreenGui = LocalGui:WaitForChild("Load")
local HUD: ScreenGui = LocalGui:WaitForChild("HUD")

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local LoadEvent: RemoteEvent = Events:WaitForChild("Load")
local DropEvent: RemoteEvent = Events:WaitForChild("Drop")
local EquipEvent: RemoteEvent = Events:WaitForChild("Equip")
local MoveAutominerEvent: RemoteEvent = Events:WaitForChild("MoveAutominer")
local AnimateAutominerEvent: RemoteEvent = Events:WaitForChild("AnimateAutominer")
local AutominerMineEvent: RemoteEvent = Events:WaitForChild("AutominerMine")

local Bindables: Folder = ReplicatedStorage:WaitForChild("Bindables")
local LoadBindable: BindableEvent = Bindables:WaitForChild("Load")

local Functions: Folder = ReplicatedStorage:WaitForChild("Functions")
local GetOreInfoFunction: RemoteFunction = Functions:WaitForChild("GetOreInfo")

local LoadingScreenInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)

local EquippedPickaxe

-- / / FUNCTIONS

local function EquipPickaxe(PickaxeType: string)
    if not EquippedPickaxe then
        EquippedPickaxe = _Pickaxe.New()
    end
    
    LocalGui:WaitForChild("Interacts"):WaitForChild("Pickaxes"):WaitForChild("Equipped").Value = LocalGui:WaitForChild("Interacts"):WaitForChild("Pickaxes"):WaitForChild("Pickaxes"):WaitForChild(PickaxeType)
    EquippedPickaxe:Set(PickaxeType)
end

local function PlayerLoaded(PlayerData: table) -- Player has been fully loaded. End load screen.
    _Interacts.Setup(PlayerData)

    for _, Button: Model in pairs(workspace:WaitForChild("ActiveTowers"):WaitForChild(LocalPlayer.Name):WaitForChild("Buttons"):GetChildren()) do
        local CreateButton = _Button.new(Button)
    end

    local Refinery = workspace:WaitForChild("ActiveTowers"):WaitForChild(LocalPlayer.Name):WaitForChild("Refinery")
    local R1, R2 = _Button._new(Refinery:WaitForChild("Refine")), _Button._new(Refinery:WaitForChild("Instant"))

    LoadBindable:Fire(PlayerData)

    task.wait(2) -- For now. To make the player feel as if their is an actual load time.
    -- When the game has actual stuff to load, we will remove this.

    local LastTween
    for _, Item in pairs(LoadingScreen:GetChildren()) do
        local Tween
        if Item.ClassName == "Frame" then
            Tween = TweenService:Create(Item, LoadingScreenInfo, {Transparency = 1})
        elseif Item.ClassName == "ImageLabel" then
            Tween = TweenService:Create(Item, LoadingScreenInfo, {ImageTransparency = 1})
        elseif Item.ClassName == "TextLabel" then
            Tween = TweenService:Create(Item, LoadingScreenInfo, {TextTransparency = 1})
        end
        Tween:Play()

        LastTween = Tween
    end

    LastTween.Completed:Connect(function()
        LoadingScreen.Enabled = false
        HUD.Enabled = true

        task.wait(1)
        LoadingScreen:Destroy()
    end)
end

local function CreateOre(DropperName, OreTable) -- Spawn an ore with given table
    local Ore: Instance = ReplicatedStorage:WaitForChild("Ores"):WaitForChild(OreTable[1]):Clone()
    Ore:SetAttribute("ID", OreTable[2])
    Ore:SetAttribute("Set", false)
    Ore:SetAttribute("TotalHealth", _Settings.Ores[OreTable[1]]["Health"])
    Ore:SetAttribute("Health", _Settings.Ores[OreTable[1]]["Health"])
    Ore:SetAttribute("Strength", _Settings.Ores[OreTable[1]]["Strength"])

    Ore.Position = workspace:WaitForChild("ActiveTowers"):WaitForChild(LocalPlayer.Name):WaitForChild("Droppers"):WaitForChild(DropperName):WaitForChild("Drop").Position
    Ore.Parent = workspace:WaitForChild("ActiveOres")

    task.wait(1)

    repeat -- Wait until the ore has settled, and then lock it in place
        task.wait(.25)

        if Ore:GetAttribute("Set") == true or Ore.AssemblyLinearVelocity.Magnitude >= 1 then continue end -- If the ore is already set, or is still dropping then wait again

        Ore:SetAttribute("Set", true)
        Ore.Anchored = true
    until Ore:GetAttribute("Set") == true
end

local function FindOre(OreInfo: table) -- Function that finds the ore part (in workspace) with given info
    local Ore

    for _, _Ore in pairs(workspace:WaitForChild("ActiveOres"):GetChildren()) do
        if _Ore:GetAttribute("ID") == OreInfo["ID"] then
            Ore = _Ore
        end
    end

    return Ore
end

-- / / REMOTES

LoadEvent.OnClientEvent:Connect(PlayerLoaded)
DropEvent.OnClientEvent:Connect(function(DropTable)
    for DropperName, OreTable in pairs(DropTable) do
        CreateOre(DropperName, OreTable)
    end
end)
EquipEvent.OnClientEvent:Connect(EquipPickaxe)

GetOreInfoFunction.OnClientInvoke = function(OreInfo: table) -- Server inquires about info on this ore
    local Ore: Part = FindOre(OreInfo)
    return Ore.Position, Ore.CFrame, Ore:GetAttribute("Set") -- So we return the ores position in the workspace as well as if it's set in place or not.
end

MoveAutominerEvent.OnClientEvent:Connect(function(PlayerName: string, Autominer: string, TargetCFrame: CFrame, Time: number)
    print('move', Time)
end)

AnimateAutominerEvent.OnClientEvent:Connect(function(PlayerName: string, Autominer: string, Time: number)
    print('animate', Time)
end)

AutominerMineEvent.OnClientEvent:Connect(function(OreInfo: table)
    local Ore: Part = FindOre(OreInfo)
    _UI.BackpackAdd(OreInfo["Type"])

    Ore:Destroy()
end)

-- / / EVENTS