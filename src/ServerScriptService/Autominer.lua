-- / / Autominers, created by KingCreoo on 12/17/23

-- / / DEFINE
local _Autominer = {}
_Autominer.__index = _Autominer

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))
local _Data = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Data"))

-- / / VARIABLES

local Modes = {"Off", "Best", "Worst", "Closest", "Random"}
local AltModes = {["Off"] = 1, ["Best"] = 2, ["Worst"] = 3, ["Closest"] = 4, ["Random"] = 5}

local Bindables: Folder = ReplicatedStorage:WaitForChild("Bindables")

-- / / LOCAL FUNCTIONS

-- / / OBJECT FUNCTIONS

function _Autominer.new(Player: Player, Autominer: string)
    local self = setmetatable({}, _Autominer)
    self.Player = Player.Name
    self.Tower = workspace:WaitForChild("ActiveTowers"):WaitForChild(Player.Name)
    self.Autominer = Autominer.Name
    self.Mode = "Off"
    self.Model = Autominer

    local SetBindable: BindableFunction = self.Model:WaitForChild("Set")
    SetBindable.OnInvoke = function()
        return self:ShiftModes()
    end

    return self
end

function _Autominer:ShiftModes()
    if self.Mode == Modes[#Modes] then
        self.Mode = Modes[1]
        return self.Mode
    else
        self.Mode = Modes[AltModes[self.Mode] + 1]
        return self.Mode
    end
end

-- / / RETURN
return _Autominer