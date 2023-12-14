-- / / _Pickaxe, created by KingCreoo on 12/13/23

-- / / DEFINE
local _Pickaxe = {}
_Pickaxe.__index = _Pickaxe

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))

-- / / VARIABLES

local LocalPlayer: Player = Players.LocalPlayer
local Mouse: Mouse = LocalPlayer:GetMouse()

local Events = ReplicatedStorage:WaitForChild("Events")
local Functions = ReplicatedStorage:WaitForChild("Functions")

local EquipEvent: RemoteEvent = Events:WaitForChild("Equip")
local ActivateFunction: RemoteFunction = Functions:WaitForChild("Activate")
local ValidateFunction: RemoteFunction = Functions:WaitForChild("Validate")

-- / / FUNCTIONS

function _Pickaxe.New(Type: string)
    local self = setmetatable({}, _Pickaxe)
    self.Type = Type

    self.Active = false
    self.Equipped = false
    self.Target = nil

    self.Tool = LocalPlayer:WaitForChild("Backpack"):WaitForChild("Pickaxe")
    self.Listen = self:Listen()

    self.Connections = {}

    return self
end

function _Pickaxe:Listen()
    self.Tool.Equipped:Connect(function()
        self:Equip()
    end)

    self.Tool.Unequipped:Connect(function()
        self:Equip()
    end)

    self.Tool.Activated:Connect(function()
        self:Activate()
    end)

    self.Tool.Deactivated:Connect(function()
        self:Deactivate()
    end)
end

function _Pickaxe:Move()
    if self.Equipped == false then
        return
    end

    if self.Target == nil then
        return
    end
end

function _Pickaxe:Activate()
    print('Activated')
end

function _Pickaxe:Deactivate()
    print('Deactivated')
end

function _Pickaxe:Equip()
    --local Humanoid: Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")

    if self.Equipped == true then
        self.Equipped = false

        print('Dequipped')

        --Humanoid:EquipTool(self.Tool) -- For when we create custom pickaxe GUI
    elseif self.Equipped == false then
        self.Equipped = true

        print('Equipped')

        --Humanoid:UnequipTools() -- For when we create custom pickaxe GUI
    end
end

function _Pickaxe:Destroy()
    self = nil
end

return _Pickaxe