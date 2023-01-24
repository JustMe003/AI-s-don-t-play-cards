require("UI");
function Client_PresentConfigureUI(rootParent)
	Init(rootParent);
    
    dragons = Mod.Settings.Dragons
    if dragons == nil then dragons = {}; end

    root = GetRoot().SetFlexibleWidth(1);
    colors = GetColors();
    showMain();
end

function showMain()
    DestroyWindow();
    SetWindow("Main");

    for _, dragon in pairs(dragons) do
        CreateButton(root).SetText(dragon.Name).SetColor(dragon.Color).SetOnClick(function() modifyDragon(dragon); end);
    end

    CreateEmpty(root).SetPreferredHeight(5);
    
    CreateButton(root).SetText("Add Dragon").SetColor(colors.Lime).SetOnClick(function() table.insert(dragons, initDragon()); modifyDragon(dragons[#dragons]) end).SetInteractable(#dragons < 5);
end

function modifyDragon(dragon)
    DestroyWindow();
    SetWindow("modifyDragon");
    
    local dragonInputs = {};
    
    CreateButton(root).SetOnClick(function() saveDragon(dragon, dragonInputs); showMain(); end).SetColor(colors.Orange).SetText("Return");
    local line = CreateHorz(root).SetFlexibleWidth(1);
    CreateLabel(line).SetText("Dragon name: ").SetColor(colors.Textcolor);
    dragonInputs.Name = CreateTextInputField(line).SetText(dragon.Name).SetFlexibleWidth(1);
    
    line = CreateHorz(root).SetFlexibleWidth(1);
    CreateLabel(line).SetText("Dragon color: ").SetColor(colors.Textcolor);
    CreateButton(line).SetText(dragon.ColorName).SetColor(dragon.Color).SetOnClick(function() if #dragons < 5 then saveDragon(dragon, dragonInputs); changeColor(dragon); else UI.Alert("To pick a different color for '" .. dragonInputs.Name.GetText() .. "', you must first delete another dragon. You can at most have 5 dragons, all with distinct colors") end end);
    
    line = CreateHorz(root).SetFlexibleWidth(1);
    dragonInputs.UseHealth = CreateCheckBox(line).SetText(" ").SetIsChecked(dragon.UseHealth);
    CreateLabel(line).SetText("Use dynamic health").SetColor(colors.Textcolor);

    local vert = CreateVert(root);
    
    line = CreateHorz(root).SetFlexibleWidth(1);
    dragonInputs.DragonBreathAttack = CreateCheckBox(line).SetText(" ").SetIsChecked(dragon.DragonBreathAttack);
    CreateLabel(line).SetText("Enable Dragon Breath Attack").SetColor(colors.Textcolor);
    
    line = CreateHorz(root).SetFlexibleWidth(1);
    dragonInputs.IsVisibleToAllPlayers = CreateCheckBox(line).SetText(" ").SetIsChecked(dragon.IsVisibleToAllPlayers);
    CreateLabel(line).SetText("This dragon is always visible for every player").SetColor(colors.Textcolor);
    
    line = CreateHorz(root).SetFlexibleWidth(1);
    dragonInputs.CanBeAirliftedToSelf = CreateCheckBox(line).SetText(" ").SetIsChecked(dragon.CanBeAirliftedToSelf);
    CreateLabel(line).SetText("Players can airlift this dragon").SetColor(colors.Textcolor);
    
    line = CreateHorz(root).SetFlexibleWidth(1);
    dragonInputs.CanBeGiftedWithGiftCard = CreateCheckBox(line).SetText(" ").SetIsChecked(dragon.CanBeGiftedWithGiftCard);
    CreateLabel(line).SetText("Players can gift this dragon to other players").SetColor(colors.Textcolor);
    
    line = CreateHorz(root).SetFlexibleWidth(1);
    dragonInputs.IncludeABeforeName = CreateCheckBox(line).SetText(" ").SetIsChecked(dragon.IncludeABeforeName);
    CreateLabel(line).SetText("automatically put the word 'A' before the name of this dragon").SetColor(colors.Textcolor);

    dragonInputs.UseHealth.SetOnValueChanged(function() healthAndDamage(dragon, vert) end);
end

function healthAndDamage(dragon, vert)
    local win = "healthAndDamage";
    AddSubWindow(GetCurrentWindow, win);
    DestroyWindow(win);
    SetWindow(win);

    CreateButton(vert).SetText("test");
end

function changeColor(dragon)
    DestroyWindow();
    SetWindow("modifyDragon");

    local c = {Blue=colors.Blue, Green=colors.Green, Red=colors.Red, Yellow=colors.Yellow, White=colors.Ivory};
    CreateLabel(root).SetText("Pick the color you want").SetColor(colors.Textcolor);
    for _, d in pairs(dragons) do
        if d ~= dragon then
            c[d.ColorName] = nil;
        end
    end
    for name, color in pairs(c) do
        CreateButton(root).SetText(name).SetColor(color).SetOnClick(function() dragon.Color = color; dragon.ColorName = name; modifyDragon(dragon); end)
    end
end

function saveDragon(dragon, inputs)
    dragons[dragon.ID].Name = inputs.Name.GetText();
    dragons[dragon.ID].DragonBreathAttack = inputs.DragonBreathAttack.GetIsChecked();
    dragons[dragon.ID].IsVisibleToAllPlayers = inputs.IsVisibleToAllPlayers.GetIsChecked();
    dragons[dragon.ID].CanBeAirliftedToSelf = inputs.CanBeAirliftedToSelf.GetIsChecked();
    dragons[dragon.ID].CanBeGiftedWithGiftCard = inputs.CanBeGiftedWithGiftCard.GetIsChecked();
    dragons[dragon.ID].IncludeABeforeName = inputs.IncludeABeforeName.GetIsChecked();
    dragons[dragon.ID].UseHealth = inputs.UseHealth.GetIsChecked();
end

function initDragon()
    local t = {};
    t.Name = "New Dragon";
    local c = {colors.Blue, colors.Green, colors.Red, colors.Yellow, colors.Ivory};
    for _, dragon in ipairs(dragons) do
        for i, v in ipairs(c) do
            if v == dragon.Color then
                table.remove(c, i);
            end
        end
    end
    t.Color = c[math.random(#c)];
    t.ColorName = getColorName(t.Color);
    t.DragonBreathAttack = true;
    t.IsVisibleToAllPlayers = false;
    t.CanBeAirliftedToSelf = true;
    t.CanBeGiftedWithGiftCard = false;
    t.IncludeABeforeName = true;
    t.UseHealth = true;
    t.ID = #dragons + 1;
    return t;
end

function getColorName(s)
    if s == colors.Blue then
        return "Blue";
    elseif s == colors.Red then
        return "Red";
    elseif s == colors.Green then
        return "Green";
    elseif s == colors.Yellow then
        return "Yellow";
    else
        return "White"
    end
end