--[[
    Jason
    This controller is tasked to control interactive elements attached to the engine
    such as doors, switches, etc.
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Knit = require(ReplicatedStorage.Packages.Knit)
local Config  = require(ReplicatedStorage.ACS_Engine.Rules.Config)

local IntearctionService = Knit:GetService("InteractionService")
local InteractionController = {}

local Key = nil


local function InteractElement(element)

    local nearest = element
    
    if nearest == nil then return end
    
    -- TODO: add some hover UI to the doorknob similar to ACS vanilla fireteam selection
    
    if nearest:GetAttribute("InteractionType") == "Door" then
        IntearctionService:Interact("door", {
            nearest,
            "normal"
        }) --TODO: add support to door open type
    end
    
end

local function getNearest()
    local minDistance = Config.MinimumInteractionDistance

    --[[pseudocode
        first get player's camera (what they see)
    
        get player's character magnitude and compare it to its object that's closest to it
        might use raycast
        
        if the distance is less than the minimum distance, then we can interact with it
    ]]
end

function InteractionController:KnitStart()
    RunService:BindToRenderStep("Interaction", 200, getNearest())
end

function InteractionController:KnitInit()
    
end