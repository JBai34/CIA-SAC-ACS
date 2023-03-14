--[[
	
	CharacterAction is responsible for rendering all character actions, such as stance, leaning, etc.

]]

--=====
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
--=====
local ACSClient = script.Parent.Parent.Parent
local Modules 	= ACSClient.Modules

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
local Engine 		= ReplicatedStorage.ACS_Engine
local Events 		= Engine:FindFirstChild("Events")
local Mods 			= Engine:FindFirstChild("Modules")
local HUDs 			= Engine:FindFirstChild("HUD")
local Essential 	= Engine:FindFirstChild("Essential")
local ArmModel 		= Engine:FindFirstChild("ArmModel")
local GunModels 	= Engine:FindFirstChild("GunModels")
local AttModels 	= Engine:FindFirstChild("AttModels")
local AttModules  	= Engine:FindFirstChild("AttModules")
local Rules			= require(Engine.Rules.Config)
local PastaFx		= Engine:FindFirstChild("FX")
--=========================================================
local CharacterAction = {}

local function handleCamera(): ... any
	-- leaning only controls cameraX, cameraY is controlled by stance
	if CharacterState.leaning == 0 then
		CharacterState.cameraX = 0
	else
		--[[
			in the code below, 1.25 is the cameraX offset, where leaning is the direction the character is leaning,
			if leaning direction is -1 (leaning left) then the camera offset is -1.25, else it'll be positive.
		]]
		CharacterState.cameraX = 1.25 * CharacterState.leaning
	end
	-- stances controls the cameraY
	if CharacterState.stances == 0 then
		CharacterState.cameraY = 0
	elseif CharacterState.stances == 1 then
		CharacterState.cameraY = -1
	elseif CharacterState.stances == 2 then
		CharacterState.cameraY = -3.25
		CharacterState.cameraX = 0 -- you can't lean in a prone position technically
	end
	
	TS:Create(Humanoid, TweenInfo.new(.3), {CameraOffset = Vector3.new(CharacterState.cameraX,CharacterState.cameraY,0)} ):Play()
end

function CharacterAction:Stand(): ...any
	--Stance:FireServer(Stances,Virar)
	
	if CharacterState.steadyWalking then
		Humanoid.WalkSpeed = Rules.SlowPaceWalkSpeed
		Humanoid.JumpPower = Rules.JumpPower
	else
		if CharacterState.injured then
			Humanoid.WalkSpeed = Rules.InjuredWalksSpeed
			Humanoid.JumpPower = Rules.JumpPower
		else
			Humanoid.WalkSpeed = Rules.NormalWalkSpeed
			Humanoid.JumpPower = Rules.JumpPower
		end
	end
	handleCamera()
end

function CharacterAction:Crouch(): ...any
	--Stance:FireServer(Stances,Virar)
	
	if script.Parent:GetAttribute("Injured") then
		Humanoid.WalkSpeed = Rules.InjuredCrouchWalkSpeed
		Humanoid.JumpPower = 0
	else
		Humanoid.WalkSpeed = Rules.CrouchWalkSpeed
		Humanoid.JumpPower = 0
	end
	handleCamera()
end

function CharacterAction:Prone(): ...any
	--Stance:FireServer(Stances,Virar)
	
	if CharacterState.surrendered == true then
		Humanoid.WalkSpeed = 0
	else
		Humanoid.WalkSpeed = Rules.ProneWalksSpeed
	end
	
	Humanoid.JumpPower = 0
	handleCamera()
end

function CharacterAction:Lean(newLeanDirecton: number): ...any
	--Stance:FireServer(Stances,Virar) -- Virar is a number indicating which way the character is leaning
	if CharacterState.leaning == newLeanDirecton then
		CharacterState.leaning = 0
			
	else
		CharacterState.leaning = newLeanDirecton
	
	end
	handleCamera()
end

return CharacterAction