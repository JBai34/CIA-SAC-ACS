local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CAS = game:GetService("ContextActionService")

local Player   = Players.LocalPlayer
local Character = Player.Character
--=====
local ACSClient = script.Parent.Parent.Parent
local Modules 	= ACSClient.Modules
local HandleAction		= require(Modules.HandleAction)

local Actions	= Modules.Actions
local PlayAnimation		= require(Actions.PlayAnimation)
local WeaponAction      = require(Actions.WeaponAction)

local States 	= Modules.States
local FirearmState 		= require(States.FirearmState)
local ViewModelState 	= require(States.ViewModelState)
local CharacterState 	= require(States.CharacterState)
local InputState		= require(States.InputState)

local Props		= Modules.Props
local FirearmProps 		= require(Props.FirearmProps)

local Functions	= Modules.Functions
local RunCheck				= require(Functions.RunCheck)
local ResetMods				= require(Functions.ResetMods)

local Others 		= Modules.Others
local ModTable 				= require(Others.ModTable)

-- ==
--=====
local ACS_Workspace = workspace:FindFirstChild("ACS_WorkSpace")
local Engine 		= ReplicatedStorage:FindFirstChild("ACS_Engine")
local Events 		= Engine:FindFirstChild("Events")
local Mods 			= Engine:FindFirstChild("Modules")
local HUDs 			= Engine:FindFirstChild("HUD")
local Essential 	= Engine:FindFirstChild("Essential")
local ArmModel 		= Engine:FindFirstChild("ArmModel")
local GunModels 	= Engine:FindFirstChild("GunModels")
local AttModels 	= Engine:FindFirstChild("AttModels")
local AttModules  	= Engine:FindFirstChild("AttModules")
local Rules			= Engine:FindFirstChild("GameRules")
local PastaFx		= Engine:FindFirstChild("FX")
--=========================================================
local EquipAction = {}

local Camera = workspace.CurrentCamera



function EquipAction:Unset(tool)
	WeaponAction:Unset(tool)
	--unsetup weapon data module
	CAS:UnbindAction("Fire")
	CAS:UnbindAction("ADS")
	CAS:UnbindAction("Reload")
	CAS:UnbindAction("CycleLaser")
	CAS:UnbindAction("CycleLight")
	CAS:UnbindAction("CycleFiremode")
	CAS:UnbindAction("CycleAimpart")
	CAS:UnbindAction("ZeroUp")
	CAS:UnbindAction("ZeroDown")
	CAS:UnbindAction("CheckMag")

    TS:Create(Camera,
        TweenInfo.new(
            0.2,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            0,
            false,
            0
	),
	{FieldOfView = 70}):Play()

	UserInputService.MouseIconEnabled = true
	UserInputService.MouseDeltaSensitivity = 1
	Camera.CameraType = Enum.CameraType.Custom
	Player.CameraMode = Enum.CameraMode.Classic
    
end

function EquipAction:Setup(tool)
	if Character and Character:WaitForChild("Humanoid").Health > 0 and tool ~= nil then
		UserInputService.MouseIconEnabled 	= false
		Player.CameraMode 			= Enum.CameraMode.LockFirstPerson
        
        WeaponAction:Setup(tool)
        
		CAS:BindAction("Fire", 			HandleAction, true, 	Enum.UserInputType.MouseButton1, 	Enum.KeyCode.ButtonR2)
		CAS:BindAction("ADS", 			HandleAction, true, 	Enum.UserInputType.MouseButton2, 	Enum.KeyCode.ButtonL2) 
		CAS:BindAction("Reload", 		HandleAction, true, 	Enum.KeyCode.R, 					Enum.KeyCode.ButtonB )
		CAS:BindAction("CycleAimpart", 	HandleAction, false, 	Enum.KeyCode.T											 )
		
		CAS:BindAction("CycleLaser", 	HandleAction, true, 	Enum.KeyCode.H											 )
		CAS:BindAction("CycleLight", 	HandleAction, true, 	Enum.KeyCode.J											 )
		
		CAS:BindAction("CycleFiremode", HandleAction, false, 	Enum.KeyCode.V											 )
		CAS:BindAction("CheckMag", 		HandleAction, false, 	Enum.KeyCode.M											 )

		CAS:BindAction("ZeroDown", 		HandleAction, false, 	Enum.KeyCode.LeftBracket								 )
		CAS:BindAction("ZeroUp", 		HandleAction, false, 	Enum.KeyCode.RightBracket								 )

		--loadAttachment(WeaponInHand)
    end
end

return EquipAction