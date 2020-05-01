---------------------------
-- ccConfig by Texafornian
--
-- Used by "ccSuite" scripts
--
-- Modify everything except for the DECLARATIONS section
-- Tables can be edited in any way if the proper format is used

------------------
-- DECLARATIONS
------------------

ccConfig = {}
ccConfig.AdvanceQuests = {}
ccConfig.AdvanceQuests.Quests = {}
ccConfig.AdvanceQuests.Topics = {}
ccConfig.AdvanceQuests.WipeTimes = {}
ccConfig.Build = {}
ccConfig.CellReset = {}
ccConfig.CellReset.SavedCells = {}
ccConfig.CellReset.WipeTimes = {}
ccConfig.CharGen = {}
ccConfig.CharGen.Tamriel = {}
ccConfig.CharGen.Vanilla = {}
ccConfig.Commands = {}
ccConfig.Commands.InfoWindow1 = {}
ccConfig.Commands.InfoWindow2 = {}
ccConfig.Commands.InfoWindow3 = {}
ccConfig.Commands.Punish = {}
ccConfig.Commands.Punish.Tamriel = {}
ccConfig.Commands.Punish.Vanilla = {}
ccConfig.DynamicDifficulty = {}
ccConfig.Factions = {}
ccConfig.Hardcore = {}
ccConfig.Hardcore.DeathDrop = {}
ccConfig.Hardcore.DeathDrop.Tamriel = {}
ccConfig.Hardcore.DeathDrop.Vanilla = {}
ccConfig.Hardcore.SafeCells = {}
ccConfig.Hardcore.SafeCells.Tamriel = {}
ccConfig.Hardcore.SafeCells.Vanilla = {}
ccConfig.Holidays = {}
ccConfig.Perks = {}
ccConfig.Perks.Lottery = {}
ccConfig.Perks.Tamriel = {}
ccConfig.Perks.Vanilla = {}
ccConfig.ServerMessage = {}

--------------------
-- GENERAL CONFIG
--------------------

-- Paths to various folders.
ccConfig.CellPath = tes3mp.GetDataPath().."/cell/"
ccConfig.DataPath = tes3mp.GetDataPath().."/custom/ccsuite/"
ccConfig.PlayerPath = tes3mp.GetDataPath().."/player/"

-- If running a server with Tamriel Rebuilt, Province Cyrodiil, and 
-- Skyrim: Home of the Nords, then change "vanilla" to "tamriel".
ccConfig.ServerPlugins = "vanilla"

-- Enable various ccScript addons here.
ccConfig.AdvanceQuestsEnabled = true
ccConfig.BuildEnabled = true
ccConfig.CellResetEnabled = true
ccConfig.DynamicDifficultyEnabled = true
ccConfig.FactionsEnabled = true
ccConfig.HardcoreEnabled = true
ccConfig.HolidaysEnabled = true
ccConfig.PerksEnabled = true
ccConfig.ServerMessageEnabled = true
ccConfig.StatsEnabled = true

-- A faction will be deleted if none of its members log in for this number of days.
ccConfig.DaysInactive = 30

-- The maximum number of players allowed on the server at one time. Used for various functions.
ccConfig.NumberOfPlayers = 25

--------------------------
-- ADVANCE QUESTS CONFIG
--------------------------

--------
-- INFO:
--
-- This can wipe the world file (optional), advance specific quests,
-- and give the player a list of dialogue topics.
--
-- All entries can be modfied/added/removed. Double-check your commas!
--------

-- If enabled, the server will wipe the world file every time the server restarts.
-- WARNING: If enabled, server crashes will lead to unscheduled wipes!
ccConfig.AdvanceQuests.AlwaysWipeOnRestart = false

-- If ccConfig.AdvanceQuests.AlwaysWipeOnRestart is set to false, then the server
-- will wipe the world file and advance quests only if the server restarts during 
-- the following hours.
ccConfig.AdvanceQuests.WipeTimes.Vanilla = {
    { "01" },
    { "13" }
}

ccConfig.AdvanceQuests.WipeTimes.Tamriel = {
    { "01" }
}

-- Format (quests): { type, journal index, "questID", "actorRefId" }
ccConfig.AdvanceQuests.Quests.Vanilla = {
    { 0, 12, "a1_1_findspymaster", "caius cosades" }, 
    { 0, 60, "tr_dbattack", "player" }
}

ccConfig.AdvanceQuests.Quests.Tamriel = {}

-- Format (topics): { "topic name" }
ccConfig.AdvanceQuests.Topics.Vanilla = {
    { "Balmora" },
    { "Caius Cosades" },
    { "Dark Brotherhood" },
    { "fines and compensation" },
    { "little advice" },
    { "little secret" },
    { "latest rumors" },
    { "orders" },
    { "report to Caius Cosades" },
    { "transport to Mournhold" },
    { "transport to Vvardenfell" }
}

ccConfig.AdvanceQuests.Topics.Tamriel = {}

--------------------
-- BUILD CONFIG
--------------------

--------
-- INFO:
--
-- Controls various settings for the ccBuild script.
--------

-- Specifies which cell will be used for the /build command.
-- Format: { "cell ID", Xcoord, Ycoord, Zcoord, Zrot}
ccConfig.Build.BuildCell = { "Mournhold", 82, -5170, -84, 0 }

-- Specifies the number of pillows player receive when using the pillow option in the /build menu.
-- Delete this entry from ccBuild.BuildTable in ccBuild.lua if you don't want the player to receive any pillows.
ccConfig.Build.NumberOfPillows = 50

-- Specifies where the player will be sent when leaving the build cell. Default is Balmora.
-- Format: { "cell ID", Xcoord, Ycoord, Zcoord, Zrot}
ccConfig.Build.ReturnCell = { "-3, -2", -23894.0, -15079.0, 505, 1.571 }

-- Determines whether normal and HC players will suffer stat loss/permadeath if they die in the build cell.
ccConfig.Build.SafeBuildEnabled = true

--------------------
-- CELL RESET CONFIG
--------------------

--------
-- INFO:
--
-- Controls which cells are deleted, if any at all, at server restart or specified times.
--------

-- If enabled, the server delete wipe non-saved cells every time the server restarts.
-- WARNING: If enabled, server crashes will lead to unscheduled wipes!
ccConfig.CellReset.AlwaysWipeOnRestart = false

