-- / / _Pickaxe, created by KingCreoo on 12/13/23

-- / / DEFINE
local _Pickaxe = {}
_Pickaxe.__index = _Pickaxe

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))
local _UI = require(script.Parent.UI)

-- / / VARIABLES

local ActivationTicks = {}

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

function _Pickaxe.New()
    local self = setmetatable({}, _Pickaxe)

    self.Active = false
    self.Equipped = false

    self.Target = nil
    self.TargetTick = 0
    self.Highlight = nil
    self.Connection = nil

    self.Tool = LocalPlayer:WaitForChild("Backpack"):WaitForChild("Pickaxe")
    self.Listen = self:Listen()

    self.Connections = {}

    return self
end

function _Pickaxe:Set(Type: string)
    self.Type = Type
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

    if not Target then 
        self:Highlight() 
        return 
    end

    if not Target.Parent then 
        self:Highlight() 
        return 
    end

    if Target.Parent ~= ActiveOres then 
        self:Highlight() 
        return 
    end

    if self.Equipped == false then 
        self:Highlight() 
        return 
    end

    self:Highlight(Target)
end

function _Pickaxe:FirstTarget()
    local Target = Mouse.Target

    if not Target then return end
    if not Target.Parent then return end
    if Target.Parent ~= ActiveOres then return end

    if Target:GetAttribute("Strength") > _Settings.Pickaxes[self.Type]["Strength"] then
        warn("Your pickaxe is too weak!")
        self.Tool:Deactivate()
        LocalPlayer.Character.Humanoid:UnequipTools()
        return 1
    end

    if Target:GetAttribute("Targeted") > 1 then
        warn("Ore is being mined by an autominer!")
        self.Tool:Deactivate()
        LocalPlayer.Character.Humanoid:UnequipTools()
        return 1
    end

    self.Target = Target
    Highlight.Adornee = Target
    self.TargetTick += 1

    return Target
end

function _Pickaxe:Highlight(Target: Part)
    if not Target then
        if Highlight.Adornee == Limbo then return end
        Highlight.Adornee = Limbo
        return
    end

    Highlight.Adornee = Target
end

function _Pickaxe:Activate()
    local Tick = workspace:GetServerTimeNow()
    ActivationTicks[Tick] = true

    ActivateFunction:InvokeServer() -- Tell the server that we are activating this pickaxe

    local Strength = _Settings.Pickaxes[self.Type]["Strength"]
    local Damage = _Settings.Pickaxes[self.Type]["Speed"] * (LocalPlayer:GetAttribute("MineSpeed") + _Settings.GlobalBoosts["MineSpeed"]) / 10

    self.Active = true
    local t = self:FirstTarget()
    if t == 1 then return end
    --self.Target = t

    self.Connection = Mouse.Move:Connect(function()
        local MouseTarget = Mouse.Target

        if not MouseTarget or not MouseTarget.Parent or MouseTarget.Parent ~= ActiveOres then
            self.Target = nil
            return
        elseif self.Target == MouseTarget then
            return
        end

        if MouseTarget:GetAttribute("Strength") > Strength then
            warn("Your pickaxe is too weak!")
            self.Tool:Deactivate()
            LocalPlayer.Character.Humanoid:UnequipTools()
            return
        end

        if MouseTarget:GetAttribute("Targeted") > 1 then
            warn("Ore is being mined by an autominer!")
            self.Tool:Deactivate()
            LocalPlayer.Character.Humanoid:UnequipTools()
            return
        end

        self.Target = MouseTarget
        self.TargetTick += 1
    end)

    coroutine.wrap(function()
        while self.Active == true do
            local Target = self.Target
            local TargetTick = self.TargetTick
            task.wait(.1)

            if not Target or not self.Target or self.Target ~= Target or self.TargetTick ~= TargetTick or not ActivationTicks[Tick] or self.Active == false then continue end

            local Health = Target:GetAttribute("Health")
            if Health - Damage <= 0 then
                local Success = ValidateFunction:InvokeServer(Target:GetAttribute("ID"))
                if Success == true then
                    Target:Destroy()

                    _UI.BackpackAdd(Target.Name)

                    self.Target = nil
                    self.TargetTick = 0

                    self:FirstTarget()
                --else
                    --Drop gui here
                end
            else
                if Target:GetAttribute("Targeted") == 0 then
                    Target:SetAttribute("Targeted", 1)
                end
                Target:SetAttribute("Health", Health - Damage)
            end
        end
    end)()
end

function _Pickaxe:Deactivate()
    self.Active = false
    table.clear(ActivationTicks)

    if self.Connection then
        self.Connection:Disconnect() 
    end
    self.Connection = nil
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