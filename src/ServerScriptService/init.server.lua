-- / / Server, created by KingCreoo on 12/11/23

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- / / MODULES

local _Settings = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Settings"))
local _Tower = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Tower"))

-- / / VARIABLES

local Towers = {}

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local LoadEvent: RemoteEvent = Events:WaitForChild("Load")

-- / / FUNCTIONS

local function LoadPlayer(Player: Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    Character:SetPrimaryPartCFrame(workspace:WaitForChild("Limbo").CFrame + Vector3.new(0,5,0)) -- Teleport player to limbo

    local PlayerTower = _Tower.New(Player)
    PlayerTower:Add() -- Create a tower for the player and assign a vacant(now occupied) location.
    Towers[Player.Name] = PlayerTower

    Character:SetPrimaryPartCFrame(PlayerTower.Model:WaitForChild("Teleport").CFrame) -- Teleport the player to the tower's location.

    LoadEvent:FireClient(Player) -- Communicate to the client that player has been loaded.
end

local function RemovePlayer(Player: Player)
    local PlayerTower = Towers[Player.Name]
    PlayerTower:Remove() -- Remove the player's tower from the workspace and mark it's location as vacant.
end

-- / / REMOTES

-- / / EVENTS

Players.PlayerAdded:Connect(LoadPlayer)
Players.PlayerRemoving:Connect(RemovePlayer)