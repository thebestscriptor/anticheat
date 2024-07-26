local Check = {};
Check.Reason = 'Flying'

local Params = RaycastParams.new();
Params.FilterType = Enum.RaycastFilterType.Include
Params.FilterDescendantsInstances = {workspace:WaitForChild('Baseplate')}

function Check:Check(Player: Player, Check: {[string]: any})
	local Character = Player.Character
	local HumanoidRootPart = Character and Character:FindFirstChild('HumanoidRootPart')
	
	if (not HumanoidRootPart) then
		return
	end
	
	local Cast = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -12, 0), Params);
	
	if (HumanoidRootPart.Position.Y <= -10) then
		Player:LoadCharacter()
		return false
	end
	
	if (HumanoidRootPart.Position.Y < 0.8) then
		if (not Check.Air) then
			Check.Air = tick()
		end
		
		if (tick() - Check.Air) >= 3 then
			Player:LoadCharacter()
			return false
		end
	else
		if (Check.Air) then
			Check.Air = nil
		end
	end
	
	if not (Cast and Cast.Instance) then
		if (HumanoidRootPart.Position.Y > (workspace.Baseplate.Position.Y + 15)) then
			return (tick() - Check.LastRespawn) > 1.5
		end
	else
		return false
	end
	
	return false
end

return Check
