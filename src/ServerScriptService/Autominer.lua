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
local _Ores = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Ores"))

-- / / VARIABLES

local Modes = {"Off", "Best", "Worst", "Random"}
local AltModes = {["Off"] = 1, ["Best"] = 2, ["Worst"] = 3, ["Random"] = 4}

local Bindables: Folder = ReplicatedStorage:WaitForChild("Bindables")
local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local Functions: Folder = ReplicatedStorage:WaitForChild("Functions")

local MoveAutominerEvent: RemoteEvent = Events:WaitForChild("MoveAutominer")
local AskForCFrameFunction: RemoteFunction = Functions:WaitForChild("AskForCFrame")

-- / / LOCAL FUNCTIONS

-- / / OBJECT FUNCTIONS

function _Autominer.new(Player: Player, Autominer: string)
    local self = setmetatable({}, _Autominer)
    self.Player = Player.Name
    self.Tower = workspace:WaitForChild("ActiveTowers"):WaitForChild(Player.Name)
    self.Autominer = Autominer.Name
    self.Mode = "Off"
    self.Model = Autominer
    self.DockPosition = self.Model.PrimaryPart.Position
    self.DockCFrame = self.Model.Primarypart.CFrame

    local SetBindable: BindableFunction = self.Model:WaitForChild("Set")
    SetBindable.OnInvoke = function()
        return self:ShiftModes()
    end

    coroutine.wrap(function()
        while Players:FindFirstChild(Player.Name) do
            local Mode = self.Mode

            if Mode == "Off" then
                self:Off()
            else
                self:Mine(Mode)
            end
        end
        return
    end)()

    return self
end

function _Autominer:Off()
    if self.Model.PrimaryPart.Position == self.DockPosition then -- If the miner is already docked, then we will just wait 1 second and see if there is a new command
        task.wait(1)
        return
    end

    local Time = (self.Model.PrimaryPart.Position - self.DockPosition).Magnitude / 2
    MoveAutominerEvent:FireAllClients(self.Player, self.Autominer, self.DockCFrame, Time)

    task.wait(Time)
    self.Model:MoveTo(self.DockPosition)

    return
end

function _Autominer:Mine(Mode: string)
    local Target = _Ores:GetAutominerTarget(Mode)
    if not Target then
        task.wait(1)
        return
    end

    local TargetCFrame, TargetPosition = AskForCFrameFunction:InvokeClient(Players:WaitForChild(self.Player), Target)
    local Time = (self.Model.PrimaryPart.Position - TargetPosition).Magnitude / 2

    MoveAutominerEvent:FireAllClients(self.Player, self.Autominer, TargetCFrame, Time)

    task.wait(Time)
    self.Model:MoveTo(self.TargetPosition)

    return
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