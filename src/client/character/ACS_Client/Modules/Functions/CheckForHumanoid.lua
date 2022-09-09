return function(raycastResult)
	local FoundHumanoid = false
	local HumanoidInstance: Humanoid = nil
	if raycastResult then
		if (raycastResult.Parent:FindFirstChildOfClass("Humanoid") or raycastResult.Parent.Parent:FindFirstChildOfClass("Humanoid")) then
			FoundHumanoid = true
			if raycastResult.Parent:FindFirstChildOfClass('Humanoid') or raycastResult.Parent.Parent:FindFirstChildOfClass('Humanoid') then
				HumanoidInstance = raycastResult.Parent:FindFirstChildOfClass('Humanoid') or raycastResult.Parent.Parent:FindFirstChildOfClass('Humanoid')
			end
		else
			FoundHumanoid = false
		end	
	end
	return FoundHumanoid, HumanoidInstance
end