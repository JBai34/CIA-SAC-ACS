local ViewModelState = require(script.Parent.Parent.States.ViewModelState)
--====================
local PlayAnimation = {}

function PlayAnimation:EquipAnim()
	AnimDebounce = false
	pcall(function()
		ViewModelState.AnimData.EquipAnim({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
	AnimDebounce = true
end


function PlayAnimation:IdleAnim()
	pcall(function()
		ViewModelState.AnimData.IdleAnim({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
	AnimDebounce = true
end

function PlayAnimation:SprintAnim()
	AnimDebounce = false
	pcall(function()
		ViewModelState.AnimData.SprintAnim({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
end

function PlayAnimation:HighReady()
	pcall(function()
		ViewModelState.AnimData.HighReady({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
end

function PlayAnimation:LowReady()
	pcall(function()
		ViewModelState.AnimData.LowReady({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
end

function PlayAnimation:Patrol()
	pcall(function()
		ViewModelState.AnimData.Patrol({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
end

function PlayAnimation:ReloadAnim()
	pcall(function()
		ViewModelState.AnimData.ReloadAnim({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
end

function PlayAnimation:TacticalReloadAnim()
	pcall(function()
		ViewModelState.AnimData.TacticalReloadAnim({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
end

function PlayAnimation:JammedAnim()
	pcall(function()
		ViewModelState.AnimData.JammedAnim({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
end

function PlayAnimation:PumpAnim()
	reloading = true
	pcall(function()
		ViewModelState.AnimData.PumpAnim({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
	reloading = false
end

function PlayAnimation:MagCheckAnim()
	CheckingMag = true
	pcall(function()
		ViewModelState.AnimData.MagCheck({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
	CheckingMag = false
end

function PlayAnimation:meleeAttack()
	pcall(function()
		ViewModelState.AnimData.meleeAttack({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
end

function PlayAnimation:GrenadeReady()
	pcall(function()
		ViewModelState.AnimData.GrenadeReady({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
end

function PlayAnimation:GrenadeThrow()
	pcall(function()
		ViewModelState.AnimData.GrenadeThrow({
			ViewModelState.RArmWeld,
			ViewModelState.LArmWeld,
			ViewModelState.GunWeld,
			ViewModelState.WeaponInHand,
			ViewModelState.ViewModel,
		})
	end)
end

return PlayAnimation