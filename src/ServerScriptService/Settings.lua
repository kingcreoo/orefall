local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Settings = {}

Settings.Version = "0.0.1"

Settings.Locations = {
    [1] = {["CFrame"] = CFrame.new(40,0,0), ["Occupied"] = false},
    [2] = {["CFrame"] = CFrame.new(-40,0,0), ["Occupied"] = false},
}

Settings.DefaultData = { -- In the future we will have to write a system that creates default data based off of the game's files.
    ["leaderstats"] = {
        ["Cash"] = 100
    },
    ["Version"] = Settings.Version
}

Settings.Ores = {
    ["Coal"] = {
        ["Name"] = "Coal",
        ["Model"] = ReplicatedStorage:WaitForChild("Ores"):WaitForChild("Coal"),
        ["Value"] = 1, -- How many coins will be rewarded
        ["Rarity"] = 1, -- Once every (rarity) this ore will be dropped
        ["Strength"] = 1 -- How many seconds it will take to mine on default pickaxe
    },
    ["Iron"] = {
        ["Name"] = "Iron",
        ["Model"] = ReplicatedStorage:WaitForChild("Ores"):WaitForChild("Iron"),
        ["Value"] = 3,
        ["Rarity"] = 3,
        ["Strength"] = 1.5
    }
}

Settings.OreOrder = {"Iron", "Coal"} -- This order must be in most rare to least rare. This is because of how my random selections are done.

return Settings