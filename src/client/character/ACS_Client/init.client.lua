if not game:GetService("Players").LocalPlayer.Character then game:GetService("Players").LocalPlayer.CharacterAdded:Wait() end

local Player 			= game.Players.LocalPlayer
local char 			    = Player.Character or Player.CharacterAdded:Wait()
local mouse 		    = Player:GetMouse()
local cam 			    = workspace.CurrentCamera

local User 			= game:GetService("UserInputService")
local CAS 			= game:GetService("ContextActionService")
local Run 			= game:GetService("RunService")
local TS 			= game:GetService('TweenService')
local Debris 		= game:GetService("Debris")
local PhysicsService= game:GetService("PhysicsService")

local ReplicatedStorage 			= game:GetService("ReplicatedStorage")
local ACS_Workspace = workspace:FindFirstChild("ACS_WorkSpace")
local Engine 		= ReplicatedStorage:FindFirstChild("ACS_Engine")
local Events 			= Engine:FindFirstChild("Events")
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
local ACS_Client 	= char:WaitForChild("ACS_Client")

local Equipped 		= 0
local Primary 		= ""
local Secondary 	= ""
local Grenades 		= ""

local Ammo
local StoredAmmo

local GreAmmo = 0

local WeaponInHand, WeaponTool, WeaponData, AnimData
local ViewModel, AnimPart, LArm, RArm, LArmWeld, RArmWeld, GunWeld
local SightData, BarrelData, UnderBarrelData, OtherData
local generateBullet = 1
local BSpread
local RecoilPower
local LastSpreadUpdate = time()
local SE_GUI
local SKP_01 = Events.AcessId:InvokeServer(Player.UserId)

local charspeed 	= 0
local running 		= false
local runKeyDown 	= false
local aimming 		= false
local shooting 		= false
local reloading 	= false
local mouse1down 	= false
local AnimDebounce 	= false
local CancelReload 	= false
local SafeMode		= false
local JumpDelay 	= false
local NVG 			= false
local NVGdebounce 	= false	
local GunStance 	= 0
local AimPartMode 	= 1

local SightAtt		= nil
local reticle		= nil
local CurAimpart 	= nil

local BarrelAtt 	= nil
local Suppressor 	= false
local FlashHider 	= false

local UnderBarrelAtt= nil

local OtherAtt 		= nil

local LaserAttachment 		= false
local LaserActive	= false
local IRmode		= false
local IREnable		= false
local LaserDist 	= 0
local Laser 		= nil
local Pointer 		= nil

local FlashLightAttachment 		= false
local FlashLightActive 	= false

local BipodAtt 		= false
local CanBipod 		= false
local BipodActive 	= false

local GRDebounce 	= false

local CurrentlyEquippingTool 	= false
local Sens 			= 50
local Power 		= 150

local BipodCF 		= CFrame.new()
local NearZ 		= CFrame.new(0,0,-.5)

--------------------mods

local ModTable = {

	camRecoilMod 	= {
		RecoilTilt 	= 1,
		RecoilUp 	= 1,
		RecoilLeft 	= 1,
		RecoilRight = 1
	}

	,gunRecoilMod	= {
		RecoilUp 	= 1,
		RecoilTilt 	= 1,
		RecoilLeft 	= 1,
		RecoilRight = 1
	}

	,ZoomValue 		= 70
	,Zoom2Value 	= 70
	,AimRM 			= 1
	,SpreadRM 		= 1
	,DamageMod 		= 1
	,minDamageMod 	= 1

	,MinRecoilPower 			= 1
	,MaxRecoilPower 			= 1
	,RecoilPowerStepAmount 		= 1

	,MinSpread 					= 1
	,MaxSpread 					= 1					
	,AimInaccuracyStepAmount 	= 1
	,AimInaccuracyDecrease 		= 1
	,WalkMult 					= 1
	,adsTime 					= 1		
	,MuzzleVelocity 			= 1
}  

--------------------mods

local maincf 		= CFrame.new() --weapon offset of camera
local guncf  		= CFrame.new() --weapon offset of camera
local larmcf 		= CFrame.new() --left arm offset of weapon
local rarmcf 		= CFrame.new() --right arm offset of weapon

local gunbobcf		= CFrame.new()
local recoilcf 		= CFrame.new()
local aimcf 		= CFrame.new()
local AimTween 		= TweenInfo.new(
	0.2,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.InOut,
	0,
	false,
	0
)

local Ignore_Model = {cam,char,ACS_Workspace.Client,ACS_Workspace.Server}

local ModStorageFolder 	= Player.PlayerGui:FindFirstChild('ModStorage') or Instance.new('Folder')
ModStorageFolder.Parent = Player.PlayerGui
ModStorageFolder.Name 	= 'ModStorage'

function RAND(Min, Max, Accuracy)
	local Inverse = 1 / (Accuracy or 1)
	return (math.random(Min * Inverse, Max * Inverse) / Inverse)
end

SE_GUI = HUDs:WaitForChild("StatusUI"):Clone()
SE_GUI.Parent = Player.PlayerGui 

local BloodScreen 		= TS:Create(SE_GUI.Efeitos.Health, TweenInfo.new(1,Enum.EasingStyle.Circular,Enum.EasingDirection.InOut,-1,true), {Size =  UDim2.new(1.2,0,1.4,0)})
local BloodScreenLowHP 	= TS:Create(SE_GUI.Efeitos.LowHealth, TweenInfo.new(1,Enum.EasingStyle.Circular,Enum.EasingDirection.InOut,-1,true), {Size =  UDim2.new(1.2,0,1.4,0)})

local RecoilSpring = SpringMod.new(Vector3.new())
RecoilSpring.d = .1
RecoilSpring.s = 20

local cameraspring = SpringMod.new(Vector3.new())
cameraspring.d	= .5
cameraspring.s	= 20

local SwaySpring = SpringMod.new(Vector3.new())
SwaySpring.d = .25
SwaySpring.s = 20

local TWAY, XSWY, YSWY = 0,0,0

local oldtick = tick()
local xTilt = 0
local yTilt = 0
local lastPitch = 0
local lastYaw = 0

local Stance = Events.Stance
local Stances = 0
local Virar = 0
local CameraX = 0
local CameraY = 0

local Sentado 		= false
local Swimming		= false
local falling 		= false
local cansado 		= false
local Crouched 		= false
local Proned		= false
local Steady 		= false
local CanLean 		= true
local ChangeStance 	= true

--// Char Parts
local Humanoid = char:WaitForChild('Humanoid')
local Head = char:WaitForChild('Head')
local Torso = char:WaitForChild('UpperTorso')
local HumanoidRootPart = char:WaitForChild('HumanoidRootPart')
local RootJoint = char.LowerTorso:WaitForChild('Root')
local Neck = Head:WaitForChild('Neck')
local Right_Shoulder = char.RightUpperArm:WaitForChild('RightShoulder')
local Left_Shoulder = char.LeftUpperArm:WaitForChild('LeftShoulder')
local Right_Hip = char.RightUpperLeg:WaitForChild('RightHip')
local Left_Hip = char.LeftUpperLeg:WaitForChild('LeftHip')

local YOffset = Neck.C0.Y
local WaistYOffset = Neck.C0.Y
local CFNew, CFAng = CFrame.new, CFrame.Angles
local Asin = math.asin
local T = 0.15

User.MouseIconEnabled 	= true
Player.CameraMode 			= Enum.CameraMode.Classic

cam.CameraType = Enum.CameraType.Custom
cam.CameraSubject = Humanoid

if gameRules.TeamTags then
	local tag = Essential.TeamTag:clone()
	tag.Parent = char
	tag.Disabled = false
end

function handleAction(actionName, inputState, inputObject)

	if actionName == "Fire" and inputState == Enum.UserInputState.Begin and AnimDebounce then
		Shoot()

		if WeaponData.Type == "Grenade" then
			Grenade()
		end

	elseif actionName == "Fire" and inputState == Enum.UserInputState.End then
		mouse1down = false
	end

	if actionName == "Reload" and inputState == Enum.UserInputState.Begin and AnimDebounce and not CheckingMag and not reloading then
		if WeaponData.Jammed then
			Jammed()
		else
			Reload()
		end
	end

	if actionName == "Reload" and inputState == Enum.UserInputState.Begin and reloading and WeaponData.ShellInsert then
		CancelReload = true
	end

	if actionName == "CycleLaser" and inputState == Enum.UserInputState.Begin and LaserAttachment then
		SetLaser()
	end

	if actionName == "CycleLight" and inputState == Enum.UserInputState.Begin and FlashLightAttachment then
		SetFlashLight()
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

	if actionName == "CheckMag" and inputState == Enum.UserInputState.Begin and not CheckingMag and not reloading and not runKeyDown and AnimDebounce then
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
						Events.NVG:Fire(NVG)
						NVGdebounce = false		
					end)

				end
			end
		end
	end

	if actionName == "ADS" and inputState == Enum.UserInputState.Begin and AnimDebounce then
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
			Events.GunStance:FireServer(GunStance,AnimData)
			SprintAnim()
		end

	elseif actionName == "Run" and inputState == Enum.UserInputState.End and runKeyDown then
		runKeyDown 	= false
		Stand()
		if not CheckingMag and not reloading and WeaponData and WeaponData.Type ~= "Grenade" and (GunStance == 0 or GunStance == 2 or GunStance == 3) then
			GunStance = 0
			Events.GunStance:FireServer(GunStance,AnimData)
			IdleAnim()
		end
	end
end

function resetMods()

	ModTable.camRecoilMod.RecoilUp 		= 1
	ModTable.camRecoilMod.RecoilLeft 	= 1
	ModTable.camRecoilMod.RecoilRight 	= 1
	ModTable.camRecoilMod.RecoilTilt 	= 1

	ModTable.gunRecoilMod.RecoilUp 		= 1
	ModTable.gunRecoilMod.RecoilTilt 	= 1
	ModTable.gunRecoilMod.RecoilLeft 	= 1
	ModTable.gunRecoilMod.RecoilRight 	= 1

	ModTable.AimRM			= 1
	ModTable.SpreadRM 		= 1
	ModTable.DamageMod 		= 1
	ModTable.minDamageMod 	= 1

	ModTable.MinRecoilPower 		= 1
	ModTable.MaxRecoilPower 		= 1
	ModTable.RecoilPowerStepAmount 	= 1

	ModTable.MinSpread 					= 1
	ModTable.MaxSpread 					= 1
	ModTable.AimInaccuracyStepAmount 	= 1
	ModTable.AimInaccuracyDecrease 		= 1
	ModTable.WalkMult 					= 1
	ModTable.MuzzleVelocity 			= 1

end