-- If ccConfig.CellReset.AlwaysWipeOnRestart is set to false, then the server
-- will delete non-saved cells only if the server restarts during the following hours.
ccConfig.CellReset.WipeTimes.Vanilla = {
    { "01" },
    { "07" },
    { "13" },
    { "19" }
}

ccConfig.CellReset.WipeTimes.Tamriel = {
    { "01" },
    { "07" },
    { "13" },
    { "19" }
}

-- Specifies which vanilla cells should not be deleted upon cell reset.
ccConfig.CellReset.SavedCells.Vanilla = {}

-- Specifies which plugin cells should not be deleted upon cell reset.
ccConfig.CellReset.SavedCells.Tamriel = {}

-- Determines whether to save the ccBuild build cell.
-- "ccConfig.BuildEnabled" must be set to true for this to work. 
ccConfig.CellReset.SaveBuildCell = true

-- WIP
-- Determines whether to save each faction's claimed cell(s).
-- "ccConfig.FactionsEnabled" must be set to true for this to work. 
ccConfig.CellReset.SaveFactionCells = true

--------------------
-- CHARGEN CONFIG
--------------------

--------
-- INFO:
--
-- By default, the "Message of the Day" displays immediately after chargen.
--------

-- Determines whether players will see a MOTD after chargen.
-- This is currently required for enabling hardcore mode!
ccConfig.CharGen.MOTDEnabled = true

-- Customize your MOTD.
ccConfig.CharGen.MOTDMessage = color.MediumSeaGreen .. "Welcome to The Cornerclub!" .. color.GoldenRod .. "\
    Join our Discord at the-cornerclub.com\n\
    Rules:\
    1) Don't edit your stats\
    2) Don't spawn-camp\
    3) Don't cause server instability\n\
    Commands:\
    " .. color.White .. "/build" .. color.GoldenRod .. " - Teleport to the persistent build cell\
    " .. color.White .. "/faction" .. color.GoldenRod .. " - Create a player faction\
    " .. color.White .. "/perks" .. color.GoldenRod .. " - Collect/use tokens on special features\
    " .. color.White .. "/schedule" .. color.GoldenRod .. " - Lists cell and quest reset times\
    " .. color.White .. "/stats" .. color.GoldenRod .. " - See how long you've played\n"

-- If hardcore mode is enabled, then this message will appear immediately below the above message.
-- A "Yes/No" prompt will appear below this message. "Yes" activates Hardcore Mode.
ccConfig.CharGen.MOTDMessageHC = color.GoldenRod .. "Would you like to enable " .. color.Red .. "Hardcore Mode?" .. color.GoldenRod .. "\
    - Increased difficulty\
    - Character deletion upon death\
    - View the top player rankings via /ladder"

--------
-- INFO:
--
-- All entries can be modfied/added/removed and the spawn tables.
-- are generated/randomized automatically on start-up.
--
-- Format (items): { "refID", count, charge }
-- Format (clothes): { "refID", count (this should be 1), charge }
--------

-- Must be set to true for all players to receive randomized starting clothes.
-- See ccConfig.CharGen.Vanilla.Pants, .Shirts, etc. & ccConfig.CharGen.Tamriel.Pants, .Shirts, etc.
ccConfig.CharGen.RandomizedClothes = true

-- Must be set to true for specific classes to receive items after chargen.
-- See ccConfig.CharGen.Vanilla.ClassItems & ccConfig.CharGen.Tamriel.ClassItems.
ccConfig.CharGen.StartingClassItems = true

-- Must be set to true for players to receive misc. items after chargen.
-- See ccConfig.CharGen.Vanilla.MiscItems & ccConfig.CharGen.Tamriel.MiscItems.
ccConfig.CharGen.StartingMiscItems = true

-- Must be set to true for players with specific skills to receive items after chargen.
-- See ccConfig.CharGen.Vanilla.MajorSkillItems & ccConfig.CharGen.Tamriel.MajorSkillItems.
ccConfig.CharGen.StartingSkillItems = true

-- The minimum skill level that a player must have for a skill to receive a weapon 
-- after chargen.
-- If it's set to 0, then everyone will receive everything from the tables.
ccConfig.CharGen.StartingSkillMinLevel = 35

-- Must be set to true for player to receive a weapon after chargen.
-- Server will iterate through a player's skills and give the first 
-- weapon category that meets the minimum skill threshold (see below).
ccConfig.CharGen.StartingWeapon = true

-- The minimum skill level that a player must have for a weapon
-- skill to receive a weapon after chargen.
-- If it's set to 0, then everyone will receive something from the same weapon category.
ccConfig.CharGen.StartingWeaponMinLevel = 40

-- List of cells/locations where players can randomly spawn after chargen.
-- Format (cells): { "cell ID", Xcoord, Ycoord, Zcoord, Zrot, "displayed name" }
ccConfig.CharGen.Vanilla.Cells = {
    { "-3, 6", -16523, 54362, 1973, 2.73, "Ald'Ruhn" },
    { "-11, 15", -89353, 128479, 110, 1.86, "Ald Velothi" },
    { "-3, -3", -20986, -17794, 865, -0.87, "Balmora" },
    { "-2, 2", -12238, 20554, 1514, -2.77, "Caldera" },
    { "7, 22", 62629, 185197, 131, -2.83, "Dagon Fel" },
    { "2, -13", 20769, -103041, 107, -0.87, "Ebonheart" },
    { "-8, 3", -58009, 26377, 52, -1.49, "Gnaar Mok" },
    { "-11, 11", -86910, 90044, 1021, 0.44, "Gnisis" },
    { "-6, -5", -49093, -40154, 78, 0.94, "Hla Oad" },
    { "-9, 17", -69502, 142754, 50, 2.89, "Khuul" },
    { "-3, 12", -22622, 101142, 1725, 0.28, "Maar Gan" },
    { "12, -8", 103871, -58060, 1423, 2.2, "Molag Mar" },
    { "0, -7", 2341, -56259, 1477, 2.13, "Pelagiad" },
    { "17, 4", 141415, 39670, 213, 2.47, "Sadrith Mora" },
    { "6, -6", 52855, -48216, 897, 2.36, "Suran" },
    { "14, 4", 122576, 40955, 59, 1.16, "Tel Aruhn" },
    { "14, -13", 119124, -101518, 51, 3.08, "Tel Branora" },
    { "13, 14", 106608, 115787, 53, -0.39, "Tel Mora" },
    { "3, -10", 36412, -74454, 59, -1.66, "Vivec" },
    { "11, 14", 101402, 114893, 158, -2.03, "Vos" }
}

