local Modules = script.Parent.Parent
--=====
local States = Modules.States
local FirearmState = require(States.FirearmState)
local ViewModelState = require(States.ViewModelState)
local CharacterState = require(States.CharacterState)
local InputState	= require(States.InputState)

local Props = Modules.Props
local FirearmProps = require(Props.FirearmProps)

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
--=====
local ReplicatedStorage 			= game:GetService("ReplicatedStorage")
local ACS_Workspace = workspace:FindFirstChild("ACS_WorkSpace")
local Engine 		= ReplicatedStorage:FindFirstChild("ACS_Engine")
local Events 				= Engine:FindFirstChild("Events")
local Mods 			= Engine:FindFirstChild("Modules")
local HUDs 					= Engine:FindFirstChild("HUD")
local Essential 			= Engine:FindFirstChild("Essential")
local ArmModel 				= Engine:FindFirstChild("ArmModel")
local GunModels 			= Engine:FindFirstChild("GunModels")
local AttModels 			= Engine:FindFirstChild("AttModels")
local AttModules  			= Engine:FindFirstChild("AttModules")
local Rules			= Engine:FindFirstChild("GameRules")
local PastaFx		= Engine:FindFirstChild("FX")

local gameRules		         = require(Rules:WaitForChild("Config"))
local SpringMod 	         = require(Mods:WaitForChild("Spring"))
local HitMod 		         = require(Mods:WaitForChild("Hitmarker"))
local Thread 		         = require(Mods:WaitForChild("Thread"))
local Ultil			         = require(Mods:WaitForChild("Utilities"))
local ACS_Client 	= Player.Character:WaitForChild("ACS_Client")
--=========================================================
local WeaponAction = {}

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
			bulletSpread = CFrame.Angles(
				math.rad(RAND(-FirearmProps.BulletSpread - (charspeed/1) * WalkMul, FirearmProps.BulletSpread + (charspeed/1) * WalkMul) / (10 * weaponData.AimSpreadReduction)),
				math.rad(RAND(-FirearmProps.BulletSpread - (charspeed/1) * WalkMul, FirearmProps.BulletSpread + (charspeed/1) * WalkMul) / (10 * weaponData.AimSpreadReduction)),
				math.rad(RAND(-FirearmProps.BulletSpread - (charspeed/1) * WalkMul, FirearmProps.BulletSpread + (charspeed/1) * WalkMul) / (10 * weaponData.AimSpreadReduction))
			)
		else
			bulletSpread = CFrame.Angles(
				math.rad(RAND(-FirearmProps.BulletSpread - (charspeed/1) * WalkMul, FirearmProps.BulletSpread + (charspeed/1) * WalkMul) / 10),
				math.rad(RAND(-FirearmProps.BulletSpread - (charspeed/1) * WalkMul, FirearmProps.BulletSpread + (charspeed/1) * WalkMul) / 10),
				math.rad(RAND(-FirearmProps.BulletSpread - (charspeed/1) * WalkMul, FirearmProps.BulletSpread + (charspeed/1) * WalkMul) / 10)
			)
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
				PumpAnim()
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

return WeaponAction