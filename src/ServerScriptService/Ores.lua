-- / / _Ores, created by KingCreoo on 12/13/23 :)))))

-- / / DEFINE
local _Ores = {}

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))
local _Data = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Data"))

-- / / VARIABLES

local PlayerTimes = {}

local ServerStartTime = workspace:GetServerTimeNow()

local Characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*_<>"
local OreDataBase = {}

local Events = ReplicatedStorage:WaitForChild("Events")
local Functions = ReplicatedStorage:WaitForChild("Functions")

local ActivateFunction: RemoteFunction = Functions:WaitForChild("Activate")
local ValidateFunction: RemoteFunction = Functions:WaitForChild("Validate")

-- / / LOCAL FUNCTIONS

local function RoundNumberToDecimal(Number, DecimalPlace)
    local Multiplier = 10 ^ DecimalPlace
    return math.floor(Number * Multiplier + 0.5) / Multiplier
end

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
    local ID = tostring(RoundNumberToDecimal(workspace:GetServerTimeNow() - ServerStartTime, 1)) .. "-"

    for _ = 1, 8 do
        local RandomNumber = math.random(1, string.len(Characters))
        local RandomCharacter = Characters:sub(RandomNumber, RandomNumber)

        ID = ID .. RandomCharacter
    end

    return ID
end

-- / / FUNCTIONS

function _Ores.DropForPlayer(Player)
    OreDataBase[Player.Name] = {}

    coroutine.wrap(function()
        while Players:FindFirstChild(Player.Name) do
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
        end
    end)()
end

function _Ores.Validate(Player: Player, OreID: string) -- Validate that the player has actually mined this ore through a series of checks
    local OreType = OreDataBase[Player.Name][OreID]

    local TimeOfDestruction = workspace:GetServerTimeNow() - ServerStartTime
    local Valid = true

    if not OreType then -- First and foremost, if the ore was never created here on the server: we know the player cheated.
        Valid = false                           -- (or some other weird scenario that should not yield a reward)
        warn("Ore does not exist.")
    end

    if _Settings.Pickaxes[Player:WaitForChild("pickaxe").Value]["Strength"] < _Settings.Ores[OreType]["Strength"] then -- If the player's pickaxe is too weak
        Valid = false -- On non-cheater clients, this will be taken care of on the client but we want to check here too
        warn("Player's pickaxe is too weak.")
    end

    local TimeOfCreation = string.split(OreID, "-")[1] -- Get the time in which this ore was created (approximately)
    local TimeToDestroyOre = _Settings.Ores[OreType]["Health"] / _Settings.Pickaxes[Player:WaitForChild("pickaxe").Value]["Speed"]
    local TimeOfPreviousDestruction = PlayerTimes[Player.Name] -- The time in which player destroyed the last ore (or time of activation)
    local TimeOreDestroyedIn = TimeOfDestruction - TimeOfCreation

    if TimeOreDestroyedIn + .5 --[[Add buffer]] < TimeToDestroyOre then -- In this case, the ore was destroyed faster than it should have based off of creation and destruction time.
        Valid = false -- Really what this block does is prevent an autominer that would instantly break ores from where they drop
        warn("Ore was destroyed too fast #1.")
    end

    if TimeOfDestruction - TimeOfPreviousDestruction < TimeToDestroyOre then -- In this case, the player is mining the ore too fast
        Valid = false -- It had been less time to mine this ore since they mined the previous ore, than the ore's time to destroy
        warn("Ore was destroyed too fast #2.")
    end

    if not Valid then return false end -- For now, we won't do anything about suspected cheaters. We simply won't reward the player anything.

    -- Now we can go about rewarding actual players, who actually mined the ore

    PlayerTimes[Player.Name] = workspace:GetServerTimeNow() - ServerStartTime -- First, set the player's new lastminetime for next calculations

    local PlayerData = _Data.Get(Player)
    PlayerData["Backpack"][OreType] += 1
    _Data.Set(Player, PlayerData)

    return true
end

-- / / EVENTS

ActivateFunction.OnServerInvoke = function(Player: Player)
    PlayerTimes[Player.Name] = workspace:GetServerTimeNow() - ServerStartTime

    return true
end

ValidateFunction.OnServerInvoke = _Ores.Validate

return _Ores