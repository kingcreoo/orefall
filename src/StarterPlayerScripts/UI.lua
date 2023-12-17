-- / / UI, created by KingCreoo on 12/16/23

-- / / DEFINE
local _UI = {}

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))

-- / / VARIABLES

local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local InteractsGui = PlayerGui:WaitForChild("Interacts")
local HUDGui = PlayerGui:WaitForChild("HUD")

local PickaxesFrame = InteractsGui:WaitForChild("Pickaxes")
local EquippedPickaxe = PickaxesFrame:WaitForChild("Equipped")

local BackpackFrame: Frame = HUDGui:WaitForChild("Backpack")
local OresIndex = BackpackFrame:WaitForChild("Index")

local Functions = ReplicatedStorage:WaitForChild("Functions")
local Events = ReplicatedStorage:WaitForChild("Events")

local RefineEvent: RemoteEvent = Events:WaitForChild("Refine")
local InstantEvent: RemoteEvent = Events:WaitForChild("Instant")

local EquipFunction: RemoteFunction = Functions:WaitForChild("Equip")
local PurchaseFunction: RemoteFunction = Functions:WaitForChild("Purchase")

local Green = Color3.fromRGB(85, 170, 0)
local Red = Color3.fromRGB(255, 73, 73)

-- / / BACKPACK

function _UI.BackpackAdd(Ore: string)
    local OreLabel: TextLabel = OresIndex:WaitForChild(Ore)

    if OreLabel.Visible == false then
        OreLabel.Visible = true

        OreLabel.Text = OreLabel:GetAttribute("Text") .. "1"
    elseif OreLabel.Visible == true then
        local String = string.split(OreLabel.Text, ": ")
        local Name = String[1]
        local Amount = String[2]

        OreLabel.Text = Name .. tostring(tonumber(Amount) + 1)
    end
end

function _UI.BackpackClear()
    for _, Index in pairs(OresIndex) do
        local OreLabel = Index.Value

        OreLabel.Visible = false
    end
end

-- / / PICKAXES

local function Equip(Pickaxe: TextButton)
    local success = EquipFunction:InvokeServer(Pickaxe.Name)

    if success then
        Pickaxe.BackgroundColor3 = Red
        Pickaxe.Text = "Equipped"
        Pickaxe:SetAttribute("State", 2)

        local e: TextButton = EquippedPickaxe.Value
        e.Text = "Equip"
        e:SetAttribute("State", 1)
    end
end

local function Purchase(Pickaxe: TextButton)
    local result = PurchaseFunction:InvokeServer(Pickaxe.Name)

    if result == true then
        Pickaxe.BackgroundColor3 = Red
        Pickaxe.Text = "Equipp"
        Pickaxe:SetAttribute("State", 1)
    elseif result == "owned" then
        warn('already own this pickaxe!')
    elseif result == "cash" then
        warn('not enough cash!')
    elseif result == "rebirths" then
        warn('not enough rebirths!')
    end
end

for _, Pickaxe: TextButton in pairs(PickaxesFrame:WaitForChild("Pickaxes"):GetChildren()) do
    Pickaxe.MouseButton1Down:Connect(function()
        if Pickaxe:GetAttribute("State") == 1 then
            Equip(Pickaxe)
        elseif Pickaxe:GetAttribute("State") == 0 then
            Purchase(Pickaxe)
        end
    end)
end

-- / / RETURN
return _UI