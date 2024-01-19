-- / / ALL OF THESE VARIABLES SHOULD NOT BE CHANGED MID-GAME.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Settings = {}

Settings.Version = "0.6"

Settings.Locations = {
    [1] = {["CFrame"] = CFrame.new(40,0,0), ["Occupied"] = false},
    [2] = {["CFrame"] = CFrame.new(-40,0,0), ["Occupied"] = false},
}

Settings.DefaultData = { -- In the future we will have to write a system that creates default data based off of the game's files.
    ["leaderstats"] = {
        ["Cash"] = 100,
        ["Rebirths"] = 0
    },
    ["Pickaxe"] = "Level1",
    ["Pickaxes"] = {
        ["Level1"] = 1,
        ["Level2"] = 0
    },
    ["Autominers"] = {
        ["Autominer1"] = 0,
        ["Autominer2"] = 0,
        ["Autominer3"] = 0
    },
    ["Droppers"] = {
        ["Dropper1"] = 0,
        ["Dropper2"] = 0,
        ["Dropper3"] = 0
    },
    ["Backpack"] = {
        ["Coal"] = 0,
        ["Iron"] = 0,
        ["Gold"] = 0,
        ["Diamond"] = 0,
        ["Emerald"] = 0,
        ["Ruby"] = 0,
    },
    ["Boosts"] = {},
    ["RebirthBoosts"] = {
        ["XP"] = 1.00,
        ["Money"] = 1.00,
        ["Refinery"] = 1.00,
        ["Luck"] = 1.00
    },
    ["Version"] = Settings.Version,
    ["LeaveTime"] = nil
}

Settings.Ores = {
    ["Coal"] = {
        ["Name"] = "Coal",
        ["Model"] = ReplicatedStorage:WaitForChild("Ores"):WaitForChild("Coal"),
        ["Rarity"] = 1, -- Once every (rarity) this ore will be dropped
        ["Strength"] = 1, -- What level pickaxe is required to mine this ore
        ["Health"] = 1, -- How long it will take to mine this ore (1 health Ore + 1 speed Pickaxe = 1 second break time)
        ["Reward"] = 3, -- Reward in coins
        ["RewardInstant"] = 1, -- Reward in coins for instant sell
        ["RefineTime"] = 1 -- Refine time in seconds
    },
    ["Iron"] = {
        ["Name"] = "Iron",
        ["Model"] = ReplicatedStorage:WaitForChild("Ores"):WaitForChild("Iron"),
        ["Rarity"] = 3,
        ["Strength"] = 1,
        ["Health"] = 1.5,
        ["Reward"] = 8,
        ["RewardInstant"] = 3,
        ["RefineTime"] = 2
    },
    ["Gold"] = {
        ["Name"] = "Gold",
        ["Model"] = ReplicatedStorage:WaitForChild("Ores"):WaitForChild("Gold"),
        ["Rarity"] = 8,
        ["Strength"] = 1,
        ["Health"] = 3,
        ["Reward"] = 15,
        ["RewardInstant"] = 8,
        ["RefineTime"] = 3
    },
    ["Diamond"] = {
        ["Name"] = "Diamond",
        ["Model"] = ReplicatedStorage:WaitForChild("Ores"):WaitForChild("Diamond"),
        ["Rarity"] = 21,
        ["Strength"] = 2,
        ["Health"] = 5,
        ["Reward"] = 28,
        ["RewardInstant"] = 16,
        ["RefineTime"] = 6
    },
    ["Emerald"] = {
        ["Name"] = "Emerald",
        ["Model"] = ReplicatedStorage:WaitForChild("Ores"):WaitForChild("Gold"),
        ["Rarity"] = 64,
        ["Strength"] = 2,
        ["Health"] = 8,
        ["Reward"] = 72,
        ["RewardInstant"] = 32,
        ["RefineTime"] = 8
    },
    ["Ruby"] = {
        ["Name"] = "Ruby",
        ["Model"] = ReplicatedStorage:WaitForChild("Ores"):WaitForChild("Gold"),
        ["Rarity"] = 128,
        ["Strength"] = 2,
        ["Health"] = 12,
        ["Reward"] = 112,
        ["RewardInstant"] = 64,
        ["RefineTime"] = 12
    },
}

Settings.OreOrder = {"Ruby", "Emerald", "Diamond", "Gold", "Iron", "Coal"} -- This order must be in most rare to least rare. This is because of how my random selections are done.
Settings.OreOrderKeys = {["Ruby"] = 6, ["Emerald"] = 5, ["Diamond"] = 4, ["Gold"] = 3, ["Iron"] = 2, ["Coal"] = 1}

Settings.Pickaxes = {
    ["Level1"] = {
        ["Name"] = "Level1",
        ["Model"] = ReplicatedStorage:WaitForChild("Pickaxes"):WaitForChild("Level1"),
        ["Strength"] = 1, -- What level ore this pickaxe can mine
        ["Speed"] = 1, -- How fast this pickaxe will mine (1 health Ore + 1 speed Pickaxe = 1 second break time)
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

Settings.Droppers = {
    ["Dropper1"] = {
        ["Name"] = "Dropper1",
        ["Value"] = 0,
        ["Luck"] = 1
    },
    ["Dropper2"] = {
        ["Name"] = "Dropper2",
        ["Value"] = 100,
        ["Luck"] = 1
    },
    ["Dropper3"] = {
        ["Name"] = "Dropper3",
        ["Value"] = 250,
        ["Luck"] = 2
    }
}

Settings.Autominers = {
    ["Autominer1"] = {
        ["Name"] = "Autominer1",
        ["Value"] = 100
    },
    ["Autominer2"] = {
        ["Name"] = "Autominer2",
        ["Value"] = 200
    },
    ["Autominer3"] = {
        ["Name"] = "Autominer3",
        ["Value"] = 300
    }
}

return Settings