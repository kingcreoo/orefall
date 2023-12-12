local Players = game:GetService("Players")
local LocalPlayer: Player = Players.LocalPlayer
local LocalGui: PlayerGui = LocalPlayer.PlayerGui
local LoadingScreen: ScreenGui = LocalGui:WaitForChild("Load")
LoadingScreen.Enabled = true -- Enable the loading screen, making it visible for the player.

local ReplicatedFirst = game:GetService("ReplicatedFirst")
ReplicatedFirst:RemoveDefaultLoadingScreen() -- Removes default loading screen.
-- This allows for us to implement a custom loading screen.