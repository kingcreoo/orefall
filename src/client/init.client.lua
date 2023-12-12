-- / / Client, created by KingCreoo on 12/11/23

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- / / MODULES

-- / / VARIABLES

local LocalPlayer: Player = Players.LocalPlayer
local Events: Folder = ReplicatedStorage:WaitForChild("Events")

local LoadEvent: RemoteEvent = Events:WaitForChild("Load")

-- / / FUNCTIONS

local function PlayerLoaded() -- Player has been fully loaded. End load screen.
    print(LocalPlayer.Name .. " has been loaded.")
end

-- / / REMOTES

LoadEvent.OnClientEvent:Connect(PlayerLoaded)

-- / / EVENTS