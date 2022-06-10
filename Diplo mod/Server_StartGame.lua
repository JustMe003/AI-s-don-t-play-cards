function Server_StartGame(game, standing)
	local data = Mod.PublicGameData;
	local relations = {};
	local isInFaction = {};
	local playerInFaction = {};
	local playerData = Mod.PlayerGameData;
	for i, p in pairs(game.ServerGame.Game.PlayingPlayers) do
		relations[i] = {};
		isInFaction[i] = false;
		for k, _ in pairs(game.ServerGame.Game.PlayingPlayers) do
			relations[i][k] = "InPeace";
		end
		if not p.IsAI then
			playerData[i] = {};
			playerData[i].LastMessage = game.ServerGame.Game.ServerTime;
		end
	end
	data.Relations = relations;
	data.IsInFaction = isInFaction;
	data.PlayerInFaction = playerInFaction;
	Mod.PlayerGameData = playerData;
	Mod.PublicGameData = data;
end