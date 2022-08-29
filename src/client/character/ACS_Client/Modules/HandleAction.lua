return function(actionName, inputState, inputObject)

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

	if actionName == "CycleLaser" and inputState == Enum.UserInputState.Begin and LaserAtt then
		SetLaser()
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
						Evt.NVG:Fire(NVG)
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