function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
    for i = 0, game.Game.TurnNumber - 1 do
		for j = 0, game.Game.TurnNumber - 2 do
			game.GetStanding(i, j, function(t) 
				print("i: " .. i, "j: " .. j, t.Territories[1].NumArmies.NumArmies);
			end);
		end
		print();
	end 
end