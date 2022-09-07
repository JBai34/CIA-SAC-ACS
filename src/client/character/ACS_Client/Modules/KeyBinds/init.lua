local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")

local Key = Enum.KeyCode
return {
    ShootKey = Enum.UserInputType.MouseButton1;
    
    ReloadKey = Key.R;
    FiremodeKey = Key.V;
    
    AimKey = Enum.UserInputType.MouseButton2;
    AimPartCycleKey     = Key.T;
    
    RunKey = Key.LeftShift;
    CrouchKey = Key.C;
    StandKey = Key.X;
    
}