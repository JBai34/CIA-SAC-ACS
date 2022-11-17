local Players = game:GetService("Players")
--=====
local Modules = script.Modules
local States = Modules.States
local FirearmState = require(States.FirearmState)

local Actions = Modules.Actions
local WeaponAction = require(Actions.WeaponAction)

local Props = Modules.Props
local FirearmProps = require(Props.FirearmProps)

local Player = Players.LocalPlayer
if not Player.Character then Player.CharacterAdded:Wait() end
local Character = Player.Character

--=====

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
				WeaponAction:Setup(tool)
				--end)

			elseif FirearmState.CurrentlyEquippingTool then
				pcall(function()
					WeaponAction:Unset(tool)
					WeaponAction:Setup(tool)
				end)
			end;
		end;
	end

end)

Character.ChildRemoved:Connect(function(tool)
	if tool == FirearmProps.WeaponTool then
		if FirearmState.CurrentlyEquippingTool then
			WeaponAction:Unset(tool)
		end
	end
end)
