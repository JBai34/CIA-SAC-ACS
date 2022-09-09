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

local Functions:Folder	= Modules.Functions
local RunCheck				= require(Functions.RunCheck)
local GunFx					= require(Functions.GunFX)
local CheckForHumanoid		= require(Functions.CheckForHumanoid)
local Recoil				= require(Functions.Recoil)
local CalculateBulletSpread = require(Functions.CalculateBulletSpread)
local CalculateTracer		= require(Functions.CalculateTracer)

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
local WeaponAction = {}

local Camera = workspace.CurrentCamera
local IgnoreModel = {Camera,Character,ACS_Workspace.Client,ACS_Workspace.Server}
--==
local function JamChance()
	if FirearmProps.WeaponData.CanBreak == true and not FirearmProps.WeaponData.Jammed and Ammo - 1 > 0 then
		local Jam = math.random(1000)
		if Jam <= 2 then
			FirearmProps.WeaponData.Jammed = true
			ViewModelState.WeaponInHand.Handle.Click:Play()
		end
	end
end

--==
function WeaponAction:meleeCast()

	-- Set an origin and directional vector
	local rayOrigin 	= Camera.CFrame.Position
	local rayDirection 	= Camera.CFrame.LookVector * FirearmProps.WeaponData.BladeRange

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = IgnoreModel
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.IgnoreWater = true
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)


	if raycastResult then
		local Hit2 = raycastResult.Instance

		--Check if it's a hat or accessory
		if Hit2 and Hit2.Parent:IsA('Accessory') or Hit2.Parent:IsA('Hat') then

			for _,players in pairs(game.Players:GetPlayers()) do
				if players.Character then
					for _, hats in pairs(players.Character:GetChildren()) do
						if hats:IsA("Accessory") then
							table.insert(IgnoreModel, hats)
						end
					end
				end
			end

			return self:meleeCast()
		end

		if Hit2 and Hit2.Name == "Ignorable" or Hit2.Name == "Glass" or Hit2.Name == "Ignore" or Hit2.Parent.Name == "Top" or Hit2.Parent.Name == "Helmet" or Hit2.Parent.Name == "Up" or Hit2.Parent.Name == "Down" or Hit2.Parent.Name == "Face" or Hit2.Parent.Name == "Olho" or Hit2.Parent.Name == "Headset" or Hit2.Parent.Name == "Numero" or Hit2.Parent.Name == "Vest" or Hit2.Parent.Name == "Chest" or Hit2.Parent.Name == "Waist" or Hit2.Parent.Name == "Back" or Hit2.Parent.Name == "Belt" or Hit2.Parent.Name == "Leg1" or Hit2.Parent.Name == "Leg2" or Hit2.Parent.Name == "Arm1"  or Hit2.Parent.Name == "Arm2" then
			table.insert(IgnoreModel, Hit2)
			return self:meleeCast()
		end

		if Hit2 and Hit2.Parent.Name == "Top" or Hit2.Parent.Name == "Helmet" or Hit2.Parent.Name == "Up" or Hit2.Parent.Name == "Down" or Hit2.Parent.Name == "Face" or Hit2.Parent.Name == "Olho" or Hit2.Parent.Name == "Headset" or Hit2.Parent.Name == "Numero" or Hit2.Parent.Name == "Vest" or Hit2.Parent.Name == "Chest" or Hit2.Parent.Name == "Waist" or Hit2.Parent.Name == "Back" or Hit2.Parent.Name == "Belt" or Hit2.Parent.Name == "Leg1" or Hit2.Parent.Name == "Leg2" or Hit2.Parent.Name == "Arm1"  or Hit2.Parent.Name == "Arm2" then
			table.insert(IgnoreModel, Hit2.Parent)
			return self:meleeCast()
		end

		if Hit2 and (Hit2.Transparency >= 1 or Hit2.CanCollide == false) and Hit2.Name ~= 'Head' and Hit2.Name ~= 'Right Arm' and Hit2.Name ~= 'Left Arm' and Hit2.Name ~= 'Right Leg' and Hit2.Name ~= 'Left Leg' and Hit2.Name ~= "UpperTorso" and Hit2.Name ~= "LowerTorso" and Hit2.Name ~= "RightUpperArm" and Hit2.Name ~= "RightLowerArm" and Hit2.Name ~= "RightHand" and Hit2.Name ~= "LeftUpperArm" and Hit2.Name ~= "LeftLowerArm" and Hit2.Name ~= "LeftHand" and Hit2.Name ~= "RightUpperLeg" and Hit2.Name ~= "RightLowerLeg" and Hit2.Name ~= "RightFoot" and Hit2.Name ~= "LeftUpperLeg" and Hit2.Name ~= "LeftLowerLeg" and Hit2.Name ~= "LeftFoot" and Hit2.Name ~= 'Armor' and Hit2.Name ~= 'EShield' then
			table.insert(self:meleeCast(), Hit2)
			return self:meleeCast()
		end
	end


	if raycastResult then
		local foundHumanoid, humanoid = CheckForHumanoid(raycastResult.Instance) -- returns boolean, humanoid
		HitMod.HitEffect(IgnoreModel, raycastResult.Position, raycastResult.Instance , raycastResult.Normal, raycastResult.Material, FirearmProps.WeaponData)
		Events.HitEffect:FireServer(raycastResult.Position, raycastResult.Instance , raycastResult.Normal, raycastResult.Material, FirearmProps.WeaponData)

		local HitPart = raycastResult.Instance

		if foundHumanoid == true and humanoid.Health > 0 then
			local SKP_02 = SKP_01.."-"..Player.UserId

			if HitPart.Name == "Head" or HitPart.Parent.Name == "Top" or HitPart.Parent.Name == "Headset" or HitPart.Parent.Name == "Olho" or HitPart.Parent.Name == "Face" or HitPart.Parent.Name == "Numero" then
				task.spawn(function()
					Events.Damage:InvokeServer(FirearmProps.WeaponTool, humanoid, 0, 1, FirearmProps.WeaponData, ModTable, nil, nil, SKP_02)	
				end)

			elseif HitPart.Name == "Torso" or HitPart.Name == "UpperTorso" or HitPart.Name == "LowerTorso" or HitPart.Parent.Name == "Chest" or HitPart.Parent.Name == "Waist" or HitPart.Name == "RightUpperArm" or HitPart.Name == "RightLowerArm" or HitPart.Name == "RightHand" or HitPart.Name == "LeftUpperArm" or HitPart.Name == "LeftLowerArm" or HitPart.Name == "LeftHand" then
				task.spawn(function()
					Events.Damage:InvokeServer(FirearmProps.WeaponTool, humanoid, 0, 2, FirearmProps.WeaponData, ModTable, nil, nil, SKP_02)	
				end)

			elseif HitPart.Name == "Right Arm" or HitPart.Name == "Right Leg" or HitPart.Name == "Left Leg" or HitPart.Name == "Left Arm" or HitPart.Name == "RightUpperLeg" or HitPart.Name == "RightLowerLeg" or HitPart.Name == "RightFoot" or HitPart.Name == "LeftUpperLeg" or HitPart.Name == "LeftLowerLeg" or HitPart.Name == "LeftFoot" then
				task.spawn(function()
					Events.Damage:InvokeServer(FirearmProps.WeaponTool, humanoid, 0, 3, FirearmProps.WeaponData, ModTable, nil, nil, SKP_02)	
				end)

			end
		end			
	end