function setMods(ModData)

	ModTable.camRecoilMod.RecoilUp 		= ModTable.camRecoilMod.RecoilUp * ModData.camRecoil.RecoilUp
	ModTable.camRecoilMod.RecoilLeft 	= ModTable.camRecoilMod.RecoilLeft * ModData.camRecoil.RecoilLeft
	ModTable.camRecoilMod.RecoilRight 	= ModTable.camRecoilMod.RecoilRight * ModData.camRecoil.RecoilRight
	ModTable.camRecoilMod.RecoilTilt 	= ModTable.camRecoilMod.RecoilTilt * ModData.camRecoil.RecoilTilt

	ModTable.gunRecoilMod.RecoilUp 		= ModTable.gunRecoilMod.RecoilUp * ModData.gunRecoil.RecoilUp
	ModTable.gunRecoilMod.RecoilTilt 	= ModTable.gunRecoilMod.RecoilTilt * ModData.gunRecoil.RecoilTilt
	ModTable.gunRecoilMod.RecoilLeft 	= ModTable.gunRecoilMod.RecoilLeft * ModData.gunRecoil.RecoilLeft
	ModTable.gunRecoilMod.RecoilRight 	= ModTable.gunRecoilMod.RecoilRight * ModData.gunRecoil.RecoilRight

	ModTable.AimRM						= ModTable.AimRM * ModData.AimRecoilReduction
	ModTable.SpreadRM 					= ModTable.SpreadRM * ModData.AimSpreadReduction
	ModTable.DamageMod 					= ModTable.DamageMod * ModData.DamageMod
	ModTable.minDamageMod 				= ModTable.minDamageMod * ModData.minDamageMod

	ModTable.MinRecoilPower 			= ModTable.MinRecoilPower * ModData.MinRecoilPower
	ModTable.MaxRecoilPower 			= ModTable.MaxRecoilPower * ModData.MaxRecoilPower
	ModTable.RecoilPowerStepAmount 		= ModTable.RecoilPowerStepAmount * ModData.RecoilPowerStepAmount

	ModTable.MinSpread 					= ModTable.MinSpread * ModData.MinSpread
	ModTable.MaxSpread 					= ModTable.MaxSpread * ModData.MaxSpread
	ModTable.AimInaccuracyStepAmount 	= ModTable.AimInaccuracyStepAmount * ModData.AimInaccuracyStepAmount
	ModTable.AimInaccuracyDecrease 		= ModTable.AimInaccuracyDecrease * ModData.AimInaccuracyDecrease
	ModTable.WalkMult 					= ModTable.WalkMult * ModData.WalkMult
	ModTable.MuzzleVelocity 			= ModTable.MuzzleVelocity * ModData.MuzzleVelocityMod
end

function loadAttachment(weapon)
	if weapon and weapon:FindFirstChild("Nodes") ~= nil then

		--load sight Att
		if weapon.Nodes:FindFirstChild("Sight") ~= nil and WeaponData.SightAtt ~= "" then

			SightData =  require(AttModules[WeaponData.SightAtt])

			SightAtt = AttModels[WeaponData.SightAtt]:Clone()
			SightAtt.Parent = weapon
			SightAtt:SetPrimaryPartCFrame(weapon.Nodes.Sight.CFrame)
			weapon.AimPart.CFrame = SightAtt.AimPos.CFrame

			reticle = SightAtt.SightMark.SurfaceGui.Border.Scope	
			if SightData.SightZoom > 0 then
				ModTable.ZoomValue = SightData.SightZoom
			end
			if SightData.SightZoom2 > 0 then
				ModTable.Zoom2Value = SightData.SightZoom2
			end
			setMods(SightData)


			for index, key in pairs(weapon:GetChildren()) do
				if key.Name == "IS" then
					key.Transparency = 1
				end
			end

			for index, key in pairs(SightAtt:GetChildren()) do
				if key:IsA('BasePart') then
					Ultil.Weld(weapon:WaitForChild("Handle"), key )
					key.Anchored = false
					key.CanCollide = false
				end
			end

		end

		--load Barrel Att
		if weapon.Nodes:FindFirstChild("Barrel") ~= nil and WeaponData.BarrelAtt ~= "" then

			BarrelData =  require(AttModules[WeaponData.BarrelAtt])

			BarrelAtt = AttModels[WeaponData.BarrelAtt]:Clone()
			BarrelAtt.Parent = weapon
			BarrelAtt:SetPrimaryPartCFrame(weapon.Nodes.Barrel.CFrame)


			if BarrelAtt:FindFirstChild("BarrelPos") ~= nil then
				weapon.Handle.Muzzle.WorldCFrame = BarrelAtt.BarrelPos.CFrame
			end

			Suppressor 		= BarrelData.IsSuppressor
			FlashHider 		= BarrelData.IsFlashHider

			setMods(BarrelData)

			for index, key in pairs(BarrelAtt:GetChildren()) do
				if key:IsA('BasePart') then
					Ultil.Weld(weapon:WaitForChild("Handle"), key )
					key.Anchored = false
					key.CanCollide = false
				end
			end
		end

		--load Under Barrel Att
		if weapon.Nodes:FindFirstChild("UnderBarrel") ~= nil and WeaponData.UnderBarrelAtt ~= "" then

			UnderBarrelData =  require(AttModules[WeaponData.UnderBarrelAtt])

			UnderBarrelAtt = AttModels[WeaponData.UnderBarrelAtt]:Clone()
			UnderBarrelAtt.Parent = weapon
			UnderBarrelAtt:SetPrimaryPartCFrame(weapon.Nodes.UnderBarrel.CFrame)


			setMods(UnderBarrelData)
			BipodAtt = UnderBarrelData.IsBipod

			if BipodAtt then
				CAS:BindAction("ToggleBipod", handleAction, true, Enum.KeyCode.B)
			end

			for index, key in pairs(UnderBarrelAtt:GetChildren()) do
				if key:IsA('BasePart') then
					Ultil.Weld(weapon:WaitForChild("Handle"), key )
					key.Anchored = false
					key.CanCollide = false
				end
			end
		end

		if weapon.Nodes:FindFirstChild("Other") ~= nil and WeaponData.OtherAtt ~= "" then

			OtherData =  require(AttModules[WeaponData.OtherAtt])

			OtherAtt = AttModels[WeaponData.OtherAtt]:Clone()
			OtherAtt.Parent = weapon
			OtherAtt:SetPrimaryPartCFrame(weapon.Nodes.Other.CFrame)


			setMods(OtherData)
			LaserAttachment = OtherData.EnableLaser
			FlashLightAttachment = OtherData.EnableFlashlight
			
			if OtherData.InfraRed then
				IREnable = true
			end
			
			for index, key in pairs(OtherAtt:GetChildren()) do
				if key:IsA('BasePart') then
					Ultil.Weld(weapon:WaitForChild("Handle"), key )
					key.Anchored = false
					key.CanCollide = false
				end
			end
		end
	end
end

function SetLaser()
	if gameRules.RealisticLaser and IREnable then
		if not LaserActive and not IRmode then
			LaserActive = true
			IRmode 		= true

		elseif LaserActive and IRmode then
			IRmode 		= false
		else
			LaserActive = false
			IRmode 		= false
		end
	else
		LaserActive = not LaserActive
	end

	print(LaserActive, IRmode)

	if LaserActive then
		if not Pointer then
			for index, Key in pairs(WeaponInHand:GetDescendants()) do
				if Key:IsA("BasePart") and Key.Name == "LaserPoint" then
					local LaserPointer = Instance.new('Part',Key)
					LaserPointer.Shape = 'Ball'
					LaserPointer.Size = Vector3.new(0.2, 0.2, 0.2)
					LaserPointer.CanCollide = false
					LaserPointer.Color = Key.Color
					LaserPointer.Material = Enum.Material.Neon

					local LaserSP = Instance.new('Attachment',Key)			
					local LaserEP = Instance.new('Attachment',LaserPointer)

					local Laser = Instance.new('Beam',LaserPointer)
					Laser.Transparency = NumberSequence.new(0)
					Laser.LightEmission = 1
					Laser.LightInfluence = 1
					Laser.Attachment0 = LaserSP
					Laser.Attachment1 = LaserEP
					Laser.Color = ColorSequence.new(Key.Color)
					Laser.FaceCamera = true
					Laser.Width0 = 0.01
					Laser.Width1 = 0.01

					if gameRules.RealisticLaser then
						Laser.Enabled = false
					end

					Pointer = LaserPointer
					break
				end
			end
		end
	else
		for index, Key in pairs(WeaponInHand:GetDescendants()) do
			if Key:IsA("BasePart") and Key.Name == "LaserPoint" then
				Key:ClearAllChildren()
				break
			end
		end
		Pointer = nil
		if gameRules.ReplicatedLaser then
			Events.SVLaser:FireServer(nil,2,nil,false,WeaponTool)
		end
	end
	WeaponInHand.Handle.Click:play()
	UpdateGui()
end

function SetFlashLight()

	FlashLightActive = not FlashLightActive
	
	if FlashLightActive then
		for index, Key in pairs(WeaponInHand:GetDescendants()) do
			if Key:IsA("BasePart") and Key.Name == "FlashPoint" then
				Key.Light.Enabled = true
			end
		end
	else
		for index, Key in pairs(WeaponInHand:GetDescendants()) do
			if Key:IsA("BasePart") and Key.Name == "FlashPoint" then
				Key.Light.Enabled = false
			end
		end
	end
	Events.SVFlash:FireServer(WeaponTool,FlashLightActive)
	WeaponInHand.Handle.Click:play()
	UpdateGui()
end

function ADS(aimming)
	if WeaponData and WeaponInHand then

		if aimming then

			if SafeMode then
				SafeMode = false
				GunStance = 0
				IdleAnim()
				UpdateGui()
			end

			game:GetService('UserInputService').MouseDeltaSensitivity = (Sens/100)

			WeaponInHand.Handle.AimDown:Play()

			GunStance = 2
			Events.GunStance:FireServer(GunStance,AnimData)

		else
			game:GetService('UserInputService').MouseDeltaSensitivity = 1
			WeaponInHand.Handle.AimUp:Play()

			GunStance = 0
			Events.GunStance:FireServer(GunStance,AnimData)

		end
	end
end

function SetAimpart()
	if aimming then
		if AimPartMode == 1 then
			AimPartMode = 2
			if WeaponInHand:FindFirstChild('AimPart2') then
				CurAimpart = WeaponInHand:FindFirstChild('AimPart2')
			end 
		else
			AimPartMode = 1
			CurAimpart = WeaponInHand:FindFirstChild('AimPart')
		end
		--print("Set to Aimpart: "..AimPartMode)
	end
end

function Firemode()

	WeaponInHand.Handle.SafetyClick:Play()
	mouse1down = false

	---Semi Settings---		
	if WeaponData.ShootType == 1 and WeaponData.FireModes.Burst == true then
		WeaponData.ShootType = 2
	elseif WeaponData.ShootType == 1 and WeaponData.FireModes.Burst == false and WeaponData.FireModes.Auto == true then
		WeaponData.ShootType = 3
		---Burst Settings---
	elseif WeaponData.ShootType == 2 and WeaponData.FireModes.Auto == true then
		WeaponData.ShootType = 3
	elseif WeaponData.ShootType == 2 and WeaponData.FireModes.Semi == true and WeaponData.FireModes.Auto == false then
		WeaponData.ShootType = 1
		---Auto Settings---
	elseif WeaponData.ShootType == 3 and WeaponData.FireModes.Semi == true then
		WeaponData.ShootType = 1
	elseif WeaponData.ShootType == 3 and WeaponData.FireModes.Semi == false and WeaponData.FireModes.Burst == true then
		WeaponData.ShootType = 2
		---Explosive Settings---
	end
	UpdateGui()

end

