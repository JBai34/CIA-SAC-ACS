local Debris = game:GetService("Debris")

local ReplicatedStorage= game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CAS = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
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

function CharacterAction:Stand(): ...any
	Stance:FireServer(Stances,Virar)
	TS:Create(Humanoid, TweenInfo.new(.3), {CameraOffset = Vector3.new(CameraX,CameraY,0)} ):Play()

	SE_GUI.MainFrame.Poses.Levantado.Visible = true
	SE_GUI.MainFrame.Poses.Agaixado.Visible = false
	SE_GUI.MainFrame.Poses.Deitado.Visible = false

	if Steady then
		Humanoid.WalkSpeed = Rules.SlowPaceWalkSpeed
		Humanoid.JumpPower = Rules.JumpPower
	else
		if script.Parent:GetAttribute("Injured") then
			Humanoid.WalkSpeed = Rules.InjuredWalksSpeed
			Humanoid.JumpPower = Rules.JumpPower
		else
			Humanoid.WalkSpeed = Rules.NormalWalkSpeed
			Humanoid.JumpPower = Rules.JumpPower
		end
	end

end

function CharacterAction:Crouch(): ...any
	Stance:FireServer(Stances,Virar)
	TS:Create(Humanoid, TweenInfo.new(.3), {CameraOffset = Vector3.new(CameraX,CameraY,0)} ):Play()

	SE_GUI.MainFrame.Poses.Levantado.Visible = false
	SE_GUI.MainFrame.Poses.Agaixado.Visible = true
	SE_GUI.MainFrame.Poses.Deitado.Visible = false

	if script.Parent:GetAttribute("Injured") then
		Humanoid.WalkSpeed = Rules.InjuredCrouchWalkSpeed
		Humanoid.JumpPower = 0
	else
		Humanoid.WalkSpeed = Rules.CrouchWalkSpeed
		Humanoid.JumpPower = 0
	end
end

function CharacterAction:Prone(): ...any
	Stance:FireServer(Stances,Virar)
	TS:Create(Humanoid, TweenInfo.new(.3), {CameraOffset = Vector3.new(CameraX,CameraY,0)} ):Play()
	
	if CharacterState.surrendered == true then
		Humanoid.WalkSpeed = 0
	else
		Humanoid.WalkSpeed = Rules.ProneWalksSpeed
	end
	
	Humanoid.JumpPower = 0 
end

function CharacterAction:Lean(): ...any
	TS:Create(Humanoid, TweenInfo.new(.3), {CameraOffset = Vector3.new(CameraX,CameraY,0)} ):Play()
	Stance:FireServer(Stances,Virar) -- Virar is a number indicating which way the character is leaning
	CharacterState.leaning = Virar
end

return CharacterAction