end

function WeaponAction:CastRay(_bullet, _origin)
	if _bullet then

		local Bpos = _bullet.Position
		local Bpos2 = Camera.CFrame.Position

		local recast = false
		local TotalDistTraveled = 0
		local Debounce = false
		local raycastResult

		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = IgnoreModel
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		raycastParams.IgnoreWater = true

		while _bullet do
			RunService.Heartbeat:Wait()
			if _bullet.Parent ~= nil then
				Bpos = _bullet.Position
				TotalDistTraveled = (_bullet.Position - _origin).Magnitude

				if TotalDistTraveled > 7000 then
					_bullet:Destroy()
					Debounce = true
					break
				end

				for _, targetPlayer in pairs(game.Players:GetPlayers()) do
					if not Debounce and targetPlayer ~= Player and targetPlayer.Character and targetPlayer.Character:FindFirstChild('Head') ~= nil 
						and (targetPlayer.Character.Head.Position - Bpos).magnitude <= 25 then
						Events.Whizz:FireServer(targetPlayer)
						Events.Suppression:FireServer(targetPlayer,1)
						Debounce = true
					end
				end

				-- Set an _origin and directional vector
				raycastResult = workspace:Raycast(Bpos2, (Bpos - Bpos2) * 1, raycastParams)

				recast = false

				if raycastResult then
					local Hit2 = raycastResult.Instance

					if Hit2 and (Hit2.Parent:IsA('Accessory') or Hit2.Parent:IsA('Hat')) then
						for _,players in pairs(game.Players:GetPlayers()) do
							if players.Character then
								for _, hats in pairs(players.Character:GetChildren()) do
									if hats:IsA("Accessory") then
										table.insert(IgnoreModel, hats)
									end
								end
							end
						end
						recast = true
						self:CastRay(_bullet, _origin)
						break
					end
					
					if Hit2 and Hit2.Name == "Ignorable" or Hit2.Name == "Glass" or Hit2.Name == "Ignore" or Hit2.Parent.Name == "Top" or Hit2.Parent.Name == "Helmet" or Hit2.Parent.Name == "Up" or Hit2.Parent.Name == "Down" or Hit2.Parent.Name == "Face" or Hit2.Parent.Name == "Olho" or Hit2.Parent.Name == "Headset" or Hit2.Parent.Name == "Numero" or Hit2.Parent.Name == "Vest" or Hit2.Parent.Name == "Chest" or Hit2.Parent.Name == "Waist" or Hit2.Parent.Name == "Back" or Hit2.Parent.Name == "Belt" or Hit2.Parent.Name == "Leg1" or Hit2.Parent.Name == "Leg2" or Hit2.Parent.Name == "Arm1"  or Hit2.Parent.Name == "Arm2" then
						table.insert(IgnoreModel, Hit2)
						recast = true
						self:CastRay(_bullet, _origin)
						break
					end
					
					if Hit2 and Hit2.Parent.Name == "Top" or Hit2.Parent.Name == "Helmet" or Hit2.Parent.Name == "Up" or Hit2.Parent.Name == "Down" or Hit2.Parent.Name == "Face" or Hit2.Parent.Name == "Olho" or Hit2.Parent.Name == "Headset" or Hit2.Parent.Name == "Numero" or Hit2.Parent.Name == "Vest" or Hit2.Parent.Name == "Chest" or Hit2.Parent.Name == "Waist" or Hit2.Parent.Name == "Back" or Hit2.Parent.Name == "Belt" or Hit2.Parent.Name == "Leg1" or Hit2.Parent.Name == "Leg2" or Hit2.Parent.Name == "Arm1"  or Hit2.Parent.Name == "Arm2" then
						table.insert(IgnoreModel, Hit2.Parent)
						recast = true
						self:CastRay(_bullet, _origin)
						break
					end

					if Hit2 and (Hit2.Transparency >= 1 or Hit2.CanCollide == false) and Hit2.Name ~= 'Head' and Hit2.Name ~= 'Right Arm' and Hit2.Name ~= 'Left Arm' and Hit2.Name ~= 'Right Leg' and Hit2.Name ~= 'Left Leg' and Hit2.Name ~= "UpperTorso" and Hit2.Name ~= "LowerTorso" and Hit2.Name ~= "RightUpperArm" and Hit2.Name ~= "RightLowerArm" and Hit2.Name ~= "RightHand" and Hit2.Name ~= "LeftUpperArm" and Hit2.Name ~= "LeftLowerArm" and Hit2.Name ~= "LeftHand" and Hit2.Name ~= "RightUpperLeg" and Hit2.Name ~= "RightLowerLeg" and Hit2.Name ~= "RightFoot" and Hit2.Name ~= "LeftUpperLeg" and Hit2.Name ~= "LeftLowerLeg" and Hit2.Name ~= "LeftFoot" and Hit2.Name ~= 'Armor' and Hit2.Name ~= 'EShield' then
						table.insert(IgnoreModel, Hit2)
						recast = true
						self:CastRay(_bullet, _origin)
						break
					end

					if not recast then

						_bullet:Destroy()
						Debounce = true

						local foundHumanoid, humanoid = CheckForHumanoid(raycastResult.Instance) -- returns boolean, humanoid
						HitMod.HitEffect(IgnoreModel, raycastResult.Position, raycastResult.Instance , raycastResult.Normal, raycastResult.Material, FirearmProps.WeaponData)
						Events.HitEffect:FireServer(raycastResult.Position, raycastResult.Instance , raycastResult.Normal, raycastResult.Material, FirearmProps.WeaponData)
						
						local HitPart = raycastResult.Instance
						TotalDistTraveled = (raycastResult.Position - _origin).Magnitude

						if foundHumanoid == true and humanoid.Health > 0 and FirearmProps.WeaponData then
							local SKP_02 = SKP_01.."-"..Player.UserId

							if HitPart.Name == "Head" or HitPart.Parent.Name == "Top" or HitPart.Parent.Name == "Headset" or HitPart.Parent.Name == "Olho" or HitPart.Parent.Name == "Face" or HitPart.Parent.Name == "Numero" then
								Events.Damage:InvokeServer(FirearmProps.WeaponTool, humanoid, TotalDistTraveled, 1, FirearmProps.WeaponData, ModTable, nil, nil, SKP_02)
							elseif HitPart.Name == "Torso" or HitPart.Name == "UpperTorso" or HitPart.Name == "LowerTorso" or HitPart.Parent.Name == "Chest" or HitPart.Parent.Name == "Waist" or HitPart.Name == "Right Arm" or HitPart.Name == "Left Arm" or HitPart.Name == "RightUpperArm" or HitPart.Name == "RightLowerArm" or HitPart.Name == "RightHand" or HitPart.Name == "LeftUpperArm" or HitPart.Name == "LeftLowerArm" or HitPart.Name == "LeftHand" then				
								Events.Damage:InvokeServer(FirearmProps.WeaponTool, humanoid, TotalDistTraveled, 2, FirearmProps.WeaponData, ModTable, nil, nil, SKP_02)
							elseif HitPart.Name == "Right Leg" or HitPart.Name == "Left Leg" or HitPart.Name == "RightUpperLeg" or HitPart.Name == "RightLowerLeg" or HitPart.Name == "RightFoot" or HitPart.Name == "LeftUpperLeg" or HitPart.Name == "LeftLowerLeg" or HitPart.Name == "LeftFoot" then
								Events.Damage:InvokeServer(FirearmProps.WeaponTool, humanoid, TotalDistTraveled, 3, FirearmProps.WeaponData, ModTable, nil, nil, SKP_02)		
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

