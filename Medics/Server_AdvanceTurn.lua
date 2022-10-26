function Server_AdvanceTurn_Start(game, addNewOrder)
    medics = {};
    for p, _ in pairs(game.Game.PlayingPlayers) do
        medics[p] = 0;
    end
    for _, terr in pairs(game.ServerGame.LatestTurnStanding.Territories) do
        if terr.NumArmies.SpecialUnits ~= nil and #terr.NumArmies.SpecialUnits > 0 then
            medics[terr.OwnerPlayerID] = medics[terr.OwnerPlayerID] + getNMedics(terr.NumArmies);
        end
    end
end

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
    if order.proxyType == "GameOrderCustom" and startsWith(order.Payload, "BuyMedic_") and medics[order.PlayerID] < Mod.Settings.MaxUnits then
        local terrID = tonumber(string.sub(order.Payload, #"BuyMedic_" + 1));
        if order.CostOpt ~= nil and Mod.Settings.Cost == order.CostOpt[WL.ResourceType.Gold] and game.ServerGame.LatestTurnStanding.Territories[terrID].OwnerPlayerID == order.PlayerID then
            local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID);
            builder.Name = "Medic";
            builder.AttackPower = Mod.Settings.Health;
            builder.CanBeAirliftedToSelf = true;
            builder.CanBeAirliftedToTeammate = true;
            builder.CanBeGiftedWithGiftCard = true;
            builder.CanBeTransferredToTeammate = true;
            builder.CombatOrder = 9120;
            builder.DamageAbsorbedWhenAttacked = Mod.Settings.Health;
            builder.DamageToKill = Mod.Settings.Health;
            builder.DefensePower = Mod.Settings.Health;
            builder.ImageFilename = "Medic.png";
            builder.IncludeABeforeName = true;
            builder.TextOverHeadOpt = "Medic";
            local mod = WL.TerritoryModification.Create(terrID);
            mod.AddSpecialUnits = {builder.Build()};

            local event = WL.GameOrderEvent.Create(order.PlayerID, "Purchased a Medic", {}, {mod});
            event.JumpToActionSpotOpt = WL.RectangleVM.Create(game.Map.Territories[terrID].MiddlePointX, game.Map.Territories[terrID].MiddlePointY, game.Map.Territories[terrID].MiddlePointX, game.Map.Territories[terrID].MiddlePointY);
            addNewOrder(event);
            medics[order.PlayerID] = medics[order.PlayerID] + 1;
        end
        skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage);
    elseif order.proxyType == "GameOrderAttackTransfer" and orderResult.IsAttack and getNMedics(orderResult.ActualArmies) == 0 then
        for connID, _ in pairs(game.Map.Territories[order.To].ConnectedTo) do
            if getNMedics(game.ServerGame.LatestTurnStanding.Territories[connID].NumArmies) > 0 then
                local mod = WL.TerritoryModification.Create(connID);
                if game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID == game.ServerGame.LatestTurnStanding.Territories[connID].OwnerPlayerID then
                    mod.AddArmies = round(orderResult.DefendingArmiesKilled.NumArmies * (Mod.Settings.Percentage / 100));
                elseif game.ServerGame.LatestTurnStanding.Territories[order.From].OwnerPlayerID == game.ServerGame.LatestTurnStanding.Territories[connID].OwnerPlayerID then
                    mod.AddArmies = round(orderResult.AttackingArmiesKilled.NumArmies * (Mod.Settings.Percentage / 100));
                end
                if mod.AddArmies ~= nil and mod.AddArmies > 0 then
                    local event = WL.GameOrderEvent.Create(game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID, "Medic recovered " .. Mod.Settings.Percentage .. "% armies", {}, {mod});
                    event.JumpToActionSpotOpt = WL.RectangleVM.Create(game.Map.Territories[connID].MiddlePointX, game.Map.Territories[connID].MiddlePointY, game.Map.Territories[connID].MiddlePointX, game.Map.Territories[connID].MiddlePointY);
                    addNewOrder(event);
                end
            end
        end
    end
end

function Server_AdvanceTurn_End(game, addNewOrder)
	
end

function getNMedics(armies)
    local ret = 0;
    for _, sp in pairs(armies.SpecialUnits) do
        if sp.Name == "Medic" then
            ret = ret + 1;
        end
    end
    return ret;
end

function startsWith(s, sub)
    return string.sub(s, 1, #sub) == sub;
end

function round(n)
    return math.floor(n + 0.5);
end