function setup(Tool)

	if char and char:WaitForChild("Humanoid").Health > 0 and Tool ~= nil then
		CurrentlyEquippingTool = true
		User.MouseIconEnabled 	= false
		Player.CameraMode 			= Enum.CameraMode.LockFirstPerson

		WeaponTool 		= Tool
		WeaponData 		= require(Tool:WaitForChild("ACS_Settings"))
		AnimData 		= require(Tool:WaitForChild("ACS_Animations"))
		WeaponInHand 	= GunModels:WaitForChild(Tool.Name):Clone()
		WeaponInHand.PrimaryPart = WeaponInHand:WaitForChild("Handle")

		Events.Equip:FireServer(Tool,1,WeaponData,AnimData)

		ViewModel = ArmModel:WaitForChild("Arms"):Clone()
		ViewModel.Name = "Viewmodel"

		if char:FindFirstChild("Body Colors") ~= nil then
			local Colors = char:WaitForChild("Body Colors"):Clone()
			Colors.Parent = ViewModel
		end

		if char:FindFirstChild("Shirt") ~= nil then
			local Shirt = char:FindFirstChild("Shirt"):Clone()
			Shirt.Parent = ViewModel
		end

		AnimPart = Instance.new("Part",ViewModel)
		AnimPart.Size = Vector3.new(0.1,0.1,0.1)
		AnimPart.Anchored = true
		AnimPart.CanCollide = false
		AnimPart.Transparency = 1

		ViewModel.PrimaryPart = AnimPart

		LArmWeld = Instance.new("Motor6D",AnimPart)
		LArmWeld.Name = "LeftArm"
		LArmWeld.Part0 = AnimPart

		RArmWeld = Instance.new("Motor6D",AnimPart)
		RArmWeld.Name = "RightArm"
		RArmWeld.Part0 = AnimPart

		GunWeld = Instance.new("Motor6D",AnimPart)
		GunWeld.Name = "Handle"

		--setup arms to camera

		ViewModel.Parent = cam

		maincf = AnimData.MainCFrame
		guncf = AnimData.GunCFrame

		larmcf = AnimData.LArmCFrame
		rarmcf = AnimData.RArmCFrame


		LArm = ViewModel:WaitForChild("Left Arm")
		LArmWeld.Part1 = LArm
		LArmWeld.C0 = CFrame.new()
		LArmWeld.C1 = CFrame.new(1,-1,-5) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)):inverse()

		RArm = ViewModel:WaitForChild("Right Arm")
		RArmWeld.Part1 = RArm
		RArmWeld.C0 = CFrame.new()
		RArmWeld.C1 = CFrame.new(-1,-1,-5) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)):inverse()
		GunWeld.Part0 = RArm

		LArm.Anchored = false
		RArm.Anchored = false

		--setup weapon to camera
		ModTable.ZoomValue 		= WeaponData.Zoom
		ModTable.Zoom2Value 	= WeaponData.Zoom2
		IREnable 				= WeaponData.InfraRed


		CAS:BindAction("Fire", handleAction, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
		CAS:BindAction("ADS", handleAction, true, Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2) 
		CAS:BindAction("Reload", handleAction, true, Enum.KeyCode.R, Enum.KeyCode.ButtonB)
		CAS:BindAction("CycleAimpart", handleAction, false, Enum.KeyCode.T)
		
		CAS:BindAction("CycleLaser", handleAction, true, Enum.KeyCode.H)
		CAS:BindAction("CycleLight", handleAction, true, Enum.KeyCode.J)
		
		CAS:BindAction("CycleFiremode", handleAction, false, Enum.KeyCode.V)
		CAS:BindAction("CheckMag", handleAction, false, Enum.KeyCode.M)

		CAS:BindAction("ZeroDown", handleAction, false, Enum.KeyCode.LeftBracket)
		CAS:BindAction("ZeroUp", handleAction, false, Enum.KeyCode.RightBracket)

		loadAttachment(WeaponInHand)

		BSpread				= math.min(WeaponData.MinSpread * ModTable.MinSpread, WeaponData.MaxSpread * ModTable.MaxSpread)
		RecoilPower 		= math.min(WeaponData.MinRecoilPower * ModTable.MinRecoilPower, WeaponData.MaxRecoilPower * ModTable.MaxRecoilPower)

		Ammo = WeaponData.AmmoInGun
		StoredAmmo = WeaponData.StoredAmmo
		CurAimpart = WeaponInHand:FindFirstChild("AimPart")
		
		for index, Key in pairs(WeaponInHand:GetDescendants()) do
			if Key:IsA("BasePart") and Key.Name == "FlashPoint" then
				FlashLightAttachment = true
			end
			if Key:IsA("BasePart") and Key.Name == "LaserPoint" then
				LaserAttachment = true
			end
		end
		

		if WeaponData.EnableHUD then
			SE_GUI.GunHUD.Visible = true
		end
		UpdateGui()

		for index, key in pairs(WeaponInHand:GetChildren()) do
			if key:IsA('BasePart') and key.Name ~= 'Handle' then

				if key.Name ~= "Bolt" and key.Name ~= 'Lid' and key.Name ~= "Slide" then
					Ultil.Weld(WeaponInHand:WaitForChild("Handle"), key)
				end

				if key.Name == "Bolt" or key.Name == "Slide" then
					Ultil.WeldComplex(WeaponInHand:WaitForChild("Handle"), key, key.Name)
				end;

				if key.Name == "Lid" then
					if WeaponInHand:FindFirstChild('LidHinge') then
						Ultil.Weld(key, WeaponInHand:WaitForChild("LidHinge"))
					else
						Ultil.Weld(key, WeaponInHand:WaitForChild("Handle"))
					end
				end
			end
		end;

		for L_213_forvar1, L_214_forvar2 in pairs(WeaponInHand:GetChildren()) do
			if L_214_forvar2:IsA('BasePart') then
				L_214_forvar2.Anchored = false
				L_214_forvar2.CanCollide = false
			end
		end;

		if WeaponInHand:FindFirstChild("Nodes") then
			for L_213_forvar1, L_214_forvar2 in pairs(WeaponInHand.Nodes:GetChildren()) do
				if L_214_forvar2:IsA('BasePart') then
					Ultil.Weld(WeaponInHand:WaitForChild("Handle"), L_214_forvar2)
					L_214_forvar2.Anchored = false
					L_214_forvar2.CanCollide = false
				end
			end;
		end

		GunWeld.Part1 = WeaponInHand:WaitForChild("Handle")
		GunWeld.C1 = guncf

		--WeaponInHand:SetPrimaryPartCFrame( RArm.CFrame * guncf)

		WeaponInHand.Parent = ViewModel	
		if Ammo <= 0 and WeaponData.Type == "Gun" then
			WeaponInHand.Handle.Slide.C0 = WeaponData.SlideEx:inverse()
		end
		EquipAnim()
		if WeaponData and WeaponData.Type ~= "Grenade" then
			RunCheck()
		end

	end
end

function unset()
	CurrentlyEquippingTool = false
	Events.Equip:FireServer(WeaponTool,2)
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

	mouse1down = false
	aimming = false

	TS:Create(cam,AimTween,{FieldOfView = 70}):Play()

	User.MouseIconEnabled = true
	game:GetService('UserInputService').MouseDeltaSensitivity = 1
	cam.CameraType = Enum.CameraType.Custom
	Player.CameraMode = Enum.CameraMode.Classic


	if WeaponInHand then

		WeaponData.AmmoInGun = Ammo
		WeaponData.StoredAmmo = StoredAmmo

		ViewModel:Destroy()
		ViewModel 		= nil
		WeaponInHand	= nil
		WeaponTool		= nil
		LArm 			= nil
		RArm 			= nil
		LArmWeld 		= nil
		RArmWeld 		= nil
		WeaponData 		= nil
		AnimData		= nil
		SightAtt		= nil
		reticle			= nil
		BarrelAtt 		= nil
		UnderBarrelAtt 	= nil
		OtherAtt 		= nil
		LaserAttachment 		= false
		LaserActive		= false
		IRmode			= false
		FlashLightAttachment 		= false
		FlashLightActive 	= false
		BipodAtt 		= false
		BipodActive 	= false
		LaserDist 		= 0
		Pointer 		= nil
		BSpread 		= nil
		RecoilPower 	= nil
		Suppressor 		= false
		FlashHider 		= false
		CancelReload 	= false
		reloading 		= false
		SafeMode		= false
		CheckingMag		= false
		GRDebounce 		= false
		GunStance 		= 0
		resetMods()
		generateBullet 	= 1
		AimPartMode 	= 1

		SE_GUI.GunHUD.Visible = false
		SE_GUI.GrenadeForce.Visible = false
		BipodCF = CFrame.new()
		if gameRules.ReplicatedLaser then
			Events.SVLaser:FireServer(nil,2,nil,false,WeaponTool)
		end
	end
end

local HalfStep = false
function HeadMovement()
	if char.Humanoid.Health > 0 then
		local CameraDirection = char.HumanoidRootPart.CFrame:toObjectSpace(cam.CFrame).lookVector
		if Neck then
			if char.Humanoid.RigType == Enum.HumanoidRigType.R15 and char.Humanoid.Health > 0 and char.Humanoid.PlatformStand == false then
				HalfStep = not HalfStep
				local neckCFrame = CFNew(0, YOffset, 0) * CFAng(-Asin(char.UpperTorso.CFrame.lookVector.Y), -Asin(CameraDirection.X/1.15), 0) * CFAng(Asin(CameraDirection.Y), 0, 0)
				TS:Create(Neck, TweenInfo.new(.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {C0 = neckCFrame}):Play()
				if HalfStep then
					Events.HeadRot:FireServer(neckCFrame)
				end
			end
		end
	end
end

function renderCam()			
	cam.CFrame = cam.CFrame*CFrame.Angles(cameraspring.p.x,cameraspring.p.y,cameraspring.p.z)
end

function renderGunRecoil()			
	recoilcf = recoilcf*CFrame.Angles(RecoilSpring.p.x,RecoilSpring.p.y,RecoilSpring.p.z)
end

function Recoil()
	local vr = (math.random(WeaponData.camRecoil.camRecoilUp[1], WeaponData.camRecoil.camRecoilUp[2])/2) * ModTable.camRecoilMod.RecoilUp
	local lr = (math.random(WeaponData.camRecoil.camRecoilLeft[1], WeaponData.camRecoil.camRecoilLeft[2])) * ModTable.camRecoilMod.RecoilLeft
	local rr = (math.random(WeaponData.camRecoil.camRecoilRight[1], WeaponData.camRecoil.camRecoilRight[2])) * ModTable.camRecoilMod.RecoilRight
	local hr = (math.random(-rr, lr)/2)
	local tr = (math.random(WeaponData.camRecoil.camRecoilTilt[1], WeaponData.camRecoil.camRecoilTilt[2])/2) * ModTable.camRecoilMod.RecoilTilt

	local RecoilX = math.rad(vr * RAND( 1, 1, .1))
	local RecoilY = math.rad(hr * RAND(-1, 1, .1))
	local RecoilZ = math.rad(tr * RAND(-1, 1, .1))

	local gvr = (math.random(WeaponData.gunRecoil.gunRecoilUp[1], WeaponData.gunRecoil.gunRecoilUp[2]) /10) * ModTable.gunRecoilMod.RecoilUp
	local gdr = (math.random(-1,1) * math.random(WeaponData.gunRecoil.gunRecoilTilt[1], WeaponData.gunRecoil.gunRecoilTilt[2]) /10) * ModTable.gunRecoilMod.RecoilTilt
	local glr = (math.random(WeaponData.gunRecoil.gunRecoilLeft[1], WeaponData.gunRecoil.gunRecoilLeft[2])) * ModTable.gunRecoilMod.RecoilLeft
	local grr = (math.random(WeaponData.gunRecoil.gunRecoilRight[1], WeaponData.gunRecoil.gunRecoilRight[2])) * ModTable.gunRecoilMod.RecoilRight

	local ghr = (math.random(-grr, glr)/10)	

	local ARR = WeaponData.AimRecoilReduction * ModTable.AimRM

	if BipodActive then
		cameraspring:accelerate(Vector3.new( RecoilX, RecoilY/2, 0 ))

		if not aimming then
			RecoilSpring:accelerate(Vector3.new( math.rad(.25 * gvr * RecoilPower), math.rad(.25 * ghr * RecoilPower), math.rad(.25 * gdr)))
			recoilcf = recoilcf * CFrame.new(0,0,.1) * CFrame.Angles( math.rad(.25 * gvr * RecoilPower ),math.rad(.25 * ghr * RecoilPower ),math.rad(.25 * gdr * RecoilPower ))

		else
			RecoilSpring:accelerate(Vector3.new( math.rad( .25 * gvr * RecoilPower/ARR) , math.rad(.25 * ghr * RecoilPower/ARR), math.rad(.25 * gdr/ ARR)))
			recoilcf = recoilcf * CFrame.new(0,0,.1) * CFrame.Angles( math.rad(.25 * gvr * RecoilPower/ARR ),math.rad(.25 * ghr * RecoilPower/ARR ),math.rad(.25 * gdr * RecoilPower/ARR ))
		end

		Thread:Wait(0.05)
		cameraspring:accelerate(Vector3.new(-RecoilX, -RecoilY/2, 0))

	else
		cameraspring:accelerate(Vector3.new( RecoilX , RecoilY, RecoilZ ))
		if not aimming then
			RecoilSpring:accelerate(Vector3.new( math.rad(gvr * RecoilPower), math.rad(ghr * RecoilPower), math.rad(gdr)))
			recoilcf = recoilcf * CFrame.new(0,-0.05,.1) * CFrame.Angles( math.rad( gvr * RecoilPower ),math.rad( ghr * RecoilPower ),math.rad( gdr * RecoilPower ))

		else
			RecoilSpring:accelerate(Vector3.new( math.rad(gvr * RecoilPower/ARR) , math.rad(ghr * RecoilPower/ARR), math.rad(gdr/ ARR)))
			recoilcf = recoilcf * CFrame.new(0,0,.1) * CFrame.Angles( math.rad( gvr * RecoilPower/ARR ),math.rad( ghr * RecoilPower/ARR ),math.rad( gdr * RecoilPower/ARR ))
		end
	end
end

function CheckForHumanoid(L_225_arg1)
	local L_226_ = false
	local L_227_ = nil
	if L_225_arg1 then
		if (L_225_arg1.Parent:FindFirstChildOfClass("Humanoid") or L_225_arg1.Parent.Parent:FindFirstChildOfClass("Humanoid")) then
			L_226_ = true
			if L_225_arg1.Parent:FindFirstChildOfClass('Humanoid') then
				L_227_ = L_225_arg1.Parent:FindFirstChildOfClass('Humanoid')
			elseif L_225_arg1.Parent.Parent:FindFirstChildOfClass('Humanoid') then
				L_227_ = L_225_arg1.Parent.Parent:FindFirstChildOfClass('Humanoid')
			end
		else
			L_226_ = false
		end	
	end
	return L_226_, L_227_
end

function CastRay(Bullet, Origin)
	if Bullet then

		local Bpos = Bullet.Position
		local Bpos2 = cam.CFrame.Position

		local recast = false
		local TotalDistTraveled = 0
		local Debounce = false
		local raycastResult

		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = Ignore_Model
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		raycastParams.IgnoreWater = true

		while Bullet do
			Run.Heartbeat:Wait()
			if Bullet.Parent ~= nil then
				Bpos = Bullet.Position
				TotalDistTraveled = (Bullet.Position - Origin).Magnitude

				if TotalDistTraveled > 7000 then
					Bullet:Destroy()
					Debounce = true
					break
				end

				for _, player in pairs(game.Players:GetChildren()) do
					if not Debounce and player:IsA('Player') and player ~= Player and player.Character and player.Character:FindFirstChild('Head') ~= nil and (player.Character.Head.Position - Bpos).magnitude <= 25 then
						Events.Whizz:FireServer(player)
						Events.Suppression:FireServer(player,1,nil,nil)
						Debounce = true
					end
				end

				-- Set an origin and directional vector
				raycastResult = workspace:Raycast(Bpos2, (Bpos - Bpos2) * 1, raycastParams)

				recast = false

				if raycastResult then
					local Hit2 = raycastResult.Instance

					if Hit2 and Hit2.Parent:IsA('Accessory') or Hit2.Parent:IsA('Hat') then
						for _,players in pairs(game.Players:GetPlayers()) do
							if players.Character then
								for i, hats in pairs(players.Character:GetChildren()) do
									if hats:IsA("Accessory") then
										table.insert(Ignore_Model, hats)
									end
								end
							end
						end
						recast = true
						CastRay(Bullet, Origin)
						break
					end
					
					if Hit2 and Hit2.Name == "Ignorable" or Hit2.Name == "Glass" or Hit2.Name == "Ignore" or Hit2.Parent.Name == "Top" or Hit2.Parent.Name == "Helmet" or Hit2.Parent.Name == "Up" or Hit2.Parent.Name == "Down" or Hit2.Parent.Name == "Face" or Hit2.Parent.Name == "Olho" or Hit2.Parent.Name == "Headset" or Hit2.Parent.Name == "Numero" or Hit2.Parent.Name == "Vest" or Hit2.Parent.Name == "Chest" or Hit2.Parent.Name == "Waist" or Hit2.Parent.Name == "Back" or Hit2.Parent.Name == "Belt" or Hit2.Parent.Name == "Leg1" or Hit2.Parent.Name == "Leg2" or Hit2.Parent.Name == "Arm1"  or Hit2.Parent.Name == "Arm2" then
						table.insert(Ignore_Model, Hit2)
						recast = true
						CastRay(Bullet, Origin)
						break
					end
					
					if Hit2 and Hit2.Parent.Name == "Top" or Hit2.Parent.Name == "Helmet" or Hit2.Parent.Name == "Up" or Hit2.Parent.Name == "Down" or Hit2.Parent.Name == "Face" or Hit2.Parent.Name == "Olho" or Hit2.Parent.Name == "Headset" or Hit2.Parent.Name == "Numero" or Hit2.Parent.Name == "Vest" or Hit2.Parent.Name == "Chest" or Hit2.Parent.Name == "Waist" or Hit2.Parent.Name == "Back" or Hit2.Parent.Name == "Belt" or Hit2.Parent.Name == "Leg1" or Hit2.Parent.Name == "Leg2" or Hit2.Parent.Name == "Arm1"  or Hit2.Parent.Name == "Arm2" then
						table.insert(Ignore_Model, Hit2.Parent)
						recast = true
						CastRay(Bullet, Origin)
						break
					end

					if Hit2 and (Hit2.Transparency >= 1 or Hit2.CanCollide == false) and Hit2.Name ~= 'Head' and Hit2.Name ~= 'Right Arm' and Hit2.Name ~= 'Left Arm' and Hit2.Name ~= 'Right Leg' and Hit2.Name ~= 'Left Leg' and Hit2.Name ~= "UpperTorso" and Hit2.Name ~= "LowerTorso" and Hit2.Name ~= "RightUpperArm" and Hit2.Name ~= "RightLowerArm" and Hit2.Name ~= "RightHand" and Hit2.Name ~= "LeftUpperArm" and Hit2.Name ~= "LeftLowerArm" and Hit2.Name ~= "LeftHand" and Hit2.Name ~= "RightUpperLeg" and Hit2.Name ~= "RightLowerLeg" and Hit2.Name ~= "RightFoot" and Hit2.Name ~= "LeftUpperLeg" and Hit2.Name ~= "LeftLowerLeg" and Hit2.Name ~= "LeftFoot" and Hit2.Name ~= 'Armor' and Hit2.Name ~= 'EShield' then
						table.insert(Ignore_Model, Hit2)
						recast = true
						CastRay(Bullet, Origin)
						break
					end

					if not recast then

						Bullet:Destroy()
						Debounce = true

						local FoundHuman,VitimaHuman = CheckForHumanoid(raycastResult.Instance)
						HitMod.HitEffect(Ignore_Model, raycastResult.Position, raycastResult.Instance , raycastResult.Normal, raycastResult.Material, WeaponData)
						Events.HitEffect:FireServer(raycastResult.Position, raycastResult.Instance , raycastResult.Normal, raycastResult.Material, WeaponData)
						
						local HitPart = raycastResult.Instance
						TotalDistTraveled = (raycastResult.Position - Origin).Magnitude

						if FoundHuman == true and VitimaHuman.Health > 0 and WeaponData then
							local SKP_02 = SKP_01.."-"..Player.UserId

							if HitPart.Name == "Head" or HitPart.Parent.Name == "Top" or HitPart.Parent.Name == "Headset" or HitPart.Parent.Name == "Olho" or HitPart.Parent.Name == "Face" or HitPart.Parent.Name == "Numero" then
								Events.Damage:InvokeServer(WeaponTool, VitimaHuman, TotalDistTraveled, 1, WeaponData, ModTable, nil, nil, SKP_02)
							elseif HitPart.Name == "Torso" or HitPart.Name == "UpperTorso" or HitPart.Name == "LowerTorso" or HitPart.Parent.Name == "Chest" or HitPart.Parent.Name == "Waist" or HitPart.Name == "Right Arm" or HitPart.Name == "Left Arm" or HitPart.Name == "RightUpperArm" or HitPart.Name == "RightLowerArm" or HitPart.Name == "RightHand" or HitPart.Name == "LeftUpperArm" or HitPart.Name == "LeftLowerArm" or HitPart.Name == "LeftHand" then				
								Events.Damage:InvokeServer(WeaponTool, VitimaHuman, TotalDistTraveled, 2, WeaponData, ModTable, nil, nil, SKP_02)
							elseif HitPart.Name == "Right Leg" or HitPart.Name == "Left Leg" or HitPart.Name == "RightUpperLeg" or HitPart.Name == "RightLowerLeg" or HitPart.Name == "RightFoot" or HitPart.Name == "LeftUpperLeg" or HitPart.Name == "LeftLowerLeg" or HitPart.Name == "LeftFoot" then
								Events.Damage:InvokeServer(WeaponTool, VitimaHuman, TotalDistTraveled, 3, WeaponData, ModTable, nil, nil, SKP_02)		
							end	
						end
					end
					break
				end

				Bpos2 = Bpos
			else
				break
			end
		end
	end
end

local Tracers = 0
function TracerCalculation()
	if WeaponData.Tracer or WeaponData.BulletFlare then
		if WeaponData.RandomTracer.Enabled then
			if (math.random(1, 100) <= WeaponData.RandomTracer.Chance) then	
				return true
			else
				return false
			end
		else
			if Tracers >= WeaponData.TracerEveryXShots then
				Tracers = 0
				return true
			else
				Tracers = Tracers + 1
				return false
			end
		end
	end
end

function CreateBullet()

	local Bullet = Instance.new("Part",ACS_Workspace.Client)
	Bullet.Name = Player.Name.."_Bullet"
	Bullet.CanCollide = false
	Bullet.Shape = Enum.PartType.Ball
	Bullet.Transparency = 1
	Bullet.Size = Vector3.new(1,1,1)

	local Origin 		= WeaponInHand.Handle.Muzzle.WorldPosition
	local Direction 	= WeaponInHand.Handle.Muzzle.WorldCFrame.LookVector + (WeaponInHand.Handle.Muzzle.WorldCFrame.UpVector * (((WeaponData.BulletDrop * WeaponData.CurrentZero/4)/WeaponData.MuzzleVelocity))/2)
	local BulletCF 		= CFrame.new(Origin, Direction) 
	local WalkMul 		= WeaponData.WalkMult * ModTable.WalkMult
	local BColor 		= Color3.fromRGB(255,255,255)
	local balaspread

	if aimming and WeaponData.Bullets <= 1 then
		balaspread = CFrame.Angles(
			math.rad(RAND(-BSpread - (charspeed/1) * WalkMul, BSpread + (charspeed/1) * WalkMul) / (10 * WeaponData.AimSpreadReduction)),
			math.rad(RAND(-BSpread - (charspeed/1) * WalkMul, BSpread + (charspeed/1) * WalkMul) / (10 * WeaponData.AimSpreadReduction)),
			math.rad(RAND(-BSpread - (charspeed/1) * WalkMul, BSpread + (charspeed/1) * WalkMul) / (10 * WeaponData.AimSpreadReduction))
		)
	else
		balaspread = CFrame.Angles(
			math.rad(RAND(-BSpread - (charspeed/1) * WalkMul, BSpread + (charspeed/1) * WalkMul) / 10),
			math.rad(RAND(-BSpread - (charspeed/1) * WalkMul, BSpread + (charspeed/1) * WalkMul) / 10),
			math.rad(RAND(-BSpread - (charspeed/1) * WalkMul, BSpread + (charspeed/1) * WalkMul) / 10)
		)
	end

	Direction = balaspread * Direction

	local tracerIsVisible = TracerCalculation()

	if WeaponData.RainbowMode then
		BColor = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
	else
		BColor = WeaponData.TracerColor
	end

	if tracerIsVisible then
		if gameRules.ReplicatedBullets then
			Events.ServerBullet:FireServer(Origin,Direction,WeaponData,ModTable)
		end

		if WeaponData.Tracer == true then

			local At1 = Instance.new("Attachment")
			At1.Name = "At1"
			At1.Position = Vector3.new(-(.05),0,0)
			At1.Parent = Bullet

			local At2  = Instance.new("Attachment")
			At2.Name = "At2"
			At2.Position = Vector3.new((.05),0,0)
			At2.Parent = Bullet

			local Particles = Instance.new("Trail")
			Particles.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0, 0);
				NumberSequenceKeypoint.new(1, 1);
			}
			)
			Particles.WidthScale = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 2, 0);
				NumberSequenceKeypoint.new(1, 1);
			}
			)


			Particles.Color = ColorSequence.new(BColor)
			Particles.Texture = "rbxassetid://232918622"
			Particles.TextureMode = Enum.TextureMode.Stretch

			Particles.FaceCamera = true
			Particles.LightEmission = 1
			Particles.LightInfluence = 0
			Particles.Lifetime = .25
			Particles.Attachment0 = At1
			Particles.Attachment1 = At2
			Particles.Parent = Bullet
		end

		if WeaponData.BulletFlare == true then
			local bg = Instance.new("BillboardGui", Bullet)
			bg.Adornee = Bullet
			bg.Enabled = false
			local flashsize = math.random(275, 375)/10
			bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
			bg.LightInfluence = 0
			local flash = Instance.new("ImageLabel", bg)
			flash.BackgroundTransparency = 1
			flash.Size = UDim2.new(1, 0, 1, 0)
			flash.Position = UDim2.new(0, 0, 0, 0)
			flash.Image = "http://www.roblox.com/asset/?id=1047066405"
			flash.ImageTransparency = math.random(2, 5)/15
			flash.ImageColor3 = BColor

			task.spawn(function()
				task.wait(.1)
				if Bullet:FindFirstChild("BillboardGui") ~= nil then
					Bullet.BillboardGui.Enabled = true
				end
			end)
		end

	end

	local BulletMass = Bullet:GetMass()
	local Force = Vector3.new(0,BulletMass * (196.2) - (WeaponData.BulletDrop) * (196.2), 0)
	local BF = Instance.new("BodyForce",Bullet)

	Bullet.CFrame = BulletCF
	Bullet:ApplyImpulse(Direction * WeaponData.MuzzleVelocity * ModTable.MuzzleVelocity)
	BF.Force = Force

	game.Debris:AddItem(Bullet, 5)

	CastRay(Bullet, Origin)
