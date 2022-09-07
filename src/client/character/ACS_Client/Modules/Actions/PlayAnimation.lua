local ViewModelState = require(script.Parent.Parent.States.ViewModelState)
--====================
local PlayAnimation = {}
local objs = {
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		}

function PlayAnimation:EquipAnim()
	AnimDebounce = false
	pcall(function()
		ViewModelState.AnimData.EquipAnim(objs)
	end)
	AnimDebounce = true
end


function PlayAnimation:IdleAnim()
	pcall(function()
		ViewModelState.AnimData.IdleAnim(objs)
	end)
	AnimDebounce = true
end

function PlayAnimation:SprintAnim()
	AnimDebounce = false
	pcall(function()
		ViewModelState.AnimData.SprintAnim(objs)
	end)
end

function PlayAnimation:HighReady()
	pcall(function()
		ViewModelState.AnimData.HighReady(objs)
	end)
end

function PlayAnimation:LowReady()
	pcall(function()
		ViewModelState.AnimData.LowReady(objs)
	end)
end

function PlayAnimation:Patrol()
	pcall(function()
		ViewModelState.AnimData.Patrol(objs)
	end)
end

function PlayAnimation:ReloadAnim()
	pcall(function()
		ViewModelState.AnimData.ReloadAnim(objs)
	end)
end

function PlayAnimation:TacticalReloadAnim()
	pcall(function()
		ViewModelState.AnimData.TacticalReloadAnim(objs)
	end)
end

function PlayAnimation:JammedAnim()
	pcall(function()
		ViewModelState.AnimData.JammedAnim(objs)
	end)
end

function PlayAnimation:PumpAnim()
	reloading = true
	pcall(function()
		ViewModelState.AnimData.PumpAnim(objs)
	end)
	reloading = false
end

function PlayAnimation:MagCheckAnim()
	CheckingMag = true
	pcall(function()
		ViewModelState.AnimData.MagCheck(objs)
	end)
	CheckingMag = false
end

function PlayAnimation:meleeAttack()
	pcall(function()
		ViewModelState.AnimData.meleeAttack(objs)
	end)
end

function PlayAnimation:GrenadeReady()
	pcall(function()
		ViewModelState.AnimData.GrenadeReady(objs)
	end)
end

function PlayAnimation:GrenadeThrow()
	pcall(function()
		ViewModelState.AnimData.GrenadeThrow(objs)
	end)
end

return PlayAnimation