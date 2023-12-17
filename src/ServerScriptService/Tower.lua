-- / / Tower Module, created by KingCreoo on 12/12/23

-- / / DEFINE
local Tower = {}
Tower.__index = Tower

-- / / SERVICES

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))
local _Data = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Data"))

-- / / FUNCTIONS

function Tower.New(Player)
    local self = setmetatable({}, Tower)
    self.Owner = Player

    return self
end

function Tower:Add(Player) -- Create player's tower and assign location.
    -- Eventually: load player's saved tower.

    self.Model = ReplicatedStorage:WaitForChild("TowerTemplate"):Clone()
    self.Model.Name = Player.Name
    self.Model.Parent = workspace:WaitForChild("ActiveTowers")

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

function Tower:Load(Player, PlayerData: table)
    for DropperName, Owned in pairs(PlayerData["Droppers"]) do
        if Owned == 1 then
            local Dropper = self.Model:WaitForChild("Droppers"):WaitForChild(DropperName) -- Make all owned droppers visible
            for _, Part: Part in pairs(Dropper:WaitForChild("Build"):GetChildren()) do
                Part.Transparency = Part:GetAttribute("Transparency")
                Part.Color = Part:GetAttribute("Color")
            end

            local Button = self.Model:WaitForChild("Buttons"):WaitForChild(DropperName) -- And then clear all buttons of owned droppers.
            Button:Destroy()
        end
    end

    self:Listen(Player)
end

function Tower:Listen(Player)
    for _, Button in pairs(self.Model:WaitForChild("Buttons"):GetChildren()) do
        local debounce = false

        Button:WaitForChild("Touch").Touched:Connect(function(touched)
            if touched.Parent.Name == Player.Name and touched.Parent:FindFirstChild("Humanoid") and not debounce then
                debounce = true
                local PlayerData = _Data.Get(Player)

                if PlayerData["leaderstats"]["Cash"] >= _Settings.Droppers[Button.Name]["Value"] then -- Player has stepped on button and can purchase dropper
                    PlayerData["leaderstats"]["Cash"] -= _Settings.Droppers[Button.Name]["Value"]
                    PlayerData["Droppers"][Button.Name] = 1

                    _Data.Set(Player, PlayerData)

                    for _, Part: Part in pairs(self.Model:WaitForChild("Droppers"):WaitForChild(Button.Name):WaitForChild("Build"):GetChildren()) do
                        Part.Transparency = Part:GetAttribute("Transparency")
                        Part.Color = Part:GetAttribute("Color")
                    end

                    Button:Destroy()
                else -- Player has stepped on button but does not have the cash to purchase dropper
                    warn(Player.Name " does not have enough cash to buy this dropper. Prompt them with $$$")

                    task.wait(1)
                    debounce = false
                end
            end
        end)
    end
end

function Tower:Remove() -- Remove player's tower and mark location as vacant.
    self.Model:Destroy()
    _Settings.Locations[self.Location]["Occupied"] = false
end

-- / / RETURN
return Tower