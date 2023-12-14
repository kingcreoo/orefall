-- / / _Pickaxe, created by KingCreoo on 12/13/23

-- / / DEFINE
local _Pickaxe = {}
_Pickaxe.__index = _Pickaxe

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))

-- / / VARIABLES

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Events = ReplicatedStorage:WaitForChild("Events")
local Functions = ReplicatedStorage:WaitForChild("Functions")

local EquipEvent: RemoteEvent = Events:WaitForChild("Equip")
local ActivateFunction: RemoteFunction = Functions:WaitForChild("Activate")
local ValidateFunction: RemoteFunction = Functions:WaitForChild("Validate")

-- / / FUNCTIONS

function _Pickaxe.New(Type: string)
    local self = setmetatable({}, _Pickaxe)
    self.Type = Type

    self.Active = false
    self.Enabled = false
    self.Target = false

    return self
end

function _Pickaxe:Activate()

end

function _Pickaxe:Deactivate()

end

function _Pickaxe:Destroy()
    self = nil
end

return _Pickaxe