-- / / Tower Module, created by KingCreoo on 12/12/23

-- / / DEFINE
local Tower = {}
Tower.__index = Tower

-- / / SERVICES

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- / / VARIABLES

local _Settings = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Settings"))

-- / / FUNCTIONS

function Tower.New(Player)
    local self = setmetatable({}, Tower)
    self.Owner = Player

    return self
end

function Tower:Add() -- Create player's tower and assign location.
    -- Eventually: load player's saved tower.

    self.Model = ReplicatedStorage:WaitForChild("TowerTemplate"):Clone()

    local SelectedLocation
    for Number, Info in pairs(_Settings.Locations) do -- Select a vacant location
        if Info["Occupied"] then continue end
        SelectedLocation = Number
        break
    end

    _Settings.Locations[SelectedLocation]["Occupied"] = true -- Mark selected location as occupied.
    self.Location = SelectedLocation
    self.Model:SetPrimaryPartCFrame(_Settings.Locations[SelectedLocation]["CFrame"])
end

function Tower:Remove() -- Remove player's tower and mark location as vacant.
    self.Model:Destroy()
    _Settings.Locations[self.Location]["Occupied"] = false
end

-- / / RETURN
return Tower