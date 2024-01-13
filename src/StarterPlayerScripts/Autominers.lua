-- / / Autominers, written by KingCreoo on 1/10/2024

-- / / DEFINE
local _Autominers = {}

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- / / MODULES

local _UI = require(script.Parent.UI)

-- / / VARIABLES

local LocalPlayer: Player = Players.LocalPlayer

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local MoveAutominerEvent: RemoteEvent = Events:WaitForChild("MoveAutominer")
local DisableAutominerEvent: RemoteEvent = Events:WaitForChild("DisableAutominer")
local AnimateAutominerEvent: RemoteEvent = Events:WaitForChild("AnimateAutominer")
local AutominerMineEvent: RemoteEvent = Events:WaitForChild("AutominerMine")

local Bindables: Folder = ReplicatedStorage:WaitForChild("Bindables")

local Functions: Folder = ReplicatedStorage:WaitForChild("Functions")
local GetOreInfoFunction: RemoteFunction = Functions:WaitForChild("GetOreInfo")

local RotationInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

-- / / LOCAL FUNCTIONS

local function FindOre(OreInfo: table) -- Function that finds the ore part (in workspace) with given info
    local Ore

    for _, _Ore in pairs(workspace:WaitForChild("ActiveOres"):GetChildren()) do
        if _Ore:GetAttribute("ID") == OreInfo["ID"] then
            Ore = _Ore
        end
    end

    return Ore
end

-- / / REMOTES

GetOreInfoFunction.OnClientInvoke = function(OreInfo: table) -- Server inquires about info on this ore
    local Ore: Part = FindOre(OreInfo)
    return Ore.Position, Ore.CFrame, Ore:GetAttribute("Set"), Ore:GetAttribute("Targeted") -- So we return the ores position in the workspace as well as if it's set in place or not.
end

MoveAutominerEvent.OnClientEvent:Connect(function(PlayerName: string, AutominerName: string, TargetPosition: Vector3, _, ActualTargetPosition: Vector2, TimeToMove: number, Target: table)
    if PlayerName == LocalPlayer.Name then
        local Ore: Part = FindOre(Target)
        Ore:SetAttribute("Targeted", 2)
        Ore.BrickColor = BrickColor.new("Really red")
    end

    local Autominer = workspace:WaitForChild("ActiveTowers"):FindFirstChild(PlayerName).Autominers:FindFirstChild(AutominerName)

    local FirstLookCFrame = CFrame.lookAt(Autominer.PrimaryPart.Position, ActualTargetPosition)
    local LookHere = Vector3.new(TargetPosition.X, 2, TargetPosition.Z)

    local Tween0 = TweenService:Create(Autominer.PrimaryPart, RotationInfo, {CFrame = FirstLookCFrame})
    Tween0:Play()

    local x, y, z = ActualTargetPosition.X, ActualTargetPosition.Y, ActualTargetPosition.Z
    local _, _, _, R00, R01, R02, R10, R11, R12, R20, R21, R22 = FirstLookCFrame:GetComponents()
    local TargetCFrame = CFrame.new(x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)

    Tween0.Completed:Connect(function()
        local Tween1 = TweenService:Create(Autominer.PrimaryPart, TweenInfo.new(TimeToMove, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = TargetCFrame})
        Tween1:Play()

        Tween1.Completed:Connect(function()
            local Tween2 = TweenService:Create(Autominer.PrimaryPart, RotationInfo, {CFrame = CFrame.lookAt(ActualTargetPosition, LookHere)})
            Tween2:Play()
        end)
    end)
end)

DisableAutominerEvent.OnClientEvent:Connect(function(PlayerName: string, AutominerName: string, TargetPosition: Vector3, TargetCFrame: CFrame, TimeToMove: number)
    local Autominer = workspace:WaitForChild("ActiveTowers"):FindFirstChild(PlayerName).Autominers:FindFirstChild(AutominerName)

    local x, y, z = TargetCFrame:GetComponents()
    local _, _, _, R00, R01, R02, R10, R11, R12, R20, R21, R22 = CFrame.lookAt(Autominer.PrimaryPart.Position, TargetPosition):GetComponents()

    local FirstTarget = CFrame.lookAt(Autominer.PrimaryPart.Position, TargetPosition)
    local SecondTarget = CFrame.new(x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
    local FinalTarget = TargetCFrame

    local Tween0 = TweenService:Create(Autominer.PrimaryPart, RotationInfo, {CFrame = FirstTarget})
    Tween0:Play()

    Tween0.Completed:Connect(function()
        local Tween1 = TweenService:Create(Autominer.PrimaryPart, TweenInfo.new(TimeToMove, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = SecondTarget})
        Tween1:Play()

        Tween1.Completed:Connect(function()
            local Tween3 = TweenService:Create(Autominer.PrimaryPart, RotationInfo, {CFrame = FinalTarget})
            Tween3:Play()
        end)
    end)
end)

AnimateAutominerEvent.OnClientEvent:Connect(function(PlayerName: string, Autominer: string, Time: number)
    --print(Autominer, Time)
end)

AutominerMineEvent.OnClientEvent:Connect(function(OreInfo: table)
    local Ore: Part = FindOre(OreInfo)
    _UI.BackpackAdd(OreInfo["Type"])

    Ore:Destroy()
end)

-- / / RETURN
return _Autominers