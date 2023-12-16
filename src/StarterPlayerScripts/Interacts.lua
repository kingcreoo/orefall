-- / / Interacts, created by KingCreoo on 12/16/23

-- / / DEFINE
local _Interacts = {}

-- / / SERVICES

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))

-- / / VARIABLES

local LocalPlayer = Players.LocalPlayer

local Green = Color3.fromRGB(85, 170, 0)
local Red = Color3.fromRGB(255, 73, 73)

local Info = TweenInfo.new(.2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)

-- / / LOCAL FUNCTIONS

-- / / FUNCTIONS

function _Interacts.Setup(PlayerData: table)
    local PlayerTower = workspace:WaitForChild("ActiveTowers"):WaitForChild(LocalPlayer.Name)

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local InteractsGui = PlayerGui:WaitForChild("Interacts")

    local PickaxesFrame = InteractsGui:WaitForChild("Pickaxes")

    for _, Pickaxe in pairs(PickaxesFrame:WaitForChild("Pickaxes"):GetChildren()) do
        if PlayerData["Pickaxes"][Pickaxe.Name] == 1 then
            Pickaxe.Text = "Equip"
            Pickaxe.BackgroundColor3 = Red
            Pickaxe:SetAttribute("State", 1)
        elseif PlayerData["Pickaxes"][Pickaxe.Name] == 0 then
            Pickaxe.Text = "Purchase"
            Pickaxe.BackgroundColor3 = Green
            Pickaxe:SetAttribute("State", 0)
        end
    end

    PickaxesFrame:WaitForChild("Pickaxes"):WaitForChild(PlayerData["Pickaxe"]).BackgroundColor3 = Red
    PickaxesFrame:WaitForChild("Pickaxes"):WaitForChild(PlayerData["Pickaxe"]).Text = "Equipped"
    PickaxesFrame:WaitForChild("Pickaxes"):WaitForChild(PlayerData["Pickaxe"]):SetAttribute("State", 2)

    local Interacts = PlayerTower:WaitForChild("Interacts")

    for _, Interact in pairs(Interacts:GetChildren()) do
        local Prompt: ProximityPrompt = Interact:WaitForChild("Prompt")

        Prompt.PromptShown:Connect(function()
            local T0 = Interact:FindFirstChild("Tween0")
            if T0 then
                T0:Destroy()
            end

            local T1 = Interact:FindFirstChild("Tween1")
            if T1 then
                T1:Destroy()
            end

            InteractsGui:WaitForChild(Interact.Name).Size = UDim2.new(0,0,0,0)
            InteractsGui:WaitForChild(Interact.Name).Visible = true

            local Tween0 = TweenService:Create(workspace.CurrentCamera, Info, {FieldOfView = 80})
            Tween0.Parent = Interact
            Tween0.Name = "Tween0"
            Tween0:Play()

            local Tween1 = TweenService:Create(InteractsGui:WaitForChild(Interact.Name), Info, {Size = UDim2.new(.612, 0, .714, 0)})
            Tween1.Parent = Interact
            Tween1.Name = "Tween1"
            Tween1:Play()
        end)

        Prompt.PromptHidden:Connect(function()
            local Tween0 = TweenService:Create(workspace.CurrentCamera, Info, {FieldOfView = 70})
            Tween0.Parent = Interact
            Tween0.Name = "Tween0"
            Tween0:Play()

            local Tween1 = TweenService:Create(InteractsGui:WaitForChild(Interact.Name), Info, {Size = UDim2.new(0,0,0,0)})
            Tween1.Parent = Interact
            Tween1.Name = "Tween1"
            Tween1:Play()

            Tween0.Completed:Connect(function()
                InteractsGui:WaitForChild(Interact.Name).Visible = false
            end)
        end)
    end
end

-- / / RETURN
return _Interacts