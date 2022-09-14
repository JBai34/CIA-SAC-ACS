local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CAS = game:GetService("ContextActionService")

local Player   = Players.LocalPlayer
local Character = Player.Character
--=====
local ACSClient:Folder  = script.Parent.Parent.Parent
local Modules:Folder 	= ACSClient.Modules

local Actions:Folder	= Modules.Actions
local PlayAnimation		= require(Actions.PlayAnimation)
local WeaponAction		= require(Actions.WeaponAction)

local States:Folder 	= Modules.States
local FirearmState 		= require(States.FirearmState)
local ViewModelState 	= require(States.ViewModelState)
local CharacterState 	= require(States.CharacterState)
local InputState		= require(States.InputState)

local Props:Folder		= Modules.Props
local FirearmProps 		= require(Props.FirearmProps)

local Functions:Folder	= Modules.Functions
local RunCheck				= require(Functions.RunCheck)
local GunFx					= require(Functions.GunFX)
local CheckForHumanoid		= require(Functions.CheckForHumanoid)
local Recoil				= require(Functions.Recoil)
local CalculateBulletSpread = require(Functions.CalculateBulletSpread)
local CalculateTracer		= require(Functions.CalculateTracer)
local ResetMods				= require(Functions.ResetMods)

local Others:Folder 		= Modules.Others
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
local gameRules		         = require(Rules:WaitForChild("Config"))
local SpringMod 	         = require(Mods:WaitForChild("Spring"))
local HitMod 		         = require(Mods:WaitForChild("Hitmarker"))
local Thread 		         = require(Mods:WaitForChild("Thread"))
local Ultil			         = require(Mods:WaitForChild("Utilities"))
--=========================================================

local Camera = workspace.CurrentCamera
local IgnoreModel = {Camera,Character,ACS_Workspace.Client,ACS_Workspace.Server}

