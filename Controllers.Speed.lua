local Check = {};
Check.Reason = 'Speed/Teleportation'

local function NoY(Position: Vector3)
	return Position * Vector3.new(1, 0, 1)
end

function Check:Check(Player: Player, Check: {[string]: any})
	local Character = Player.Character
	local HumanoidRootPart = Character and Character:FindFirstChild('HumanoidRootPart')
	
	if (not HumanoidRootPart) then
		return
	end
	
	if (not Check.Position) then
		Check.Position = Character:GetPivot()
	end
	
	local LastPosition = Check.Position
	local CurrentPosition = Character:GetPivot()
	
	local Distance = (NoY(CurrentPosition.Position) - NoY(LastPosition.Position)).Magnitude
	return (Distance >= 30)
end

return Check
