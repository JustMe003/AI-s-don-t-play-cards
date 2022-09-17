function Server_StartGame(game, standing)
    local t = {};
    local s = standing;
    for _, v in pairs(s.Territories) do
        if not v.IsNeutral and t[v.OwnerPlayerID] == nil then
            armies = s.Territories[v.ID].NumArmies;
            armies = WL.Armies.Create(WL.Armies.Create(s.Territories[v.ID].NumArmies.NumArmies, {WL.Boss1.Create(v.OwnerPlayerID)}))
            s.Territories[v.OwnerPlayerID].NumArmies = armies;
            t[v.OwnerPlayerID] = true;
        end
    end
    standing = s;
end
