local Cache = {};
local Checks = {};
local Controllers = {};

for _, Module in next, script:GetChildren() do
	Checks[Module.Name] = require(Module)
end

function Controllers:IsACheater(Player: Player)
	if (not Cache[Player]) then
		return
	end
	
	local Cheated = false
	
	for Name, Module in Checks do
		if Module:Check(Player, Cache[Player]) then
			Cheated = true
			Cache[Player].Strikes += 1
			Cache[Player].ActiveReason = Module.Reason
			break
		end
	end
	
	if (not Cheated) then
		Cache[Player].Position = Player.Character:GetPivot()
	end
	
	return Cheated and (Cache[Player].Strikes > 0)
end

function Controllers:GetActiveReason(Player: Player)
	return Cache[Player] and Cache[Player].ActiveReason
end

function Controllers:Init()
	local function PlayerAdded(Player: Player)
		Cache[Player] = {
			Air = 0,
			Strikes = 0,
			Position = nil,
			LastRespawn = 0,
			Connections = {},
			ActiveReason = '',
		}
		
		local function CharacterAdded(Character: Model)
			Cache[Player].Position = nil
			Cache[Player].LastRespawn = tick()
			
			for _, Connection in next, Cache[Player].Connections do
				if (Connection and Connection.Connected) then
					Connection:Disconnect()
				end
			end
			
			table.clear(Cache[Player].Connections)
			Cache[Player].Connections = {}
			
			local Humanoid: Humanoid = Character:WaitForChild('Humanoid');
			
			Cache[Player].Connections[#Cache[Player].Connections + 1] = Humanoid.Seated:Once(function()
				if (Humanoid.Sit) then
					Player:Kick('Sitting')
				end
			end)
			
			Cache[Player].Connections[#Cache[Player].Connections + 1] = Humanoid.Swimming:Once(function(Speed: number)
				Player:Kick('Swimming')
			end)
		end
		
		Player.CharacterAdded:Connect(CharacterAdded)
		
		if (Player.Character) then
			CharacterAdded(Player.Character)
		end
	end
	
	local function PlayerRemoved(Player: Player)
		if (Cache[Player] and Cache[Player].Connections) then
			for _, Connection in next, Cache[Player].Connections do
				if (Connection and Connection.Connected) then
					Connection:Disconnect()
				end
			end
		end
		
		table.clear(Cache[Player])
		Cache[Player] = nil
	end
	
	for _, Player in next, game.Players:GetPlayers() do
		task.spawn(PlayerAdded, Player)
	end

	game.Players.PlayerAdded:Connect(PlayerAdded)
	game.Players.PlayerRemoving:Connect(PlayerRemoved)
	
	return Controllers
end

return Controllers
