

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
--=====
local Modules = script.Modules
local States = Modules.States
local FirearmState = require(States.FirearmState)
local ViewModelState = require(States.ViewModelState)
local CharacterState = require(States.CharacterState)
local InputState	= require(States.InputState)

local Props = Modules.Props
local FirearmProps = require(Props.FirearmProps)

local CalculateBulletSpread = require(Modules.Others.CalculateBulletSpread)

local Player = Players.LocalPlayer
if not Player.Character then Player.CharacterAdded:Wait() end
local Character = Player.Character

--=====
local ReplicatedStorage 			= game:GetService("ReplicatedStorage")

Character.ChildAdded:Connect(function(tool)
	if      
        tool:IsA('Tool') and Character.Humanoid.Health > 0 and 
        not FirearmState.CurrentlyEquippingTool and tool:FindFirstChild("ACS_Settings") ~= nil and 
        (require(tool.ACS_Settings).Type == 'Gun' or require(tool.ACS_Settings).Type == 'Melee' or require(tool.ACS_Settings).Type == 'Grenade') 
    then
		local notDriving = true
		if Character:WaitForChild('Humanoid').Sit and Character.Humanoid.SeatPart:IsA("VehicleSeat") then
			notDriving = false;
		end

		if notDriving then
			if not FirearmState.CurrentlyEquippingTool then
				--pcall(function()
				setup(tool)
				--end)

			elseif FirearmState.CurrentlyEquippingTool then
				pcall(function()
					unset()
					setup(tool)
				end)
			end;
		end;
	end

end)

Character.ChildRemoved:Connect(function(tool)
	if tool == WeaponTool then
		if CurrentlyEquippingTool then
			unset()
		end
	end
end)
