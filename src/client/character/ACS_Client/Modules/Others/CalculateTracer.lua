return function(weaponData, weaponState)
    if weaponData.Tracer or weaponData.BulletFlare then
		if weaponData.RandomTracer.Enabled then
			if (math.random(1, 100) <= weaponData.RandomTracer.Chance) then	
				return true
			else
				return false
			end
		else
			if weaponState.Tracers >= weaponData.TracerEveryXShots then
				weaponState.Tracers = 0
				return true
			else
				weaponState.Tracers += 1
				return false
			end
		end
	end
end