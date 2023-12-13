-- / / Server, created by KingCreoo on 12/11/23

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("DataStore")

-- / / MODULES

local _Settings = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Settings"))
local _Tower = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Tower"))
local _Data = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Data"))

-- / / VARIABLES

local Towers = {}

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local LoadEvent: RemoteEvent = Events:WaitForChild("Load")

-- / / FUNCTIONS

local function DeepCopy(Table)
    local Copy = {}

    for k, v in pairs(Table) do
        if type(v) == table then
            DeepCopy(v)
        else
            Copy[k] = v
        end
    end

    return Copy
end

local function DeepReconcile(Table0 --[[Default data]], Table1 --[[Player's data]])
    for k, v in pairs(Table0) do
        if not Table1[k] then continue end

        if type(v) == table then
            DeepReconcile(Table0[k], Table1[k])
        else
            if Table1[k] then 
                Table0[k] = Table1[k] 
            end
        end
    end
end

local function LoadPlayer(Player: Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    Character:SetPrimaryPartCFrame(workspace:WaitForChild("Limbo").CFrame + Vector3.new(0,5,0)) -- Teleport player to limbo

    local PlayerData = DataStore:GetAsync("Player_" .. Players:GetUserIdFromNameAsync(Player.Name))
    if not PlayerData then
        print(Player.Name .. " is a new player.")
        PlayerData = _Data.NewPlayer(Player)
    else
        if PlayerData["Version"] ~= _Settings.Version then
            DeepReconcile(_Settings.DefaultData, PlayerData) 
        end
    end

    _Data.Set(Player, PlayerData)

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = Player

    for Stat, Value in pairs(PlayerData["leaderstats"]) do
        local NewValue = Instance.new("IntValue")
        NewValue.Name = Stat
        NewValue.Value = Value
        NewValue.Parent = leaderstats
    end

    local PlayerTower = _Tower.New(Player)
    PlayerTower:Add() -- Create a tower for the player and assign a vacant(now occupied) location.
    Towers[Player.Name] = PlayerTower

    Character:SetPrimaryPartCFrame(PlayerTower.Model:WaitForChild("Teleport").CFrame) -- Teleport the player to the tower's location.

    LoadEvent:FireClient(Player) -- Communicate to the client that player has been loaded.
end

local function RemovePlayer(Player: Player)
    local PlayerTower = Towers[Player.Name]
    PlayerTower:Remove() -- Remove the player's tower from the workspace and mark it's location as vacant.

    local PlayerData = _Data.Remove(Player) -- Remove player's data from database (and save the data.)
    -- Save the player's data here, just in case.
end

-- / / REMOTES

-- / / EVENTS

Players.PlayerAdded:Connect(LoadPlayer)
Players.PlayerRemoving:Connect(RemovePlayer)