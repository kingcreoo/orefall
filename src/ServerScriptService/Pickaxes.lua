-- / / Pickaxes, created by KingCreoo on 12/14/23
-- Manages purchasing and equip/dequiping of pickaxes

-- / / DEFINE
local _Pickaxes = {}

-- / / SERVICES

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))

-- / / VARIABLES

local Events = ReplicatedStorage:WaitForChild("Events")
local EquipEvent: RemoteEvent = Events:WaitForChild("Equip")

-- / / FUNCTIONS

function _Pickaxes.Equip(Player: Player, PickaxeType: string)
    local OldPickaxe = Player:WaitForChild("Backpack"):FindFirstChild("Pickaxe")
    if OldPickaxe then -- Remove player's old pickaxe
        OldPickaxe:Destroy()
    end

    Player:WaitForChild('pickaxe').Value = PickaxeType

    local Pickaxe = _Settings.Pickaxes[PickaxeType]["Model"]:Clone() -- Get new pickaxe for player
    Pickaxe.Parent = Player:WaitForChild("Backpack") -- Place new pickaxe in player's inventory
    Pickaxe.Name = "Pickaxe"

    EquipEvent:FireClient(Player, PickaxeType)
end

return _Pickaxes