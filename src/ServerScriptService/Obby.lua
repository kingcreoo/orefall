-- Obby written by KingCreoo on 1/19/24

-- / / DEFINE
local _Obby = {}

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- / / MODULES

local _Data = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Data"))
local _Boosts = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Boosts"))
local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))

-- / / VARIABLES

local Events = ReplicatedStorage:WaitForChild("Events")
local StageProgressEvent: RemoteEvent = Events:WaitForChild("StageProgress")

local ObbiesFolder = workspace:WaitForChild("Obbies")
local ActiveObbies = {}

local ObbyAssets = ReplicatedStorage:WaitForChild("Obby")
local Locations = ObbyAssets:WaitForChild("Locations")
local Stages = ObbyAssets:WaitForChild("Stages")
local Checkpoint = ObbyAssets:WaitForChild("Checkpoint")
local Startpoint = ObbyAssets:WaitForChild("Startpoint")
local Endpoint = ObbyAssets:WaitForChild("Endpoint")
local Bottom = ObbyAssets:WaitForChild("Bottom")

local StagesTable = {}
for _, v in pairs(Stages:GetChildren()) do
    table.insert(StagesTable, v)
end

-- / / LOCAL FUNCTIONS

local function SelectLocation()
    for _, Location in pairs(Locations:GetChildren()) do
        if Location:GetAttribute("Occupied") == true then
            continue
        else
            Location:SetAttribute("Occupied", true)
            return Location
        end
    end
end

local function Generate(Player: Player, Location: Part)

    local Folder = Instance.new("Folder")
    Folder.Name = Player.Name
    Folder.Parent = ObbiesFolder

    local StageFoler = Instance.new("Folder")
    StageFoler.Name = "Stages"
    StageFoler.Parent = Folder

    local CheckpointFolder = Instance.new("Folder")
    CheckpointFolder.Name = "Checkpoints"
    CheckpointFolder.Parent = Folder

    local KillParts = {}

    local start_point = Startpoint:Clone()
    start_point.Position = Location.Position
    start_point.Parent = Folder

    local bottom = Bottom:Clone()
    bottom:SetPrimaryPartCFrame(start_point.CFrame)
    bottom.Parent = Folder

    table.insert(KillParts, bottom:WaitForChild("Kill"))

    for i = 1, 10 do
        local Stage = StagesTable[math.random(1, #StagesTable)]:Clone()
        Stage.Name = tostring(i)

        local TargetCFrame
        if i == 1 then
            TargetCFrame = start_point.CFrame
        else
            TargetCFrame = CheckpointFolder:FindFirstChild(tostring(i - 1)).PrimaryPart.CFrame
        end

        Stage:SetPrimaryPartCFrame(TargetCFrame)
        Stage.Parent = Folder

        for _, Part in pairs(Stage:GetChildren()) do
            if Part.Name == "Kill" then
                table.insert(KillParts, Part)
            end
        end

        if i == 10 then
            local endpoint = Endpoint:Clone()
            endpoint:SetPrimaryPartCFrame(Stage:WaitForChild("Anchor1").CFrame)
            endpoint.Parent = Folder

            break
        end

        local checkpoint = Checkpoint:Clone()
        checkpoint.Name = tostring(i)
        checkpoint:SetPrimaryPartCFrame(Stage:WaitForChild("Anchor1").CFrame)
        checkpoint.Parent = CheckpointFolder
    end

    local Character = Player.Character or Player.CharacterAdded:Wait()
    Character:SetPrimaryPartCFrame(start_point.CFrame + Vector3.new(0, 4, 0))

    StageProgressEvent:FireClient(Player, 1)

    return Folder, KillParts, Character
end

-- / / MODULE FUNCTIONS

function _Obby.Add(Player: Player)
    local Location: Part = SelectLocation()
    local Folder, KillParts, Character = Generate(Player, Location)
    local RespawnPoint = Folder:WaitForChild("Startpoint")
    local Progress = 0

    for _, Part: Part in pairs(KillParts) do
        Part.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChildOfClass("Humanoid") then
                Character:SetPrimaryPartCFrame(RespawnPoint.CFrame + Vector3.new(0,4,0))
            end
        end)
    end

    for _, checkpoint in pairs(Folder:WaitForChild("Checkpoints"):GetChildren()) do
        checkpoint:WaitForChild("Color").Touched:Connect(function()
            if tonumber(checkpoint.Name) <= Progress then return end

            RespawnPoint = checkpoint:WaitForChild("Color")
            checkpoint:WaitForChild("Color").BrickColor = checkpoint:WaitForChild("Color"):GetAttribute("Complete")
            Progress = tonumber(checkpoint.Name)

            StageProgressEvent:FireClient(Player, 2, Progress)
        end)
    end

    local claimed_reward = false

    for _, Reward in pairs(Folder:WaitForChild("Endpoint"):GetChildren()) do
        if not Reward:IsA("Model") then
            continue
        end

        Reward:WaitForChild("Touch").Touched:Connect(function(hit)
            if not hit.Parent:FindFirstChildOfClass("Humanoid") or not hit.Parent.Name == Player.Name or claimed_reward then
                return
            end

            claimed_reward = true

            StageProgressEvent:FireClient(Player, 3)
            _Boosts.Give(Player, Reward.Name, 2, 120)
            _Obby.Remove(Player)
        end)
    end
end

function _Obby.Remove(Player: Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    Character:SetPrimaryPartCFrame(workspace:WaitForChild("ActiveTowers"):WaitForChild(Player.Name):WaitForChild("Teleport").CFrame)

    ObbiesFolder:WaitForChild(Player.Name):Destroy()
end

-- / / REMOTES

StageProgressEvent.OnServerEvent:Connect(function(Player: Player)
    _Obby.Remove(Player)
end)

-- / / RETURN
return _Obby