function WeaponAction:UpdateGui()
	if SE_GUI then
		local HUD = SE_GUI.GunHUD

		if FirearmProps.WeaponData ~= nil then

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

			if FirearmProps.WeaponData.Jammed then
				HUD.B.BackgroundColor3 = Color3.fromRGB(255,0,0)
			else
				HUD.B.BackgroundColor3 = Color3.fromRGB(255,255,255)
			end

			if FirearmState.SafeMode then
				HUD.A.Visible = true
			else
				HUD.A.Visible = false
			end

			if FirearmProps.Ammo > 0 then
				HUD.B.Visible = true
			else
				HUD.B.Visible = false
			end

			if FirearmProps.WeaponData.ShootType == 1 then
				HUD.FText.Text = "Semi"
			elseif FirearmProps.WeaponData.ShootType == 2 then
				HUD.FText.Text = "Burst"
			elseif FirearmProps.WeaponData.ShootType == 3 then
				HUD.FText.Text = "Auto"
			elseif FirearmProps.WeaponData.ShootType == 4 then
				HUD.FText.Text = "Pump-Action"
			elseif FirearmProps.WeaponData.ShootType == 5 then
				HUD.FText.Text = "Bolt-Action"
			end

			HUD.Sens.Text = (InputState.MouseSensitivity/100)
			HUD.BText.Text = FirearmProps.WeaponData.BulletType
			HUD.NText.Text = FirearmProps.WeaponData.gunName

			if FirearmProps.WeaponData.EnableZeroing then
				HUD.ZeText.Visible = true
				HUD.ZeText.Text = FirearmProps.WeaponData.CurrentZero .." m"
			else
				HUD.ZeText.Visible = false
			end

			if FirearmProps.WeaponData.MagCount then
				HUD.SAText.Text = math.ceil(FirearmProps.StoredAmmo/FirearmProps.WeaponData.Ammo)
				HUD.Magazines.Visible = true
				HUD.Bullets.Visible = false
			else
				HUD.SAText.Text = FirearmProps.StoredAmmo
				HUD.Magazines.Visible = false
				HUD.Bullets.Visible = true
			end

			if FirearmProps.Suppressor then
				HUD.Att.Silencer.Visible = true
			else
				HUD.Att.Silencer.Visible = false
			end


			if FirearmProps.HasLaser then
				HUD.Att.Laser.Visible = true
				if FirearmState.LaserActive then
					if FirearmProps.HasIR and FirearmState.IRLaserActive == false then -- Enable IR
						TS:Create(HUD.Att.Laser, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(0,255,0), ImageTransparency = .123}):Play()
					elseif not (FirearmProps.HasIR and FirearmState.IRLaserActive) then -- No IR/Disable IR
						TS:Create(HUD.Att.Laser, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,255,255), ImageTransparency = .123}):Play()
					end
				else -- Laser deactivated
					TS:Create(HUD.Att.Laser, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,0,0), ImageTransparency = .5}):Play()
				end
			else -- No laser on firearm
				HUD.Att.Laser.Visible = false
			end

			if FirearmProps.HasBipod then
				HUD.Att.Bipod.Visible = true
			else
				HUD.Att.Bipod.Visible = false
			end

			if FirearmProps.HasFlashLight then
				HUD.Att.Flash.Visible = true
				if FirearmState.FlashLightActive then
					TS:Create(HUD.Att.Flash, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,255,255), ImageTransparency = .123}):Play()
				else
					TS:Create(HUD.Att.Flash, TweenInfo.new(.1,Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255,0,0), ImageTransparency = .5}):Play()
				end
			else
				HUD.Att.Flash.Visible = false
			end

			if FirearmProps.WeaponData.Type == "Grenade" then
				SE_GUI.GrenadeForce.Visible = true
			else
				SE_GUI.GrenadeForce.Visible = false
			end
		end
	end
