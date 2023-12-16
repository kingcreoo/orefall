-- / / Client, created by KingCreoo on 12/11/23

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TweenService = game:GetService("TweenService")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))
local _Pickaxe = require(script.Pickaxe)
local _Interacts = require(script.Interacts)
local _UI = require(script.UI)

-- / / VARIABLES

local LocalPlayer: Player = Players.LocalPlayer
local LocalGui: PlayerGui = LocalPlayer.PlayerGui
local LoadingScreen: ScreenGui = LocalGui:WaitForChild("Load")

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local LoadEvent: RemoteEvent = Events:WaitForChild("Load")
local DropEvent: RemoteEvent = Events:WaitForChild("Drop")
local EquipEvent: RemoteEvent = Events:WaitForChild("Equip")

local LoadingScreenInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)

local EquippedPickaxe

-- / / FUNCTIONS

local function EquipPickaxe(PickaxeType: string)
    LocalGui:WaitForChild("Interacts"):WaitForChild("Pickaxes"):WaitForChild("Equipped").Value = LocalGui:WaitForChild("Interacts"):WaitForChild("Pickaxes"):WaitForChild("Pickaxes"):WaitForChild(PickaxeType)
    EquippedPickaxe:Set(PickaxeType)
end

local function PlayerLoaded(PlayerData: table) -- Player has been fully loaded. End load screen.
    _Interacts.Setup(PlayerData)

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
        task.wait(1)
        LoadingScreen:Destroy()
    end)
end

local function CreateOre(DropperName, OreTable)
    local Ore: Instance = ReplicatedStorage:WaitForChild("Ores"):WaitForChild(OreTable[1]):Clone()
    Ore:SetAttribute("ID", OreTable[2])
    Ore:SetAttribute("TotalHealth", _Settings.Ores[OreTable[1]]["Health"])
    Ore:SetAttribute("Health", _Settings.Ores[OreTable[1]]["Health"])
    Ore:SetAttribute("Strength", _Settings.Ores[OreTable[1]]["Strength"])

    Ore.Position = workspace:WaitForChild("ActiveTowers"):WaitForChild(LocalPlayer.Name):WaitForChild("Droppers"):WaitForChild(DropperName):WaitForChild("Drop").Position
    Ore.Parent = workspace:WaitForChild("ActiveOres")
end

-- / / REMOTES

LoadEvent.OnClientEvent:Connect(PlayerLoaded)
DropEvent.OnClientEvent:Connect(function(DropTable)
    for DropperName, OreTable in pairs(DropTable) do
        CreateOre(DropperName, OreTable)
    end
end)
EquipEvent.OnClientEvent:Connect(EquipPickaxe)

-- / / EVENTS