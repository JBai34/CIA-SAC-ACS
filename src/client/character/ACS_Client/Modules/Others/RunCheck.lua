local Players = game:GetService("Players")
local ReplicatedStorage= game:GetService("ReplicatedStorage")

local Player   = Players.LocalPlayer
local Character = Player.Character
--=====
local ACSClient:Folder  = script.Parent.Parent.Parent
local Modules:Folder 	= ACSClient.Modules

local Actions:Folder	= Modules.Actions
local PlayAnimation		= require(Actions.PlayAnimation)

local States:Folder 	= Modules.States
local FirearmState 		= require(States.FirearmState)
local ViewModelState 	= require(States.ViewModelState)
local InputState		= require(States.InputState)

--=====
local Engine 		= ReplicatedStorage:FindFirstChild("ACS_Engine")
local Events 		= Engine:FindFirstChild("Events")
--=========================================================

return function()
	if InputState.runKeyDown then
		InputState.mouse1down = false
		FirearmState.GunStance = 3
		Events.GunStance:FireServer(FirearmState.GunStance, ViewModelState.AnimData)
		PlayAnimation:SprintAnim()
	else
		if FirearmState.Aiming then
			FirearmState.GunStance = 2
			Events.GunStance:FireServer(FirearmState.GunStance,ViewModelState.AnimData)
		else
			FirearmState.GunStance = 0
			Events.GunStance:FireServer(FirearmState.GunStance,ViewModelState.AnimData)
		end
		PlayAnimation:IdleAnim()
	end
end