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

local Bindables: Folder = ReplicatedStorage:WaitForChild("Bindables")
local SetAutominerBindable: BindableFunction = Bindables:WaitForChild("SetAutominer")

-- / / LOCAL FUNCTIONS

-- / / OBJECT FUNCTIONS

function _Autominer.new(Player: Player, Autominer: string)
    local self = setmetatable({}, _Autominer)
    self.Player = Player.Name
    self.Tower = workspace:WaitForChild("ActiveTowers"):WaitForChild(Player.Name)
    self.Autominer = Autominer
    self.Mode = 0
    self.Model = ReplicatedStorage:WaitForChild("Autominers"):WaitForChild("Autominer"):Clone()

    self.Model.Parent = workspace
    self.Model:SetPrimaryPartCFrame(self.Tower:WaitForChild("Docks"):WaitForChild(self.Autominer))

    self:Listen()

    return self
end

function _Autominer:ShiftModes()
    if self.Mode == Modes[#Modes] then
        self.Mode = Modes[0]
        return self.Mode
    else
        self.Mode = Modes[self.Mode + 1]
        return self.Mode
    end
end

function _Autominer:Listen()
    SetAutominerBindable.OnInvoke = function(Player: Player, Autominer: string)
        if self.Player == Player.Name and self.Autominer == Autominer then
            local Result = self:ShiftModes()
            return Result
        end
    end
end

-- / / RETURN
return _Autominer