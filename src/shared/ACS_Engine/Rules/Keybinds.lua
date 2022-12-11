
--[[
        CAS:BindAction("Fire", 			HandleAction, true, 	Enum.UserInputType.MouseButton1, 	Enum.KeyCode.ButtonR2)
		CAS:BindAction("ADS", 			HandleAction, true, 	Enum.UserInputType.MouseButton2, 	Enum.KeyCode.ButtonL2) 
		CAS:BindAction("Reload", 		HandleAction, true, 	Enum.KeyCode.R, 					Enum.KeyCode.ButtonB )
		CAS:BindAction("CycleAimpart", 	HandleAction, false, 	Enum.KeyCode.T											 )
		
		CAS:BindAction("CycleLaser", 	HandleAction, true, 	Enum.KeyCode.H											 )
		CAS:BindAction("CycleLight", 	HandleAction, true, 	Enum.KeyCode.J											 )
		
		CAS:BindAction("CycleFiremode", HandleAction, false, 	Enum.KeyCode.V											 )
		CAS:BindAction("CheckMag", 		HandleAction, false, 	Enum.KeyCode.M											 )

		CAS:BindAction("ZeroDown", 		HandleAction, false, 	Enum.KeyCode.LeftBracket								 )
		CAS:BindAction("ZeroUp", 		HandleAction, false, 	Enum.KeyCode.RightBracket
]]
return {
    Behaviors = {
        AimBehavior                 = 0; -- 0 for trigger, 1 for hold, default 0
        AttachmentTriggerBehavior   = 1; -- 0 for trigger, 1 for hold, default 0
        LeanBehavior                = 0; -- 0 for trigger, 1 for hold, default 0
    };
    
    Keybinds = {   
        Fire            = {Enum.UserInputType.MouseButton1, 	Enum.KeyCode.ButtonR2};
        Aim             = {Enum.UserInputType.MouseButton2, 	Enum.KeyCode.ButtonL2};
        Reload          = {Enum.KeyCode.R, 	                    Enum.KeyCode.ButtonL2};
        CycleAimpart    = {Enum.KeyCode.T, 	                    nil};
        
        CycleLaser      = {Enum.KeyCode.G, 	                    nil};
        CycleFlash      = {Enum.KeyCode.B, 	                    nil};
        
    }
    
}