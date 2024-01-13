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
local AnimateAutominerEvent: RemoteEvent = Events:WaitForChild("AnimateAutominer")
local AutominerMineEvent: RemoteEvent = Events:WaitForChild("AutominerMine")
local DisableAutominerEvent: RemoteEvent = Events:WaitForChild("DisableAutominer")
local GetOreInfoFunction: RemoteFunction = Functions:WaitForChild("GetOreInfo")

-- / / LOCAL FUNCTIONS

local function GetPointOnCircle() -- Get a point on a circle with a given position
    local Angle = math.random(1, 360)

    local x = math.cos(Angle) * 5
	local z = math.sin(Angle) * 5

	return x, z
end

-- / / OBJECT FUNCTIONS

function _Autominer.new(Player: Player, Autominer)
    local self = setmetatable({}, _Autominer)
    self.Player = Player.Name
    self.Tower = workspace:WaitForChild("ActiveTowers"):WaitForChild(Player.Name)
    self.Autominer = Autominer.Name
    self.Mode = "Off"
    self.Model = Autominer
    self.DockPosition = self.Model.PrimaryPart.Position
    self.DockCFrame = self.Model.PrimaryPart.CFrame

    local SetBindable: BindableFunction = self.Model:WaitForChild("Set")
    SetBindable.OnInvoke = function()
        return self:ShiftModes()
    end

    coroutine.wrap(function()
        while Players:FindFirstChild(Player.Name) and _Data.Get(Player)["Autominers"][self.Autominer] == 1 do
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

    local Time = (self.Model.PrimaryPart.Position - self.DockPosition).Magnitude / 13
    DisableAutominerEvent:FireAllClients(self.Player, self.Autominer, self.DockPosition, self.DockCFrame, Time)

    task.wait(Time)
    self.Model:SetPrimaryPartCFrame(self.DockCFrame)

    return
end

function _Autominer:Mine(Mode: string)
    local Target, TargetPosition, TargetCFrame = _Ores.GetAutominerTarget(self.Player, Mode)
    if not Target then
        task.wait(1)
        return
    end

    local x, z = GetPointOnCircle()

    local ActualTargetPosition = Vector3.new(TargetPosition.X + x, 2, TargetPosition.Z + z)

    local TimeToMove = (self.Model.PrimaryPart.Position - ActualTargetPosition).Magnitude / 13
    MoveAutominerEvent:FireAllClients(self.Player, self.Autominer, TargetPosition, TargetCFrame, ActualTargetPosition, TimeToMove, Target)

    task.wait(TimeToMove + 2)
    self.Model:SetPrimaryPartCFrame(CFrame.lookAt(ActualTargetPosition, Vector3.new(TargetPosition.X, 2, TargetPosition.Z)))

    local TimeToMine = _Settings.Ores[Target["Type"]]["Health"] / (_Settings.Pickaxes["Level1"]["Speed"] / 3)
    AnimateAutominerEvent:FireAllClients(self.Player, self.Autominer, TimeToMine)

    task.wait(TimeToMine)

    local PlayerData = _Data.Get(Players:WaitForChild(self.Player))
    PlayerData["Backpack"][Target["Type"]] += 1
    _Data.Set(Players:WaitForChild(self.Player), PlayerData)

    AutominerMineEvent:FireClient(Players:WaitForChild(self.Player), Target)

    local success = _Ores.RemoveOre(Players:WaitForChild(self.Player), Target["ID"]) -- Remove ore from player's database
    if not success then
        warn("ore does not exist in player's database")
    end

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