end


function meleeCast()

	local recast
	-- Set an origin and directional vector
	local rayOrigin 	= cam.CFrame.Position
	local rayDirection 	= cam.CFrame.LookVector * WeaponData.BladeRange

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = Ignore_Model
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.IgnoreWater = true
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)


	if raycastResult then
		local Hit2 = raycastResult.Instance

		--Check if it's a hat or accessory
		if Hit2 and Hit2.Parent:IsA('Accessory') or Hit2.Parent:IsA('Hat') then

			for _,players in pairs(game.Players:GetPlayers()) do
				if players.Character then
					for i, hats in pairs(players.Character:GetChildren()) do
						if hats:IsA("Accessory") then
							table.insert(Ignore_Model, hats)
						end
					end
				end
			end

			return meleeCast()
		end

		if Hit2 and Hit2.Name == "Ignorable" or Hit2.Name == "Glass" or Hit2.Name == "Ignore" or Hit2.Parent.Name == "Top" or Hit2.Parent.Name == "Helmet" or Hit2.Parent.Name == "Up" or Hit2.Parent.Name == "Down" or Hit2.Parent.Name == "Face" or Hit2.Parent.Name == "Olho" or Hit2.Parent.Name == "Headset" or Hit2.Parent.Name == "Numero" or Hit2.Parent.Name == "Vest" or Hit2.Parent.Name == "Chest" or Hit2.Parent.Name == "Waist" or Hit2.Parent.Name == "Back" or Hit2.Parent.Name == "Belt" or Hit2.Parent.Name == "Leg1" or Hit2.Parent.Name == "Leg2" or Hit2.Parent.Name == "Arm1"  or Hit2.Parent.Name == "Arm2" then
			table.insert(Ignore_Model, Hit2)
			return meleeCast()
		end

		if Hit2 and Hit2.Parent.Name == "Top" or Hit2.Parent.Name == "Helmet" or Hit2.Parent.Name == "Up" or Hit2.Parent.Name == "Down" or Hit2.Parent.Name == "Face" or Hit2.Parent.Name == "Olho" or Hit2.Parent.Name == "Headset" or Hit2.Parent.Name == "Numero" or Hit2.Parent.Name == "Vest" or Hit2.Parent.Name == "Chest" or Hit2.Parent.Name == "Waist" or Hit2.Parent.Name == "Back" or Hit2.Parent.Name == "Belt" or Hit2.Parent.Name == "Leg1" or Hit2.Parent.Name == "Leg2" or Hit2.Parent.Name == "Arm1"  or Hit2.Parent.Name == "Arm2" then
			table.insert(Ignore_Model, Hit2.Parent)
			return meleeCast()
		end

		if Hit2 and (Hit2.Transparency >= 1 or Hit2.CanCollide == false) and Hit2.Name ~= 'Head' and Hit2.Name ~= 'Right Arm' and Hit2.Name ~= 'Left Arm' and Hit2.Name ~= 'Right Leg' and Hit2.Name ~= 'Left Leg' and Hit2.Name ~= "UpperTorso" and Hit2.Name ~= "LowerTorso" and Hit2.Name ~= "RightUpperArm" and Hit2.Name ~= "RightLowerArm" and Hit2.Name ~= "RightHand" and Hit2.Name ~= "LeftUpperArm" and Hit2.Name ~= "LeftLowerArm" and Hit2.Name ~= "LeftHand" and Hit2.Name ~= "RightUpperLeg" and Hit2.Name ~= "RightLowerLeg" and Hit2.Name ~= "RightFoot" and Hit2.Name ~= "LeftUpperLeg" and Hit2.Name ~= "LeftLowerLeg" and Hit2.Name ~= "LeftFoot" and Hit2.Name ~= 'Armor' and Hit2.Name ~= 'EShield' then
			table.insert(Ignore_Model, Hit2)
			return meleeCast()
		end
	end


	if raycastResult then
		local FoundHuman,VitimaHuman = CheckForHumanoid(raycastResult.Instance)
		HitMod.HitEffect(Ignore_Model, raycastResult.Position, raycastResult.Instance , raycastResult.Normal, raycastResult.Material, WeaponData)
		Events.HitEffect:FireServer(raycastResult.Position, raycastResult.Instance , raycastResult.Normal, raycastResult.Material, WeaponData)

		local HitPart = raycastResult.Instance

		if FoundHuman == true and VitimaHuman.Health > 0 then
			local SKP_02 = SKP_01.."-"..Player.UserId

			if HitPart.Name == "Head" or HitPart.Parent.Name == "Top" or HitPart.Parent.Name == "Headset" or HitPart.Parent.Name == "Olho" or HitPart.Parent.Name == "Face" or HitPart.Parent.Name == "Numero" then
				Thread:Spawn(function()
					Events.Damage:InvokeServer(WeaponTool, VitimaHuman, 0, 1, WeaponData, ModTable, nil, nil, SKP_02)	
				end)

			elseif HitPart.Name == "Torso" or HitPart.Name == "UpperTorso" or HitPart.Name == "LowerTorso" or HitPart.Parent.Name == "Chest" or HitPart.Parent.Name == "Waist" or HitPart.Name == "RightUpperArm" or HitPart.Name == "RightLowerArm" or HitPart.Name == "RightHand" or HitPart.Name == "LeftUpperArm" or HitPart.Name == "LeftLowerArm" or HitPart.Name == "LeftHand" then
				Thread:Spawn(function()
					Events.Damage:InvokeServer(WeaponTool, VitimaHuman, 0, 2, WeaponData, ModTable, nil, nil, SKP_02)	
				end)

			elseif HitPart.Name == "Right Arm" or HitPart.Name == "Right Leg" or HitPart.Name == "Left Leg" or HitPart.Name == "Left Arm" or HitPart.Name == "RightUpperLeg" or HitPart.Name == "RightLowerLeg" or HitPart.Name == "RightFoot" or HitPart.Name == "LeftUpperLeg" or HitPart.Name == "LeftLowerLeg" or HitPart.Name == "LeftFoot" then
				Thread:Spawn(function()
					Events.Damage:InvokeServer(WeaponTool, VitimaHuman, 0, 3, WeaponData, ModTable, nil, nil, SKP_02)	
				end)

			end
		end			
	end
