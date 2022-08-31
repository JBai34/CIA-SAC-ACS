local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
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
local ModTable 				= require(Others.ModTable)
local RunCheck				= require(Others.RunCheck)

local Camera = workspace.CurrentCamera
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
local WeaponAction = {}

function WeaponAction:UpdateGui()
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

function WeaponAction:CreateBullet(weaponData)

		local Bullet = Instance.new("Part",ACS_Workspace.Client)
		Bullet.Name = Player.Name.."_Bullet"
		Bullet.CanCollide = false
		Bullet.Shape = Enum.PartType.Ball
		Bullet.Transparency = 1
		Bullet.Size = Vector3.new(1,1,1)

		local Origin 		= ViewModelState.WeaponInHand.Handle.Muzzle.WorldPosition
		local Direction 	= ViewModelState.WeaponInHand.Handle.Muzzle.WorldCFrame.LookVector + 
								(ViewModelState.WeaponInHand.Handle.Muzzle.WorldCFrame.UpVector * 
								(((weaponData.BulletDrop * weaponData.CurrentZero/4)/weaponData.MuzzleVelocity))/2)
		local BulletCF 		= CFrame.new(Origin, Direction) 
		local WalkMul 		= weaponData.WalkMult * ModTable.WalkMult
		local BColor 		= Color3.fromRGB(255,255,255)
		local bulletSpread

		if FirearmState.Aimming and weaponData.Bullets <= 1 then
			bulletSpread = CalculateBulletSpread()
		else
			bulletSpread = CalculateBulletSpread()
		end

		Direction = bulletSpread * Direction

		local tracerIsVisible = TracerCalculation()

		if weaponData.RainbowMode then
			BColor = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
		else
			BColor = weaponData.TracerColor
		end

		if tracerIsVisible then
			if gameRules.ReplicatedBullets then
				Events.ServerBullet:FireServer(Origin,Direction,weaponData,ModTable)
			end

			if weaponData.Tracer == true then

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

			if weaponData.BulletFlare == true then
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

		local BulletMass = Bullet:GetMass()
		local Force = Vector3.new(0,BulletMass * (196.2) - (weaponData.BulletDrop) * (196.2), 0)
		local BF = Instance.new("BodyForce",Bullet)

		Bullet.CFrame = BulletCF
		Bullet:ApplyImpulse(Direction * weaponData.MuzzleVelocity * ModTable.MuzzleVelocity)
		BF.Force = Force

		Debris:AddItem(Bullet, 5)

		CastRay(Bullet, Origin)
	end
end

function WeaponAction:Shoot(weaponData)
	if weaponData and weaponData.Type == "Gun" and not FirearmState.Shooting and not FirearmState.Reloading then

		if FirearmState.Reloading or InputState.runKeyDown or FirearmState.SafeMode or FirearmState.CheckingMag then
			mouse1down = false
			return
		end

		if Ammo <= 0 or weaponData.Jammed then
			ViewModelState.WeaponInHand.Handle.Click:Play()
			mouse1down = false
			return
		end

		mouse1down = true

		task.defer(function()
			if weaponData and weaponData.ShootType == 1 then 
				FirearmState.Shooting = true	
				Events.Shoot:FireServer(FirearmProps.WeaponTool,FirearmProps.Suppressor,FirearmProps.FlashHider)
				for _ =  1, weaponData.Bullets do
					task.spawn(self:CreateBullet(weaponData))
				end
				Ammo = Ammo - 1
				GunFx()
				JamChance()
				UpdateGui()
				task.spawn(Recoil)
				task.wait(60/weaponData.ShootRate)
				FirearmState.Shooting = false

			elseif weaponData and weaponData.ShootType == 2 then
				for i = 1, weaponData.BurstShot do
					if FirearmState.Shooting or Ammo <= 0 or mouse1down == false or weaponData.Jammed then
						break
					end
					FirearmState.Shooting = true	
					Events.Shoot:FireServer(FirearmProps.WeaponTool,FirearmProps.Suppressor,FirearmProps.FlashHider)
					for _ =  1, weaponData.Bullets do
						task.spawn(self:CreateBullet(weaponData))
					end
					Ammo = Ammo - 1
					GunFx()
					JamChance()
					UpdateGui()
					task.spawn(Recoil)
					task.wait(60/weaponData.ShootRate)
					FirearmState.Shooting = false

				end
			elseif weaponData and weaponData.ShootType == 3 then
				while mouse1down do
					if FirearmState.Shooting or Ammo <= 0 or weaponData.Jammed then
						break
					end
					FirearmState.Shooting = true	
					Events.Shoot:FireServer(FirearmProps.WeaponTool,FirearmProps.Suppressor,FirearmProps.FlashHider)
					for _ =  1, weaponData.Bullets do
						task.spawn(self:CreateBullet(weaponData))
					end
					Ammo = Ammo - 1
					GunFx()
					JamChance()
					UpdateGui()
					task.spawn(Recoil)
					task.wait(60/weaponData.ShootRate)
					FirearmState.Shooting = false

				end
			elseif weaponData and weaponData.ShootType == 4 or weaponData and weaponData.ShootType == 5 then
				FirearmState.Shooting = true	
				Events.Shoot:FireServer(FirearmProps.WeaponTool,FirearmProps.Suppressor,FirearmProps.FlashHider)
				for _ =  1, weaponData.Bullets do
					task.spawn(self:CreateBullet(weaponData))
				end
				Ammo = Ammo - 1
				GunFx()
				UpdateGui()
				task.spawn(Recoil)
				PlayAnimation:PumpAnim()
				RunCheck()
				FirearmState.Shooting = false

			end
		end)

	elseif weaponData and weaponData.Type == "Melee" and not InputState.runKeyDown then
		if not FirearmState.Shooting then
			FirearmState.Shooting = true
			meleeCast()
			meleeAttack()
			RunCheck()
			FirearmState.Shooting = false
		end
	end
