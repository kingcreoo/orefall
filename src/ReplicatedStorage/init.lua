-- / / ALL OF THESE VARIABLES SHOULD NOT BE CHANGED MID-GAME.

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
    ["Pickaxe"] = "Level1",
    ["Version"] = Settings.Version
}

Settings.Ores = {
    ["Coal"] = {
        ["Name"] = "Coal",
        ["Model"] = ReplicatedStorage:WaitForChild("Ores"):WaitForChild("Coal"),
        ["Value"] = 1, -- How many coins will be rewarded
        ["Rarity"] = 1, -- Once every (rarity) this ore will be dropped
        ["Strength"] = 1, -- What level pickaxe is required to mine this ore
        ["Health"] = 1 -- How long it will take to mine this ore (1 health Ore + 1 speed Pickaxe = 1 second break time) in units of 0.1 ONLY
    },
    ["Iron"] = {
        ["Name"] = "Iron",
        ["Model"] = ReplicatedStorage:WaitForChild("Ores"):WaitForChild("Iron"),
        ["Value"] = 3,
        ["Rarity"] = 3,
        ["Strength"] = 2,
        ["Health"] = 1.5
    }
}

Settings.OreOrder = {"Iron", "Coal"} -- This order must be in most rare to least rare. This is because of how my random selections are done.

Settings.Pickaxes = {
    ["Level1"] = {
        ["Name"] = "Level1",
        ["Model"] = ReplicatedStorage:WaitForChild("Pickaxes"):WaitForChild("Level1"),
        ["Strength"] = 1, -- What level ore this pickaxe can mine
        ["Speed"] = 1, -- How fast this pickaxe will mine (1 health Ore + 1 speed Pickaxe = 1 second break time) in units of 0.1 ONLY
        ["Price"] = 0
    },
    ["Level2"] = {
        ["Name"] = "Level2",
        ["Model"] = ReplicatedStorage:WaitForChild("Pickaxes"):WaitForChild("Level2"),
        ["Strength"] = 2,
        ["Speed"] = 2,
        ["Price"] = 100
    }
}

return Settings