end

function UpdateGui()
	if SE_GUI then
		local HUD = SE_GUI.GunHUD

		if WeaponData ~= nil then

			--[[if Settings.ArcadeMode == true then
				HUD.Ammo.Visible = true
				HUD.Ammo.AText.Text = Ammo.Value.."|"..Settings.Ammo
			else
				HUD.Ammo.Visible = false
			end]]

			--[[if Settings.FireModes.Explosive == true and GLChambered.Value == true then
				HUD.E.ImageColor3 = Color3.fromRGB(255,255,255)
				HUD.E.Visible = true
			elseif Settings.FireModes.Explosive == true and GLChambered.Value == false then
				HUD.E.ImageColor3 = Color3.fromRGB(255,0,0)
				HUD.E.Visible = true
			elseif Settings.FireModes.Explosive == false then
				HUD.E.Visible = false
			end]]

			if WeaponData.Jammed then
				HUD.B.BackgroundColor3 = Color3.fromRGB(255,0,0)
			else
				HUD.B.BackgroundColor3 = Color3.fromRGB(255,255,255)
			end

			if SafeMode then
				HUD.A.Visible = true
			else
				HUD.A.Visible = false
			end

			if Ammo > 0 then
				HUD.B.Visible = true
			else
				HUD.B.Visible = false
			end

			if WeaponData.ShootType == 1 then
				HUD.FText.Text = "Semi"
			elseif WeaponData.ShootType == 2 then
				HUD.FText.Text = "Burst"
			elseif WeaponData.ShootType == 3 then
				HUD.FText.Text = "Auto"
			elseif WeaponData.ShootType == 4 then
				HUD.FText.Text = "Pump-Action"
			elseif WeaponData.ShootType == 5 then
				HUD.FText.Text = "Bolt-Action"
			end

			HUD.Sens.Text = (Sens/100)
			HUD.BText.Text = WeaponData.BulletType
			HUD.NText.Text = WeaponData.gunName

			if WeaponData.EnableZeroing then
				HUD.ZeText.Visible = true
				HUD.ZeText.Text = WeaponData.CurrentZero .." m"
			else
				HUD.ZeText.Visible = false
			end

			if WeaponData.MagCount then
				HUD.SAText.Text = math.ceil(StoredAmmo/WeaponData.Ammo)
				HUD.Magazines.Visible = true
				HUD.Bullets.Visible = false
			else
				HUD.SAText.Text = StoredAmmo
				HUD.Magazines.Visible = false
				HUD.Bullets.Visible = true
			end

			if Suppressor then
				HUD.Att.Silencer.Visible = true
			else
				HUD.Att.Silencer.Visible = false
			end


			if LaserAttachment then
				HUD.Att.Laser.Visible = true
				if LaserActive then
					if IRmode then
						TS:Create(HUD.Att.Laser, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(0,255,0), ImageTransparency = .123}):Play()
					else
						TS:Create(HUD.Att.Laser, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,255,255), ImageTransparency = .123}):Play()
					end
				else
					TS:Create(HUD.Att.Laser, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,0,0), ImageTransparency = .5}):Play()
				end
			else
				HUD.Att.Laser.Visible = false
			end

			if BipodAtt then
				HUD.Att.Bipod.Visible = true
			else
				HUD.Att.Bipod.Visible = false
			end

			if FlashLightAttachment then
				HUD.Att.Flash.Visible = true
				if FlashLightActive then
					TS:Create(HUD.Att.Flash, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,255,255), ImageTransparency = .123}):Play()
				else
					TS:Create(HUD.Att.Flash, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,0,0), ImageTransparency = .5}):Play()
				end
			else
				HUD.Att.Flash.Visible = false
			end

			if WeaponData.Type == "Grenade" then
				SE_GUI.GrenadeForce.Visible = true
			else
				SE_GUI.GrenadeForce.Visible = false
			end
		end
	end
