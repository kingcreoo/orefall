-- _Button, created by KingCreoo on 12/17/23

-- / / DEFINE
local _Button = {}
_Button.__index = _Button

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))

-- / / VARIABLES

local LocalPlayer = Players.LocalPlayer
local leaderstats = LocalPlayer:WaitForChild("leaderstats")
local Cash = leaderstats:WaitForChild("Cash")

local Red = Color3.fromRGB(255,89,89)
local Green = Color3.fromRGB(117, 255, 89)

local Info = TweenInfo.new(.2, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

-- / / LOCAL FUNCTIONS

local function DeepCopy(Table)
    local Copy = {}

    for k, v in pairs(Table) do
        if type(v) == table then
            DeepCopy(v)
        else
            Copy[k] = v
        end
    end

    return Copy
end

-- / / MODULE FUNCTIONS

function _Button.new(Button: Model)
    local self = setmetatable({}, _Button)
    self.Model = Button
    self.Settings = DeepCopy(_Settings.Droppers[Button.Name])

    self:Load()

    Cash.Changed:Connect(function()
        if not self then return end

        self:Load()
    end)

    self.Model.Touch.Prompt.PromptShown:Connect(function()
        self:ShowInfo()
    end)

    self.Model.Touch.Prompt.PromptHidden:Connect(function()
        if not self then return end

        self:CloseInfo()
    end)

    self.Model.Destroying:Connect(function()
        self = nil
    end)

    return self
end

function _Button:Load()
    if not self then return end
    
    if Cash.Value >= self.Settings["Value"] then
        self.Model.Color.Color = Green
        self.Model.Touch.BillboardGui.Cash.TextColor3 = Green
    else
        self.Model.Color.Color = Red
        self.Model.Touch.BillboardGui.Cash.TextColor3 = Red
    end
end

function _Button:ShowInfo()
    local Tween0 = self.Model.Touch:FindFirstChild("Tween")
    if Tween0 then
        Tween0:Destroy()
    end

    self.Model.Touch.BillboardGui.Enabled = true
    self.Model.Touch.BillboardGui.Size = UDim2.new(0,0,0,0)

    local Tween = TweenService:Create(self.Model.Touch.BillboardGui, Info, {Size = UDim2.new(10,0,6,0)})
    Tween.Parent = self.Model.Touch
    Tween:Play()
end

function _Button:CloseInfo()
    local Tween = TweenService:Create(self.Model.Touch.BillboardGui, Info, {Size = UDim2.new(0,0,0,0)})
    Tween.Parent = self.Model.Touch
    Tween:Play()

    Tween.Completed:Connect(function()
        self.Model.Touch.BillboardGui.Enabled = false
    end)
end

-- / / RETURN
return _Button