return function(actionName, inputState, inputObject)

	if actionName == "Fire" then
		if inputState == Enum.UserInputState.Begin and ViewModelState.AnimDebounce then
			WeaponAction:Shoot()

			--[[
			if FirearmProps.WeaponData.Type == "Grenade" then
				WeaponAction:Grenade()
			end
			]]
		elseif inputState == Enum.UserInputState.End then
			InputState.Mouse1down = false
		end
	end
		

	if actionName == "Reload" and inputState == Enum.UserInputState.Begin and ViewModelState.AnimDebounce and not FirearmState.CheckingMag and not FirearmState.Reloading then
		if FirearmState.Jammed then
			WeaponAction:Jammed()
		else
			WeaponAction:Reload()
		end
	end

	if actionName == "Reload" and inputState == Enum.UserInputState.Begin and FirearmState.Reloading and FirearmProps.WeaponData.ShellInsert then
		FirearmState.CancelReload = true
	end

	if actionName == "CycleLaser" and inputState == Enum.UserInputState.Begin and FirearmProps.HasLaser then
		WeaponAction:SetLaser()
	end
	
	if actionName == "CycleLight" and inputState == Enum.UserInputState.Begin and TorchAtt then
		SetTorch()
	end

	if actionName == "CycleFiremode" and inputState == Enum.UserInputState.Begin and WeaponData and WeaponData.FireModes.ChangeFiremode then
		Firemode()
	end

	if actionName == "CycleAimpart" and inputState == Enum.UserInputState.Begin then
		SetAimpart()
	end

	if actionName == "ZeroUp" and inputState == Enum.UserInputState.Begin and WeaponData and WeaponData.EnableZeroing  then
		if WeaponData.CurrentZero < WeaponData.MaxZero then
			WeaponInHand.Handle.Click:play()
			WeaponData.CurrentZero = math.min(WeaponData.CurrentZero + WeaponData.ZeroIncrement, WeaponData.MaxZero) 
			UpdateGui()
		end
	end

	if actionName == "ZeroDown" and inputState == Enum.UserInputState.Begin and WeaponData and WeaponData.EnableZeroing  then
		if WeaponData.CurrentZero > 0 then
			WeaponInHand.Handle.Click:play()
			WeaponData.CurrentZero = math.max(WeaponData.CurrentZero - WeaponData.ZeroIncrement, 0) 
			UpdateGui()
		end
	end

	if actionName == "CheckMag" and inputState == Enum.UserInputState.Begin and not CheckingMag and not reloading and not runKeyDown and ViewModelState.AnimDebounce then
		CheckMagFunction()
	end

	if actionName == "ToggleBipod" and inputState == Enum.UserInputState.Begin and CanBipod then

		BipodActive = not BipodActive
		UpdateGui()
	end

	if actionName == "NVG" and inputState == Enum.UserInputState.Begin and not NVGdebounce then
		if Player.Character then
			local helmet = Player.Character:FindFirstChild("Helmet")
			if helmet then
				local nvg = helmet:FindFirstChild("Up")
				if nvg then
					NVGdebounce = true
					task.delay(.8,function()
						NVG = not NVG
						Evt.NVG:Fire(NVG)
						NVGdebounce = false		
					end)

				end
			end
		end
	end

	if actionName == "ADS" and inputState == Enum.UserInputState.Begin and ViewModelState.AnimDebounce then
		if WeaponData and WeaponData.canAim and GunStance > -2 and not runKeyDown and not CheckingMag then
			aimming = not aimming
			ADS(aimming)
		end

		if WeaponData.Type == "Grenade" then
			GrenadeMode()
		end
	end

	if actionName == "Stand" and inputState == Enum.UserInputState.Begin and ChangeStance and not Swimming and not Sentado and not runKeyDown then
		if Stances == 2 then
			Crouched = true
			Proned = false
			Stances = 1
			CameraY = -1
			Crouch()


		elseif Stances == 1 then		
			Crouched = false
			Stances = 0
			CameraY = 0
			Stand()
		end	
	end

	if actionName == "Crouch" and inputState == Enum.UserInputState.Begin and ChangeStance and not Swimming and not Sentado and not runKeyDown then
		if Stances == 0 then
			Stances = 1
			CameraY = -1
			Crouch()
			Crouched = true
		elseif Stances == 1 then	
			Stances = 2
			CameraX = 0
			CameraY = -3.25
			Virar = 0
			Lean()
			Prone()
			Crouched = false
			Proned = true
		end
	end

	if actionName == "ToggleWalk" and inputState == Enum.UserInputState.Begin and ChangeStance and not runKeyDown then
		Steady = not Steady

		if Steady then
			SE_GUI.MainFrame.Poses.Steady.Visible = true
		else
			SE_GUI.MainFrame.Poses.Steady.Visible = false
		end

		if Stances == 0 then
			Stand()
		end
	end

	if actionName == "LeanLeft" and inputState == Enum.UserInputState.Begin and Stances ~= 2 and ChangeStance and not Swimming and not runKeyDown and CanLean then
		if Virar == 0 or Virar == 1 then
			Virar = -1
			CameraX = -1.25
		else
			Virar = 0
			CameraX = 0
		end
		Lean()
	end

	if actionName == "LeanRight" and inputState == Enum.UserInputState.Begin and Stances ~= 2 and ChangeStance and not Swimming and not runKeyDown and CanLean then
		if Virar == 0 or Virar == -1 then
			Virar = 1
			CameraX = 1.25
		else
			Virar = 0
			CameraX = 0
		end
		Lean()
	end

	if actionName == "Run" and inputState == Enum.UserInputState.Begin and running and not script.Parent:GetAttribute("Injured") then
		runKeyDown 	= true
		Stand()
		Stances = 0
		Virar = 0
		CameraX = 0
		CameraY = 0
		Lean()

		char:WaitForChild("Humanoid").WalkSpeed = gameRules.RunWalkSpeed

		if aimming then
			aimming = false
			ADS(aimming)
		end

		if not CheckingMag and not reloading and WeaponData and WeaponData.Type ~= "Grenade" and (GunStance == 0 or GunStance == 2 or GunStance == 3) then
			GunStance = 3
			Evt.GunStance:FireServer(GunStance,AnimData)
			SprintAnim()
		end

	elseif actionName == "Run" and inputState == Enum.UserInputState.End and runKeyDown then
		runKeyDown 	= false
		Stand()
		if not CheckingMag and not reloading and WeaponData and WeaponData.Type ~= "Grenade" and (GunStance == 0 or GunStance == 2 or GunStance == 3) then
			GunStance = 0
			Evt.GunStance:FireServer(GunStance,AnimData)
			IdleAnim()
		end
	end
end