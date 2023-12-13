-- / / _Ores, created by KingCreoo on 12/13/23 :)))))

-- / / DEFINE
local _Ores = {}

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- / / MODULES

local _Settings = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Settings"))

-- / / VARIABLES

local Characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*_<>"
local OreDataBase = {}

local Events = ReplicatedStorage:WaitForChild("Events")

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

local function SelectOre(Luck: number) -- Set up only for selecting ores. Do not use for any other purpose.
    local SelectedOre

    for _, Ore in pairs(_Settings.OreOrder) do
        local RandomNumber = math.random(1, _Settings.Ores[Ore]["Rarity"])

        if RandomNumber <= Luck then
            SelectedOre = DeepCopy(_Settings.Ores[Ore])

            break
        else
            continue
        end
    end

    return SelectedOre
end

local function GenerateOreID()
    local ID = tostring(workspace:GetServerTimeNow()) .. "-"

    for _ = 1, 8 do
        local RandomNumber = string.len(Characters)
        local RandomCharacter = Characters:sub(RandomNumber, RandomNumber)

        ID = ID .. RandomCharacter
    end

    return ID
end

-- / / FUNCTIONS

function _Ores.DropForPlayer(Player)
    OreDataBase[Player.Name] = {}

    coroutine.wrap(function()
        task.wait(4) -- In the future, find this time based off of player's boosts & server boosts
        local Luck = 1 -- In the future, find this luck based off dropper's luck, player's luck, & boosts
        local DropTable = {}

        for _, Dropper in pairs(workspace:WaitForChild("ActiveTowers"):WaitForChild(Player.Name):WaitForChild("Droppers"):GetChildren()) do
            local SelectedOre = SelectOre(Luck) -- Choose an ore

            local OreID = GenerateOreID() -- Create an ID for the ore
            OreDataBase[Player.Name][OreID] = SelectedOre["Name"] -- Update player's oredatabase with new ore

            DropTable[Dropper.Name] = {SelectedOre["Name"], OreID} -- Add ore the table that will be returned to the player
        end

        Events:WaitForChild("Drop"):FireClient(Player, DropTable)
    end)()
end

-- / / EVENTS

return _Ores