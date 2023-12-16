-- / / Pickaxes, created by KingCreoo on 12/14/23
-- Manages purchasing and equip/dequiping of pickaxes

-- / / DEFINE
local _Pickaxes = {}

-- / / SERVICES

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))
local _Data = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Data"))

-- / / VARIABLES

local Events = ReplicatedStorage:WaitForChild("Events")
local EquipEvent: RemoteEvent = Events:WaitForChild("Equip")

-- / / FUNCTIONS

function _Pickaxes.Equip(Player: Player, PickaxeType: string)
    local PlayerData = _Data.Get(Player)
    if PlayerData["Pickaxes"][PickaxeType] == 0 then
        warn(Player.Name .. " does not own this pickaxe!")

        return false
    end

    local OldPickaxe = Player:WaitForChild("Backpack"):FindFirstChild("Pickaxe")
    if OldPickaxe then -- Remove player's old pickaxe
        OldPickaxe:Destroy()
    end

    Player:WaitForChild('pickaxe').Value = PickaxeType

    local Pickaxe = _Settings.Pickaxes[PickaxeType]["Model"]:Clone() -- Get new pickaxe for player
    Pickaxe.Parent = Player:WaitForChild("Backpack") -- Place new pickaxe in player's inventory
    Pickaxe.Name = "Pickaxe"

    EquipEvent:FireClient(Player, PickaxeType)

    return true
end

function _Pickaxes.Purchase(Player: Player, PickaxeType: string)
    local PlayerData = _Data.Get(Player)

    if PlayerData["Pickaxes"][PickaxeType] == 1 then -- Player already owns this pickaxe
        return "owned"
    end

    if PlayerData["leaderstats"]["Cash"] < _Settings.Pickaxes[PickaxeType]["Price"] then -- Player does not have enough cash to purchase this pickaxe
        return "cash"
    end

    PlayerData["leaderstats"]["Cash"] -= _Settings.Pickaxes[PickaxeType]["Price"]
    PlayerData["Pickaxes"][PickaxeType] = 1

    _Data.Set(Player, PlayerData)

    return true
end

return _Pickaxes