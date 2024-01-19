-- / / _Data, created by KingCreoo on 12/11/23

-- / / DEFINE
local _Data = {}

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("test")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))

-- / / VARIABLES

local Database = {}
local Saves = {}

-- / / LOCAL FUNCTIONS

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

-- / / FUNCTIONS

function _Data.NewPlayer(Player: Player) -- A new player has joined the game. For now just give them a set of default datapoints. 
    -- In the future, I will create a tutorial for new players. But for testing purposes, this is fine.
    
    local PlayerData = DeepCopy(_Settings.DefaultData) -- Give the player the game's default data.
    _Data.Set(Player, PlayerData)

    return PlayerData
end

function _Data.Set(Player: Player, PlayerData: table)
    Database[Player.Name] = PlayerData -- Set player's data
    
    local leaderstats = Player:FindFirstChild("leaderstats")
    if leaderstats then
        for Stat, Value in pairs(PlayerData["leaderstats"]) do -- Update player's leaderstat data here
            leaderstats:WaitForChild(Stat).Value = Value
        end
    end
    

    local TimeOfTransaction = os.time()
    local ToSave

    if not Saves[Player.Name] then -- Find if the player is eligable for a save at TimeOfTransaction
        ToSave = true
    else
        if Saves[Player.Name] - TimeOfTransaction > 60 then
            ToSave = true
        end
    end

    if not ToSave then return end -- If inelible for save then return

    Saves[Player.name] = TimeOfTransaction

    local Success, ErrorMessage = pcall(function()
        DataStore:SetAsync("Player_" .. Players:GetUserIdFromNameAsync(Player.Name), PlayerData) -- Save the player's data
    end)

    if not Success then 
        warn(ErrorMessage) -- If there was an error in the save: warn of error (maybe write some kind of warning for the player in the future)
    end
end

function _Data.Get(Player: Player)
    return Database[Player.Name]
end

function _Data.Remove(Player: Player)
    local PlayerData = DeepCopy(Database[Player.Name]) -- Make a copy of player's data for safe keeping
    PlayerData["Version"] = _Settings.Version -- Set player's data VERSION for data security
    PlayerData["LeaveTime"] = os.time() -- Set player's leave time
    Database[Player.Name] = nil -- Delete player's data

    local Success, ErrorMessage = pcall(function()
        DataStore:SetAsync("Player_" .. Players:GetUserIdFromNameAsync(Player.Name), PlayerData) -- Save the copy of the player's data as final save
    end)

    if not Success then 
        warn(ErrorMessage) -- If there was an error in the save, warn of error
    end

    return PlayerData -- Return copy of player's data
end

-- / / RETURN
return _Data