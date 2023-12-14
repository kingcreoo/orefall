-- / / _Pickaxe, created by KingCreoo on 12/13/23

-- / / DEFINE
local _Pickaxe = {}
_Pickaxe.__index = _Pickaxe

-- / / SERVICES

local Players = game:GetService("Players")

-- / / MODULES

-- / / VARIABLES

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

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

return _Pickaxe