-- Specific classes will receive these items after chargen if ccConfig.CharGen.StartingClassItems = true.
-- More items and/or classes can be added by following the format.
-- Format: { "name of class", { "refID", count, charge }, <more items here> }
ccConfig.CharGen.Vanilla.ClassItems = {
    { "bard", { "misc_de_lute_01", 1, -1 }, { "misc_de_drum_01", 1, -1 } },
    { "healer", { "common_robe_02", 1, -1 } },
    { "mage", { "common_robe_02", 1, -1 } },
    { "monk", { "common_robe_01", 1, -1 } },
    { "pilgrim", { "bk_PilgrimsPath", 1, -1 } },
    { "sorcerer", { "common_robe_02", 1, -1 } }
}

-- Players with specific major skills will receive items in this table after chargen.
-- Delete any or all entries if you don't want players to spawn with certain things.
-- Format: { "name of major skill", { "refID", count, charge }, <more items here> }
ccConfig.CharGen.Vanilla.SkillItems = {
    { "alchemy", { "apparatus_a_mortar_01", 1, -1 }, { "apparatus_a_alembic_01", 1, -1 } },
    { "armorer", { "hammer_repair", 3, -1 } },
    { "block", { "nordic_leather_shield", 1, -1 } },
    { "enchant", { "misc_soulgem_common", 2, -1 } },
    { "security", { "pick_apprentice_01", 2, -1 }, { "probe_apprentice_01", 2, -1 } }
}

