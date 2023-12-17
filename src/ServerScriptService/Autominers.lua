-- / / Autominers, created by KingCreoo on 12/17/23

-- / / DEFINE
local _Autominers = {}
_Autominers.__index = _Autominers

-- / / SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- / / MODULES

local _Settings = require(ReplicatedStorage:WaitForChild("Settings"))
local _Data = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Data"))

-- / / VARIABLES

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local Functions: Folder = ReplicatedStorage:WaitForChild("Functions")

local PurchaseAutominerFunction: RemoteFunction = Functions:WaitForChild("PurchaseAutominer")

-- / / LOCAL FUNCTIONS

local function PurchaseAutominer(Player: Player, Autominer: string)
    local PlayerData: table = _Data.Get(Player)

    if PlayerData["leaderstats"]["Cash"] < _Settings.Autominers[Autominer]["Value"] then return "cash" end

    PlayerData["leaderstats"]["Cash"] -= _Settings.Autominers[Autominer]["Value"]
    Player:WaitForChild("leaderstats"):WaitForChild("Cash").Value = PlayerData["leaderstats"]["Cash"]
    PlayerData["Autominers"][Autominer] = 1
    
    _Data.Set(Player, PlayerData)

    return true
end

-- / / MODULE FUNCTIONS

-- / / OBJECT FUNCTIONS

-- / / REMOTES
PurchaseAutominerFunction.OnServerInvoke = PurchaseAutominer

-- / / RETURN
return _Autominers