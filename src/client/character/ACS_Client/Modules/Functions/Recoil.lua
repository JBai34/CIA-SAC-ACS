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
local HandleAction		= require(Modules.HandleAction)

local Actions:Folder	= Modules.Actions
local PlayAnimation		= require(Actions.PlayAnimation)

local States:Folder 	= Modules.States
local FirearmState 		= require(States.FirearmState)
local ViewModelState 	= require(States.ViewModelState)
local CharacterState 	= require(States.CharacterState)
local InputState		= require(States.InputState)

local Props:Folder		= Modules.Props
local FirearmProps 		= require(Props.FirearmProps)

local Others:Folder 		= Modules.Others
local CalculateBulletSpread = require(Others.CalculateBulletSpread)
local CalculateTracer		= require(Others.CalculateTracer)
local ModTable 				= require(Others.ModTable)
local RAND                  = require(Others.RAND)
local RunCheck				= require(Others.RunCheck)
local GunFx					= require(Others.GunFX)
local CheckForHumanoid		= require(Others.CheckForHumanoid)
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
local RecoilSpring = SpringMod.new(Vector3.new())
RecoilSpring.d = .1
RecoilSpring.s = 20

local CameraSpring = SpringMod.new(Vector3.new())
CameraSpring.d	= .5
CameraSpring.s	= 20

local SwaySpring = SpringMod.new(Vector3.new())
SwaySpring.d = .25
SwaySpring.s = 20

return function (weaponData)
	local vr = (math.random(weaponData.camRecoil.camRecoilUp[1], weaponData.camRecoil.camRecoilUp[2])/2) * ModTable.camRecoilMod.RecoilUp
	local lr = (math.random(weaponData.camRecoil.camRecoilLeft[1], weaponData.camRecoil.camRecoilLeft[2])) * ModTable.camRecoilMod.RecoilLeft
	local rr = (math.random(weaponData.camRecoil.camRecoilRight[1], weaponData.camRecoil.camRecoilRight[2])) * ModTable.camRecoilMod.RecoilRight
	local hr = (math.random(-rr, lr)/2)
	local tr = (math.random(weaponData.camRecoil.camRecoilTilt[1], weaponData.camRecoil.camRecoilTilt[2])/2) * ModTable.camRecoilMod.RecoilTilt

	local RecoilX = math.rad(vr * RAND( 1, 1, .1))
	local RecoilY = math.rad(hr * RAND(-1, 1, .1))
	local RecoilZ = math.rad(tr * RAND(-1, 1, .1))

	local gvr = (math.random(weaponData.gunRecoil.gunRecoilUp[1], weaponData.gunRecoil.gunRecoilUp[2]) /10) * ModTable.gunRecoilMod.RecoilUp
	local gdr = (math.random(-1,1) * math.random(weaponData.gunRecoil.gunRecoilTilt[1], weaponData.gunRecoil.gunRecoilTilt[2]) /10) * ModTable.gunRecoilMod.RecoilTilt
	local glr = (math.random(weaponData.gunRecoil.gunRecoilLeft[1], weaponData.gunRecoil.gunRecoilLeft[2])) * ModTable.gunRecoilMod.RecoilLeft
	local grr = (math.random(weaponData.gunRecoil.gunRecoilRight[1], weaponData.gunRecoil.gunRecoilRight[2])) * ModTable.gunRecoilMod.RecoilRight

	local ghr = (math.random(-grr, glr)/10)	

	local ARR = weaponData.AimRecoilReduction * ModTable.AimRM

	if FirearmState.BipodActive then
		CameraSpring:accelerate(Vector3.new( RecoilX, RecoilY/2, 0 ))

		if not FirearmState.Aiming then
			RecoilSpring:accelerate(Vector3.new( math.rad(.25 * gvr * FirearmProps.RecoilPower), math.rad(.25 * ghr * FirearmProps.RecoilPower), math.rad(.25 * gdr)))
			recoilcf = recoilcf * CFrame.new(0,0,.1) * CFrame.Angles( math.rad(.25 * gvr * FirearmProps.RecoilPower ),math.rad(.25 * ghr * FirearmProps.RecoilPower ),math.rad(.25 * gdr * FirearmProps.RecoilPower ))

		else
			RecoilSpring:accelerate(Vector3.new( math.rad( .25 * gvr * FirearmProps.RecoilPower/ARR) , math.rad(.25 * ghr * FirearmProps.RecoilPower/ARR), math.rad(.25 * gdr/ ARR)))
			recoilcf = recoilcf * CFrame.new(0,0,.1) * CFrame.Angles( math.rad(.25 * gvr * FirearmProps.RecoilPower/ARR ),math.rad(.25 * ghr * FirearmProps.RecoilPower/ARR ),math.rad(.25 * gdr * FirearmProps.RecoilPower/ARR ))
		end

		task.wait(0.05)
		CameraSpring:accelerate(Vector3.new(-RecoilX, -RecoilY/2, 0))

	else
		CameraSpring:accelerate(Vector3.new( RecoilX , RecoilY, RecoilZ ))
		if not FirearmState.Aiming then
			RecoilSpring:accelerate(Vector3.new( math.rad(gvr * FirearmProps.RecoilPower), math.rad(ghr * FirearmProps.RecoilPower), math.rad(gdr)))
			recoilcf = recoilcf * CFrame.new(0,-0.05,.1) * CFrame.Angles( math.rad( gvr * FirearmProps.RecoilPower ),math.rad( ghr * FirearmProps.RecoilPower ),math.rad( gdr * FirearmProps.RecoilPower ))

		else
			RecoilSpring:accelerate(Vector3.new( math.rad(gvr * FirearmProps.RecoilPower/ARR) , math.rad(ghr * FirearmProps.RecoilPower/ARR), math.rad(gdr/ ARR)))
			recoilcf = recoilcf * CFrame.new(0,0,.1) * CFrame.Angles( math.rad( gvr * FirearmProps.RecoilPower/ARR ),math.rad( ghr * FirearmProps.RecoilPower/ARR ),math.rad( gdr * FirearmProps.RecoilPower/ARR ))
		end
	end
end