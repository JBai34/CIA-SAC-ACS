return {
    charWalkspeed 	= 0,
    running 	= false,
    jumping 	= false,
    swimming    = false,
    sitting     = false,
    steadyWalking = false,
    
    canLean     = true,
    
    stances     = 0, -- 0 = standing, 1 = crouching, 2 = prone
    leaning     = 0, -- 0 = not leaning, -1 = leaning left, 1 = leaning right
    
    surrendered = false,
    
    injured = false,
    
    cameraX = 0, 
    cameraY = 0,
    -- Path: CharacterState.lua
}