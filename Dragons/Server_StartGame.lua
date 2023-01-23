function Server_StartGame(game, standing)
    local s = standing;
    for _, terr in pairs(s.Territories) do
        if terr.OwnerPlayerID ~= WL.PlayerID.Neutral then
            s.Territories[terr.ID].NumArmies = s.Territories[terr.ID].NumArmies.Add(WL.Armies.Create(0, {getDragon(terr.OwnerPlayerID)}))
        end
    end
    standing = s;
end

function getDragon(p)
    local builder = WL.CustomSpecialUnitBuilder.Create(p);
    builder.Name = "Dragon";
    builder.IncludeABeforeName = true;
    builder.ImageFilename = 'dragon.png';
    builder.AttackPower = 20;
    builder.DefensePower = 20;
    builder.Health = 20;
    builder.CombatOrder = 1362;
    builder.CanBeGiftedWithGiftCard = true;
    builder.CanBeTransferredToTeammate = true;
    builder.CanBeAirliftedToSelf = true;
    builder.CanBeAirliftedToTeammate = true;
    builder.IsVisibleToAllPlayers = false;
    return builder.Build();
end