-- Players will receive all items in this table after chargen.
-- Delete any or all entries if you don't want players to spawn with certain things.
ccConfig.CharGen.Vanilla.MiscItems = {
    { "p_restore_health_b", 3, -1 },
    { "p_restore_fatigue_b", 3, -1 },
    { "p_restore_magicka_b", 3, -1 },
    { "gold_001", 75, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough.
ccConfig.CharGen.Vanilla.Axes = {
    { "chitin war axe", 1, -1 },
    { "iron battle axe", 1, -1 },
    { "iron war axe", 1, -1 },
    { "miner's pick", 1, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough.
ccConfig.CharGen.Vanilla.BluntWeapons = {
    { "chitin club", 1, -1 },
    { "iron club", 1, -1 },
    { "iron mace", 1, -1 },
    { "iron warhammer", 1, -1 },
    { "spiked club", 1, -1 },
    { "wooden staff", 1, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough.
ccConfig.CharGen.Vanilla.Longblades = {
    { "iron broadsword", 1, -1 },
    { "iron claymore", 1, -1 },
    { "iron longsword", 1, -1 },
    { "iron saber", 1, -1 }
}

ccConfig.CharGen.Vanilla.MarksmanAmmo = {
    { "chitin arrow", 50, -1 },
    { "iron arrow", 50, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough.
ccConfig.CharGen.Vanilla.MarksmanWeapons = {
    { "chitin short bow", 1, -1 },
    { "long bow", 1, -1 },
    { "short bow", 1, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough. 
ccConfig.CharGen.Vanilla.Shortblades = {
    { "chitin dagger", 1, -1 },
    { "chitin shortsword", 1, -1 },
    { "iron dagger", 1, -1 },
    { "iron shortsword", 1, -1 },
    { "iron tanto", 1, -1 },
    { "iron wakizashi", 1, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough.
ccConfig.CharGen.Vanilla.Spears = {
    { "chitin spear", 1, -1 },
    { "iron halberd", 1, -1 },
    { "iron long spear", 1, -1 },
    { "iron spear", 1, -1 }
}

-- Players will receive one of these pairs of pants after chargen.
ccConfig.CharGen.Vanilla.Pants = {
    { "common_pants_01", 1, -1 },
    { "common_pants_02", 1, -1 },
    { "common_pants_03", 1, -1 },
    { "common_pants_04", 1, -1 },
    { "common_pants_05", 1, -1 },
    { "common_pants_06", 1, -1 },
    { "common_pants_07", 1, -1 }
}

-- Players will receive one of these shirts after chargen.
ccConfig.CharGen.Vanilla.Shirts = {
    { "common_shirt_01", 1, -1 },
    { "common_shirt_02", 1, -1 },
    { "common_shirt_03", 1, -1 },
    { "common_shirt_04", 1, -1 },
    { "common_shirt_05", 1, -1 },
    { "common_shirt_06", 1, -1 },
    { "common_shirt_07", 1, -1 }
}

-- Players will receive one of these pairs of shoes after chargen.
ccConfig.CharGen.Vanilla.Shoes = {
    { "common_shoes_01", 1, -1 },
    { "common_shoes_02", 1, -1 },
    { "common_shoes_03", 1, -1 },
    { "common_shoes_04", 1, -1 },
    { "common_shoes_05", 1, -1 }
}

-- Players will receive one of these skirts after chargen.
ccConfig.CharGen.Vanilla.Skirts = {
    { "common_skirt_01", 1, -1 },
    { "common_skirt_02", 1, -1 },
    { "common_skirt_03", 1, -1 },
    { "common_skirt_04", 1, -1 },
    { "common_skirt_05", 1, -1 }
}

-- Additional cells/locations that are added to vanilla table 
-- if "tamriel" is chosen above.
ccConfig.CharGen.Tamriel.Cells = {
    { "-106, 8", -861187, 66491, 89, 2.89, "Karthwasten" },
    { "136, -52", -1106032, -421883, 237, -2.06, "Stirk" }
}

ccConfig.CharGen.Tamriel.ClassItems = {}

ccConfig.CharGen.Tamriel.SkillItems = {}

ccConfig.CharGen.Tamriel.MiscItems = {}

ccConfig.CharGen.Tamriel.Axes = {
    { "T_Cr_Goblin_Axe_01", 1, -1 }
}

ccConfig.CharGen.Tamriel.BluntWeapons = {
    { "T_Com_Farm_Hoe_01", 1, -1 },
    { "T_Com_Farm_Shovel_01", 1, -1 },
    { "T_Com_Iron_Morningstar_01", 1, -1 }
}

ccConfig.CharGen.Tamriel.Longswords = {
    { "T_Com_Iron_Broadsword_01", 1, -1 },
    { "T_Com_Iron_Broadsword_02", 1, -1 },
    { "T_Com_Iron_Broadsword_03", 1, -1 },
    { "T_Com_Iron_Saber_01", 1, -1 },
    { "T_Com_Iron_Saber_02", 1, -1 },
    { "T_Com_Iron_Saber_03", 1, -1 }
}

ccConfig.CharGen.Tamriel.MarksmanWeapons = {
    { "T_Com_Wood_CrossbowFix_01", 1, -1 }
}

ccConfig.CharGen.Tamriel.MarksmanAmmo = {
    { "iron bolt", 50, -1 }
}

ccConfig.CharGen.Tamriel.Shortswords = {
    { "T_Com_Iron_Dagger_01", 1, -1 },
    { "T_Com_Iron_Dagger_02", 1, -1 },
    { "T_Com_Iron_Tanto_01", 1, -1 },
    { "T_Com_Iron_Tanto_02", 1, -1 },
    { "T_Com_Iron_Tanto_03", 1, -1 },
    { "T_Com_Iron_Tanto_04", 1, -1 }
}

ccConfig.CharGen.Tamriel.Spears = {
    { "T_Com_Farm_Pitchfork_01", 1, -1 },
    { "T_Com_Farm_Scythe_01", 1, -1 },
    { "T_Com_Var_Harpoon_01", 1, -1 },
    { "T_Com_Var_Harpoon_02", 1, -1 }
}

ccConfig.CharGen.Tamriel.Pants = {
    { "T_Com_Cm_Pants_01", 1, -1 },
    { "T_Com_Cm_Pants_02", 1, -1 },
    { "T_Com_Cm_Pants_03", 1, -1 },
    { "T_Com_Cm_Pants_04", 1, -1 }
}

ccConfig.CharGen.Tamriel.Shirts = {
    { "T_Com_Cm_Shirt_01", 1, -1 },
    { "T_Com_Cm_Shirt_02", 1, -1 },
    { "T_Com_Cm_Shirt_03", 1, -1 },
    { "T_Com_Cm_Shirt_04", 1, -1 }
}

ccConfig.CharGen.Tamriel.Shoes = {
    { "T_Com_Cm_Shoes_01", 1, -1 },
    { "T_Com_Cm_Shoes_02", 1, -1 },
    { "T_Com_Cm_Shoes_03", 1, -1 }
}

ccConfig.CharGen.Tamriel.Skirts = {
    { "T_Com_Cm_Skirt_01", 1, -1 }
}

------------------------
-- COMMANDS CONFIG
------------------------

--------
-- INFO:
--
-- Three information windows that you can customize.
-- 
-- Command = /<command> causes the window to appear.
-- Message = The block of text in the window.
--------

ccConfig.Commands.InfoWindow1.Command = "modding"

ccConfig.Commands.InfoWindow1.Message = "Help build Tamriel!\n\
    Tamriel Rebuilt (Morrowind) and Project Tamriel (Cyrodiil, Skyrim) are always looking for more help.\n\
    Interested in creating interiors and exteriors?\
    How about writing dialogue and/or quests?\
    Maybe you're a modeler, texturer, or animator?\n\
    Your work will be seen on our Tamriel server!\n\
    Visit the following sites to learn more:\
    Tamriel Rebuilt: tamriel-rebuilt.org\
    Project Tamriel: project-tamriel.com"

ccConfig.Commands.InfoWindow2.Command = "schedule"

ccConfig.Commands.InfoWindow2.Message = "Server Schedules:\n\
    Both servers back up all data and reset cells every 6 hours (1 AM, 7 AM, 1 PM, 7 PM EDT)\n\
    Vanilla: Quests reset every 12 hours (1 AM, 1 PM EDT)\
    Tamriel: Quests reset every 24 hours (1 AM EDT)"

ccConfig.Commands.InfoWindow3.Command = nil

ccConfig.Commands.InfoWindow3.Message = nil

--------
-- INFO:
--
-- Sends a player to a random forsaken place when you don't feel like kicking or banning.
-- 
-- Interior cells: Preferably without doors.
-- Exterior cells: Preferably the ocean.
--------

ccConfig.Commands.Punish.Vanilla.Interiors = {
    { "Mark's Vampire Test Cell " },
    { "Mournhold" }, -- test cell
    { "Solstheim" } -- test cell
}

ccConfig.Commands.Punish.Vanilla.Exteriors = {
    { "30, 30", 249856, 249856, 0, 0 } -- ocean
}

ccConfig.Commands.Punish.Tamriel.Interiors = {}

ccConfig.Commands.Punish.Tamriel.Exteriors = {}

------------------------------
-- DYNAMIC DIFFICULTY CONFIG
------------------------------

-- How much the difficulty will increase or decrease per player connection event.
ccConfig.DynamicDifficulty.DifficultyPerPlayer = 7

-- If enabled, the difficulty will stop increasing after a specified value.
ccConfig.DynamicDifficulty.MaxDifficultyEnabled = true

-- The highest possible difficulty value.
-- Requires maxDifficultyEnabled to be set to true!
ccConfig.DynamicDifficulty.MaxDifficultyValue = 100

--------------------
-- FACTIONS CONFIG
--------------------

-- Specifies the color (color.lua) of faction chat messages (/f <msg>).
ccConfig.Factions.ChatColor = color.LightBlue

-- Specifies whether players can claim cells.
ccConfig.Factions.ClaimCellsEnabled = true

-- Specifies the amount of seconds a player must wait to use warp-to-faction-cell again.
ccConfig.Factions.WarpCooldown = 1800

-- Specifies which cells (interpreted as prefixes) are prohibited from being claimed.
ccConfig.Factions.ProhibitedCells = {
    { "Ahemmusa Camp" },
    { "Akulakhan's Chamber" },
    { "Ald Velothi" },
    { "Ald-ruhn" },
    { "Balmora" },
    { "Buckmoth Legion Fort" },
    { "Caldera" },
    { "Dagon Fel" },
    { "Dagoth Ur" },
    { "Dren Plantation" },
    { "Ebonheart" },
    { "Erabenimsun Camp" },
    { "Fort Frostmoth" },
    { "Ghostgate" },
    { "Gnaar Mok" },
    { "Hla Oad" },
    { "Karthgad" },
    { "Karthwasten" },
    { "Khuul" },
    { "Maar Gan" },
    { "Molag Mar" },
    { "Moonmoth Legion Fort" },
    { "Mournhold" },
    { "Necrom" },
    { "Old Ebonheart" },
    { "Pelagiad" },
    { "Raven Rock" },
    { "Rethan Manor" },
    { "Sadrith Mora" },
    { "Seyda Neen" },
    { "Skaal Village" },
    { "Solstheim, Castle Karstaag" },
    { "Sotha Sil" },
    { "Stirk" },
    { "Suran" },
    { "Tel Aruhn" },
    { "Tel Branora" },
    { "Tel Fyr" },
    { "Tel Mora" },
    { "Tel Uvirith" },
    { "Tel Vos" },
    { "Urshilaku Camp" },
    { "Vivec" },
    { "Vos" },
    { "Zainab Camp" }
}

--------------------
-- HARDCORE CONFIG
--------------------

-- How much harder the game should be for HC players.
-- Set it to 0 for no extra difficulty.
ccConfig.Hardcore.AddedDifficulty = 25

-- If enabled, HC players' names and levels will be tracked on a monthly, auto-generated ladder.
ccConfig.Hardcore.LadderEnabled = true

-- If enabled, then a player will not be deleted when they die in a "safe cell" (ccConfig.lua).
ccConfig.Hardcore.UseSafeCells = true

--------
-- INFO:
--
-- Configure whether players drop certain things upon death.
--
-- HUGE thanks to Dave, Mupf, Atkana and Rickoff
--
-- NOTE: Only player gold and the "otherDrops" will drop right now! 
-- Need to figure out how to package packets together.
--------

-- If enabled, then the inventory of a Hardcore player who dies will 
-- be dropped on the ground, allowing other players to loot them.
ccConfig.Hardcore.DeathDrop.Enabled = true

-- If enabled, then Hardcore players will only drop their gold when they die.
-- "ccConfig.Hardcore.DeathDrop.Enabled" must be set to true for this to work.
-- ccDeathDrop.dropOnlyGold = true

-- Drop additional items that the player wasn't necessarily carrying.
-- "ccConfig.Hardcore.DeathDrop.Enabled" must be set to true for this to work.
-- Anyone else remember Diablo II's ears?
-- Format: { "refID", count, charge }
ccConfig.Hardcore.DeathDrop.Vanilla = {
    { "misc_skull00", 1, -1 }
}

ccConfig.Hardcore.DeathDrop.Tamriel = {}

--------
-- INFO:
--
-- List of cells where players aren't punished for dying.
--
-- NOTE: This only protects Hardcore players at the moment.
--------

-- Must be set to true for everything in this section to be applied.
ccConfig.Hardcore.SafeCells.enabled = true

-- If enabled, then all of the cells in the Spawn Config section below will be added 
-- automatically to the list of safe cells.
ccConfig.Hardcore.SafeCells.useSpawnCells = true

-- List of additional protected cells. These are added to the list regardless of 
-- whether ccConfig.Hardcore.SafeCells.useSpawnCells is enabled.
-- Format: { "cell ID" }
ccConfig.Hardcore.SafeCells.Vanilla = {}

ccConfig.Hardcore.SafeCells.Tamriel = {}

---------------------
-- HOLIDAYS CONFIG
---------------------

--------
-- INFO:
--
-- Designates specific days or periods as special events.
--
-- NOTE: Default holidays are currently hardcoded. You'll have to edit ccHolidays.lua to 
-- add functionality for any new holidays you create.
--------

-- Specifies days or periods of special events.
-- Delete an entry to prevent it from being processed.
-- Format: { "Name", "day/period", "start month", "start day", "end month", "end day" }
ccConfig.Holidays.Table = {
    { "Anniversary", "day", 04, 10, nil, nil },
    { "Halloween", "day", 10, 31, nil, nil },
    { "Morrowind", "day", 05, 01, nil, nil },
    { "Winter", "period", 12, 24, 01, 01 }
} 

------------------
-- PERKS CONFIG
------------------

--------
-- INFO:
--
-- NOTE: If you want to change the order in which perks appear, or which 
-- perks are available to the player, then go to the bottom of ccPerks.lua 
-- and modify the table. Don't edit the "name" and "storedFunc" values 
-- in the entries.
--------

-- Specify the amount of tokens players receive when claiming once per day.
ccConfig.Perks.TokensPerClaim = 1

-- Specify whether players earn tokens when reaching specific levels.
ccConfig.Perks.TokensOnLevelUpEnabled = true

-- Specify the amount of tokens players receive when leveling up.
-- Note: Requires tokensOnLevelUpEnabled to be enabled.
ccConfig.Perks.TokensPerLevelUp = 1

-- Specify the interval at which players receive tokens after leveling up.
-- Ex: Setting the value to 2 would give token(s) at level 2, 4, 6, etc.
-- Note: Requires tokensOnLevelUpEnabled to be enabled.
ccConfig.Perks.TokensLevelInterval = 2

-- Specify a maximum level after which player do not receive any more tokens.
-- Set it to a high number if you do not want a maximum level.
-- Note: Requires tokensOnLevelUpEnabled to be enabled.
ccConfig.Perks.TokensMaxLevel = 78

-- Specify the token cost (for non-Admins) for various perks.
ccConfig.Perks.TokenCostBirthsign = 1
ccConfig.Perks.TokenCostCreature = 1
ccConfig.Perks.TokenCostExpulsion = 1
ccConfig.Perks.TokenCostGender = 1
ccConfig.Perks.TokenCostHair = 1
ccConfig.Perks.TokenCostHead = 1
ccConfig.Perks.TokenCostLottery = 1
ccConfig.Perks.TokenCostPet = 1
ccConfig.Perks.TokenCostRace = 1
ccConfig.Perks.TokenCostRewards = 1
ccConfig.Perks.TokenCostWarp = 1
ccConfig.Perks.TokenCostWeather = 1

--------
-- INFO:
--
-- Information used by the various "changer" perks.
--
-- Don't change these entries unless you know what you're doing.
--
-- Format: { "ID", "female hair ID", # female hairstyles, "female head ID", # female heads, "male hair ID",
-- # male hairstyles, "male head ID", # male heads, "displayed name" }
--------

-- Vanilla races
ccConfig.Perks.Vanilla.Races = {
    { "high elf", "b_n_high elf_f_hair_", 4, "b_n_high elf_f_head_", 6, "b_n_high elf_m_hair_", 5, "b_n_high elf_m_head_", 6, "Altmer" },
    { "argonian", "b_n_argonian_f_hair", 5, "b_n_argonian_f_head_", 3, "b_n_argonian_m_hair", 6, "b_n_argonian_m_head_", 3, "Argonian" },
    { "wood elf", "b_n_wood elf_f_hair_", 5, "b_n_wood elf_f_head_", 6, "b_n_wood elf_m_hair_", 6, "b_n_wood elf_m_head_", 8, "Bosmer" },
    { "breton", "b_n_breton_f_hair_", 5, "b_n_breton_f_head_", 6, "b_n_breton_m_hair_", 5, "b_n_breton_m_head_", 8, "Breton" },
    { "dark elf", "b_n_dark elf_f_hair_", 24, "b_n_dark elf_f_head_", 10, "b_n_dark elf_m_hair_", 26, "b_n_dark elf_m_head_", 17, "Dunmer" },
    { "imperial", "b_n_imperial_f_hair_", 7, "b_n_imperial_f_head_", 7, "b_n_imperial_m_hair_", 9, "b_n_imperial_m_head_", 7, "Imperial" },
    { "khajiit", "b_n_khajiit_f_hair", 5, "b_n_khajiit_f_head_", 4, "b_n_khajiit_m_hair", 5, "b_n_khajiit_m_head_", 4, "Khajiit" },
    { "nord", "b_n_nord_f_hair_", 5, "b_n_nord_f_head_", 8, "b_n_nord_m_hair", 7, "b_n_nord_m_head_", 8, "Nord" },
    { "orc", "b_n_orc_f_hair_", 5, "b_n_orc_f_head_", 3, "b_n_orc_m_hair_", 5, "b_n_orc_m_head_", 4, "Orsimer" },
    { "redguard", "b_n_redguard_f_hair_", 5, "b_n_redguard_f_head_", 6, "b_n_redguard_m_hair_", 6, "b_n_redguard_m_head_", 6, "Redguard" }
}

-- Races added by Tamriel_Data.esm
ccConfig.Perks.Tamriel.Races = {
    { "t_els_cathay", "t_b_kcr_hairfemale_", 5, "t_b_kcr_headfemale_", 4, "t_b_kc_hairmale_", 5, "t_b_kc_headmale_", 3, "Cathay" },
    { "t_els_cathay-raht", "t_b_kcr_hairfemale_", 5, "t_b_kcr_headfemale_", 3, "t_b_kcr_hairmale_", 5, "t_b_kcr_headmale_", 4, "Cathay-raht" },
    { "t_pya_seaelf", "t_b_mao_hairfemale_", 4, "t_b_mao_headfemale_", 5, "t_b_mao_hairmale_", 5, "t_b_mao_headmale_", 6, "Maormer" },
    { "t_els_ohmes", "t_b_ko_hairfemale_", 26, "t_b_ko_headfemale_", 16, "t_b_ko_hairmale_", 17, "t_b_ko_headmale_", 15, "Ohmes" },
    { "t_els_ohmes-raht", "t_b_kor_hairfemale_", 24, "t_b_kor_headfemale_", 5, "t_b_kor_hairmale_", 5, "t_b_kor_headmale_", 3, "Ohmes-raht" },
    { "t_sky_reachman", "t_b_rea_hairfemshotn_", 8, "t_b_rea_headfemshotn_", 6, "t_b_rea_hairmaleshotn_", 7, "t_b_rea_headmaleshotn_", 10, "Reachman" }, -- Requires letter "a" after the number
    { "t_els_suthay", "t_b_ks_hairfemale_", 5, "t_b_ks_headfemale_", 4, "t_b_ks_hairmale_", 5, "t_b_ks_headmale_", 4, "Suthay" }
}

--------
-- INFO:
--
-- "Appear as Creature" list is generated automatically by the server on start-up.
--
-- Creatures can be added/removed/modified, but be aware that some
-- vanilla creatures have been omitted because they crash the server.
-- For example: Almalexia and her variant.
--
-- Format: { "refID", "displayed name" }
--------

ccConfig.Perks.Vanilla.Creatures = {
    { "alit", "Alit" },
    { "ancestor_ghost", "Ancestor Ghost" },
    { "ascended_sleeper", "Ascended Sleeper" },
    { "ash_ghoul", "Ash Ghoul" },
    { "ash_slave", "Ash Slave" },
    { "dagoth endus", "Ash Vampire" },
    { "ash_zombie", "Ash Zombie" },
    { "netch_betty", "Betty Netch" },
    { "netch_bull", "Bull Netch" },
    { "atronach_flame", "Atronach (Flame)" },
    { "atronach_frost", "Atronach (Frost)" },
    { "atronach_storm", "Atronach (Storm)" },
    { "BM_bear_black", "Bear (Black)" },
    { "BM_bear_brown", "Bear (Brown)" },
    { "BM_bear_snow_unique", "Bear (Snow)" },
    { "BM_bear_be_UNIQUE", "Bear (Snow Variant)" },
    { "BM_frost_boar", "Boar" },
    { "bonelord", "Bonelord" },
    { "bonewalker", "Bonewalker (Lesser)" },
    { "bonewalker_greater", "Bonewalker (Greater)" },
    { "centurion_projectile", "Centurion Archer" },
    { "centurion_sphere", "Centurion Sphere" },
    { "centurion_steam", "Centurion Steam" },
    { "clannfear", "Clannfear" },
    { "cliff racer", "Cliff Racer" },
    { "corprus_lame", "Corprus (Lame)" },
    { "corprus_stalker", "Corprus (Stalker)" },
    { "daedroth", "Daedroth" },
    { "dagoth_ur_1", "Dagoth Ur" },
    { "BM_draugr01", "Draugr" },
    { "dremora", "Dremora" },
    { "dreugh", "Dreugh" },
    { "durzog_wild", "Durzog (Wild)" },
    { "durzog_war", "Durzog (War)" },
    { "dwarven ghost", "Dwemer Ghost" },
    { "fabricant_hulking", "Fabricant (Hulking)" },
    { "fabricant_verminous", "Fabricant (Verminous)" },
    { "bm_frost_giant", "Frost Giant" },
    { "goblin_grunt", "Goblin Grunt" },
    { "goblin_bruiser", "Goblin Bruiser" },
    { "goblin_warchief1", "Goblin Warchief" },
    { "guar", "Guar" },
    { "guar_white", "Guar (Unique)" },
    { "BM_hircine", "Hircine" },
    { "BM_hircine_huntaspect", "Hircine (Hunt)" },
    { "BM_hircine_spdaspect", "Hircine (Speed)" },
    { "BM_hircine_straspect", "Hircine (Strength)" },
    { "BM_horker", "Horker" },
    { "BM_horker_swim_UNIQUE", "Horker (Unique)" },
    { "hunger", "Hunger" },
    { "BM_ice_troll", "Ice Troll" },
    { "imperfect", "Imperfect" },
    { "kagouti", "Kagouti" },
    { "kwama forager", "Kwama Forager" },
    { "Kwama Queen", "Kwama Queen" },
    { "kwama warrior", "Kwama Warrior" },
    { "kwama worker", "Kwama Worker" },
    { "lich", "Lich" },
    { "lich_barilzar", "Lich (Unique)" },
    { "mudcrab", "Mudcrab" },
    { "nix-hound", "Nix-Hound" },
    { "ogrim", "Ogrim" },
    { "rat", "Rat" },
    { "Rat_pack_rerlas", "Rat (Variant)" },
    { "glenmoril_raven", "Raven" },
    { "BM_riekling", "Riekling" },
    { "BM_riekling_mounted", "Riekling (Mounted)" },
    { "scamp", "Scamp" },
    { "scrib", "Scrib" },
    { "shalk", "Shalk" },
    { "skeleton", "Skeleton" },
    { "BM_spriggan", "Spriggan" },
    { "BM_udyrfrykte", "Udyrfrykte" },
    { "vivec_god", "Vivec" },
    { "winged twilight", "Winged Twilight" },
    { "BM_wolf_grey", "Wolf (Gray)" },
    { "BM_wolf_red", "Wolf (Red)" },
    { "BM_wolf_skeleton", "Wolf (Skeleton)" },
    { "BM_wolf_snow_unique", "Wolf (Snow)" },
    { "yagrum bagarn", "Yagrum Bagarn" }
}

-- WIP
ccConfig.Perks.Tamriel.Creatures = {
    { "T_Cyr_Cre_Mino_01", "Minotaur" }
}

--------
-- INFO:
--
-- The more "entries" something has, the more likely it is to be won.
--
-- All filler, token, and item entries are added up by the server on start-up.
--------

-- Adds blank entries to the lottery to lower the chances that a player will win any tokens or items.
-- If set to 0, then a player will always win something.
ccConfig.Perks.Lottery.FillerEntries = 35

-- Winnable token values. All entries can be modified/removed/added.
-- Format: { Number of tokens, number of entries, name }
-- If number of entries is set to 0, then it will never be winnable.
ccConfig.Perks.Lottery.Tokens = {
    { 1, 11, "1 token!\n" },
    { 2, 7, "2 tokens!\n" },
    { 5, 4, "5 tokens!\n" },
    { 10, 2, "10 tokens!\n" },
    { 25, 1, "25 tokens!!!\n" }
}

-- Winnable lottery prizes. All entries can be modified/removed/added.
-- Format: { refID, count, charge, name/type }
ccConfig.Perks.Lottery.Items = {
    { "ingred_bread_01_UNI3", 2, -1, "some Muffins!\n" },
    { "ingred_scrib_jelly_02", 2, -1, "some rare ingredients!\n" },
    { "ingred_heartwood_01", 2, -1, "some rare ingredients!\n" },
    { "apparatus_sm_alembic_01", 1, -1, "a unique alchemical tool!\n" },
    { "apparatus_sm_calcinator_01", 1, -1, "a unique alchemical tool!\n" },
    { "apparatus_sm_mortar_01", 1, -1, "a unique alchemical tool!\n" },
    { "apparatus_sm_retort_01", 1, -1, "a unique alchemical tool!\n" },
    { "veloths_shield", 1, 15, "a unique shield!\n" },
    { "steel_towershield_ancient", 1, -1, "a unique shield!\n" },
    { "BM_hunter_battleaxe_unique", 1, -1, "a unique weapon!\n" },
    { "daedric_club_tgdc", 1, -1, "a unique weapon!\n" },
    { "herder_crook", 1, 80, "a unique weapon!\n" },
    { "iron fork", 1, -1, "a unique weapon!\n" },
    { "axe_queen_of_bats_unique", 1, 500, "a unique weapon!\n" },
    { "staff_of_llevule", 1, 50, "a unique weapon!\n" },
    { "ebony_dagger_mehrunes", 1, -1, "a unique weapon!\n" },
    { "clutterbane", 1, 10, "a unique weapon!\n" },
    { "throwing knife of sureflight", 7, -1, "a unique weapon!\n" },
    { "slippers_of_doom", 1, 120, "a unique pair of shoes!\n" },
    { "robe of burdens", 1, 75, "a unique robe!\n" },
    { "mandas_locket", 1, -1, "a unique amulet!\n" },
    { "fenrick's doorjam ring", 1, 5, "a unique ring!\n" },
    { "Recall_Ring", 1, 90, "a unique ring!\n" },
    { "common_ring_tsiya", 1, -1, "a unique ring!\n" },
    { "fur_colovian_helm_white", 1, -1, "a unique hat!\n" },
    { "gondolier_helm", 1, -1, "an uncommon hat!\n" },
    { "Misc_flask_grease", 1, -1, "a Jar of Grease!\n" },
    { "skeleton_key", 1, -1, "a rare lockpick!\n" },
    { "light_com_lantern_02_inf", 1, -1, "a rare lantern!\n" },
    { "misc_com_plate_02_tgrc", 1, -1, "a unique Blue Plate! This one is nice.\n" },
    { "misc_com_plate_06_tgrc", 1, -1, "a unique Brown Plate! This one seems to last longer.\n" }
}

--------
-- INFO:
--
-- Choose which token rewards the player can generate.
-- NOTE: Don't change anything inside the row entries unless you know what you're doing.
-- If you want to remove an entry, then just delete the entire row from the table.
--
-- NOTE: Use /generate <table entry #> to create the permanent record.
-- TODO: Auto-generate the records if not present in appropriate recordstore .json file.
--
-- Format (weapon): { inputType [1], baseid [2], id [3], name [4], model [5], icon [6], script [7], enchantmentId [8], 
-- enchantmentCharge [9], subtype [10], weight [11], value [12], health [13], speed [14], reach [15], damageChop [16], 
-- damageSlash [17], damageThrust [18], flags [19], count* [20], charge* [21], "Listed Name" [22] }
-- NOTE: All fields except those marked with * must be strings. Leave fields as nil if they're not applicable.
--------

ccConfig.Perks.RewardItems = {
    { "weapon", nil, "ccreward_axe_thrown", "Throwable Axe", "w\\W_WARAXE_IRON.nif", "w\\Tx_waraxe_iron.tga", nil, nil, nil, 
    "11", "0.5", "1", "100", "1.1", "1.1", { "1", "5" }, { "0", "1" }, { "0", "1" }, nil, 25, -1, "Axes (Throwable)" },
    { "weapon", nil, "ccreward_plate_thrown_bl", "Throwable Plate", "m\\Misc_Com_Plate_02.NIF", "m\\Misc_Com_Plate_02.tga", nil, nil, nil, 
    "11", "0.5", "1", "100", "1.1", "1.1", { "1", "5" }, { "0", "1" }, { "0", "1" }, nil, 25, -1, "Blue Plates (Throwable)" },
    { "weapon", nil, "ccreward_plate_thrown_br", "Throwable Plate", "m\\Misc_Com_Plate_06.NIF", "m\\Misc_Com_Plate_06.tga", nil, nil, nil, 
    "11", "0.5", "1", "100", "1.1", "1.1", { "1", "5" }, { "0", "1" }, { "0", "1" }, nil, 25, -1, "Brown Plates (Throwable)" },
    { "weapon", nil, "ccreward_lute_melee", "Reinforced Lute", "m\\Misc_de_lute_01.NIF", "m\\Tx_de_lute_01.tga", nil, nil, nil, 
    "5", "0.5", "1", "100", "1.1", "1.1", { "1", "5" }, { "1", "5" }, { "1", "5" }, nil, 1, -1, "Fat Lute (Melee)" },
    { "weapon", nil, "ccreward_pillow_melee", "Reinforced Pillow", "m\\Misc_Com_Pillow_01.NIF", "m\\Misc_Com_Pillow_01.tga", nil, nil, nil, 
    "3", "0.5", "1", "100", "1.1", "1.1", { "1", "5" }, { "1", "5" }, { "1", "5" }, nil, 1, -1, "Pillow (Melee)" },
    { "weapon", nil, "ccreward_pillow_thrown", "Throwable Pillow", "m\\Misc_Com_Pillow_01.NIF", "m\\Misc_Com_Pillow_01.tga", nil, nil, nil, 
    "11", "0.5", "1", "100", "1.1", "1.1", { "1", "5" }, { "0", "1" }, { "0", "1" }, nil, 25, -1, "Pillows (Throwable)" }
}

--------
-- INFO:
--
-- Choose which weather patterns the player can generate.
-- NOTE: Don't change anything inside the row entries; the IDs are hardcoded.
-- If you want to remove an entry, then just delete the entire row from the table.
--
-- Format: { weather ID, "Displayed Name" }
--------

ccConfig.Perks.WeatherTypes = {
    { 0, "Clear" },
    { 1, "Cloudy" },
    { 2, "Foggy" },
    { 3, "Overcast" },
    { 4, "Rain" },
    { 5, "Thunder" },
    { 6, "Ash" },
    { 7, "Blight" },
    { 8, "Snowing" },
    { 9, "Blizzard" }
}

-------------------------
-- SERVER MESSAGE CONFIG
-------------------------

-- Messages that appear at specified minute(s) past the hour.
-- Format: { minute(s) past the hour, "message" }
-- Ex: { "15", "Ur Welcome" } will display "Ur Welcome" in chat at 1:15, 2:15, etc.
ccConfig.ServerMessage.Messages = {
    { "00", color.Yellow .. "Type /help for all Cornerclub commands. Visit us online at the-cornerclub.com.\n" },
    { "15", color.Yellow .. "Want to help create Morrowind, Skyrim, and Cyrodiil? Type /modding for info.\n" },
    { "30", color.Yellow .. "Type /help for all Cornerclub commands. Visit us online at the-cornerclub.com.\n" },
    { "45", color.Yellow .. "Want to help create Morrowind, Skyrim, and Cyrodiil? Type /modding for info.\n" }
}

-- How often the timer should restart. Only modify this if you know what you're doing.
ccConfig.ServerMessage.Timer = 60

--------
-- NOTE: The following commands are only applicable to those who have set up automated restarts outside of TES3MP.
-- This can be done with the Windows Task Scheduler or Linux's "crontab".
-- As of TES3MP v0.7.0, there is no way to restart the server from within the program.
--------

-- Must be enabled for everything else in this section to work.
ccConfig.ServerMessage.RestartWarningEnabled = true

-- Contains your restart times minus 2 minutes.
-- The server will display a "two minute" restart warning at the specified minute(s) past the hour.
-- Format: { hour, minute(s) past the hour } in 24-hour time.
-- Ex: { "12", "30" } = 12:30
ccConfig.ServerMessage.RestartWarningTimes = {
    { "00", "58" },
    { "06", "58" },
    { "12", "58" },
    { "18", "58" }
}

-- The "restart warning" message that appears at the times in ccConfig.ServerMessage.RestartWarningTimes.
ccConfig.ServerMessage.RestartWarningMessage = color.Orange .. "\n=~=~=~=~=~=~=~=~=~=~=\nSERVER WILL RESTART IN 2 MINUTES\n=~=~=~=~=~=~=~=~=~=~=\n\n"
