local ModTable = require(script.Parent.Parent.Others.ModTable)
return function(ModData)

	ModTable.camRecoilMod.RecoilUp 		= ModTable.camRecoilMod.RecoilUp * ModData.camRecoil.RecoilUp
	ModTable.camRecoilMod.RecoilLeft 	= ModTable.camRecoilMod.RecoilLeft * ModData.camRecoil.RecoilLeft
	ModTable.camRecoilMod.RecoilRight 	= ModTable.camRecoilMod.RecoilRight * ModData.camRecoil.RecoilRight
	ModTable.camRecoilMod.RecoilTilt 	= ModTable.camRecoilMod.RecoilTilt * ModData.camRecoil.RecoilTilt

	ModTable.gunRecoilMod.RecoilUp 		= ModTable.gunRecoilMod.RecoilUp * ModData.gunRecoil.RecoilUp
	ModTable.gunRecoilMod.RecoilTilt 	= ModTable.gunRecoilMod.RecoilTilt * ModData.gunRecoil.RecoilTilt
	ModTable.gunRecoilMod.RecoilLeft 	= ModTable.gunRecoilMod.RecoilLeft * ModData.gunRecoil.RecoilLeft
	ModTable.gunRecoilMod.RecoilRight 	= ModTable.gunRecoilMod.RecoilRight * ModData.gunRecoil.RecoilRight

	ModTable.AimRM						= ModTable.AimRM * ModData.AimRecoilReduction
	ModTable.SpreadRM 					= ModTable.SpreadRM * ModData.AimSpreadReduction
	ModTable.DamageMod 					= ModTable.DamageMod * ModData.DamageMod
	ModTable.minDamageMod 				= ModTable.minDamageMod * ModData.minDamageMod

	ModTable.MinRecoilPower 			= ModTable.MinRecoilPower * ModData.MinRecoilPower
	ModTable.MaxRecoilPower 			= ModTable.MaxRecoilPower * ModData.MaxRecoilPower
	ModTable.RecoilPowerStepAmount 		= ModTable.RecoilPowerStepAmount * ModData.RecoilPowerStepAmount

	ModTable.MinSpread 					= ModTable.MinSpread * ModData.MinSpread
	ModTable.MaxSpread 					= ModTable.MaxSpread * ModData.MaxSpread
	ModTable.AimInaccuracyStepAmount 	= ModTable.AimInaccuracyStepAmount * ModData.AimInaccuracyStepAmount
	ModTable.AimInaccuracyDecrease 		= ModTable.AimInaccuracyDecrease * ModData.AimInaccuracyDecrease
	ModTable.WalkMult 					= ModTable.WalkMult * ModData.WalkMult
	ModTable.MuzzleVelocity 			= ModTable.MuzzleVelocity * ModData.MuzzleVelocityMod
end