end

function WeaponAction:CreateBullet()

		local Bullet = Instance.new("Part",ACS_Workspace.Client)
		Bullet.Name = Player.Name.."_Bullet"
		Bullet.CanCollide = false
		Bullet.Shape = Enum.PartType.Ball
		Bullet.Transparency = 1
		Bullet.Size = Vector3.new(1,1,1)

		local Origin 		= ViewModelState.WeaponInHand.Handle.Muzzle.WorldPosition
		local Direction 	= ViewModelState.WeaponInHand.Handle.Muzzle.WorldCFrame.LookVector + 
								(ViewModelState.WeaponInHand.Handle.Muzzle.WorldCFrame.UpVector * 
								(((FirearmProps.WeaponData.BulletDrop * FirearmProps.WeaponData.CurrentZero/4)/FirearmProps.WeaponData.MuzzleVelocity))/2)
		local BulletCF 		= CFrame.new(Origin, Direction) 
		local WalkMul 				= FirearmProps.WeaponData.WalkMult * ModTable.WalkMult
		local BColor 		= Color3.fromRGB(255,255,255)
		local bulletSpread

		if FirearmState.Aimming and FirearmProps.WeaponData.Bullets <= 1 then
			bulletSpread = CalculateBulletSpread()
		else
			bulletSpread = CalculateBulletSpread()
		end

		Direction = bulletSpread * Direction

		local tracerIsVisible = CalculateTracer(FirearmProps.WeaponData, FirearmState)

		if FirearmProps.WeaponData.RainbowMode then
			BColor = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
		else
			BColor = FirearmProps.WeaponData.TracerColor
		end

		if tracerIsVisible then
			if gameRules.ReplicatedBullets then
				Events.ServerBullet:FireServer(Origin,Direction,FirearmProps.WeaponData,ModTable)
			end

			if FirearmProps.WeaponData.Tracer == true then

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

			if FirearmProps.WeaponData.BulletFlare == true then
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
		local Force = Vector3.new(0,BulletMass * (196.2) - (FirearmProps.WeaponData.BulletDrop) * (196.2), 0)
		local BF = Instance.new("BodyForce",Bullet)

		Bullet.CFrame = BulletCF
		Bullet:ApplyImpulse(Direction * FirearmProps.WeaponData.MuzzleVelocity * ModTable.MuzzleVelocity)
		BF.Force = Force

		Debris:AddItem(Bullet, 5)

		self:CastRay(Bullet, Origin)
	end
