local TS = game:GetService("TweenService")

return function(firearmProps, firearmState, viewModelState)
    local ModTable = require(script.Parent.ModTable)
	if firearmProps.weaponData.Suppressor == true then
		viewModelState.WeaponInHand.Handle.Muzzle.Supressor:Play()
	else
		viewModelState.WeaponInHand.Handle.Muzzle.Fire:Play()
	end

	if firearmProps.FlashHider == true then
		viewModelState.WeaponInHand.Handle.Muzzle["Smoke"]:Emit(10)
	else
		viewModelState.WeaponInHand.Handle.Muzzle["FlashFX[Flash]"]:Emit(10)
		viewModelState.WeaponInHand.Handle.Muzzle["Smoke"]:Emit(10)
	end

	if firearmProps.BulletRecoilSpread then
		firearmProps.BulletRecoilSpread = math.min(
            firearmProps.WeaponData.MaxSpread * ModTable.MaxSpread, 
            firearmProps.BulletRecoilSpread + firearmProps.WeaponData.AimInaccuracyStepAmount * ModTable.AimInaccuracyStepAmount
        )
		firearmProps.RecoilPower =  math.min(
            firearmProps.WeaponData.MaxRecoilPower * ModTable.MaxRecoilPower, 
            firearmProps.RecoilPower + firearmProps.WeaponData.RecoilPowerStepAmount * ModTable.RecoilPowerStepAmount
        )
	end

	firearmState.GenerateBullet = firearmState.GenerateBullet + 1
	firearmState.LastSpreadUpdate = time()

	if firearmProps.Ammo > 0 or not firearmProps.WeaponData.SlideLock then
		TS:Create( 
            viewModelState.WeaponInHand.Handle.Slide, 
            TweenInfo.new(
            30/firearmProps.WeaponData.ShootRate,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            0,
            true), 
            {C0 =  firearmProps.WeaponData.SlideEx:Inverse()}):Play()
	elseif firearmProps.Ammo <= 0 and firearmProps.WeaponData.SlideLock then
		TS:Create(
            viewModelState.WeaponInHand.Handle.Slide,
            TweenInfo.new(
            30/firearmProps.WeaponData.ShootRate,
            Enum.EasingStyle.Linear), 
            {C0 =  firearmProps.WeaponData.SlideEx:Inverse()}):Play()
	end
	viewModelState.WeaponInHand.Handle.Chamber.Smoke:Emit(10)
	viewModelState.WeaponInHand.Handle.Chamber.Shell:Emit(1)
end