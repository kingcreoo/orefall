-- / / Server, created by KingCreoo on 12/11/23

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- / / MODULES

local _Settings = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Settings"))

-- / / VARIABLES

local Events: Folder = ReplicatedStorage:WaitForChild("Events")

local LoadEvent: RemoteEvent = Events:WaitForChild("Load")

-- / / FUNCTIONS

local function LoadPlayer(Player: Player)

    LoadEvent:FireClient(Player) -- Communicate to the client that player has been loaded.
end

-- / / REMOTES

-- / / EVENTS

Players.PlayerAdded:Connect(LoadPlayer)