end

function WeaponAction:Shoot()
	if FirearmProps.WeaponData and FirearmProps.WeaponData.Type == "Gun" and not FirearmState.Shooting and not FirearmState.Reloading then

		if FirearmState.Reloading or InputState.runKeyDown or FirearmState.SafeMode or FirearmState.CheckingMag then
			mouse1down = false
			return
		end

		if Ammo <= 0 or FirearmProps.WeaponData.Jammed then
			ViewModelState.WeaponInHand.Handle.Click:Play()
			mouse1down = false
			return
		end

		mouse1down = true

		task.defer(function()
			if FirearmProps.WeaponData and FirearmProps.WeaponData.ShootType == 1 then 
				FirearmState.Shooting = true	
				Events.Shoot:FireServer(FirearmProps.WeaponTool,FirearmProps.Suppressor,FirearmProps.FlashHider)
				for _ =  1, FirearmProps.WeaponData.Bullets do
					task.spawn(self:CreateBullet(FirearmProps.WeaponData))
				end
				Ammo = Ammo - 1
				GunFx(FirearmProps, FirearmState, ViewModelState)
				JamChance()
				self:UpdateGui()
				task.spawn(Recoil(FirearmProps.WeaponData))
				task.wait(60/FirearmProps.WeaponData.ShootRate)
				FirearmState.Shooting = false

			elseif FirearmProps.WeaponData and FirearmProps.WeaponData.ShootType == 2 then
				for i = 1, FirearmProps.WeaponData.BurstShot do
					if FirearmState.Shooting or Ammo <= 0 or mouse1down == false or FirearmProps.WeaponData.Jammed then
						break
					end
					FirearmState.Shooting = true	
					Events.Shoot:FireServer(FirearmProps.WeaponTool,FirearmProps.Suppressor,FirearmProps.FlashHider)
					for _ =  1, FirearmProps.WeaponData.Bullets do
						task.spawn(self:CreateBullet(FirearmProps.WeaponData))
					end
					Ammo = Ammo - 1
					GunFx(FirearmProps, FirearmState, ViewModelState)
					JamChance()
					self:UpdateGui()
					task.spawn(Recoil(FirearmProps.WeaponData))
					task.wait(60/FirearmProps.WeaponData.ShootRate)
					FirearmState.Shooting = false

				end
			elseif FirearmProps.WeaponData and FirearmProps.WeaponData.ShootType == 3 then
				while mouse1down do
					if FirearmState.Shooting or Ammo <= 0 or FirearmProps.WeaponData.Jammed then
						break
					end
					FirearmState.Shooting = true	
					Events.Shoot:FireServer(FirearmProps.WeaponTool,FirearmProps.Suppressor,FirearmProps.FlashHider)
					for _ =  1, FirearmProps.WeaponData.Bullets do
						task.spawn(self:CreateBullet(FirearmProps.WeaponData))
					end
					Ammo = Ammo - 1
					GunFx(FirearmProps, FirearmState, ViewModelState)
					JamChance()
					self:UpdateGui()
					task.spawn(Recoil(FirearmProps.WeaponData))
					task.wait(60/FirearmProps.WeaponData.ShootRate)
					FirearmState.Shooting = false

				end
			elseif FirearmProps.WeaponData and FirearmProps.WeaponData.ShootType == 4 or FirearmProps.WeaponData and FirearmProps.WeaponData.ShootType == 5 then
				FirearmState.Shooting = true	
				Events.Shoot:FireServer(FirearmProps.WeaponTool,FirearmProps.Suppressor,FirearmProps.FlashHider)
				for _ =  1, FirearmProps.WeaponData.Bullets do
					task.spawn(self:CreateBullet(FirearmProps.WeaponData))
				end
				Ammo = Ammo - 1
				GunFx(FirearmProps, FirearmState, ViewModelState)
				self:UpdateGui()
				task.spawn(Recoil(FirearmProps.WeaponData))
				PlayAnimation:PumpAnim()
				RunCheck()
				FirearmState.Shooting = false

			end
		end)

	elseif FirearmProps.WeaponData and FirearmProps.WeaponData.Type == "Melee" and not InputState.runKeyDown then
		if not FirearmState.Shooting then
			FirearmState.Shooting = true
			self:meleeCast()
			PlayAnimation:meleeAttack()
			RunCheck()
			FirearmState.Shooting = false
		end
	end
