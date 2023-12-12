-- / / Client, created by KingCreoo on 12/11/23

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TweenService = game:GetService("TweenService")

-- / / MODULES

-- / / VARIABLES

local LocalPlayer: Player = Players.LocalPlayer
local LocalGui: PlayerGui = LocalPlayer.PlayerGui
local LoadingScreen: ScreenGui = LocalGui:WaitForChild("Load")

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local LoadEvent: RemoteEvent = Events:WaitForChild("Load")

local LoadingScreenInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)

-- / / FUNCTIONS

local function PlayerLoaded() -- Player has been fully loaded. End load screen.
    print(LocalPlayer.Name .. " has been loaded.")

    task.wait(2) -- For now. To make the player feel as if their is an actual load time.
    -- When the game has actual stuff to load, we will remove this.

    local LastTween
    for _, Item in pairs(LoadingScreen:GetChildren()) do
        local Tween = TweenService:Create(Item, LoadingScreenInfo, {Transparency = 1})
        Tween:Play()

        LastTween = Tween
    end

    LastTween.Completed:Connect(function()
        LoadingScreen.Enabled = false
        task.wait(1)
        LoadingScreen:Destroy()
    end)
end

-- / / REMOTES

LoadEvent.OnClientEvent:Connect(PlayerLoaded)

-- / / EVENTS

-- / / ON PLAYERADDED

LoadingScreen.Enabled = true