local Players = game:GetService("Players")
local CAS = game:GetService("ContextActionService")
--=====
local Modules = script.Parent.Modules
local States = Modules.States
local FirearmState = require(States.FirearmState)

local Actions = Modules.Actions
local EquipAction = require(Actions.EquipAction)
local HandleAction = require(Modules.HandleAction)

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
				EquipAction:Setup(tool)
				--end)

			elseif FirearmState.CurrentlyEquippingTool then
				pcall(function()
					EquipAction:Unset(tool)
					EquipAction:Setup(tool)
				end)
			end;
		end;
	end

end)

Character.ChildRemoved:Connect(function(tool)
	if tool == FirearmProps.WeaponTool then
		if FirearmState.CurrentlyEquippingTool then
			EquipAction:Unset(tool)
		end
	end
end)
print("Run")
CAS:BindAction("Run", HandleAction, false, Enum.KeyCode.LeftShift)

CAS:BindAction("Stand", HandleAction, false, Enum.KeyCode.X)
CAS:BindAction("Crouch", HandleAction, false, Enum.KeyCode.C)
CAS:BindAction("NVG", HandleAction, false, Enum.KeyCode.N)

CAS:BindAction("ToggleWalk", HandleAction, false, Enum.KeyCode.Z)
CAS:BindAction("LeanLeft", HandleAction, false, Enum.KeyCode.Q)
CAS:BindAction("LeanRight", HandleAction, false, Enum.KeyCode.E)