end

function CheckMagFunction()

	if aimming then
		aimming = false
		ADS(aimming)
	end

	if SE_GUI then
		local HUD = SE_GUI.GunHUD

		TS:Create(HUD.CMText,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,0),{TextTransparency = 0,TextStrokeTransparency = 0.75}):Play()

		if Ammo >= WeaponData.Ammo then
			HUD.CMText.Text = "Full"
		elseif Ammo > math.floor((WeaponData.Ammo)*.75) and Ammo < WeaponData.Ammo then
			HUD.CMText.Text = "Nearly full"
		elseif Ammo < math.floor((WeaponData.Ammo)*.75) and Ammo > math.floor((WeaponData.Ammo)*.5) then
			HUD.CMText.Text = "Almost half"
		elseif Ammo == math.floor((WeaponData.Ammo)*.5) then
			HUD.CMText.Text = "Half"
		elseif Ammo > math.ceil((WeaponData.Ammo)*.25) and Ammo <  math.floor((WeaponData.Ammo)*.5) then
			HUD.CMText.Text = "Less than half"
		elseif Ammo < math.ceil((WeaponData.Ammo)*.25) and Ammo > 0 then
			HUD.CMText.Text = "Almost empty"
		elseif Ammo == 0 then
			HUD.CMText.Text = "Empty"
		end

		task.delay(.25,function()
			TS:Create(HUD.CMText,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,5),{TextTransparency = 1,TextStrokeTransparency = 1}):Play()
		end)
	end
	mouse1down 	= false
	SafeMode 	= false
	GunStance 	= 0
	Events.GunStance:FireServer(GunStance,AnimData)
	UpdateGui()
	MagCheckAnim()
	RunCheck()
end

function Grenade()
	if not GRDebounce then
		GRDebounce = true
		GrenadeReady()

		TossGrenade()
	end
end

function TossGrenade()
	if WeaponTool and WeaponData and GRDebounce == true then
		local SKP_02 = SKP_01.."-"..Player.UserId
		GrenadeThrow()
		if WeaponTool and WeaponData then
			Events.Grenade:FireServer(WeaponTool,WeaponData,cam.CFrame,cam.CFrame.LookVector,Power,SKP_02)
			unset()
		end
	end
end

function GrenadeMode()
	if Power >= 150 then
		Power = 100
		SE_GUI.GrenadeForce.Text = "Mid Throw"
	elseif Power >= 100 then
		Power = 50
		SE_GUI.GrenadeForce.Text = "Low Throw"
	elseif Power >= 50 then
		Power = 150
		SE_GUI.GrenadeForce.Text = "High Throw"
	end
end

function JamChance()
	if WeaponData.CanBreak == true and not WeaponData.Jammed and Ammo - 1 > 0 then
		local Jam = math.random(1000)
		if Jam <= 2 then
			WeaponData.Jammed = true
			WeaponInHand.Handle.Click:Play()
		end
	end
end

function Jammed()
	if WeaponData.Type == "Gun" and WeaponData.Jammed then

		mouse1down = false
		reloading = true
		SafeMode = false
		GunStance = 0
		Events.GunStance:FireServer(GunStance,AnimData)
		UpdateGui()

		JammedAnim()
		WeaponData.Jammed = false
		UpdateGui()
		reloading = false
		RunCheck()
	end
end

function Reload()
	if WeaponData.Type == "Gun" and StoredAmmo > 0 and (Ammo < WeaponData.Ammo or WeaponData.IncludeChamberedBullet and Ammo < WeaponData.Ammo + 1) then

		mouse1down = false
		reloading = true
		SafeMode = false
		GunStance = 0
		Events.GunStance:FireServer(GunStance,AnimData)
		UpdateGui()

		if WeaponData.ShellInsert then
			if Ammo > 0 then
				for i = 1,WeaponData.Ammo - Ammo do
					if StoredAmmo > 0 and Ammo < WeaponData.Ammo then
						if CancelReload then
							break
						end
						ReloadAnim()
						Ammo = Ammo + 1
						StoredAmmo = StoredAmmo - 1
						UpdateGui()
					end
				end
			else
				TacticalReloadAnim()
				Ammo = Ammo + 1
				StoredAmmo = StoredAmmo - 1
				UpdateGui()
				for i = 1,WeaponData.Ammo - Ammo do
					if StoredAmmo > 0 and Ammo < WeaponData.Ammo then
						if CancelReload then
							break
						end
						ReloadAnim()
						Ammo = Ammo + 1
						StoredAmmo = StoredAmmo - 1
						UpdateGui()
					end
				end

			end
		else
			if Ammo > 0 then
				ReloadAnim()
			else
				TacticalReloadAnim()
			end

			if (Ammo - (WeaponData.Ammo - StoredAmmo)) < 0 then
				Ammo = Ammo + StoredAmmo
				StoredAmmo = 0

			elseif Ammo <= 0 then
				StoredAmmo = StoredAmmo - (WeaponData.Ammo - Ammo)
				Ammo = WeaponData.Ammo

			elseif Ammo > 0 and WeaponData.IncludeChamberedBullet then
				StoredAmmo = StoredAmmo - (WeaponData.Ammo - Ammo) - 1
				Ammo = WeaponData.Ammo + 1

			elseif Ammo > 0 and not WeaponData.IncludeChamberedBullet then
				StoredAmmo = StoredAmmo - (WeaponData.Ammo - Ammo)
				Ammo = WeaponData.Ammo
			end
		end
		CancelReload = false
		reloading = false
		RunCheck()
		UpdateGui()
	end
end

function GunFx()
	if Suppressor == true then
		WeaponInHand.Handle.Muzzle.Supressor:Play()
	else
		WeaponInHand.Handle.Muzzle.Fire:Play()
	end

	if FlashHider == true then
		WeaponInHand.Handle.Muzzle["Smoke"]:Emit(10)
	else
		WeaponInHand.Handle.Muzzle["FlashFX[Flash]"]:Emit(10)
		WeaponInHand.Handle.Muzzle["Smoke"]:Emit(10)
	end

	if BSpread then
		BSpread = math.min(WeaponData.MaxSpread * ModTable.MaxSpread, BSpread + WeaponData.AimInaccuracyStepAmount * ModTable.AimInaccuracyStepAmount)
		RecoilPower =  math.min(WeaponData.MaxRecoilPower * ModTable.MaxRecoilPower, RecoilPower + WeaponData.RecoilPowerStepAmount * ModTable.RecoilPowerStepAmount)
	end

	generateBullet = generateBullet + 1
	LastSpreadUpdate = time()

	if Ammo > 0 or not WeaponData.SlideLock then
		TS:Create( WeaponInHand.Handle.Slide, TweenInfo.new(30/WeaponData.ShootRate,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,true,0), {C0 =  WeaponData.SlideEx:inverse() }):Play()
	elseif Ammo <= 0 and WeaponData.SlideLock then
		TS:Create( WeaponInHand.Handle.Slide, TweenInfo.new(30/WeaponData.ShootRate,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,0), {C0 =  WeaponData.SlideEx:inverse() }):Play()
	end
	WeaponInHand.Handle.Chamber.Smoke:Emit(10)
	WeaponInHand.Handle.Chamber.Shell:Emit(1)
end

function Shoot()
	if WeaponData and WeaponData.Type == "Gun" and not shooting and not reloading then

		if reloading or runKeyDown or SafeMode or CheckingMag then
			mouse1down = false
			return
		end

		if Ammo <= 0 or WeaponData.Jammed then
			WeaponInHand.Handle.Click:Play()
			mouse1down = false
			return
		end

		mouse1down = true

		task.delay(0, function()
			if WeaponData and WeaponData.ShootType == 1 then 
				shooting = true	
				Events.Atirar:FireServer(WeaponTool,Suppressor,FlashHider)
				for _ =  1, WeaponData.Bullets do
					Thread:Spawn(CreateBullet)
				end
				Ammo = Ammo - 1
				GunFx()
				JamChance()
				UpdateGui()
				Thread:Spawn(Recoil)
				task.wait(60/WeaponData.ShootRate)
				shooting = false

			elseif WeaponData and WeaponData.ShootType == 2 then
				for i = 1, WeaponData.BurstShot do
					if shooting or Ammo <= 0 or mouse1down == false or WeaponData.Jammed then
						break
					end
					shooting = true	
					Events.Atirar:FireServer(WeaponTool,Suppressor,FlashHider)
					for _ =  1, WeaponData.Bullets do
						Thread:Spawn(CreateBullet)
					end
					Ammo = Ammo - 1
					GunFx()
					JamChance()
					UpdateGui()
					Thread:Spawn(Recoil)
					task.wait(60/WeaponData.ShootRate)
					shooting = false

				end
			elseif WeaponData and WeaponData.ShootType == 3 then
				while mouse1down do
					if shooting or Ammo <= 0 or WeaponData.Jammed then
						break
					end
					shooting = true	
					Events.Atirar:FireServer(WeaponTool,Suppressor,FlashHider)
					for _ =  1, WeaponData.Bullets do
						Thread:Spawn(CreateBullet)
					end
					Ammo = Ammo - 1
					GunFx()
					JamChance()
					UpdateGui()
					Thread:Spawn(Recoil)
					task.wait(60/WeaponData.ShootRate)
					shooting = false

				end
			elseif WeaponData and WeaponData.ShootType == 4 or WeaponData and WeaponData.ShootType == 5 then
				shooting = true	
				Events.Atirar:FireServer(WeaponTool,Suppressor,FlashHider)
				for _ =  1, WeaponData.Bullets do
					Thread:Spawn(CreateBullet)
				end
				Ammo = Ammo - 1
				GunFx()
				UpdateGui()
				Thread:Spawn(Recoil)
				PumpAnim()
				RunCheck()
				shooting = false

			end
		end)

	elseif WeaponData and WeaponData.Type == "Melee" and not runKeyDown then
		if not shooting then
			shooting = true
			meleeCast()
			meleeAttack()
			RunCheck()
			shooting = false
		end
	end
