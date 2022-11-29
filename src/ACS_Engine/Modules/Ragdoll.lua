local Players = game.Players

return function(character)
	if character ~= nil then
		local player = Players:GetPlayerFromCharacter(character)
        if not player then return end
		if character.Humanoid.RigType == Enum.HumanoidRigType.R6 then

			local head = character:FindFirstChild('Head')
			local humanoid = character:FindFirstChild('Humanoid')
			local leftarm = character:FindFirstChild("Left Arm")
			local leftleg = character:FindFirstChild("Left Leg")
			local rightleg = character:FindFirstChild("Right Leg")
			local rightarm = character:FindFirstChild("Right Arm")
			local torso = character:FindFirstChild("Torso")

			humanoid.PlatformStand = true
			humanoid.AutoRotate = false

			local HeadA = Instance.new("Attachment")
			HeadA.Name = "HeadA"
			HeadA.Parent = head
			HeadA.Position = Vector3.new(0, -0.5, 0)
			HeadA.Rotation = Vector3.new(0, 0, -90)
			HeadA.Axis = Vector3.new(0, -1, 0)
			HeadA.SecondaryAxis = Vector3.new(1, 0, 0)

			local LeftArmA = Instance.new("Attachment")
			LeftArmA.Name = "LeftArmA"
			LeftArmA.Parent = leftarm
			LeftArmA.Position = Vector3.new(0.5, 0.6, 0)
			LeftArmA.Rotation = Vector3.new(0, 0, 0)
			LeftArmA.Axis = Vector3.new(1, 0, 0)
			LeftArmA.SecondaryAxis = Vector3.new(0, 1, 0)

			local LeftLegA = Instance.new("Attachment")
			LeftLegA.Name = "LeftLegA"
			LeftLegA.Parent = leftleg
			LeftLegA.Position = Vector3.new(0.1, 1, -0)
			LeftLegA.Rotation = Vector3.new(-0, -0, -90)
			LeftLegA.Axis = Vector3.new(-0, -1, 0)
			LeftLegA.SecondaryAxis = Vector3.new(1, 0, 0)

			local RightArmA = Instance.new("Attachment")
			RightArmA.Name = "RightArmA"
			RightArmA.Parent = rightarm
			RightArmA.Position = Vector3.new(-0.5, 0.6, 0)
			RightArmA.Rotation = Vector3.new(-180, 0, -180)
			RightArmA.Axis = Vector3.new(-1, 0, 0)
			RightArmA.SecondaryAxis = Vector3.new(0, 1, 0)

			local RightLegA = Instance.new("Attachment")
			RightLegA.Name = "RightLegA"
			RightLegA.Parent = rightleg
			RightLegA.Position = Vector3.new(-0.1, 1, 0)
			RightLegA.Rotation = Vector3.new(0, 0, -90)
			RightLegA.Axis = Vector3.new(-0, -1, -0)
			RightLegA.SecondaryAxis = Vector3.new(1, 0, -0)

			local TorsoA = Instance.new("Attachment")
			TorsoA.Name = "TorsoA"
			TorsoA.Parent = torso
			TorsoA.Position = Vector3.new(0.4, -1, 0)
			TorsoA.Rotation = Vector3.new(0, 0, -90)
			TorsoA.Axis = Vector3.new(0, -1, 0)
			TorsoA.SecondaryAxis = Vector3.new(1, 0, 0)

			local TorsoA1 = Instance.new("Attachment")
			TorsoA1.Name = "TorsoA1"
			TorsoA1.Parent = torso
			TorsoA1.Position = Vector3.new(-0.4, -1, 0)
			TorsoA1.Rotation = Vector3.new(0, 0, -90)
			TorsoA1.Axis = Vector3.new(0, -1, 0)
			TorsoA1.SecondaryAxis = Vector3.new(1, 0, 0)

			local TorsoA2 = Instance.new("Attachment")
			TorsoA2.Name = "TorsoA2"
			TorsoA2.Parent = torso
			TorsoA2.Position = Vector3.new(-1, 0.8, 0)
			TorsoA2.Rotation = Vector3.new(-0, 0, -0)
			TorsoA2.Axis = Vector3.new(1, -0, 0)
			TorsoA2.SecondaryAxis = Vector3.new(0, 1, -0)

			local TorsoA3 = Instance.new("Attachment")
			TorsoA3.Name = "TorsoA3"
			TorsoA3.Parent = torso
			TorsoA3.Position = Vector3.new(1, 0.8, 0)
			TorsoA3.Rotation = Vector3.new(180, 0, 180)
			TorsoA3.Axis = Vector3.new(-1, -0, 0)
			TorsoA3.SecondaryAxis = Vector3.new(-0, 1, -0)

			local TorsoA4 = Instance.new("Attachment")
			TorsoA4.Name = "TorsoA4"
			TorsoA4.Parent = torso
			TorsoA4.Position = Vector3.new(-0, 1, 0)
			TorsoA4.Rotation = Vector3.new(0, 0, -90)
			TorsoA4.Axis = Vector3.new(0, -1, 0)
			TorsoA4.SecondaryAxis = Vector3.new(1, 0, 0)


			local HA = Instance.new("BallSocketConstraint")
			HA.Parent = head
			HA.Attachment0 = HeadA
			HA.Attachment1 = TorsoA4
			HA.Enabled = true

			local LAT = Instance.new("BallSocketConstraint")
			LAT.Parent = leftarm
			LAT.Attachment0 = LeftArmA
			LAT.Attachment1 = TorsoA2
			LAT.Enabled = true

			local RAT = Instance.new("BallSocketConstraint")
			RAT.Parent = rightarm
			RAT.Attachment0 = RightArmA
			RAT.Attachment1 = TorsoA3
			RAT.Enabled = true

			local HA1 = Instance.new("BallSocketConstraint")
			HA.Parent = head
			HA.Attachment0 = HeadA
			HA.Attachment1 = TorsoA4
			HA.Enabled = true

			local TLL = Instance.new("BallSocketConstraint")
			TLL.Parent = torso
			TLL.Attachment0 = TorsoA1
			TLL.Attachment1 = LeftLegA
			TLL.Enabled = true

			local TRL = Instance.new("BallSocketConstraint")
			TRL.Parent = torso
			TRL.Attachment0 = TorsoA
			TRL.Attachment1 = RightLegA
			TRL.Enabled = true

		else
			------------------------------------------------
			-----------// R15 Ragdoll \\--------------------
			------------------------------------------------

			local head 		= character:FindFirstChild('Head')
			local humanoid 	= character:FindFirstChild('Humanoid') 
			local lua 		= character:FindFirstChild("LeftUpperArm") 
			local lla 		= character:FindFirstChild("LeftLowerArm") 
			local lh 		= character:FindFirstChild("LeftHand") 
			local lul 		= character:FindFirstChild("LeftUpperLeg") 
			local lll 		= character:FindFirstChild("LeftLowerLeg") 
			local lf 		= character:FindFirstChild("LeftFoot") 
			local rul 		= character:FindFirstChild("RightUpperLeg") 
			local rll 		= character:FindFirstChild("RightLowerLeg")
			local rf 		= character:FindFirstChild("RightFoot") 
			local rua 		= character:FindFirstChild("RightUpperArm") 
			local rla 		= character:FindFirstChild("RightLowerArm") 
			local rh 		= character:FindFirstChild("RightHand") 
			local ut 		= character:FindFirstChild("UpperTorso") 
			local lt 		= character:FindFirstChild("LowerTorso") 

			humanoid.PlatformStand = true
			humanoid.AutoRotate = false

			local HA = Instance.new("BallSocketConstraint")
			HA.Parent = head
			HA.Attachment0 = head.NeckRigAttachment
			HA.Attachment1 = ut.NeckRigAttachment
			HA.Enabled = true
			HA.LimitsEnabled = true
			HA.TwistLimitsEnabled = true
			HA.UpperAngle = 90
			HA.TwistLowerAngle = -60
			HA.TwistUpperAngle = 60

			local LAT = Instance.new("BallSocketConstraint")
			LAT.Parent = lua
			LAT.Attachment0 = lua.LeftShoulderRigAttachment
			LAT.Attachment1 = ut.LeftShoulderRigAttachment
			LAT.Enabled = true
			LAT.LimitsEnabled = false
			LAT.TwistLimitsEnabled = false
			LAT.UpperAngle = 180
			LAT.TwistLowerAngle = -90
			LAT.TwistUpperAngle = 0

			local LAT1 = Instance.new("BallSocketConstraint")
			LAT1.Parent = lua
			LAT1.Attachment0 = lla.LeftElbowRigAttachment
			LAT1.Attachment1 = lua.LeftElbowRigAttachment
			LAT1.Enabled = true
			LAT1.LimitsEnabled = true
			LAT1.TwistLimitsEnabled = true
			LAT1.UpperAngle = 0
			LAT1.TwistLowerAngle = -160
			LAT1.TwistUpperAngle = 0		

			local LAT2 = Instance.new("BallSocketConstraint")
			LAT2.Parent = lua
			LAT2.Attachment0 = lla.LeftWristRigAttachment
			LAT2.Attachment1 = lh.LeftWristRigAttachment
			LAT2.Enabled = true
			LAT2.LimitsEnabled = true
			LAT2.TwistLimitsEnabled = true
			LAT2.UpperAngle = 25
			LAT2.TwistLowerAngle = -25
			LAT2.TwistUpperAngle = 25

			local RAT = Instance.new("BallSocketConstraint")
			RAT.Parent = rua
			RAT.Attachment0 = rua.RightShoulderRigAttachment
			RAT.Attachment1 = ut.RightShoulderRigAttachment
			RAT.Enabled = true
			RAT.LimitsEnabled = false
			RAT.TwistLimitsEnabled = false
			RAT.UpperAngle = 90
			RAT.TwistLowerAngle = 0
			RAT.TwistUpperAngle = 0

			local RAT1 = Instance.new("BallSocketConstraint")
			RAT1.Parent = rla
			RAT1.Attachment0 = rla.RightElbowRigAttachment
			RAT1.Attachment1 = rua.RightElbowRigAttachment
			RAT1.Enabled = true
			RAT1.LimitsEnabled = true
			RAT1.TwistLimitsEnabled = true
			RAT1.UpperAngle = 0
			RAT1.TwistLowerAngle = -160
			RAT1.TwistUpperAngle = 0

			local RAT2 = Instance.new("BallSocketConstraint")
			RAT2.Parent = rh
			RAT2.Attachment0 = rla.RightWristRigAttachment
			RAT2.Attachment1 = rh.RightWristRigAttachment
			RAT2.Enabled = true
			RAT2.LimitsEnabled = true
			RAT2.TwistLimitsEnabled = true
			RAT2.UpperAngle = 25
			RAT2.TwistLowerAngle = -25
			RAT2.TwistUpperAngle = 25


			local TLL = Instance.new("BallSocketConstraint")
			TLL.Parent = ut
			TLL.Attachment0 = ut.WaistRigAttachment
			TLL.Attachment1 = lt.WaistRigAttachment
			TLL.Enabled = true
			TLL.LimitsEnabled = true
			TLL.TwistLimitsEnabled = true
			TLL.UpperAngle = 30
			TLL.TwistLowerAngle = -30
			TLL.TwistUpperAngle = 30

			local TLL1 = Instance.new("BallSocketConstraint")
			TLL1.Parent = rul
			TLL1.Attachment0 = rul.RightHipRigAttachment
			TLL1.Attachment1 = lt.RightHipRigAttachment
			TLL1.Enabled = true
			TLL1.LimitsEnabled = true
			TLL1.TwistLimitsEnabled = true
			TLL1.UpperAngle = 20
			TLL1.TwistLowerAngle = -75
			TLL1.TwistUpperAngle = 75

			local TLL2 = Instance.new("BallSocketConstraint")
			TLL2.Parent = rll
			TLL2.Attachment0 = rll.RightKneeRigAttachment
			TLL2.Attachment1 = rul.RightKneeRigAttachment
			TLL2.Enabled = true
			TLL2.LimitsEnabled = true
			TLL2.TwistLimitsEnabled = true
			TLL2.UpperAngle = 0
			TLL2.TwistLowerAngle = 0
			TLL2.TwistUpperAngle = 90

			local TLL3 = Instance.new("BallSocketConstraint")
			TLL3.Parent = rf
			TLL3.Attachment0 = rf.RightAnkleRigAttachment
			TLL3.Attachment1 = rll.RightAnkleRigAttachment
			TLL3.Enabled = true
			TLL3.LimitsEnabled = true
			TLL3.TwistLimitsEnabled = true
			TLL3.UpperAngle = 25
			TLL3.TwistLowerAngle = -25
			TLL3.TwistUpperAngle = 25

			local TLL4 = Instance.new("BallSocketConstraint")
			TLL4.Parent = lul
			TLL4.Attachment0 = lul.LeftHipRigAttachment
			TLL4.Attachment1 = lt.LeftHipRigAttachment
			TLL4.Enabled = true
			TLL4.LimitsEnabled = true
			TLL4.TwistLimitsEnabled = true
			TLL4.UpperAngle = 30
			TLL4.TwistLowerAngle = -90
			TLL4.TwistUpperAngle = 90

			local TLL5 = Instance.new("BallSocketConstraint")
			TLL5.Parent = lll
			TLL5.Attachment0 = lll.LeftKneeRigAttachment
			TLL5.Attachment1 = lul.LeftKneeRigAttachment
			TLL5.Enabled = true
			TLL5.LimitsEnabled = true
			TLL5.TwistLimitsEnabled = true
			TLL5.UpperAngle = 0
			TLL5.TwistLowerAngle = 0
			TLL5.TwistUpperAngle = 90

			local TLL6 = Instance.new("BallSocketConstraint")
			TLL6.Parent = lf
			TLL6.Attachment0 = lf.LeftAnkleRigAttachment
			TLL6.Attachment1 = lll.LeftAnkleRigAttachment
			TLL6.Enabled = true
			TLL6.LimitsEnabled = true
			TLL6.TwistLimitsEnabled = true
			TLL6.UpperAngle = 25
			TLL6.TwistLowerAngle = -25
			TLL6.TwistUpperAngle = 25
		end

		for _, v in pairs(character:GetDescendants()) do -- replace character with the character
			if not (v:IsA("Accessory") or v:IsA("Model")) and v:IsA("Motor6D") then
				v:Destroy()
			end
		end
		
		if character:FindFirstChild("HumanoidRootPart") ~= nil then
			character.HumanoidRootPart:Destroy()
		end
		
	end
end
