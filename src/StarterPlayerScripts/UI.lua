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

local PickaxesFrame = InteractsGui:WaitForChild("Pickaxes")
local EquippedPickaxe = PickaxesFrame:WaitForChild("Equipped")

local Functions = ReplicatedStorage:WaitForChild("Functions")

local EquipFunction: RemoteFunction = Functions:WaitForChild("Equip")
local PurchaseFunction: RemoteFunction = Functions:WaitForChild("Purchase")

local Green = Color3.fromRGB(85, 170, 0)
local Red = Color3.fromRGB(255, 73, 73)

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

for _, Pickaxe: TextButton in pairs(PickaxesFrame:WaitForChild("Pickaxes")) do
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