end

local L_150_ = {}

local LeanSpring = {}
LeanSpring.cornerPeek = SpringMod.new(0)
LeanSpring.cornerPeek.d = 1
LeanSpring.cornerPeek.s = 20
LeanSpring.peekFactor = math.rad(-15)
LeanSpring.dirPeek = 0

function L_150_.Update()

	LeanSpring.cornerPeek.t = LeanSpring.peekFactor * Virar
	local NewLeanCF = CFrame.fromAxisAngle(Vector3.new(0, 0, 1), LeanSpring.cornerPeek.p)
	cam.CFrame = cam.CFrame * NewLeanCF
end

game:GetService("RunService"):BindToRenderStep("Camera Update", 200, L_150_.Update)

function RunCheck()
	if runKeyDown then
		mouse1down = false
		GunStance = 3
		Events.GunStance:FireServer(GunStance,AnimData)
		SprintAnim()
	else
		if aimming then
			GunStance = 2
			Events.GunStance:FireServer(GunStance,AnimData)
		else
			GunStance = 0
			Events.GunStance:FireServer(GunStance,AnimData)
		end
		IdleAnim()
	end
end

function Stand()
	Stance:FireServer(Stances,Virar)
	TS:Create(char.Humanoid, TweenInfo.new(.3), {CameraOffset = Vector3.new(CameraX,CameraY,0)} ):Play()

	SE_GUI.MainFrame.Poses.Levantado.Visible = true
	SE_GUI.MainFrame.Poses.Agaixado.Visible = false
	SE_GUI.MainFrame.Poses.Deitado.Visible = false

	if Steady then
		char.Humanoid.WalkSpeed = gameRules.SlowPaceWalkSpeed
		char.Humanoid.JumpPower = gameRules.JumpPower
	else
		if script.Parent:GetAttribute("Injured") then
			char.Humanoid.WalkSpeed = gameRules.InjuredWalksSpeed
			char.Humanoid.JumpPower = gameRules.JumpPower
		else
			char.Humanoid.WalkSpeed = gameRules.NormalWalkSpeed
			char.Humanoid.JumpPower = gameRules.JumpPower
		end
	end

	IsStanced = false	

end

function Crouch()
	Stance:FireServer(Stances,Virar)
	TS:Create(char.Humanoid, TweenInfo.new(.3), {CameraOffset = Vector3.new(CameraX,CameraY,0)} ):Play()

	SE_GUI.MainFrame.Poses.Levantado.Visible = false
	SE_GUI.MainFrame.Poses.Agaixado.Visible = true
	SE_GUI.MainFrame.Poses.Deitado.Visible = false

	if script.Parent:GetAttribute("Injured") then
		char.Humanoid.WalkSpeed = gameRules.InjuredCrouchWalkSpeed
		char.Humanoid.JumpPower = 0
	else
		char.Humanoid.WalkSpeed = gameRules.CrouchWalkSpeed
		char.Humanoid.JumpPower = 0
	end

	IsStanced = true	
end

function Prone()
	Stance:FireServer(Stances,Virar)
	TS:Create(char.Humanoid, TweenInfo.new(.3), {CameraOffset = Vector3.new(CameraX,CameraY,0)} ):Play()

	SE_GUI.MainFrame.Poses.Levantado.Visible = false
	SE_GUI.MainFrame.Poses.Agaixado.Visible = false
	SE_GUI.MainFrame.Poses.Deitado.Visible = true
	
	if ACS_Client:GetAttribute("Surrender") then
		char.Humanoid.WalkSpeed = 0
	else
		char.Humanoid.WalkSpeed = gameRules.ProneWalksSpeed
	end
	
	char.Humanoid.JumpPower = 0 
	IsStanced = true
end

function Lean()
	TS:Create(char.Humanoid, TweenInfo.new(.3), {CameraOffset = Vector3.new(CameraX,CameraY,0)} ):Play()
	Stance:FireServer(Stances,Virar)

	if Virar == 0 then
		SE_GUI.MainFrame.Poses.Esg_Left.Visible = false
		SE_GUI.MainFrame.Poses.Esg_Right.Visible = false
	elseif Virar == 1 then
		SE_GUI.MainFrame.Poses.Esg_Left.Visible = false
		SE_GUI.MainFrame.Poses.Esg_Right.Visible = true
	elseif Virar == -1 then
		SE_GUI.MainFrame.Poses.Esg_Left.Visible = true
		SE_GUI.MainFrame.Poses.Esg_Right.Visible = false
	end
end

