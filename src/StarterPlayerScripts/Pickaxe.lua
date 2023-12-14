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

local Limbo: Part = workspace:WaitForChild("Limbo")
local Highlight: Highlight = workspace:WaitForChild("Highlight")
local ActiveOres: Folder = workspace:WaitForChild("ActiveOres")

local Events = ReplicatedStorage:WaitForChild("Events")
local Functions = ReplicatedStorage:WaitForChild("Functions")

local ActivateFunction: RemoteFunction = Functions:WaitForChild("Activate")
local ValidateFunction: RemoteFunction = Functions:WaitForChild("Validate")

-- / / FUNCTIONS

function _Pickaxe.New(Type: string)
    local self = setmetatable({}, _Pickaxe)
    self.Type = Type

    self.Active = false
    self.Equipped = false

    self.Target = nil
    self.Highlight = nil

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

    Mouse.Move:Connect(function()
        self:Move()
    end)
end

function _Pickaxe:Move()
    local Target = Mouse.Target

    if not Target then return end

    if not Target.Parent then return end

    if Target.Parent ~= ActiveOres then return end

    if self.Equipped == false then return end

    self:Highlight(Target)
end

function _Pickaxe:Highlight(Target: Part)
    if not Target then
        Highlight.Adornee = Limbo
        return
    end

    Highlight.Adornee = Target
end

function _Pickaxe:Activate()

end

function _Pickaxe:Deactivate()

end

function _Pickaxe:Equip()
    --local Humanoid: Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")

    if self.Equipped == true then -- dequip
        self.Equipped = false

        self:Highlight(nil)

        --Humanoid:EquipTool(self.Tool) -- For when we create custom pickaxe GUI
    elseif self.Equipped == false then -- equip
        self.Equipped = true

        --Humanoid:UnequipTools() -- For when we create custom pickaxe GUI
    end
end

function _Pickaxe:Destroy()
    self = nil
end

return _Pickaxe