end

function WeaponAction:Unset(tool)
	FirearmState.CurrentlyEquippingTool = false
	Events.Equip:FireServer(FirearmProps.WeaponTool,2)
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

	InputState.mouse1down = false
	FirearmState.Aiming = false

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

	UIS.MouseIconEnabled = true
	UIS.MouseDeltaSensitivity = 1
	Camera.CameraType = Enum.CameraType.Custom
	Player.CameraMode = Enum.CameraMode.Classic


	if ViewModelState.WeaponInHand then

		FirearmProps.WeaponData.AmmoInGun = 0
		FirearmProps.WeaponData.StoredAmmo = 0

		ViewModelState.ViewModel:Destroy()
		ViewModelState.ViewModel 		= nil
		ViewModelState.WeaponInHand	= nil
		FirearmProps.WeaponTool		= nil
		ViewModelState.LArm 			= nil
		ViewModelState.RArm 			= nil
		ViewModelState.LArmWeld 		= nil
		ViewModelState.RArmWeld 		= nil
		FirearmProps.WeaponData 		= nil
		ViewModelState.AnimData		= nil
		
		FirearmProps.SightAttachmentachment  = nil
		FirearmProps.Reticle                 = nil
		FirearmProps.BarrelAttachment        = nil
		FirearmProps.UnderBarrelAttachment   = nil
		FirearmProps.OtherAttachment         = nil
		
		FirearmProps.HasLaser         = false
		FirearmProps.HasIR            = false
		FirearmProps.HasFlashLight    = false
		FirearmProps.HasBipod  = false
		
		FirearmProps.LaserDist = 0
		FirearmProps.Pointer = nil
		FirearmProps.BulletRecoilSpread = nil
		FirearmProps.RecoilPower = nil
		FirearmProps.Suppressor = false
		FirearmProps.FlashHider = false

		FirearmState.CancelReload 	= false
		FirearmState.Reloading 		= false
		FirearmState.SafeMode		= false
		FirearmState.CheckingMag	= false
		FirearmState.GRDebounce 	= false
		FirearmState.GunStance 		= 0
		resetMods()
		FirearmState.AimPartMode 	= 1
		FirearmState.GenerateBullet = 1

		SE_GUI.GunHUD.Visible = false
		SE_GUI.GrenadeForce.Visible = false
		ViewModelState.BipodCFrame = CFrame.new()
		if gameRules.ReplicatedLaser then
			Events.SVLaser:FireServer(nil,2,nil,false,FirearmProps.WeaponTool)
		end
	end
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
		self:UpdateGui()

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