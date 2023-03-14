--[[
	This is the main action handler for the client. It handles all the input from the player and calls the appropriate weapon/character functions.
	
	This handler should ONLY and ONLY read the action and redirect them to the appropriate function. It should not handle any logic.
	
	@Jason
]]
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
local ACSClient = script.Parent.Parent
local Modules		  	= ACSClient.Modules

local Actions			= Modules.Actions
local PlayAnimation		= require(Actions.PlayAnimation)
local WeaponAction		= require(Actions.WeaponAction)
local CharacterAction		 = require(Actions.CharacterAction)

local States		 	= Modules.States
local FirearmState 		= require(States.FirearmState)
local ViewModelState 	= require(States.ViewModelState)
local CharacterState 	= require(States.CharacterState)
local InputState		= require(States.InputState)

local Props				= Modules.Props
local FirearmProps 		= require(Props.FirearmProps)


-- ==
--=====
local ACS_Workspace = workspace:FindFirstChild("ACS_WorkSpace")
local Engine 		 = ReplicatedStorage.ACS_Engine
local Rules			= Engine.Rules
local gameRules		= require(Rules.Config)
--=========================================================

local Camera = workspace.CurrentCamera
local IgnoreModel = {Camera,Character,ACS_Workspace.Client,ACS_Workspace.Server}

return function(actionName, userInputState, inputObject)

	if actionName == "Fire" then
		WeaponAction.Shoot(userInputState)
		--if userInputState == Enum.UserInputState.Begin and ViewModelState.AnimDebounce then
			

			--[[
			if FirearmProps.WeaponData.Type == "Grenade" then
				WeaponAction:Grenade()
			end
			]]
		--elseif userInputState == Enum.UserInputState.End then
			InputState.Mouse1down = false
		--end
	end
		

	if actionName == "Reload" and userInputState == Enum.UserInputState.Begin and ViewModelState.AnimDebounce and not FirearmState.CheckingMag and not FirearmState.Reloading then
		if FirearmState.Jammed then
			WeaponAction:Jammed()
		else
			WeaponAction:Reload()
		end
	end

	if actionName == "Reload" and userInputState == Enum.UserInputState.Begin and FirearmState.Reloading and FirearmProps.WeaponData.ShellInsert then
		FirearmState.CancelReload = true
	end

	if actionName == "CycleLaser" and userInputState == Enum.UserInputState.Begin and FirearmProps.HasLaser then
		WeaponAction:SetLaser()
	end
	
	if actionName == "CycleLight" and userInputState == Enum.UserInputState.Begin and TorchAtt then
		SetTorch()
	end

	if actionName == "CycleFiremode" and userInputState == Enum.UserInputState.Begin and WeaponData and WeaponData.FireModes.ChangeFiremode then
		Firemode()
	end

	if actionName == "CycleAimpart" and userInputState == Enum.UserInputState.Begin then
		SetAimpart()
	end

	if actionName == "ZeroUp" and userInputState == Enum.UserInputState.Begin and WeaponData and WeaponData.EnableZeroing  then
		if WeaponData.CurrentZero < WeaponData.MaxZero then
			WeaponInHand.Handle.Click:play()
			WeaponData.CurrentZero = math.min(WeaponData.CurrentZero + WeaponData.ZeroIncrement, WeaponData.MaxZero) 
		end
	end

	if actionName == "ZeroDown" and userInputState == Enum.UserInputState.Begin and WeaponData and WeaponData.EnableZeroing  then
		if WeaponData.CurrentZero > 0 then
			WeaponInHand.Handle.Click:play()
			WeaponData.CurrentZero = math.max(WeaponData.CurrentZero - WeaponData.ZeroIncrement, 0) 
		end
	end

	if actionName == "CheckMag" and userInputState == Enum.UserInputState.Begin and not CheckingMag and not reloading and not InputState.runKeyDown and ViewModelState.AnimDebounce then
		CheckMagFunction()
	end

	if actionName == "ToggleBipod" and userInputState == Enum.UserInputState.Begin and CanBipod then

		BipodActive = not BipodActive
	end

	if actionName == "NVG" and userInputState == Enum.UserInputState.Begin and not NVGdebounce then
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

	if actionName == "ADS" and userInputState == Enum.UserInputState.Begin and ViewModelState.AnimDebounce then
		if WeaponData and WeaponData.canAim and GunStance > -2 and not InputState.runKeyDown and not CheckingMag then
			aimming = not aimming
			ADS(aimming)
		end

		if WeaponData.Type == "Grenade" then
			GrenadeMode()
		end
	end

	--// STANCES \\--
	if actionName == "Stand" and userInputState == Enum.UserInputState.Begin and not CharacterState.swimming and not CharacterState.sitting and not InputState.runKeyDown then
		if CharacterState.stances == 0 then
			CharacterState.stances = 1
			CharacterAction:Crouch()
			
		elseif CharacterState.stances == 1 then		
			CharacterState.stances = 0
			CharacterAction:Stand()
		end	
		
	elseif actionName == "Crouch" and userInputState == Enum.UserInputState.Begin and not CharacterState.swimming and not CharacterState.sitting and not InputState.runKeyDown then
		if CharacterState.stances == 0 then
			CharacterState.stances = 1
			CharacterAction:Crouch()
			
		elseif CharacterState.stances == 1 then	
			CharacterState.stances = 2
			CharacterState.leaning = 0
			CharacterAction:Lean(0)
			CharacterAction:Prone()
		end
		
	elseif actionName == "ToggleWalk" and userInputState == Enum.UserInputState.Begin and not InputState.runKeyDown then
		CharacterState.steadyWalking = not CharacterState.steadyWalking
		
		if CharacterState.stances == 0 then
			CharacterAction:Stand()
		end
		
	elseif actionName == "LeanLeft" and userInputState == Enum.UserInputState.Begin and CharacterState.stances ~= 2 and not CharacterState.swimming and not InputState.runKeyDown and CharacterState.canLean then
		CharacterAction:Lean(-1)
		
	elseif actionName == "LeanRight" and userInputState == Enum.UserInputState.Begin and CharacterState.stances ~= 2 and not CharacterState.swimming and not InputState.runKeyDown and CharacterState.canLean then
		CharacterAction:Lean(1)
	end
	--// STANCES \\--
	
	if actionName == "Run" and userInputState == Enum.UserInputState.Begin and not CharacterState.running and not CharacterState.injured then
		InputState.runKeyDown 	= true
		CharacterAction:Stand()
		CharacterState.stances = 0
		CameraX = 0
		CameraY = 0
		CharacterAction:Lean(0)

		Character.Humanoid.WalkSpeed = gameRules.RunWalkSpeed

		if aimming then
			aimming = falseq
			ADS(aimming)
		end

		if not CheckingMag and not reloading and WeaponData and WeaponData.Type ~= "Grenade" and (GunStance == 0 or GunStance == 2 or GunStance == 3) then
			GunStance = 3
			Evt.GunStance:FireServer(GunStance,AnimData)
			SprintAnim()
		end
	elseif actionName == "Run" and userInputState == Enum.UserInputState.End and InputState.runKeyDown then
		InputState.runKeyDown 	= false
		CharacterAction:Stand()
		if not CheckingMag and not reloading and WeaponData and WeaponData.Type ~= "Grenade" and (GunStance == 0 or GunStance == 2 or GunStance == 3) then
			GunStance = 0
			Evt.GunStance:FireServer(GunStance,AnimData)
			IdleAnim()
		end
	end
	
end