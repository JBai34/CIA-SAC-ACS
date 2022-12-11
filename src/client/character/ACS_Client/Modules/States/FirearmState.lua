-- This should be universal throughout all firearms
return {
    Tracers = 0,
    
    Aiming = false,
    Shooting = false,
    Reloading = false,
    SafeMode = false,
    CheckingMag = false,
    LaserActive = false,
    IRLaserActive = false,
    FlashLightActive = false,
    BipodActive = false,
    Jammed = false,
    
    LastSpreadUpdate = time(),
    
    reticle = nil,   
    LaserPointer = nil,
    
    CancelReload = false,
    
    GRDebounce = false,
    GunStance = 0,
    
    GenerateBullet 	= 1,
	AimPartMode 	= 1,
    
    CurrentlyEquippingTool = false,
}

