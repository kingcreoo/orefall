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

return Settings