----------//Animation Loader\\----------
function EquipAnim()
	AnimDebounce = false
	pcall(function()
		AnimData.EquipAnim({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
	AnimDebounce = true
end


function IdleAnim()
	pcall(function()
		AnimData.IdleAnim({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
	AnimDebounce = true
end

function SprintAnim()
	AnimDebounce = false
	pcall(function()
		AnimData.SprintAnim({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
end

function HighReady()
	pcall(function()
		AnimData.HighReady({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
end

function LowReady()
	pcall(function()
		AnimData.LowReady({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
end

function Patrol()
	pcall(function()
		AnimData.Patrol({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
end

function ReloadAnim()
	pcall(function()
		AnimData.ReloadAnim({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
end

function TacticalReloadAnim()
	pcall(function()
		AnimData.TacticalReloadAnim({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
end

function JammedAnim()
	pcall(function()
		AnimData.JammedAnim({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
end

function PumpAnim()
	reloading = true
	pcall(function()
		AnimData.PumpAnim({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
	reloading = false
end

function MagCheckAnim()
	CheckingMag = true
	pcall(function()
		AnimData.MagCheck({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
	CheckingMag = false
end

function meleeAttack()
	pcall(function()
		AnimData.meleeAttack({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
end

function GrenadeReady()
	pcall(function()
		AnimData.GrenadeReady({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
end

function GrenadeThrow()
	pcall(function()
		AnimData.GrenadeThrow({
			RArmWeld,
			LArmWeld,
			GunWeld,
			WeaponInHand,
			ViewModel,
		})
	end)
end
----------//Animation Loader\\----------

----------//KeyBinds\\----------
CAS:BindAction("Run", handleAction, false, Enum.KeyCode.LeftShift)

CAS:BindAction("Stand", handleAction, false, Enum.KeyCode.X)
CAS:BindAction("Crouch", handleAction, false, Enum.KeyCode.C)
CAS:BindAction("NVG", handleAction, false, Enum.KeyCode.N)

CAS:BindAction("ToggleWalk", handleAction, false, Enum.KeyCode.Z)
CAS:BindAction("LeanLeft", handleAction, false, Enum.KeyCode.Q)
CAS:BindAction("LeanRight", handleAction, false, Enum.KeyCode.E)
----------//KeyBinds\\----------

----------//Gun System\\----------
local L_199_ = nil
char.ChildAdded:connect(function(Tool)
	if Tool:IsA('Tool') and Humanoid.Health > 0 and not CurrentlyEquippingTool and Tool:FindFirstChild("ACS_Settings") ~= nil and (require(Tool.ACS_Settings).Type == 'Gun' or require(Tool.ACS_Settings).Type == 'Melee' or require(Tool.ACS_Settings).Type == 'Grenade') then
		local L_370_ = true
		if char:WaitForChild('Humanoid').Sit and char.Humanoid.SeatPart:IsA("VehicleSeat") or char:WaitForChild('Humanoid').Sit and char.Humanoid.SeatPart:IsA("VehicleSeat") then
			L_370_ = false;
		end

		if L_370_ then
			L_199_ = Tool
			if not CurrentlyEquippingTool then
				--pcall(function()
				setup(Tool)
				--end)

			elseif CurrentlyEquippingTool then
				pcall(function()
					unset()
					setup(Tool)
				end)
			end;
		end;
	end

end)

char.ChildRemoved:connect(function(Tool)
	if Tool == WeaponTool then
		if CurrentlyEquippingTool then
			unset()
		end
	end
end)

Humanoid.Running:Connect(function(speed)
	charspeed = speed
	if speed > 0.1 then
		running = true
	else
		running = false
	end
end)

Humanoid.Swimming:Connect(function(speed)
	if Swimming then
		charspeed = speed
		if speed > 0.1 then
			running = true
		else
			running = false
		end
	end
end)

Humanoid.Died:Connect(function(speed)
	TS:Create(char.Humanoid, TweenInfo.new(1), {CameraOffset = Vector3.new(0,0,0)} ):Play()
	ChangeStance = false
	Stand()
	Stances = 0
	Virar = 0
	CameraX = 0
	CameraY = 0
	Lean()
	Equipped = 0
	unset()
	Events.NVG:Fire(false)
end)

Humanoid.Seated:Connect(function(IsSeated, Seat)

	if IsSeated and Seat and (Seat:IsA("VehicleSeat")) then
		unset()
		Humanoid:UnequipTools()
		CanLean = false
		Player.CameraMaxZoomDistance = gameRules.VehicleMaxZoom
	else
		Player.CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance
	end

	if IsSeated  then
		Sentado = true
		Stances = 0
		Virar = 0
		CameraX = 0
		CameraY = 0
		Stand()
		Lean()
	else
		Sentado = false
		CanLean = true
	end
end)

Humanoid.Changed:connect(function(Property)
	if gameRules.AntiBunnyHop then
		if Property == "Jump" and Humanoid.Sit == true and Humanoid.SeatPart ~= nil then
			Humanoid.Sit = false
		elseif Property == "Jump" and Humanoid.Sit == false then
			if JumpDelay then
				Humanoid.Jump = false
				return false
			end
			JumpDelay = true
			task.delay(0, function()
				task.wait(gameRules.JumpCoolDown)
				JumpDelay = false
			end)
		end
	end
end)

Humanoid.StateChanged:connect(function(Old,state)
	if state == Enum.HumanoidStateType.Swimming then
		Swimming = true
		Stances = 0
		Virar = 0
		CameraX = 0
		CameraY = 0
		Stand()
		Lean()
	else
		Swimming = false
	end

	if gameRules.EnableFallDamage then
		if state == Enum.HumanoidStateType.Freefall and not falling then
			falling = true
			local curVel = 0
			local peak = 0

			while falling do
				curVel = HumanoidRootPart.Velocity.magnitude
				peak = peak + 1
				Thread:Wait()
			end
			local damage = (curVel - (gameRules.MaxVelocity)) * gameRules.DamageMult
			if damage > 5 and peak > 20 then
				local SKP_02 = SKP_01.."-"..Player.UserId

				cameraspring:accelerate(Vector3.new(-damage/20, 0, math.random(-damage, damage)/5))
				SwaySpring:accelerate(Vector3.new( math.random(-damage, damage)/5, damage/5,0))

				local hurtSound = PastaFx.FallDamage:Clone()
				hurtSound.Parent = Player.PlayerGui
				hurtSound.Volume = damage/Humanoid.MaxHealth
				hurtSound:Play()
				Debris:AddItem(hurtSound,hurtSound.TimeLength)

				Events.Damage:InvokeServer(nil, nil, nil, nil, nil, nil, true, damage, SKP_02)

			end
		elseif state == Enum.HumanoidStateType.Landed or state == Enum.HumanoidStateType.Dead then
			falling = false
			SwaySpring:accelerate(Vector3.new(0, 2.5, 0))
		end
	end

end)

mouse.WheelBackward:Connect(function() -- fires when the wheel goes forwards

	if CurrentlyEquippingTool and not CheckingMag and not aimming and not reloading and not runKeyDown and AnimDebounce and WeaponData.Type == "Gun" then
		mouse1down = false
		if GunStance == 0 then
			SafeMode = true
			GunStance = -1
			UpdateGui()
			Events.GunStance:FireServer(GunStance,AnimData)
			LowReady()
		elseif GunStance == -1 then
			SafeMode = true
			GunStance = -2
			UpdateGui()
			Events.GunStance:FireServer(GunStance,AnimData)
			Patrol()
		elseif GunStance == 1 then
			SafeMode = false
			GunStance = 0
			UpdateGui()
			Events.GunStance:FireServer(GunStance,AnimData)
			IdleAnim()
		end
	end

	if CurrentlyEquippingTool and aimming and Sens > 5 then
		Sens = Sens - 5
		UpdateGui()
		game:GetService('UserInputService').MouseDeltaSensitivity = (Sens/100)
	end

end)


mouse.WheelForward:Connect(function() -- fires when the wheel goes backwards

	if CurrentlyEquippingTool and not CheckingMag and not aimming and not reloading and not runKeyDown and AnimDebounce and WeaponData.Type == "Gun" then
		mouse1down = false
		if GunStance == 0 then
			SafeMode = true
			GunStance = 1
			UpdateGui()
			Events.GunStance:FireServer(GunStance,AnimData)
			HighReady()
		elseif GunStance == -1 then
			SafeMode = false
			GunStance = 0
			UpdateGui()
			Events.GunStance:FireServer(GunStance,AnimData)
			IdleAnim()
		elseif GunStance == -2 then
			SafeMode = true
			GunStance = -1
			UpdateGui()
			Events.GunStance:FireServer(GunStance,AnimData)
			LowReady()
		end
	end

	if CurrentlyEquippingTool and aimming and Sens < 100 then
		Sens = Sens + 5
		UpdateGui()
		game:GetService('UserInputService').MouseDeltaSensitivity = (Sens/100)
	end

end)

script.Parent:GetAttributeChangedSignal("Injured"):Connect(function()
	local valor = script.Parent:GetAttribute("Injured")

	if valor and runKeyDown then
		runKeyDown 	= false
		Stand()
		if not CheckingMag and not reloading and WeaponData and WeaponData.Type ~= "Grenade" and (GunStance == 0 or GunStance == 2 or GunStance == 3) then
			GunStance = 0
			Events.GunStance:FireServer(GunStance,AnimData)
			IdleAnim()
		end
	end

	if Stances == 0 then
		Stand()
	elseif Stances == 1 then
		Crouch()
	end

end)

----------//Gun System\\----------

----------//Health HUD\\----------
BloodScreen:Play()
BloodScreenLowHP:Play()
Humanoid.HealthChanged:Connect(function(Health)
	SE_GUI.Efeitos.Health.ImageTransparency = ((Health - (Humanoid.MaxHealth/2))/(Humanoid.MaxHealth/2))
	SE_GUI.Efeitos.LowHealth.ImageTransparency = (Health /(Humanoid.MaxHealth/2))
end)
----------//Health HUD\\----------

----------//Render Functions\\----------
Run.RenderStepped:Connect(function(step)
	HeadMovement()
	renderGunRecoil()
	renderCam()

	if ViewModel and LArm and RArm and WeaponInHand then --Check if the weapon and arms are loaded

		local mouseDelta = User:GetMouseDelta()
		SwaySpring:accelerate(Vector3.new(mouseDelta.x/60, mouseDelta.y/60, 0))

		local swayVec = SwaySpring.p
		local TSWAY = swayVec.z
		local XSSWY = swayVec.X
		local YSSWY = swayVec.Y
		local Sway = CFrame.Angles(YSSWY,XSSWY,XSSWY)

		if BipodAtt then

			local BipodRay = Ray.new(UnderBarrelAtt.Main.Position, Vector3.new(0,-1.75,0))
			local BipodHit, BipodPos, BipodNorm = workspace:FindPartOnRayWithIgnoreList(BipodRay, Ignore_Model, false, true)

			if BipodHit then
				CanBipod = true
				if CanBipod and BipodActive and not runKeyDown and (GunStance == 0 or GunStance == 2) then
					TS:Create(SE_GUI.GunHUD.Att.Bipod, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,255,255), ImageTransparency = .123}):Play()
					if not aimming then
						BipodCF = BipodCF:Lerp(CFrame.new(0,(((UnderBarrelAtt.Main.Position - BipodPos).magnitude)-1) * (-1.5), 0),.2)
					else
						BipodCF = BipodCF:Lerp(CFrame.new(),.2)
					end				

				else
					BipodActive = false
					BipodCF = BipodCF:Lerp(CFrame.new(),.2)
					TS:Create(SE_GUI.GunHUD.Att.Bipod, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,255,0), ImageTransparency = .5}):Play()
				end
			else
				BipodActive = false
				CanBipod = false
				BipodCF = BipodCF:Lerp(CFrame.new(),.2)
				TS:Create(SE_GUI.GunHUD.Att.Bipod, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,0,0), ImageTransparency = .5}):Play()
			end

		end

		AnimPart.CFrame = cam.CFrame * NearZ * BipodCF * maincf * gunbobcf * aimcf

		if not AnimData.GunModelFixed then
			WeaponInHand:SetPrimaryPartCFrame(
				ViewModel.PrimaryPart.CFrame
					* guncf
			)
		end

		if running then
			gunbobcf = gunbobcf:Lerp(CFrame.new(
				0.025 * (charspeed/10) * math.sin(tick() * 8),
				0.025 * (charspeed/10) * math.cos(tick() * 16),
				0
				) * CFrame.Angles(
					math.rad( 1 * (charspeed/10) * math.sin(tick() * 16) ), 
					math.rad( 1 * (charspeed/10) * math.cos(tick() * 8) ), 
					math.rad(0)
				), 0.1)
		else
			gunbobcf = gunbobcf:Lerp(CFrame.new(
				0.005 * math.sin(tick() * 1.5),
				0.005 * math.cos(tick() * 2.5),
				0 
				), 0.1)
		end

		if CurAimpart and aimming and AnimDebounce and not CheckingMag then
			if not NVG or WeaponInHand.AimPart:FindFirstChild("NVAim") == nil then
				if AimPartMode == 1 then
					TS:Create(cam,AimTween,{FieldOfView = ModTable.ZoomValue}):Play()
					maincf = maincf:Lerp(maincf * CFrame.new(0,0,-.5) * recoilcf * Sway:inverse() * CurAimpart.CFrame:toObjectSpace(cam.CFrame), 0.2)
				else
					TS:Create(cam,AimTween,{FieldOfView = ModTable.Zoom2Value}):Play()
					maincf = maincf:Lerp(maincf * CFrame.new(0,0,-.5) * recoilcf * Sway:inverse() * CurAimpart.CFrame:toObjectSpace(cam.CFrame), 0.2)
				end
			else
				TS:Create(cam,AimTween,{FieldOfView = 70}):Play()
				maincf = maincf:Lerp(maincf * CFrame.new(0,0,-.5) * recoilcf * Sway:inverse() * (WeaponInHand.AimPart.CFrame * WeaponInHand.AimPart.NVAim.CFrame):toObjectSpace(cam.CFrame), 0.2)
			end

		else
			TS:Create(cam,AimTween,{FieldOfView = 70}):Play()
			maincf = maincf:Lerp(AnimData.MainCFrame * recoilcf * Sway:inverse(), 0.2)   
		end

		for index, Part in pairs(WeaponInHand:GetDescendants()) do
			if Part:IsA("BasePart") and Part.Name == "SightMark" then
				local dist_scale = Part.CFrame:pointToObjectSpace(cam.CFrame.Position)/Part.Size
				local reticle = Part.SurfaceGui.Border.Scope	
				reticle.Position=UDim2.new(.5+dist_scale.x,0,.5-dist_scale.y,0)	
			end
		end

		recoilcf = recoilcf:Lerp(CFrame.new() * CFrame.Angles( math.rad(RecoilSpring.p.X), math.rad(RecoilSpring.p.Y), math.rad(RecoilSpring.p.z)), 0.2)


		if BSpread then
			local currTime = time()
			if currTime - LastSpreadUpdate > (60/WeaponData.ShootRate) * 2 and not shooting and BSpread > WeaponData.MinSpread * ModTable.MinSpread then
				BSpread = math.max(WeaponData.MinSpread * ModTable.MinSpread, BSpread - WeaponData.AimInaccuracyDecrease * ModTable.AimInaccuracyDecrease)
			end
			if currTime - LastSpreadUpdate > (60/WeaponData.ShootRate) * 1.5 and not shooting and RecoilPower > WeaponData.MinRecoilPower * ModTable.MinRecoilPower then
				RecoilPower =  math.max(WeaponData.MinRecoilPower * ModTable.MinRecoilPower, RecoilPower - WeaponData.RecoilPowerStepAmount * ModTable.RecoilPowerStepAmount)
			end
		end

		if LaserActive and Pointer ~= nil then

			if NVG then
				Pointer.Transparency = 0
				Pointer.Beam.Enabled = true
			else
				if not gameRules.RealisticLaser then
					Pointer.Beam.Enabled = true
				else
					Pointer.Beam.Enabled = false
				end
				if IRmode then
					Pointer.Transparency = 1
				else
					Pointer.Transparency = 0
				end
			end
			
			for index, Key in pairs(WeaponInHand:GetDescendants()) do
				if Key:IsA("BasePart") and Key.Name == "LaserPoint" then
					local L_361_ = Ray.new(Key.CFrame.Position, Key.CFrame.LookVector * 1000)
					local Hit, Pos, Normal = workspace:FindPartOnRayWithIgnoreList(L_361_, Ignore_Model, false, true)

					if Hit then
						Pointer.CFrame =  CFrame.new(Pos, Pos + Normal)
					else
						Pointer.CFrame =  CFrame.new(cam.CFrame.Position + Key.CFrame.LookVector * 2000, Key.CFrame.LookVector)
					end

					if HalfStep and gameRules.ReplicatedLaser then
						Events.SVLaser:FireServer(Pos,1,Pointer.Color,IRmode,WeaponTool)
					end
					break
				end
			end
		end
	end
end)
----------//Render Functions\\----------

----------//Events\\----------
Events.Refil.OnClientEvent:Connect(function(Tool, Infinite, Stored)

	local data = require(Tool.ACS_Settings)
	local NewStored = math.min(data.MaxStoredAmmo - StoredAmmo, Stored.Value) 

	StoredAmmo = StoredAmmo + NewStored
	data.StoredAmmo = StoredAmmo

	UpdateGui()

	if not Infinite then
		Events.Refil:FireServer(Stored, NewStored)
	end

end)
----------//Events\\----------