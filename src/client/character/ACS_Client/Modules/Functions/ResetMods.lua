local ModTable = require(script.Parent.Parent.Others.ModTable)

return function ()
	ModTable.camRecoilMod.RecoilUp 		= 1
	ModTable.camRecoilMod.RecoilLeft 	= 1
	ModTable.camRecoilMod.RecoilRight 	= 1
	ModTable.camRecoilMod.RecoilTilt 	= 1

	ModTable.gunRecoilMod.RecoilUp 		= 1
	ModTable.gunRecoilMod.RecoilTilt 	= 1
	ModTable.gunRecoilMod.RecoilLeft 	= 1
	ModTable.gunRecoilMod.RecoilRight 	= 1

	ModTable.AimRM			= 1
	ModTable.SpreadRM 		= 1
	ModTable.DamageMod 		= 1
	ModTable.minDamageMod 	= 1

	ModTable.MinRecoilPower 		= 1
	ModTable.MaxRecoilPower 		= 1
	ModTable.RecoilPowerStepAmount 	= 1

	ModTable.MinSpread 					= 1
	ModTable.MaxSpread 					= 1
	ModTable.AimInaccuracyStepAmount 	= 1
	ModTable.AimInaccuracyDecrease 		= 1
	ModTable.WalkMult 					= 1
	ModTable.MuzzleVelocity 			= 1
end