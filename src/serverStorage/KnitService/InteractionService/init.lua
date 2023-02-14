local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local InteractionService = Knit.CreateService {
    Name = "InteractionService",
    Client = {
        InteractionTriggered = Knit.CreateEvent(),
    },
    
}

function InteractionService.Client:Interact(player: Player, interactionType: string, interactionData: {})
    if string.lower(interactionType) == "door" then
        self.Server:DoorInteraction(player, interactionData)
    end
end

function InteractionService:DoorInteraction(player: Player, doorData: {})
    local door = doorData[1]
    if not CollectionService:HasTag(door, "Door") then return end
    
    local state: number             = door:GetAttribute("State") -- 0 closed, 1 open
    local locked: boolean           = door:GetAttribute("Locked")       -- true/false
    local breakable: boolean        = door:GetAttribute("Breakable")
    local requiresKey: boolean      = door:GetAttribute("RequiresKey")
    local keyPassData: string       = door:GetAttribute("ReyPassData")
    
    local action = doorData[2] or "normal"
    
    if action == "normal" then
        if locked then
            if requiresKey and state == 0 then
                -- open door with key       
                for _, key in pairs(player.Backpack:GetChildren()) do
                    if key:IsA("Tool") and string.lower(key.Name) == "key" then
                        if key:GetAttribute("RequiresKey") == keyPassData then
                            --TODO: play some animation and sound
                            door:SetAttribute("Locked", false)
                            door:SetAttribute("State", 1)
                            break
                        end
                    end
                end
            elseif requiresKey and state == 1 then
                -- close door and auto locks it
                --TODO: play some animation and sound
                door:SetAttribute("Locked", false)
                door:SetAttribute("State", 1)
            end
        else
            --TODO: play some animation and sound
            door:SetAttribute("Locked", true)
        end
        
    elseif action == "force" then -- look for player tools that can force doors
        if breakable then
            -- open door
            --TODO: play some animation and sound
            door:SetAttribute("Locked", false)
            door:SetAttribute("State", 1)
        end
        
    elseif action == "bCharge" then -- look for player tools that be placed charges break doors
        --TODO: play some animation and sound and KABOOM  
        door:SetAttribute("Locked", false)
        door:SetAttribute("State", 1)
    end
    
end

function InteractionService:KnitStart()
    
end

function InteractionService:KnitInit()
    
end
return InteractionService