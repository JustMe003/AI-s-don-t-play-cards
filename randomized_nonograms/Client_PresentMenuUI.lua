require("UI")
local colors;
local vert;
local game;

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, ClientGame, close)
--	setMaxSize(500, 500);
	game = ClientGame;
	colors = initColors();
	vert = UI.CreateVerticalLayoutGroup(rootParent);
	permanentLabel = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(permanentLabel).SetText("Mod creator:\t").SetColor(colors.TextColor);
	UI.CreateLabel(permanentLabel).SetText("Just_A_Dutchman_").SetColor(getColor("Just_A_Dutchman_", game.Game.Players, colors.Lime));
	showMenu();
end

function showMenu()
	init()
	createButton(vert, "settings", "#3333FF", showSettings);
	createButton(vert, "Credits", "#88FF00", showCredits);
end

function showCredits()
	destroyAll();
	line = getNewHorz(vert);
	createLabel(line, "testers:", colors.TextColor);
	line = getNewHorz(vert);
	createLabel(line, "Priamus \t", getColor("Priamus", game.Game.Players, colors.SaddleBrown));
	createLabel(line, "krinid \t", getColor("krinid", game.Game.Players, colors.TyrianPurple));
	createLabel(line, "ShatteredMagpie \t", getColor("ShatteredMagpie", game.Game.Players, colors.Orchid));
	line = getNewHorz(vert);
	createLabel(line, "[GW] Rob \t", getColor("[GW] Rob", game.Game.Players, colors.Blue));
	createLabel(line, "unFairerOrb76 \t", getColor("unFairerOrb76", game.Game.Players, colors.Yellow));
	createLabel(line, "DooDlefight \t", getColor("DooDlefight", game.Game.Players, colors.DarkGreen));
	line = getNewHorz(vert);
	createLabel(line, "καλλιστηι \t", getColor("καλλιστηι", game.Game.Players, colors.Red));
	createLabel(line, "JK_3 \t", getColor("JK_3", game.Game.Players, colors.Green));
	createLabel(line, "Samek \n", getColor("Samek", game.Game.Players, colors.Ivory));
	createButton(vert, "close", "#33CC33", function() destroyAll(); showMenu(); end);

end

function showSettings()
	destroyAll();
	if Mod.Settings.CustomDistribution == true then
		createLabel(getNewHorz(vert), "Custom distribution is being used", colors.TrueColor);
		createLabel(getNewHorz(vert), "This option enforces manual distribution, and all pickable territories are in bonuses",colors.TextColors);
	else
		createLabel(getNewHorz(vert), "Custom distribution is not being used", colors.FalseColor);
	end
	createLabel(getNewHorz(vert), "The dimensions of the nonogram are:", colors.TextColors);
	line = getNewHorz(vert);
	createLabel(line, Mod.Settings.NonogramWidth, colors.NumberColor);
	createLabel(line, " by ",colors.TextColors);
	createLabel(line, " " .. Mod.Settings.NonogramHeigth, colors.NumberColor);
	createLabel(getNewHorz(), "The density is set to:", colors.TextColors);
	createLabel(getNewHorz(), Mod.Settings.NonogramDensity, colors.NumberColor);
	if Mod.Settings.NonogramDensity >= 60 then
		createLabel(getNewHorz(vert), "This means the nonogram is likely solveable, there should be 1 answer possible", colors.NumberColor);
	else
		createLabel(getNewHorz(vert), "This means the nonogram might not be solveable, you might get stuck because there is more than 1 answer possible", colors.WarningNumberColor);
	end
	if Mod.Settings.LocalDeployments == true then
		createLabel(getNewHorz(vert), "Custom local deployments is on, this means that all armies you get from territories are automatically deployed, 1 on each territory in the bonus", colors.TextColor);
	else
		createLabel(getNewHorz(vert), "Custom local deployments is off, if commerce is on you'll get gold to spend on armies",colors.TextColors);
	end
	createButton(vert, "close", "#33CC33", function() destroyAll(); showMenu(); end);
end
