--[[
    Jason
    This controller is tasked to control interactive elements attached to the engine
    such as doors, switches, etc.
]]
local CAS = game:GetService("ContextActionService")
local CollectionService = game:GetService("CollectionService")
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Knit = require(game:GetService('ReplicatedStorage').Packages.Knit)
local Config  = require(game:GetService('ReplicatedStorage').ACS_Engine.Rules.Config)
local InteractionController = {}

local function getNearest(): Model
    local nearest = nil
    local minDistance = Config.MinimumInteractionDistance

    for _, door in pairs(CollectionService:GetTagged("Door")) do
        if door.Door:FindFirstChild("Knob") then
            local distance = (door.Door.Knob.Position -
                                 Character.UpperTorso.Position).magnitude

            if distance < minDistance then
                nearest = door
                minDistance = distance
            end
        end
    end
    return nearest
end

local function InteractElement(actionName, inputState, inputObject)
    if inputState ~= Enum.UserInputState.Begin then return end

    local nearestDoor = getNearest()

    if nearestDoor == nil then return end

    if (nearestDoor.Door.Knob.Position - Character.UpperTorso.Position).magnitude <=
        mDistance then
        if nearestDoor ~= nil then
            if nearestDoor:FindFirstChild("RequiresKey") then
                Key = nearestDoor.RequiresKey.Value
            else
                Key = nil
            end
            Evt.DoorEvent:FireServer(nearestDoor, 1, Key)
        end
    end
end

function InteractionController:KnitStart()
    self.InteractionService = Knit.GetService("InteractionService")
    self.InteractionService.InteractionTriggered:Connect(function(interaction)
        if interaction.Type == "Door" then
            self:DoorInteraction(interaction)
        end
    end)
end

function InteractionController:KnitInit()
    
end