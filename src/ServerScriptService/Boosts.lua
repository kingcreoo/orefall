-- / / Boosts, written by KingCreoo on 1/19/24

-- / / DEFINE
local _Boosts = {}

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- / / MODULES

local _Data = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Data"))
local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))

-- / / VARIABLES

-- / / MODULE FUNCTIONS

function _Boosts.Rejoin(Player: Player)
    local PlayerData = _Data.Get(Player)

    local BoostsToCreate = {}
    for _, Boost in pairs(PlayerData["Boosts"]) do
        if PlayerData["LeaveTime"] - Boost['StartTime'] >= Boost['Duration'] then -- If the player's boost is finished then remove it from the player's data
            continue
        end

        table.insert(BoostsToCreate, {Boost["Type"], Boost["Multiplier"], Boost['Duration'] - (PlayerData["LeaveTime"] - Boost['StartTime'])}) -- Add boost to the new lists of boosts
    end

    PlayerData["Boosts"] = {} -- Set player's boosts to nil to prepare for creation of new boosts
    _Data.Set(Player, PlayerData)

    for _, Boost in pairs(BoostsToCreate) do -- Create new boosts
        _Boosts.Give(Player, Boost[1], Boost[2], Boost[3])
    end
end

function _Boosts.Refresh(Player: Player)
    local PlayerData = _Data.Get(Player)

    local BoostsToCreate = {}
    for _, Boost in pairs(PlayerData["Boosts"]) do
        if os.time() - Boost['StartTime'] >= Boost['Duration'] then -- If the player's boost is finished then remove it from the player's data
            continue
        end

        table.insert(BoostsToCreate, {Boost["Type"], Boost["Multiplier"], Boost['Duration'] - (os.time() - Boost['StartTime'])}) -- Add boost to the new lists of boosts
    end

    PlayerData["Boosts"] = {} -- Set player's boosts to nil to prepare for creation of new boosts
    _Data.Set(Player, PlayerData)

    for _, Boost in pairs(BoostsToCreate) do -- Create new boosts
        _Boosts.Give(Player, Boost[1], Boost[2], Boost[3])
    end
end

function _Boosts.Remove(Player: Player, BoostID: string)
    local PlayerData = _Data.Get(Player)

    if PlayerData["Boosts"][BoostID] then
        PlayerData["Boosts"][BoostID] = nil -- If this boost exists, then remove it from the player's data
        _Data.Set(Player, PlayerData)

        return true
    else
        return false -- If this boost does not exist, then return false for debugging purposes
    end
end

function _Boosts.Give(Player: Player, Type: string, Multiplier: number, Duration: number) -- Give a player their new boost, with given parameters
    local StartTime = os.time()

    local NewBoost = { -- Create the boost table
        ["Type"] = Type,
        ["Multiplier"] = Multiplier,
        ["Duration"] = Duration,
        ["StartTime"] = StartTime,
    }

    local BoostID = tostring(math.random(1000, 9999)) .. '-' .. tostring(StartTime) -- Create an ID for this boost that can be used to clear boost later

    local PlayerData = _Data.Get(Player) -- Add boost to player's data & save under boost ID
    PlayerData["Boosts"][BoostID] = NewBoost
    _Data.Set(Player, PlayerData)

    print("Boost started: ", BoostID, Duration)

    task.wait(Duration) -- Wait until boost is finished

    if Players:FindFirstChild(Player.Name) and _Data.Get(Player)["Boosts"][BoostID] then
        local SUCCESS = _Boosts.Remove(Player, BoostID) -- If the player is still in the server & the boost still exists, then remove it from the player

        if not SUCCESS then
            _Boosts.Refresh(Player) -- If the boost did not exist, for security reasons we will refresh the player's boosts with new IDs
        else
            print("Boost ended: ", BoostID)
        end
    end
end

-- / / RETURN
return _Boosts