end

function WeaponAction:Unset(tool)
	
end

function WeaponAction:Setup(tool)
	if Character and Character:WaitForChild("Humanoid").Health > 0 and tool ~= nil then
		FirearmState.CurrentlyEquippingTool = true
		UIS.MouseIconEnabled 	= false
		Player.CameraMode 			= Enum.CameraMode.LockFirstPerson

		FirearmProps.WeaponTool 					= tool
		FirearmProps.WeaponData 					= require(tool:WaitForChild("ACS_Settings"))
		ViewModelState.AnimData 					= require(tool:WaitForChild("ACS_Animations"))
		ViewModelState.WeaponInHand 	   = GunModels:WaitForChild(tool.Name):Clone()
		ViewModelState.WeaponInHand.PrimaryPart 	= ViewModelState.WeaponInHand:WaitForChild("Handle")

		Events.Equip:FireServer(tool,1,FirearmProps.WeaponData,ViewModelState.AnimData)

		ViewModelState.ViewModel = ArmModel:WaitForChild("Arms"):Clone()
		ViewModelState.ViewModel.Name = "Viewmodel"

		local humanoid = Character:FindFirstChild("Humanoid")
		local humanoidDesc = humanoid:GetAppliedDescription()
		local viewModelHumanoid = ViewModelState.ViewModel:FindFirstChildOfClass("Humanoid")
		viewModelHumanoid:ApplyDescriptionReset(humanoidDesc)
		
		--[[ 
			line 283-288 basically replaced this entire blacked out part
			of course... under the assumption that the game is using HumanoidDescription based setup
			
		if Character:FindFirstChild("Body Colors") ~= nil then
			local Colors = Character:WaitForChild("Body Colors"):Clone()
			Colors.Parent = ViewModelState.ViewModel
		end

		if Character:FindFirstChild("Shirt") ~= nil then
			local Shirt = Character:FindFirstChild("Shirt"):Clone()
			Shirt.Parent = ViewModelState.ViewModel
		end
		]]
		
		-- set up arms
		ViewModelState.AnimPart = Instance.new("Part",ViewModelState.ViewModel)
		ViewModelState.AnimPart.Size = Vector3.new(0.1,0.1,0.1)
		ViewModelState.AnimPart.Anchored = true
		ViewModelState.AnimPart.CanCollide = false
		ViewModelState.AnimPart.Transparency = 1

		ViewModelState.ViewModel.PrimaryPart = ViewModelState.AnimPart

		ViewModelState.LArmWeld = Instance.new("Motor6D",ViewModelState.AnimPart)
		ViewModelState.LArmWeld.Name = "LeftArm"
		ViewModelState.LArmWeld.Part0 = ViewModelState.AnimPart

		ViewModelState.RArmWeld = Instance.new("Motor6D",ViewModelState.AnimPart)
		ViewModelState.RArmWeld.Name = "RightArm"
		ViewModelState.RArmWeld.Part0 = ViewModelState.AnimPart

		ViewModelState.GunWeld = Instance.new("Motor6D",ViewModelState.AnimPart)
		ViewModelState.GunWeld.Name = "Handle"

		-- setup arms to camera
		ViewModelState.ViewModel.Parent = Camera

		ViewModelState.MainCFrame = ViewModelState.AnimData.MainCFrame
		ViewModelState.GunCFrame = ViewModelState.AnimData.GunCFrame

		ViewModelState.LArmCFrame = ViewModelState.AnimData.LArmCFrame
		ViewModelState.RArmCFrame = ViewModelState.AnimData.RArmCFrame

		ViewModelState.LArm = ViewModelState.ViewModel:WaitForChild("Left Arm")
		ViewModelState.LArmWeld.Part1 = ViewModelState.LArm
		ViewModelState.LArmWeld.C0 = CFrame.new()
		ViewModelState.LArmWeld.C1 = CFrame.new(1,-1,-5) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)):Inverse()

		ViewModelState.RArm = ViewModelState.ViewModel:WaitForChild("Right Arm")
		ViewModelState.RArmWeld.Part1 = ViewModelState.RArm
		ViewModelState.RArmWeld.C0 = CFrame.new()
		ViewModelState.RArmWeld.C1 = CFrame.new(-1,-1,-5) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)):Inverse()
		ViewModelState.GunWeld.Part0 = ViewModelState.RArm

		ViewModelState.LArm.Anchored = false
		ViewModelState.RArm.Anchored = false

		--setup weapon to camera
		ModTable.ZoomValue 		= FirearmProps.WeaponData.Zoom
		ModTable.Zoom2Value 	= FirearmProps.WeaponData.Zoom2
		FirearmProps.HasIR		= FirearmProps.WeaponData.InfraRed


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

		FirearmProps.BulletRecoilSpread	= 
							math.min(FirearmProps.WeaponData.MinSpread 	  * ModTable.MinSpread, 	FirearmProps.WeaponData.MaxSpread * ModTable.MaxSpread)
		FirearmProps.RecoilPower 		= 
							math.min(FirearmProps.WeaponData.MinRecoilPower * ModTable.MinRecoilPower, FirearmProps.WeaponData.MaxRecoilPower * ModTable.MaxRecoilPower)

		FirearmProps.Ammo 		= FirearmProps.WeaponData.AmmoInGun
		FirearmProps.StoredAmmo = FirearmProps.WeaponData.StoredAmmo
		FirearmProps.CurAimpart = FirearmProps.WeaponInHand:FindFirstChild("AimPart")
		
		for _, key in pairs(ViewModelState.WeaponInHand:GetDescendants()) do
			if key:IsA("BasePart") and key.Name == "FlashPoint" then
				FirearmProps.HasFlashLight = true
			end
			if key:IsA("BasePart") and key.Name == "LaserPoint" then
				FirearmProps.HasLaser = true
			end
		end
		

		if FirearmProps.WeaponData.EnableHUD then
			SE_GUI.GunHUD.Visible = true
		end
		UpdateGui()

		for _, key in pairs(ViewModelState.WeaponInHand:GetChildren()) do
			if key:IsA('BasePart') and key.Name ~= 'Handle' then

				if key.Name ~= "Bolt" and key.Name ~= 'Lid' and key.Name ~= "Slide" then
					Ultil.Weld(ViewModelState.WeaponInHand:WaitForChild("Handle"), key)
				end

				if key.Name == "Bolt" or key.Name == "Slide" then
					Ultil.WeldComplex(ViewModelState.WeaponInHand:WaitForChild("Handle"), key, key.Name)
				end;

				if key.Name == "Lid" then
					if ViewModelState.WeaponInHand:FindFirstChild('LidHinge') then
						Ultil.Weld(key, ViewModelState.WeaponInHand:WaitForChild("LidHinge"))
					else
						Ultil.Weld(key, ViewModelState.WeaponInHand:WaitForChild("Handle"))
					end
				end
			end
		end;

		for _, gunPart in pairs(ViewModelState.WeaponInHand:GetChildren()) do
			if gunPart:IsA('BasePart') then
				gunPart.Anchored = false
				gunPart.CanCollide = false
			end
		end;

		if ViewModelState.WeaponInHand:FindFirstChild("Nodes") then
			for _, part in pairs(ViewModelState.WeaponInHand.Nodes:GetChildren()) do
				if part:IsA('BasePart') then
					Ultil.Weld(ViewModelState.WeaponInHand:WaitForChild("Handle"), part)
					part.Anchored = false
					part.CanCollide = false
				end
			end;
		end

		ViewModelState.GunWeld.Part1 = ViewModelState.WeaponInHand:WaitForChild("Handle")
		ViewModelState.GunWeld.C1 = ViewModelState.GunCFrame

		--WeaponInHand:SetPrimaryPartCFrame( RArm.CFrame * guncf)

		ViewModelState.WeaponInHand.Parent = ViewModelState.ViewModel	
		if Ammo <= 0 and FirearmProps.WeaponData.Type == "Gun" then
			ViewModelState.Handle.Slide.C0 = FirearmProps.WeaponData.SlideEx:Inverse()
		end
		PlayAnimation:EquipAnim()
		if FirearmProps.WeaponData and FirearmProps.WeaponData.Type ~= "Grenade" then
			RunCheck()
		end

	end

end

return WeaponAction