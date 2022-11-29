local RAND = require(script.Parent.Parent.Others.RAND)

local function GetBulletSpread(FirearmProps, CharacterState)
    local WalkMultiplier = FirearmProps.WeaponData.WalkMul
    local x, y = -FirearmProps.BulletSpread - (CharacterState.charWalkspeed/1) * WalkMultiplier, 
                 (FirearmProps.BulletSpread + (CharacterState.charWalkspeed/1) * WalkMultiplier) / (10 * FirearmProps.WeaponData.AimSpreadReduction)
    return x, y
end

return function(FirearmProps, CharacterState)
    return CFrame.Angles(
      math.rad(RAND(GetBulletSpread(FirearmProps, CharacterState))),
      math.rad(RAND(GetBulletSpread(FirearmProps, CharacterState))),
      math.rad(RAND(GetBulletSpread(FirearmProps, CharacterState)))
    )
end